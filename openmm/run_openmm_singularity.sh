#!/bin/sh -x
#************************************************************************************************
# Usage: sh run_openmm_singularity.sh                                                            
# Copyright (c) 2022 Advanced Micro Devices, Inc. All Rights Reserved.                          
# This script is used to run AMD Infiniy OpenMM singularity commands                            
# Contact info: roohollah.etemadi@amd.com                                                       
# Version: V1.0                                                                                  
# Modified: 2022-04-27                                                                          
# Version History:                                                                              
# V1.0: run amdih/openmm:7.7.0_49 singularity                                                   
#************************************************************************************************

echo "Date: `date`"

echo "==== Pull singularity image ===="
echo "singularity pull openmm.sif docker://amdih/openmm:7.7.0_49"
singularity pull openmm.sif docker://amdih/openmm:7.7.0_49
echo "==== Pull complete ===="

echo "==== Run singulariy test ===="
echo "singularity run ./openmm.sif run-benchmarks"
singularity run ./openmm.sif run-benchmarks 
echo "==== Run complete ====" 
