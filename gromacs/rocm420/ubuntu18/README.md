# ROCm-4.2.0-based Gromacs Container

## 1.0 How to Use Docker Container
#### On Ubuntu 18/20 HWE, CentOS/RHEL 7.x, or SLES 15 SP2, use docker:
```
# Launch container in interactive mode, bash shell
sudo docker run -it --privileged --ipc=host --network=host --device=/dev/kfd --device=/dev/dri --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined amddcgpuce/gromacs_2020_3-rocm420-ubuntu18 bash
```
#### On CentOS/RHEL 8.x, use podman:
```
# Launch container in interactive mode, bash shell
sudo podman run -it --privileged docker://amddcgpuce/gromacs_2020_3-rocm420-ubuntu18 bash
```
##### Image Name + Tag | Description
```
    gromacs_2020_3-rocm420-ubuntu18:version1   -->   Gromacs v2020_3 based on ROCm v4.2.0 On Ubuntu18 (Version 1)
```

## 2.0 Steps to build Singularity container from docker image
#### Download Singularity Definition File
```
# Download Singularity Definition file
wget -O gromacs_2020_3-rocm420.ubuntu18.sdf --no-check-certificate https://raw.githubusercontent.com/amddcgpuce/rocmcontainers/main/gromacs/rocm420/ubuntu18/gromacs_2020_3.rocm420.ubuntu18.sdf
```
#### Build Singularity Image File (SIF)
##### On Ubuntu 18.04/20.04 HWE with singularity installed under /usr/local/bin
```
sudo /usr/local/bin/singularity build gromacs_2020_3.rocm420.ubuntu18.sif gromacs_2020_3.rocm420.ubuntu18.sdf
```
##### On CentOS/RHEL 8 with singularity RPM installed
```
sudo singularity build gromacs_2020_3.rocm420.ubuntu18.sif gromacs_2020_3.rocm420.ubuntu18.sdf
```
	
## 3.0 Example Usage of GROMACS Docker Container
#### GROMACS MPI Examples
```
# Launch container in interactive mode, bash shell on a Ubuntu18 system
sudo docker run -it --privileged --ipc=host --network=host --device=/dev/kfd --device=/dev/dri --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined amddcgpuce/gromacs_2020_3-rocm420-ubuntu18 bash

# Example of adh_dodec benchmarks: 
source /usr/local/gromacs/bin/GMXRC 
cd /opt/gromacs/benchmark/adh_dodec
/usr/local/gromacs/bin/gmx_mpi grompp -f pme_verlet.mdp -c conf.gro -p topol.top -maxwarn 20
mpirun --allow-run-as-root -np 2 gmx_mpi mdrun -nsteps 100000 -resetstep 90000 -ntomp 24 -noconfout -nb gpu -bonded cpu -pme gpu -npme 1 -v -nstlist 400 -gpu_id 0 -s topol.tpr

# Example of stmv benchmarks: 
source /usr/local/gromacs/bin/GMXRC 
cd /opt/gromacs/benchmark/stmv
/usr/local/gromacs/bin/gmx_mpi grompp -f pme_verlet.mdp -c stmv.gro -p stmv.top -maxwarn 20
mpirun --allow-run-as-root -np 2 gmx_mpi mdrun -nsteps 100000 -resetstep 90000 -ntomp 24 -noconfout -nb gpu -bonded cpu -pme gpu -npme 1 -v -nstlist 400 -gpu_id 0 -s topol.tpr

# Example of cellulose_nve benchmarks: 
source /usr/local/gromacs/bin/GMXRC 
cd /opt/gromacs/benchmark/cellulose_nve
/usr/local/gromacs/bin/gmx_mpi grompp -f pme_verlet.mdp -c cellulose_nve.gro -p cellulose_nve.top -maxwarn 20
mpirun --allow-run-as-root -np 2 gmx_mpi mdrun -nsteps 100000 -resetstep 90000 -ntomp 24 -noconfout -nb gpu -bonded cpu -pme gpu -npme 1 -v -nstlist 400 -gpu_id 0 -s topol.tpr
```
#### GROMACS Threaded MPI Examples
```
# Example of adh_dodec benchmarks: 
source /usr/local/gromacs/bin/GMXRC 
cd /opt/gromacs/benchmark/adh_dodec
/usr/local/gromacs/bin/gmx grompp -f pme_verlet.mdp -c conf.gro -p topol.top -maxwarn 20
gmx mdrun -v -nsteps 100000 -resetstep 90000 -noconfout -ntmpi 2 -ntomp 28 -nb gpu -bonded gpu -pme gpu -npme 1 -nstlist 400 -gpu_id 0 -s topol.tpr

# Example of stmv benchmarks: 
source /usr/local/gromacs/bin/GMXRC 
cd /opt/gromacs/benchmark/stmv
/usr/local/gromacs/bin/gmx grompp -f pme_verlet.mdp -c stmv.gro -r stmv.gro -p stmv.top -o stmv.tpr
gmx mdrun -v -nsteps 100000 -resetstep 90000 -noconfout -ntmpi 2 -ntomp 28 -nb gpu -bonded gpu -pme gpu -npme 1 -nstlist 400 -gpu_id 0 -s stmv.tpr

# Example of cellulose_nve benchmarks: 
source /usr/local/gromacs/bin/GMXRC 
cd /opt/gromacs/benchmark/cellulose_nve
/usr/local/gromacs/bin/gmx grompp -f pme_verlet.mdp -c cellulose_nve.gro -r cellulose_nve.gro -p cellulose_nve.top -o nve.tpr
gmx mdrun -v -nsteps 100000 -resetstep 90000 -noconfout -ntmpi 2 -ntomp 28 -nb gpu -bonded gpu -pme gpu -npme 1 -nstlist 400 -gpu_id 0 -s nve.tpr
```

