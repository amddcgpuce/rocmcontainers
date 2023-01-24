#!/bin/sh -x
#************************************************************************************************
# Usage: sh run_chroma_singularity.sh
# Copyright (c) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
# This script is used to run AMD Infiniy Chroma singularity commands
# Contact info: roohollah.etemadi@amd.com, sanjay.tripathi@amd.com
# Version: V1.1
# Modified: 2023-01-23
# Version History:
# V1.1: updated pull tag and added timestamp after every benchmark run
# V1.0: run amddcgpuce/chroma:3.43.0-20211118 singularity commands
#************************************************************************************************
echo "Start Test: `date`"

# Use docker-tag, if provided as parameter else exit
if [ "$#" -eq 0 ];
        then
                echo "Need Docker-Tag. Exiting."
                exit 1
        else
                tag=$1
fi

DOCKER_TAG=chroma:$tag
SIF_FILENAME=chroma_$tag.sif

echo "==== Pull singularity image ===="
echo "singularity pull --docker-login $SIF_FILENAME docker://amddcgpuce/$DOCKER_TAG"
singularity pull --docker-login $SIF_FILENAME docker://amddcgpuce/$DOCKER_TAG
echo "==== Pull complete ===="

echo "Date: `date`"

echo "==== Copy benchmark locally in benchmark dir ===="
echo "singularity run $SIF_FILENAME cp -r /benchmark ."
singularity run $SIF_FILENAME cp -r /benchmark .

echo "Date: `date`"

echo "==== Run on 1 GPU ===="
echo "singularity run --bind ./benchmark:/benchmark --pwd /benchmark $SIF_FILENAME run-benchmark --ngpus 1"
singularity run --bind ./benchmark:/benchmark --pwd /benchmark $SIF_FILENAME run-benchmark --ngpus 1

echo "Date: `date`"

echo "==== Run on 2 GPUs ===="
echo "singularity run --bind ./benchmark:/benchmark --pwd /benchmark $SIF_FILENAME run-benchmark --ngpus 2"
singularity run --bind ./benchmark:/benchmark --pwd /benchmark $SIF_FILENAME run-benchmark --ngpus 2

echo "Date: `date`"

echo "==== Run on 4 GPU ===="
echo "singularity run --bind ./benchmark:/benchmark --pwd /benchmark $SIF_FILENAME run-benchmark --ngpus 4"
singularity run --bind ./benchmark:/benchmark --pwd /benchmark $SIF_FILENAME run-benchmark --ngpus 4

echo "Date: `date`"

echo "==== Run on 8 GPUs ===="
echo "singularity run --bind ./benchmark:/benchmark --pwd /benchmark $SIF_FILENAME run-benchmark --ngpus 8"
singularity run --bind ./benchmark:/benchmark --pwd /benchmark $SIF_FILENAME run-benchmark --ngpus 8

echo "Date: `date`"

echo "==== Remove locally copied benchmark dir ===="
echo "rm -rf ./benchmark"
rm -rf ./benchmark

echo "End Test: `date`"
