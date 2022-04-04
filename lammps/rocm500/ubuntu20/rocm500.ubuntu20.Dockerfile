# V1.4 ROCM 5.0.0 Dockerfile for Ubuntu20
# sudo docker build -t amddcgpuce/lammps_20220403:latest  -f rocm500.ubuntu20.Dockerfile .

FROM ubuntu:20.04

RUN sed -i -e "s/\/archive.ubuntu/\/us.archive.ubuntu/" /etc/apt/sources.list && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    aria2 \
    autoconf \
    bison \
    bzip2 \
    check \
    cifs-utils \
    cmake \
    curl \
    dkms \
    dos2unix \
    doxygen \
    flex \
    g++-multilib \
    gcc-multilib \
    git \
    locales \
    libatlas-base-dev \
    libbabeltrace1 \
    libboost-all-dev \
    libboost-program-options-dev \
    libelf-dev \
    libelf1 \
    libfftw3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
#   libhdf5-serial-dev \
    libhdf5-dev \
    libleveldb-dev \
    liblmdb-dev \
    libnuma-dev \
    libopenblas-base \
    libopenblas-dev \
    libopencv-dev \
    libpci3 \
    libpython3.8 \
    libfile-which-perl \
    libprotobuf-dev \
    libsnappy-dev \
    libssl-dev \
    libunwind-dev \
    ocl-icd-dev \
    ocl-icd-opencl-dev \
    pkg-config \
    protobuf-compiler \
    python-numpy \
    python-pip-whl \
    python-yaml \
    python3-dev \
    python3-pip \
    python3-scipy \
    ssh \
    swig \
    sudo \
    unzip \
    vim \
    xsltproc && \
    pip3 install Cython && \
    pip3 install numpy && \
    pip3 install optionloop && \
    pip3 install setuptools && \
    pip3 install CppHeaderParser argparse && \
    ldconfig

RUN cd $HOME && \
    mkdir -p downloads && \
    cd downloads && \
    wget -O rocminstall.py --no-check-certificate https://raw.githubusercontent.com/srinivamd/rocminstaller/master/rocminstall.py && \
    python3 ./rocminstall.py --nokernel --rev 5.0 && \
    cd $HOME && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#
RUN /bin/sh -c 'ln -sf /opt/rocm-5.0.0 /opt/rocm'

#
RUN locale-gen en_US.UTF-8

# Set up paths
ENV PATH="/opt/rocm-5.0.0/bin:/opt/rocm-5.0.0/opencl/bin:${PATH}"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Build LAMMPS
COPY LAMMPS.tar.gz /opt
RUN mkdir -p     /root/.ssh
COPY id_rsa      /root/.ssh
COPY id_rsa.pub  /root/.ssh
COPY known_hosts /root/.ssh
RUN chmod o-rw   /root/.ssh/id_rsa
RUN chmod o-rw   /root/.ssh/id_rsa.pub
RUN chmod g-rw   /root/.ssh/id_rsa
RUN chmod g-rw   /root/.ssh/id_rsa.pub
RUN ls -als      /root/.ssh
RUN cd /opt && tar xvf /opt/LAMMPS.tar.gz
RUN cd /opt/lammps_benchmarking && ./DoIt.sh
RUN cd /opt/lammps_benchmarking && find . -name "*.cpp" -exec rm "{}" ";" -print
RUN rm -rf      /root/.ssh

# Default to a login shell
CMD ["bash", "-l"]
