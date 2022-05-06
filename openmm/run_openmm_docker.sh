#!/bin/sh -x
#************************************************************************************************
# Usage: sudo sh run_openmm_docker.sh                                                           
# Copyright (c) 2022 Advanced Micro Devices, Inc. All Rights Reserved.                          
# This script is used to run AMD Infiniy OpenMM Docker Container                               
# Contact info: roohollah.etemadi@amd.com                                                       
# Version: V1.0                                                                                 
# Modified: 2022-04-26                                                                         
# Version History:                                                                              
# V1.0: run amdih/openmm:7.7.0_49 docker commands                                                
#************************************************************************************************

echo "Date:`date`"

echo "==== Pull OpenMM docker image  ===="
echo "docker pull amdih/openmm:7.7.0_49"
docker pull amdih/openmm:7.7.0_49
echo "==== Pull complete  ===="

echo "==== Run OpenMM docker image in a noninteractive way  ===="
echo "docker run --rm -it --ipc=host --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined amdih/openmm:7.7.0_49 run-benchmarks"
docker run --rm -it --ipc=host --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined amdih/openmm:7.7.0_49 run-benchmarks
echo "==== Run complete ===="
