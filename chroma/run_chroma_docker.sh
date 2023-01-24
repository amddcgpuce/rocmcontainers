#!/bin/sh -x
#************************************************************************************************
# Usage: sudo sh run_chroma_docker.sh
# Copyright (c) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
# This script is used to run AMD Infiniy Chroma Docker Container
# Contact info: roohollah.etemadi@amd.com, sanjay.tripathi@amd.com
# Version History:
# V1.1: added docker tag as parameter and timestamp after every benchmark run
# V1.0: run amdih/chroma:3.43.0-20211118
# Modified: 2023-01-23
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

DOCKER_TAG=chroma:$tag

echo "==== Pull Chroma docker image  ===="
echo "docker pull amddcgpuce/$DOCKER_TAG"
docker pull amddcgpuce/$DOCKER_TAG
echo "==== Pull complete  ===="

echo "Date:`date`"

echo "*** Run Test on 1 GPU ***"
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/$DOCKER_TAG /bin/bash -c \"cd /benchmark; run-benchmark --ngpus 1 \""
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/$DOCKER_TAG /bin/bash -c "cd /benchmark; run-benchmark --ngpus 1"

echo "Date:`date`"

echo "*** Run Test on 2 GPUs ***"
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/$DOCKER_TAG /bin/bash -c \"cd /benchmark; run-benchmark --ngpus 2 \""
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/$DOCKER_TAG /bin/bash -c "cd /benchmark; run-benchmark --ngpus 2"

echo "Date:`date`"

echo "*** Run Test on 4 GPUs ***"
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/$DOCKER_TAG /bin/bash -c \"cd /benchmark; run-benchmark --ngpus 4 \""
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/$DOCKER_TAG /bin/bash -c "cd /benchmark; run-benchmark --ngpus 4"

echo "Date:`date`"

echo "*** Run Test on 8 GPUs ***"
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/$DOCKER_TAG /bin/bash -c \"cd /benchmark; run-benchmark --ngpus 8 \""
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/$DOCKER_TAG /bin/bash -c "cd /benchmark; run-benchmark --ngpus 8"

echo "Date:`date`"

echo "==== Run complete ===="
