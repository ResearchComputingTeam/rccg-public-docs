---
tags: [software, lammps]
---

# LAMMPS

LAMMPS 20230802.3 built with GCC 13.3.0. The executable is `lmp`.

```bash
module load lammps/20230802.3-gcc-13.3.0
```

This also loads Open MPI 5.0.3. The module sets `LAMMPS_POTENTIALS` to the bundled potential files.

## Job script

```bash
#!/bin/bash
#SBATCH --account=<project>
#SBATCH --partition=serial
#SBATCH --ntasks=16
#SBATCH --time=24:00:00
source /etc/profile.d/zz-lmod-hpc.sh
module load lammps/20230802.3-gcc-13.3.0
srun --mpi=pmix lmp -in in.lammps
```

Keep input files in your home directory or `/scratch`.
See also [Modules](modules.md) and [MPI](mpi.md).
