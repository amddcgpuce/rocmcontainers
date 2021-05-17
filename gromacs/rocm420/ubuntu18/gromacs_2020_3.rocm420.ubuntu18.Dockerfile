# V1.4 ROCM 4.2.0 Gromacs Dockerfile for Ubuntu18

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
    python3 ./rocminstall.py --nokernel --rev 4.2 && \
    cd $HOME && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* downloads

# Set up paths
ENV ROCM_VERSION=4.2.0
ENV ROCM_PATH="/opt/rocm-${ROCM_VERSION}"
ENV PATH="${ROCM_PATH}/bin:${ROCM_PATH}/opencl/bin:${PATH}"

#
RUN /bin/sh -c 'ln -sf ${ROCM_PATH} /opt/rocm'

#
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# Check ROCm-Kernel compatibility
COPY rocm-kernel-compatibility-test.sh /root/rocm-kernel-compatibility-test.sh
RUN chmod a+x /root/rocm-kernel-compatibility-test.sh

ENTRYPOINT ["/root/rocm-kernel-compatibility-test.sh"]


##### UCX & PMI build section

ENV MPI_HOME=/opt/ompi 
ENV UCX_HOME=/opt/ucx 
RUN mkdir $UCX_HOME && mkdir $MPI_HOME 

ENV INSTALL_DIR=/opt/mpi_install 

##############  UCX Build ##################### 
RUN mkdir $INSTALL_DIR && cd $INSTALL_DIR &&\ 
    git clone https://github.com/openucx/ucx.git -b v1.8.0 &&\ 
    cd ucx &&\ 
    ./autogen.sh &&\ 
    mkdir -p build &&\ 
    cd build &&\ 
    ../contrib/configure-release --prefix=$UCX_HOME --with-rocm=$ROCM_PATH &&\ 
    make -j$(nproc) &&\ 
    make -j$(nproc) install 

##############  MPI Build ##################### 
RUN cd $INSTALL_DIR &&\ 
    git clone https://github.com/open-mpi/ompi.git -b v4.0.3 &&\ 
    cd ompi  &&\ 
    ./autogen.pl &&\ 
    mkdir build &&\ 
    cd build &&\ 
    ../configure --prefix=$MPI_HOME --with-ucx=$UCX_HOME &&\ 
    make -j$(nproc) &&\ 
    make -j$(nproc) install 

RUN rm -rf $INSTALL_DIR

####### Gromacs Build Section
ENV INSTALL_DIR=/opt/gromacs
RUN mkdir $INSTALL_DIR

############## GROMACS Build #####################
COPY gromacs_2020.3.tgz $INSTALL_DIR/gromacs_2020.3.tgz
COPY gromacs_benchmark.tgz $INSTALL_DIR/gromacs_benchmark.tgz

RUN cd $INSTALL_DIR &&\
    tar -zxf gromacs_2020.3.tgz && tar -zxf gromacs_benchmark.tgz &&\
    cd Gromacs &&  mkdir -p build &&  cd build &&\
    cmake -DAMDGPU_TARGETS="gfx908:xnack-;gfx906:xnack-" -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx -DGMX_MPI=on -DGMX_GPU=on -DGMX_GPU_USE_AMD=on -DGMX_OPENMP=on \
	-DGMX_GPU_DETECTION_DONE=on -DGMX_SIMD=AVX2_256 -DREGRESSIONTEST_DOWNLOAD=OFF -DCMAKE_PREFIX_PATH=$ROCM_PATH .. &&\
    make -j$(nproc) &&  make -j$(nproc) install

# gmx build
RUN cd $INSTALL_DIR &&\
    cd Gromacs &&  mkdir -p build.1 &&  cd build.1 &&\
    cmake -DAMDGPU_TARGETS="gfx908:xnack-;gfx906:xnack-" -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DGMX_MPI=off -DGMX_GPU=on -DGMX_GPU_USE_AMD=on -DGMX_OPENMP=on \
	-DGMX_GPU_DETECTION_DONE=on -DGMX_SIMD=AVX2_256 -DREGRESSIONTEST_DOWNLOAD=OFF -DCMAKE_PREFIX_PATH=$ROCM_PATH .. &&\
    make -j$(nproc) &&  make -j$(nproc) install

#
RUN rm -rf $INSTALL_DIR/gromacs_2020.3.tgz $INSTALL_DIR/gromacs_benchmark.tgz $INSTALL_DIR/Gromacs

# Default to a login shell
CMD ["bash", "-l"]
