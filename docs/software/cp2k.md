---
tags: [software, cp2k]
---

# CP2K

CP2K 2024.1 built with GCC 13.3.0. The main executable is `cp2k.psmp`.

```bash
module load cp2k/2024.1-gcc-13.3.0
```

This also loads Open MPI 5.0.3, OpenBLAS and ScaLAPACK.

## Job script

```bash
#!/bin/bash
#SBATCH --account=<project>
#SBATCH --partition=serial
#SBATCH --ntasks=16
#SBATCH --time=24:00:00
source /etc/profile.d/zz-lmod-hpc.sh
module load cp2k/2024.1-gcc-13.3.0
export OMP_NUM_THREADS=1
srun --mpi=pmix cp2k.psmp -i input.inp -o output.out
```

Keep input files in your home directory or `/scratch`.
Limits and other partitions: [Partitions and limits](../acc-cluster/partitions-limits.md).
See also [Modules](modules.md) and [MPI](mpi.md).
