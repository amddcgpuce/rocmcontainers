# ROCm-4.2.0-based Pytorch Container

## 1.0 How to Use Docker Container
#### On Ubuntu 18/20 HWE, CentOS/RHEL 7.x, or SLES 15 SP2, use docker:
```
# Launch container in interactive mode, bash shell
sudo docker run -it --privileged --ipc=host --network=host --device=/dev/kfd --device=/dev/dri --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined amddcgpuce/pytorch181-rocm420-ubuntu18 bash
```
#### On CentOS/RHEL 8.x, use podman:
```
# Launch container in interactive mode, bash shell
sudo podman run -it --privileged docker://amddcgpuce/pytorch181-rocm420-ubuntu18 bash
```
##### Image Name + Tag | Description
```
    pytorch181-rocm420-ubuntu18:version1   -->   Pytorch v1.8.1 based on ROCm v4.2.0 On Ubuntu18 (Version 1)
    pytorch171-rocm420-ubuntu18:version1   -->   Pytorch v1.7.1 based on ROCm v4.2.0 On Ubuntu18 (Version 1)
```

## 2.0 Steps to build Singularity container from docker image
#### Download Singularity Definition File
```
# Download Singularity Definition file
wget -O pytorch181.rocm420.ubuntu18.sdf --no-check-certificate https://raw.githubusercontent.com/amddcgpuce/rocmcontainers/main/pytorch/rocm420/ubuntu18/pytorch181.rocm420.ubuntu18.sdf
```
#### Build Singularity Image File (SIF)
##### On Ubuntu 18.04/20.04 HWE with singularity installed under /usr/local/bin
```
sudo /usr/local/bin/singularity build pytorch181.rocm420.ubuntu18.sif pytorch181.rocm420.ubuntu18.sdf
```
##### On CentOS/RHEL 8 with singularity RPM installed
```
sudo singularity build pytorch181.rocm420.ubuntu18.sif pytorch181.rocm420.ubuntu18.sdf
```

## 3.0 Example Usage of Pytorch Docker Container
#### Benchmark examples
```
# Launch docker container in interactive mode, bash shell on a Ubuntu18 system
sudo docker run -it --privileged --ipc=host --network=host --device=/dev/kfd --device=/dev/dri --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined amddcgpuce/pytorch181-rocm420-ubuntu18 bash

# Micro-benchmark example
cd /opt/pytorch-micro-benchmarking
python3 micro_benchmarking_pytorch.py --network resnext101  --batch-size 128  --iterations 100

# Resnet sample benchmark
mkdir /usr/tmp
chmod 777 /usr/tmp
cd /usr/tmp/
cp -r /opt/pytorch/caffe2/python/examples .
python3 /usr/tmp/examples/resnet50_trainer.py --train_data null --batch_size 16 --epoch_size 1000 --num_epochs 2 --num_gpus 2
```

