```
Copyright (c) 2022 Advanced Micro Devices, Inc. All Rights Reserved.
Revision: V1.0
V1.0: add docker and singualrity commands
```

# HPL-AI

### Description
The High Performance LINPACK for Accelerator Introspection (HPL-AI) benchmark highlights the convergence of HPC and AI workloads
by solving a system of linear equations using novel, mixed-precision algorithms.

Traditional HPC algorithms focus on simulations for modeling phenomena in a variety of scientific disciplines and the computations
mostly require 64-bit precision. On the other hand, the ML/DL methods that fuel advances in AI achieve the desired results at 32-bit
or even lower precisions. The lesser demand for working precision coupled with new hardware accelerators delivering a mix of unprecedented
performance levels and energy savings than afforded by higher-accuracy formats on traditional hardware. HPL-AI unites these realms by
extending the decades-old HPL framework of benchmarking supercomputers to mixed precision implementations.

### Pull Command
```
docker pull amdih/hpl-ai:1.0.0_42
```
_NOTE: internal use only delete before publishing:_
```
docker pull aasg-containers:5000/aasg/hpl-ai:1.0.0_42 
```

## Overview

A distributed-memory implementation of HPL-AI (High Performance LINPACK for Accelerator Introspection) for AMD GPUs based on Fugaku code.

