---
tags:
  - software
  - researcher
---

# Software — Overview

The ACC cluster provides software through Lmod environment modules. Application and
library modules are built with Spack; Python environments are also available through
Conda. Use the pages below to find the right module and job example.

## Find and load software

Start by searching the available modules. Use the exact module name and version shown
by Lmod, then load it in your interactive shell or batch script:

```bash
module avail
module spider gromacs
module load gromacs/2024.1-gcc-13.3.0
module list
```

See [Modules](modules.md) for more commands, module naming, and batch-script use.

## Software guides

- [Python and Conda](conda.md): ready-made Python 3.12 environments and how to make
  a personal copy.
- [Compilers and libraries](libraries.md): available scientific libraries, including
  OpenBLAS, ScaLAPACK, HDF5, and NetCDF.
- [MPI](mpi.md): available MPI stacks, compiling and launching MPI programs, and
  Intel MPI over InfiniBand.
- [GROMACS](gromacs.md), [LAMMPS](lammps.md), and [CP2K](cp2k.md): installed versions,
  module names, and Slurm job examples.
- [Containers on the ACC cluster](containers.md): running and building Apptainer
  images in batch jobs, image storage, and troubleshooting.

Application modules load their required dependencies. For example, the GROMACS,
LAMMPS, and CP2K modules load Open MPI 5.0.3 automatically. You do not need to load
another MPI module to run those applications.

## Python environments

The `datascience-conda-env/2026.09` and `ml-cpu-conda-env/2026.09` modules provide
read-only environments that you can load directly. To install packages or customize
an environment, load `conda/2026.03` and clone a provided environment into your home
directory. See [Python and Conda](conda.md) for commands and package details.

Keep input files in your home directory or `/scratch` when running jobs. For help
with submitting jobs and cluster resources, see [Submitting jobs](../submitting-jobs.md)
and [Storage](../storage.md).
