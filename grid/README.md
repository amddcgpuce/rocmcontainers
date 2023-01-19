```
Copyright (c) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
Revision: V1.1
V1.1: updated docker tag
V1.0: add docker and singualrity commands 
```

# GRID

## Pull Command

```
sudo docker pull amdih/grid:0.8.amd5_62
```

## Running Containers
### Using Docker
Launch the container using
```
sudo docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 amdih/grid:0.8.amd5_62 /bin/bash
```
Grid is installed and available under $GRID_PATH.

The container contains an example benchmark problem, which can be executed as follows
```
Benchmark_ITT --accelerator-threads 8
```
The benchmark will be executed and ran on a single GPU. The console will display the progress of the solver. To benchmark GRID performance with multiple accelerators, it is necessary to launch multiple ranks of Benchmark_ITT and bind them to particular GPUs using the gpu_bind.sh script available under $GRID_PATH. Launching the solver using 8 GPUs is as simple as:
```
mpirun -np 8  /benchmark/gpu_bind.sh Benchmark_ITT --accelerator-threads 8 --mpi 1.1.1.8
```
### Using Singularity
This section assumes that an up-to-date version of Singularity is installed on your system and properly configured for your system. Please consult with your system administrator or view official Singularity documentation.

Pull and convert docker image to singularity image format:
```
singularity pull grid_0.8.amd5_62.sif docker://amdih/grid:0.8.amd5_62
```
You can then use examples from the preceding section to use the image. For example, to run the benchmark problem, you may do
```
singularity run grid_0.8.amd5_62.sif Benchmark_ITT --accelerator-threads 8
```
### Run Using Scripts
The run_grid_docker.sh script runs the test using Docker commands. Get the script and run it as follows:
```
sudo sh run_grid_docker.sh
``` 
Similarly, the Singularity commands can be performed by run_grid_singularity.sh script as:
```
sh run_grid_singularity.sh
```
