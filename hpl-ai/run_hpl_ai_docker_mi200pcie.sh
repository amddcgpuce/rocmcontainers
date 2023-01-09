#!/bin/sh -x
#************************************************************************************************
# Usage: sudo sh run_hpl_ai_docker_mi200pcie.sh                                                        
# Copyright (c) 2022 Advanced Micro Devices, Inc. All Rights Reserved.                         
# This script is used to run AMD Infiniy Chroma Docker Container                                
# Contact info: roohollah.etemadi@amd.com                                                       
# Version: V1.0                                                                                  
# Modified: 2022-12-20                                                                          
# Version History:                                                                              
# V1.0: amddcgpuce/hpl-ai:1.0.0_42 docker image                                             
#************************************************************************************************
echo "Start Test:`date`"

echo "==== Pull Chroma docker image  ===="
echo "docker pull amddcgpuce/hpl-ai:1.0.0_42"
docker pull amddcgpuce/hpl-ai:1.0.0_42
echo "==== Pull complete  ===="


echo "==== Run Test on 4 GPUs ===="
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/hpl-ai:1.0.0_42 /bin/bash -c mpirun -np 4 --mca pml ucx --map-by numa:PE=1 -x UCX_RNDV_PIPELINE_SEND_THRESH=256k -x UCX_RNDV_FRAG_SIZE=rocm:4m -x UCX_RNDV_THRESH=128 -x UCX_TLS=sm,self,rocm_copy,rocm_ipc hpl-ai -P 2 -B 2560 -N 235520 -numa 2 -pmap CONT2D"
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/hpl-ai:1.0.0_42 /bin/bash -c "mpirun -np 4 --mca pml ucx --map-by numa:PE=1 -x UCX_RNDV_PIPELINE_SEND_THRESH=256k -x UCX_RNDV_FRAG_SIZE=rocm:4m -x UCX_RNDV_THRESH=128 -x UCX_TLS=sm,self,rocm_copy,rocm_ipc hpl-ai -P 2 -B 2560 -N 235520 -numa 2 -pmap CONT2D"
echo "==== Complete Test on 4 GPUs ===="

echo "==== Run Test on 8 GPUs ===="
echo "docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/hpl-ai:1.0.0_42 /bin/bash -c mpirun -np 8 --mca pml ucx --map-by numa:PE=1 -x UCX_RNDV_PIPELINE_SEND_THRESH=256k -x UCX_RNDV_FRAG_SIZE=rocm:4m -x UCX_RNDV_THRESH=128 -x UCX_TLS=sm,self,rocm_copy,rocm_ipc hpl-ai -P 4 -B 2560 -N 332800 -numa 2 -pmap CONT2D"
docker run --rm -it --ipc=host --device /dev/dri --device /dev/kfd --security-opt seccomp=unconfined amddcgpuce/hpl-ai:1.0.0_42 /bin/bash -c "mpirun -np 8 --mca pml ucx --map-by numa:PE=1 -x UCX_RNDV_PIPELINE_SEND_THRESH=256k -x UCX_RNDV_FRAG_SIZE=rocm:4m -x UCX_RNDV_THRESH=128 -x UCX_TLS=sm,self,rocm_copy,rocm_ipc hpl-ai -P 4 -B 2560 -N 332800 -numa 2 -pmap CONT2D"
echo "==== Complete Test on 8 GPUs ===="

echo "End Test:`date`"
