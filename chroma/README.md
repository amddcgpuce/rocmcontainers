```
Copyright (c) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
Revision: V1.1
Modified: 2023-01-23
V1.1: updated docker tag
V1.0: add docker and singualrity commands
```
# Chroma 

## Pull Command

```
sudo docker pull amdih/chroma:3.43.0-20211118
```
## Running Containers
### Using Docker 
Launch the container using:
```
sudo docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amdih/chroma:3.43.0_29 /bin/bash
```
The container contains an example benchmark problem, which can be executed as follows:
```
cd /benchmark
run-benchmark --ngpus 1
```
The benchmark will be executed and run on a single GPU. The console will display the progress of the solver.

You can run the benchmarks on 2, 4, and 8 GPUs by modifying the --ngpus value.

### Using Singularity
This section assumes that an up-to-date version of Singularity is installed on your system and properly configured for your system. Please consult with your system administrator or view official Singularity documentation.

Pull and convert docker image to singularity image format:
```
singularity pull chroma_3.43.0_29.sif docker://amdih/chroma:3.43.0_29
```
You can then use examples from the preceding section to use the image. For example, to run the benchmark problem, you may do
```
singularity run --pwd /benchmark --writable-tmpfs chroma_3.43.0_29.sif run-benchmark --ngpus 1
```
To avoid using "--writable-tmpfs", you can copy example benchmark locally and then run the benchmark using the following :
```
singularity run chroma_3.43.0_29.sif cp -r /benchmark .
singularity run --bind ./benchmark:/benchmark --pwd /benchmark chroma_3.43.0_29.sif run-benchmark --ngpus 1
```
Similar to docker, you can run the benchmarks on 2, 4, and 8 gpus by modifying the --ngpus value.

## Run Using Scripts
The tests using Docker commands can be executed using run_chroma_docker.sh script. Get the script and run it as:
```
sudo sh run_chroma_docker.sh <docker-tag>
``` 
Similarly, the Singularity commands can be performed by run_chroma_singularity.sh script as:
```
sh run_chroma_singularity.sh <docker-tag>
```