[HPL_AI](https://icl.utk.edu/hpl-ai), or the High Performance LINPACK for Accelerator Introspection is a benchmark that highlights the convergence of HPC and AI workloads by solving a system of linear equations using novel, mixed-precision algorithms. This container implements the HPL-AI benchmark on top of AMD's ROCm platform.

# Single-Node Server Requirements
________________________________________

| CPUs | GPUs | Operating Systems | ROCm™ Driver | Container Runtimes |
| -----| ------ | ----------------- | ------------ | ------------------ |
| X86_64 CPU(s) | AMD Instinct MI200 GPU(s) <br> AMD Instinct MI100 GPU(s) | Ubuntu 20.04 <br> RedHat 8 | ROCm v5.3 compatibility | [Docker Engine](https://docs.docker.com/engine/install/) <br> [Singularity](https://sylabs.io/docs/) |

For ROCm installation procedures and validation checks, see:
* [ROCm Installation Guide](https://docs.amd.com/).
* [Testing the ROCm Installation](https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#testing-the-rocm-installation)


### Labels
* high performance computing
* HPC
* supercomputing

### Categories/Filters**
* HPC
* Benchmark


## Running Containers
This section describes how to launch the containers. It is assumed that up-to-versions of Docker and/or Singularity is installed on your system.
If needed, please consult with your system administrator or view official documentation.

### Docker
To run the container interactively, run 
```
docker run --device=/dev/kfd \
           --device=/dev/dri \
           --security-opt seccomp=unconfined \
           --net=host \
           -it amdih/hpl-ai:1.0.0_42 bash
```
and launch any `hpl-ai` run command from the prompt. For non-interactive runs, simply replace `bash` with the `hpl-ai` run command

```
docker run \
    --device=/dev/kfd \
    --device=/dev/dri \
    --net=host \
    -it amdih/hpl-ai:1.0.0_42 \
    <hpl-ai run command>
```

### Singularity

Download and save singularity image locally:
```
 singularity pull hpl-ai.sif docker://amdih/hpl-ai:1.0.0_42
```

Using singularity in similar to launching an interactive Docker run
```
singularity exec \
    --no-home \
    --pwd /benchmark \
    hpl-ai.sif
    <hpl-ai run command>
```
Examples of `hpl-ai` run commands are described in the following section


## Running Application

### SYNOPSIS
```
mpirun -n <numprocs> [mpiarguments] hpl-ai -P <numprocrows> -B <block_size> -N <matrix_size>  [arguments]
```
### DESCRIPTION
HPL-AI solves a dense linear system of equations by using a low-precision LU factorization followed by iterative
refinement. Similar to HPL, its more famous cousin, HPL-AI uses a processor grid for load balancing across MPI
ranks. The matrix of size N is tiled into blocks of size B which are cyclically distributed across a processor
grid with P rows and Q columns. P is an explicit input argument while Q is deduced from P and the total number
of MPI ranks, i.e. `Q = n/P`. HPL-AI requires that P is a multiple of the number of MPI ranks n, and that matrix
size N is a multiple of block size B. Note that the application is designed for parallel runs and requires at
least 4 GPUs/GCDs to meet the requirements `P>=2 && Q>=2`.


### BASIC ARGUMENTS
For basic usage the following MPI and HPL-AI arguments should suffice

**MPI arguments:**
```
    --map-by numa:PE=1
```
**HPL-AI arguments:**
```
   -P                     The first dimension of the process grid. Requires mod(numprocs,P) = 0.
   -B                     The block size. Requires mod(N,B) = 0, otherwise code will adjust N automatically.
   -N                     The matrix size.
```

**MPI Environment Variables**

MPI environment variables have been set inside the container for ease of use while executing using Docker and/or multiple GPUs. 
```
    OMPI_MCA_pml=ucx
    OMPI_ALLOW_RUN_AS_ROOT=1
    OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 
```

## Performance considerations
HPL-AI reports the apparent FLOPS associated with the direct solve of a dense linear system.
```
FLOPS = (2/3N^3 + 3/2N^2)/runtime
```
In reality, the number of FLOPS is somewhat higher as additional operations take place in the iterative refinement steps
required to bring the accuracy of the solution to double precision. HPL-AI also reports the residual at the end of the
refinement steps to allow the user to verify that double precision accuracy has been obtained.

In general, HPL-AI performance will increase with matrix size and the benchmark is typically scaled so that the global matrix
fills most of the available GPU memory. Optimal parameters depend on the system. Examples of parameters on AMD Instinct GPUs:


### MI100
*  4 GCD: `mpirun -np 4 --map-by node:PE=1 hpl-ai -P 2 -B 2560 -N 168960`
*  8 GCD: `mpirun -np 8 --map-by node:PE=1 hpl-ai -P 4 -B 2560 -N 235520`

### MI210/MI250/MI250X
*  4 GCD: `mpirun -np 4 --map-by node:PE=1 hpl-ai -P 2 -B 2560 -N 235520`
*  8 GCD: `mpirun -np 8 --map-by node:PE=1 hpl-ai -P 4 -B 2560 -N 332800`


### Advanced performance tuning
While the above limited set of arguments give decent performance across systems with Infinity Fabric, additional
tuning may give even better results. HPL-AI provides several command line options which combined with MPI
arguments and UCX environment variables can have significant impact on performance. This is particularly true when
high-speed intra-GPU communication is not available. The following lists a combination of settings that have worked
well on systems limited to communication across PCIe.

**MPI/UCX arguments:**
```
    --mca pml ucx
    --map-by numa:PE=1
    -x UCX_RNDV_PIPELINE_SEND_THRESH=256k
    -x UCX_RNDV_FRAG_SIZE=rocm:4m
    -x UCX_RNDV_THRESH=128
    -x UCX_TLS=sm,self,rocm_copy,rocm_ipc
```
**HPL-AI arguments:**
```
   -P                     The first dimension of the process grid. Requires mod(numprocs,P) = 0.
   -B                     The block size. Requires mod(N,B) = 0, otherwise code will adjust N automatically.
   -N                     The matrix size.

   -numa 2                Set the number of numa processes
   -pmap CONT2D           How to allocate numa-processes on the processor grid
```

For a complete list of hpl-ai arguments, see `hpl-ai -hidden_help`.
```
=================================================================================================
=                        HPL-AI Mixed-Precision Benchmark for AMD GPUs                          =
=================================================================================================

usage: mpirun -n <numprocs> [mpiarguments] ./hpl-ai -N <n> -B <b> -P <p> [arguments]

Arguments:
   -N                     The matrix size.
   -B                     The block size. Requires mod(N,B) = 0, otherwise code will adjust N automatically.
   -P                     The first dimension of the process grid. Requires mod(numprocs,P) = 0.
   -maxits                Maximal IR iterations.
   -alg                   LU factorization algorithms.
                          0: using chain scheduler, right panel tiled or not, controlled by tile_rpanel. (Default)
                          1: using chain scheduler, right panel tiled or not, controlled by tile_rpanel. Event version.
                          2: using chain scheduler, right panel tiled
                          3: using ring broadcast, right panel tiled or not, controlled by tile_rpanel.
   -tile_rpanel           Right panel uses tile layout.
   +tile_rpanel           Right panel doesn't use tile layout. (Default)
   -overlap               Enable communication and computation overlap for LU algorithm 1. (Default)
   +overlap               Disable communication and computation overlap.
   -gpu_aware_gemv        Use GPU-aware MPI for panel GEMV. (Default)
   +gpu_aware_gemv        Use regular MPI for panel GEMV.
   -numa <nnumaprocs>     Set the number of numa processes.
   -pmap <pmap>           How to allocate numa-processes on the processor grid.
                          rowcont/ROWCONT : continuous in row.
                          colcont/COLCONT : continuous in column.
                          rowdist/ROWDIST : distributed over row. (Default)
                          coldist/COLDIST : distributed over col.
                          cont2d/CONT2D   : continuous in 2d grid.
   -numap <numap>         numa topology of cont2d, must be a multiple of nnumaprocs
   -nbuf <nbuf>           The number of working buffer for broadcasting L and U panels.
                          nbuf >= 3. Default uses nbuf = 4.
   -ring_type             Ring communication type for left and right panels. Wrong type will be switched to 0.
                         -1: broadcast
                          0: bi-direction (Default)
                          1: increasing 1 ring
                          2: modified increasing 1 ring
                          3: increasing 2 ring
                          4: modified increasing 2 ring
                          5: increasing 3 ring
                          6: modified increasing 3 ring
                          7: increasing 4 ring
                          8: modified increasing 4 ring
   -rring_type            Right panel ring communication type. Wrong type will be switched to ring_type.
                          Higher priority than ring_type if being set.
   -lring_type            Left panel ring communication type. Wrong type will be switched to ring_type.
                          Higher priority than ring_type if being set.
   -async_send            Asynchronous MPI send. (Default)
   +async_send            Synchronous MPI send.
   -async_recv            Asynchronous MPI receive. (Default)
   +async_recv            Synchronous MPI receive.
   -nsend                 How many message chunks one MPI_Send uses.
   -gpu-aware-mpi         GPU-aware MPI (Default)
   +gpu-aware-mpi         Regular non-GPU-aware MPI
   -bind-gpu              Bind GPU to MPI. (Default)
   +bind-gpu              Don't bind gpu to MPI.
   -job-id <job-id>       An integer tag for the output of the timing statistics. Default uses job-id = 0.
=================================================================================================
```

# Licensing Information 

Your use of this application is subject to the terms of the applicable component-level license identified below. To the extent any subcomponent in this container requires an offer for corresponding source code, AMD hereby makes such an offer for corresponding source code form, which will be made available upon request. By accessing and using this application, you are agreeing to fully comply with the terms of this license. If you do not agree to the terms of this license, do not access or use this application.  

The application is provided in a container image format that includes the following separate and independent components: Ubuntu (License: Creative Commons CC-BY-SA version 3.0 UK licence), CMAKE (License: BSD 3), OpenMPI (License: BSD 3-Clause), OpenUCX (License: BSD 3-Clause), ROCm (License: Custom/MIT/Apache V2.0/UIUC OSL), HPL-AI (License: BSD 3-Clause). Additional third-party content in this container may be subject to additional licenses and restrictions. The components are licensed to you directly by the party that owns the content pursuant to the license terms included with such content and is not licensed to you by AMD. ALL THIRD-PARTY CONTENT IS MADE AVAILABLE BY AMD “AS IS” WITHOUT A WARRANTY OF ANY KIND. USE OF THE CONTAINER IS DONE AT YOUR SOLE DISCRETION AND UNDER NO CIRCUMSTANCES WILL AMD BE LIABLE TO YOU FOR ANY THIRD-PARTY CONTENT. YOU ASSUME ALL RISK AND ARE SOLELY RESPONSIBLE FOR ANY DAMAGES THAT MAY ARISE FROM YOUR USE OF THE CONTAINER.  

## Disclaimer   

The information contained herein is for informational purposes only, and is subject to change without notice. In addition, any stated support is planned and is also subject to change. While every precaution has been taken in the preparation of this document, it may contain technical inaccuracies, omissions and typographical errors, and AMD is under no obligation to update or otherwise correct this information. Advanced Micro Devices, Inc. makes no representations or warranties with respect to the accuracy or completeness of the contents of this document, and assumes no liability of any kind, including the implied warranties of noninfringement, merchantability or fitness for particular purposes, with respect to the operation or use of AMD hardware, software or other products described herein. No license, including implied or arising by estoppel, to any intellectual property rights is granted by this document. Terms and limitations applicable to the purchase or use of AMD’s products are as set forth in a signed agreement between the parties or in AMD's Standard Terms and Conditions of Sale.    
