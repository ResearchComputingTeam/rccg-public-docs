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

`mpi/openmpi-5.0.10` and `mpi/mvapich-4.1` cannot be loaded together.

## Applications bring their own MPI

The GROMACS, LAMMPS and CP2K modules load `openmpi/5.0.3-gcc-13.3.0` automatically.
You do not need to load an MPI yourself to run them.

## Your own MPI program

Compile with the default Open MPI and launch with `srun --mpi=pmix`.

```bash
module load openmpi/5.0.10-gcc-13.3.0
mpicc hello.c -o hello
```

`hello.c`:

```c
#include <mpi.h>
#include <stdio.h>
int main(int c, char **v) {
  int r, n;
  MPI_Init(&c, &v);
  MPI_Comm_rank(MPI_COMM_WORLD, &r);
  MPI_Comm_size(MPI_COMM_WORLD, &n);
  printf("rank %d of %d\n", r, n);
  MPI_Finalize();
  return 0;
}
```

Job script (2 nodes, 4 ranks):

```bash
#!/bin/bash
#SBATCH --account=<project>
#SBATCH --partition=n2
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --time=00:10:00
source /etc/profile.d/zz-lmod-hpc.sh
module load openmpi/5.0.10-gcc-13.3.0
srun --mpi=pmix ./hello
```

!!! warning
    Keep your program and files in your home directory or `/scratch`.
    `/tmp` is local to each node, so the other nodes cannot see it.

Available launch methods are listed by `srun --mpi=list`.

<!-- TODO: mpirun inside a job -->
