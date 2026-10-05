---
tags: [software, mpi]
---

# MPI

Several MPI stacks are installed.

| Module | What it is |
|---|---|
| `openmpi/5.0.10-gcc-13.3.0` (default) | Open MPI 5.0.10, GCC 13.3.0 |
| `openmpi/5.0.3-gcc-13.3.0` | Open MPI 5.0.3, GCC 13.3.0 |
| `mpi/openmpi-5.0.10` | Open MPI 5.0.10 (same release as the default above) |
| `mpi/hpcx` | NVIDIA HPC-X 2.25.1 |
| `mpi/impi-2021` | Intel MPI 2021.16 |
| `mpi/mvapich-4.1` | MVAPICH 4.1 |

## Applications bring their own MPI

The GROMACS, LAMMPS and CP2K modules load `openmpi/5.0.3-gcc-13.3.0` automatically.
You do not need to load an MPI yourself to run them.
See [Modules](modules.md).

## Loading one yourself

```bash
module load openmpi/5.0.10-gcc-13.3.0
```

`mpi/openmpi-5.0.10` and `mpi/mvapich-4.1` cannot be loaded together.

<!-- TODO: recommended MPI for your own code -->
<!-- TODO: how to launch MPI programs (srun or mpirun) -->
<!-- TODO: compile and run example -->
