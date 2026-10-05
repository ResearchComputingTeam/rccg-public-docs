---
tags: [software, gromacs]
---

# GROMACS

GROMACS 2024.1 built with GCC 13.3.0. The executable is `gmx_mpi`.

```bash
module load gromacs/2024.1-gcc-13.3.0
```

This also loads Open MPI 5.0.3 and OpenBLAS.

## Job script

```bash
#!/bin/bash
#SBATCH --account=<project>
#SBATCH --partition=serial
#SBATCH --ntasks=16
#SBATCH --time=24:00:00
source /etc/profile.d/zz-lmod-hpc.sh
module load gromacs/2024.1-gcc-13.3.0
srun --mpi=pmix gmx_mpi mdrun -deffnm md
```

Keep input files in your home directory or `/scratch`.
Limits and other partitions: [Partitions and limits](../acc-cluster/partitions-limits.md).
See also [Modules](modules.md) and [MPI](mpi.md).
