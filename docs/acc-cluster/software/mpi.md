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
| `mpi/2021.17` | Intel MPI 2021.17 |
| `impi/2021.16` | Intel MPI 2021.16 |
| `mpi/impi-2021` | Intel MPI 2021.16 (system module, alternative name) |
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
#SBATCH --partition=n2
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --time=00:10:00
module load openmpi/5.0.10-gcc-13.3.0
srun --mpi=pmix ./hello
```

## Intel MPI over InfiniBand

The compute nodes provide an InfiniBand fabric. Intel MPI 2021.17 and 2021.16
are available as modules; check the exact names with `module avail`.

For InfiniBand, set the fabric variables and launch with `mpirun`. Do not
select `verbs` for normal benchmarks on this cluster:

```bash
export I_MPI_FABRICS=shm:ofi
export I_MPI_OFI_PROVIDER=mlx
export FI_PROVIDER=mlx
```

`module load` sets up `I_MPI_ROOT` and `INTELMPI_ROOT` and activates the
module, so you do not need to set those or source the activation script
manually.

Compile with Intel MPI, then launch a two-node job with `mpirun`:

```bash
module load mpi/2021.17
mpicc hello.c -o hello
```

```bash
#!/bin/bash
#SBATCH --job-name=mpi-hello
#SBATCH --partition=n2
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --time=00:10:00
#SBATCH --output=%x-%j.log
#SBATCH --error=%x-%j.err

set -e
export I_MPI_FABRICS=shm:ofi
export I_MPI_OFI_PROVIDER=mlx
export FI_PROVIDER=mlx

module load mpi/2021.17
echo "Intel MPI version: $(mpirun --version | head -n 1)"
mpirun ./hello
```

MPI needs at least two RDMA-capable nodes. If MPI falls back to TCP or
performs poorly, confirm the job has two RDMA-capable nodes and prints the
fabric variables above; see [Troubleshooting](../troubleshooting.md).

!!! warning
    Keep your program and files in your home directory or `/scratch`.
    `/tmp` is local to each node, so the other nodes cannot see it.

Available launch methods are listed by `srun --mpi=list`.
