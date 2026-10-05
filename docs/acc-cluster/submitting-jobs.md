---
tags:
  - acc-cluster
  - researcher
  - slurm
  - mpi
---

# Submitting Jobs

_Placeholder — Slurm partitions, example batch script, interactive jobs, monitoring commands._

## Example batch script

```bash
#!/bin/bash
#SBATCH --job-name=example
#SBATCH --partition=<partition>
#SBATCH --nodes=1
#SBATCH --time=01:00:00

module load <module>
srun <command>
```

## Useful commands

| Command | Purpose |
|---|---|
| `squeue` | View queued/running jobs |
| `sacct` | View job accounting history |
| `scancel <jobid>` | Cancel a job |