## 4.0 Example Usage of Gromacs Singularity Container
#### Run Help
```
singularity run-help gromacs_2020_3.rocm420.ubuntu18.sif
```
##### Output
```
    singularity run gromacs_2020_3.rocm420.ubuntu18.sif /bin/bash -c "cp -r benchmark $HOME/Documents/"
    singularity run gromacs_2020_3.rocm420.ubuntu18.sif /bin/bash -c "cd $HOME/Documents/benchmark/adh_dodec; /usr/local/gromacs/bin/gmx_mpi grompp -f pme_verlet.mdp -c conf.gro -p topol.top -maxwarn 20"
    singularity run gromacs_2020_3.rocm420.ubuntu18.sif /bin/bash -c "cd $HOME/Documents/benchmark; ./run.sh"
```
#### Copy GROMACS benchmark samples from container to $HOME/Documents on host
```
singularity run gromacs_2020_3.rocm420.ubuntu18.sif /bin/bash -c "cp -r benchmark $HOME/Documents/"
```
##### Output
```
Container was created Mon May 17 22:30:31 UTC 2021
CWD: /opt/gromacs Launching: /bin/bash -c cp -r benchmark /home/USERHOME/Documents/
```
#### Running sample benchmark#1
```
singularity run gromacs_2020_3.rocm420.ubuntu18.sif /bin/bash -c "cd $HOME/Documents/benchmark/adh_dodec; /usr/local/gromacs/bin/gmx_mpi grompp -f pme_verlet.mdp -c conf.gro -p topol.top -maxwarn 20"
```
##### Output
```
Container was created Mon May 17 22:30:31 UTC 2021
CWD: /opt/gromacs Launching: /bin/bash -c cd /home/USERHOME/Documents/benchmark/adh_dodec; /usr/local/gromacs/bin/gmx_mpi grompp -f pme_verlet.mdp -c conf.gro -p topol.top -maxwarn 20
--------------------------------------------------------------------------
...output snipped...
```
#### Running sample benchmark#2
```
singularity run gromacs_2020_3.rocm420.ubuntu18.sif /bin/bash -c "cd $HOME/Documents/benchmark; ./run.sh"
```
##### Output
```
Container was created Mon May 17 22:30:31 UTC 2021
CWD: /opt/gromacs Launching: /bin/bash -c cd /home/USERHOME/Documents/benchmark; ./run.sh
--------------------------------------------------------------------------
...output snipped...
```

## 5.0 Incompatible ROCm Environment Check Message
### ROCm 4.1 Kernel Modules (rock-dkms, rock-dkms-firmware) or newer is required on MI50/MI60 platforms to run ROCm 4.1 or newer user space stack 

#### Docker Run Failure Message On Incompatible ROCm Environment
```
sudo docker run -it --privileged --ipc=host --network=host --device=/dev/kfd --device=/dev/dri --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined amddcgpuce/gromacs_2020_3-rocm420-ubuntu18 bash
```
##### Output
```
Error: Incompatible ROCm environment. The Docker container
requires the latest kernel driver to operate correctly.

Upgrade the ROCm kernel to v4.1 or newer, or use a container
tagged for v4.0.1 or older.

To inspect the version of the installed kernel driver, run either:
      dpkg --status rock-dkms [Debian-based]
      rpm -ql rock-dkms [RHEL, SUSE, and others]

To install or update the driver, follow the installation instructions at:
    https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html
```

#### Singularity Run Failure Message On Incompatible ROCm Environment
```
singularity run gromacs_2020_3.rocm420.ubuntu18.sif /bin/bash -c "cp -r benchmark $HOME/Documents/"
```
##### Output
```
Container was created Mon May 17 22:30:31 UTC 2021

Error: Incompatible ROCm environment. The Docker container 
requires the latest kernel driver to operate correctly.

Upgrade the ROCm kernel to v4.1 or newer, or use a container 
tagged for v4.0.1 or older.

To inspect the version of the installed kernel driver, run either:
    . dpkg --status rock-dkms [Debian-based]
    . rpm -ql rock-dkms [RHEL, SUSE, and others]

To install or update the driver, follow the installation instructions at:
    https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html

```
