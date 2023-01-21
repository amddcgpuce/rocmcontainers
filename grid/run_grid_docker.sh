#!/bin/sh -x
#************************************************************************************************
# Usage: sudo sh run_grid_docker.sh
# Copyright (c) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
# This script is used to run AMD Infiniy GRID Docker Container
# Contact info: roohollah.etemadi@amd.com, sanjay.tripathi@amd.com
# Version: V1.1
# Modified: 2023-01-19
# Version History:
# V1.1: added docker tag as parameter, added timestamp after every benchmark run
# V1.0: amdih/grid:0.8.2-20211213 docker image
#************************************************************************************************
echo "Start Test:`date`"

# Use docker-tag, if provided as parameter else exit
if [ "$#" -eq 0 ];
        then
                echo "Need Docker-Tag. Exiting."
                exit 1
        else
		tag=$1
fi

DOCKER_TAG=grid:$tag

echo "==== Pull GRID docker image  ===="
echo "docker pull amddcgpuce/$DOCKER_TAG"
docker pull amddcgpuce/$DOCKER_TAG
echo "==== Pull complete  ===="

echo "==== Run Test on 1 GPU ===="
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 amddcgpuce/$DOCKER_TAG /bin/bash -c \"Benchmark_ITT --accelerator-threads 8\""
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 amddcgpuce/$DOCKER_TAG /bin/bash -c "Benchmark_ITT --accelerator-threads 8"
echo "==== Completed Test on 1 GPU ===="

echo "Date:`date`"

echo "==== Run Test on 2 GPUs ===="
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 amddcgpuce/$DOCKER_TAG /bin/bash -c \"mpirun -np 2  /benchmark/gpu_bind.sh Benchmark_ITT --accelerator-threads 8 --mpi 1.1.1.2\""
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 amddcgpuce/$DOCKER_TAG /bin/bash -c "mpirun -np 2  /benchmark/gpu_bind.sh Benchmark_ITT --accelerator-threads 8 --mpi 1.1.1.2"
echo "==== Completed Test on 2 GPUs ===="

echo "Date:`date`"

echo "==== Run Test on 4 GPUs ===="
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 amddcgpuce/$DOCKER_TAG /bin/bash -c \"mpirun -np 4  /benchmark/gpu_bind.sh Benchmark_ITT --accelerator-threads 8 --mpi 1.1.1.4\""
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 amddcgpuce/$DOCKER_TAG /bin/bash -c "mpirun -np 4  /benchmark/gpu_bind.sh Benchmark_ITT --accelerator-threads 8 --mpi 1.1.1.4"
echo "==== Completed Test on 4 GPUs ===="

echo "Date:`date`"

echo "==== Run Test on 8 GPUs ===="
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 amddcgpuce/$DOCKER_TAG /bin/bash -c \"mpirun -np 8  /benchmark/gpu_bind.sh Benchmark_ITT --accelerator-threads 8 --mpi 1.1.1.8\""
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 amddcgpuce/$DOCKER_TAG /bin/bash -c "mpirun -np 8  /benchmark/gpu_bind.sh Benchmark_ITT --accelerator-threads 8 --mpi 1.1.1.8"
echo "==== Completed Test on 8 GPUs ===="

echo "End Test:`date`"