## 4.0 Example Usage of Pytorch Singularity Container
#### Run Help
```
singularity run-help pytorch181.rocm420.ubuntu18.sif
```
##### Output
```
    singularity run pytorch181.rocm420.ubuntu18.sif /bin/bash -c "cp -r /opt/pytorch-micro-benchmarking $HOME/Documents; cd $HOME/Documents/pytorch-micro-benchmarking; python3 micro_benchmarking_pytorch.py --network resnext101  --batch-size 128  --iterations 100"
    singularity run pytorch181.rocm420.ubuntu18.sif /bin/bash -c "cp -r /opt/pytorch/caffe2/python/examples $HOME/Documents; cd $HOME/Documents/examples; python3 $HOME/Documents/examples/resnet50_trainer.py --train_data null --batch_size 16 --epoch_size 1000 --num_epochs 2 --num_gpus 2"
```
#### Running sample benchmark#1
```
singularity run pytorch181.rocm420.ubuntu18.sif /bin/bash -c "cp -r /opt/pytorch-micro-benchmarking $HOME/Documents; cd $HOME/Documents/pytorch-micro-benchmarking; python3 micro_benchmarking_pytorch.py --network resnext101  --batch-size 128  --iterations 100"
```
##### Output
```
Container was created Tue May 18 17:00:00 UTC 2021
CWD: /opt/pytorch Launching: /bin/bash -c cp -r /opt/pytorch-micro-benchmarking /home/USERHOME/Documents; cd /home/USERHOME/Documents/pytorch-micro-benchmarking; python3 micro_benchmarking_pytorch.py --network resnext101  --batch-size 128  --iterations 100
INFO: running forward and backward for warmup.
INFO: running the benchmark..
OK: finished running benchmark..
--------------------SUMMARY--------------------------
Microbenchmark for network : resnext101
Num devices: 1
Dtype: FP32
Mini batch size [img] : 128
Time per mini-batch : 1.8649749994277953
Throughput [img/sec] : 68.63362781767717
```
#### Running sample benchmark#2
```
singularity run pytorch181.rocm420.ubuntu18.sif /bin/bash -c "cp -r /opt/pytorch/caffe2/python/examples $HOME/Documents; cd $HOME/Documents/examples; python3 $HOME/Documents/examples/resnet50_trainer.py --train_data null --batch_size 16 --epoch_size 1000 --num_epochs 2 --num_gpus 2"
```
##### Output
```
Container was created Tue May 18 17:00:00 UTC 2021
CWD: /opt/pytorch Launching: /bin/bash -c cp -r /opt/pytorch/caffe2/python/examples /home/USERHOME/Documents; cd /home/USERHOME/Documents/examples; python3 /home/USERHOME/Documents/examples/resnet50_trainer.py --train_data null --batch_size 16 --epoch_size 1000 --num_epochs 2 --num_gpus 2
Ignoring @/caffe2/caffe2/contrib/gloo:gloo_ops as it is not a valid file.
Ignoring @/caffe2/caffe2/contrib/nccl:nccl_ops as it is not a valid file.
Ignoring @/caffe2/caffe2/contrib/gloo:gloo_ops_gpu as it is not a valid file.
Ignoring @/caffe2/caffe2/distributed:file_store_handler_ops as it is not a valid file.
Ignoring @/caffe2/caffe2/distributed:redis_store_handler_ops as it is not a valid file.
[E init_intrinsics_check.cc:43] CPU feature avx is present on your machine, but the Caffe2 binary is not compiled with it. It means you may not get the full speed of your CPU.
[E init_intrinsics_check.cc:43] CPU feature avx2 is present on your machine, but the Caffe2 binary is not compiled with it. It means you may not get the full speed of your CPU.
[E init_intrinsics_check.cc:43] CPU feature fma is present on your machine, but the Caffe2 binary is not compiled with it. It means you may not get the full speed of your CPU.
INFO:Imagenet_trainer:Running on GPUs: [0, 1]
INFO:Imagenet_trainer:Using epoch size: 992
INFO:data_parallel_model:Parallelizing model for devices: [0, 1]
INFO:data_parallel_model:Create input and model training operators
...output snipped...
```

## 5.0 Incompatible ROCm Environment Check Message
### ROCm 4.1 Kernel Modules (rock-dkms, rock-dkms-firmware) or newer is required on MI50/MI60 platforms to run ROCm 4.1 or newer user space stack 

#### Docker Run Failure Message On Incompatible ROCm Environment
```
sudo docker run -it --privileged --ipc=host --network=host --device=/dev/kfd --device=/dev/dri --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined amddcgpuce/pytorch181-rocm420-ubuntu18 bash
```
##### Output
```
Error: Incompatible ROCm environment. The Docker container
requires the latest kernel driver to operate correctly.

Upgrade the ROCm kernel to v4.1 or newer, or use a container
tagged for v4.0.1 or older.

To inspect the version of the installed kernel driver, run either:
      dpkg --status rock-dkms [Debian-based]
      rpm -ql rock-dkms [RHEL, SUSE, and others]

To install or update the driver, follow the installation instructions at:
    https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html
```

#### Singularity Run Failure Message On Incompatible ROCm Environment
```
singularity run pytorch181.rocm420.ubuntu18.sif /bin/bash -c "cp -r /opt/pytorch-micro-benchmarking $HOME/Documents; cd $HOME/Documents/pytorch-micro-benchmarking; python3 micro_benchmarking_pytorch.py --network resnext101  --batch-size 128  --iterations 100"
```
##### Output
```
Container was created Tue May 18 17:00:00 UTC 2021

Error: Incompatible ROCm environment. The Docker container 
requires the latest kernel driver to operate correctly.

Upgrade the ROCm kernel to v4.1 or newer, or use a container 
tagged for v4.0.1 or older.

To inspect the version of the installed kernel driver, run either:
    . dpkg --status rock-dkms [Debian-based]
    . rpm -ql rock-dkms [RHEL, SUSE, and others]

To install or update the driver, follow the installation instructions at:
    https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html
```
