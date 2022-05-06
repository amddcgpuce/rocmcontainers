```
Copyright (c) 2022 Advanced Micro Devices, Inc. All Rights Reserved.
Revision: V1.0
V1.0: add docker and singualrity commands 
```

# OpenMM

## Pull Command

```
sudo docker pull amdih/openmm:7.7.0_49
```

## Runing Containers

### Using Docker
#### Interactive

Run the container interactively
```
sudo docker run --rm -it --ipc=host --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined amdih/openmm:7.7.0_49 /bin/bash
```
There is a built-in script that will execute, from the /benchmarks directory, all the standard benchmarks packaged with OpenMM. So, if you want to collect figure of merit numbers, following running the container interactive you may do:
```
run-benchmarks
```
The benchmarks script will attempt to run all the pre-packaged benchmarks in a reasonable configuration for your system but you may wish to change the arguments for your system.
```
python3 /opt/openmm/examples/benchmark.py --help
```
will list the arguments available in the pre-packaged executor. Benchmarking everything might take many minutes depending on how many tests are run. The resulting figure of merit for each benchmark will be output to the screen.

Other examples that come prepackaged with OpenMM are available on $OPENMM_PATH/examples (/opt/openmm/examples)

#### Non-interactive Benchmarks

You may run the benchmarks non-interactively from the host
```
sudo docker run --rm -it --ipc=host --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined amdih/openmm:7.7.0_49 run-benchmarks
```

### Using Singularity

This section assumes that an up-to-date version of Singularity is installed on your system and properly configured for your system. Please consult with your system administrator or view official Singularity documentations.

Pull and convert docker image to singularity image format:
```
singularity pull openmm.sif docker://amdih/openmm:7.7.0_49
```
You can then use examples from the preceding section to use the image. For example, to run all built-in benchmarks, do
```
singularity run ./openmm.sif run-benchmarks
```
Or to your custom simulation where you have input.pdb and simulation.py in your current working directory, then
```
singularity run --pwd $(pwd) ./openmm.sif python3 simulation.py
```
### Run Using Scripts
Script run_openmm_docker.sh executes the OpenMM docker commands by running:
```
sudo sh run_openmm_docker.sh
```
Script run_openmm_singularity.sh runs the singularity test commands by performing:
```
sh run_openmm_singularity.sh
```
