# V1.5 ROCm-4.2.0 Pytorch-1.8.1 Dockerfile for Ubuntu18

FROM ubuntu:18.04

RUN sed -i -e "s/\/archive.ubuntu/\/us.archive.ubuntu/" /etc/apt/sources.list && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    aria2 \
    autoconf \
    bc \
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
    libhdf5-serial-dev \
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
    python-pip \
    python-pip-whl \
    python-scipy \
    python-yaml \
    python3-dev \
    python3-pip \
    ssh \
    swig \
    sudo \
    unzip \
    vim \
    xsltproc && \
    pip3 install Cython && \
    pip3 install numpy && \
    pip3 install optionloop && \
    pip3 install protobuf && \
    pip3 install networkx && \
    pip install Cython && \
    pip install numpy && \
    pip install optionloop && \
    pip install setuptools && \
    pip install CppHeaderParser argparse && \
    ldconfig && \
    cd $HOME && \
    mkdir -p downloads && \
    cd downloads && \
    wget -O rocminstall.py --no-check-certificate https://raw.githubusercontent.com/srinivamd/rocminstaller/master/rocminstall.py && \
    python3 ./rocminstall.py --nokernel --rev 4.2 --nomiopenkernels && \
    cd $HOME && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* downloads

#
RUN /bin/sh -c 'ln -sf /opt/rocm-4.2.0 /opt/rocm'

#
RUN locale-gen en_US.UTF-8

# Set up paths
ENV PATH="/opt/rocm-4.2.0/bin:/opt/rocm-4.2.0/opencl/bin:${PATH}"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# Check ROCm-Kernel compatibility
COPY rocm-kernel-compatibility-test.sh /root/rocm-kernel-compatibility-test.sh
RUN chmod a+x /root/rocm-kernel-compatibility-test.sh

ENTRYPOINT ["/root/rocm-kernel-compatibility-test.sh"]


# Pytorch Build Section

# Clone Pytorcha and benchmark for verification
RUN cd /opt/ && \
    git clone --recursive https://github.com/pytorch/pytorch -b v1.8.1 &&\
    git clone https://github.com/ROCmSoftwarePlatform/pytorch-micro-benchmarking &&\
    cd /opt/pytorch &&\
    python3 -m pip install -r requirements.txt &&\
    pip3 install torchvision --no-deps &&\
    pip3 install image &&\
    python3 tools/amd_build/build_amd.py &&\
    USE_ROCM=1 USE_LMDB=1 USE_OPENCV=1 MAX_JOBS=$(nproc) python3 setup.py install 


# Default to a login shell
CMD ["bash", "-l"]
