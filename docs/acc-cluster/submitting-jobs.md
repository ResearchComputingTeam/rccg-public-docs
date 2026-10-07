---
tags: [acc, slurm, mpi]
---

# Submitting jobs

Always give a time limit with `--time`.
Defaults: [Time and memory](time-memory.md). Partitions: [Partitions and limits](partitions-limits.md).

## Batch job

```bash
#!/bin/bash
#SBATCH --job-name=myjob
#SBATCH --partition=serial
#SBATCH --ntasks=1
#SBATCH --time=02:00:00
#SBATCH --output=%x-%j.out
./my_program
```

```bash
sbatch job.sh
```

Keep your program and files in your home directory or `/scratch`, not `/tmp`
([Storage](storage.md)).

## Interactive session

```bash
srun --time=00:30:00 --pty bash
```

Type `exit` to end it. An interactive session ends if your connection drops,
so use batch jobs for anything long.

## Job array

Run the same script for several inputs:

```bash
#!/bin/bash
#SBATCH --job-name=array
#SBATCH --time=00:05:00
#SBATCH --array=1-4
#SBATCH --output=%x-%A_%a.out
echo "task $SLURM_ARRAY_TASK_ID on $(hostname)"
```

Each task has its own output file, `<job-name>-<array-jobid>_<task>.out`.
E.g.
Files created from above job : array-197_1.out, array-197_2.out, array-197_3.out, array-197_4.out
Content of a file : 
```bash
$ cat array-197_2.out
task 2 on <name_of_the_node>
```

## Several nodes (MPI)

Use `n2` (up to 2 nodes) or `n3` (up to 3 nodes) and launch with `srun --mpi=pmix`:

```bash
#!/bin/bash
#SBATCH --partition=n2
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --time=00:10:00
source /etc/profile.d/zz-lmod-hpc.sh
module load openmpi/5.0.10-gcc-13.3.0
srun --mpi=pmix ./hello
```

More: [MPI](../software/mpi.md).

## Software in job scripts

Load the module first, then your modules:

```bash
module load <app>
./<app> --input mydataset
```

More: [Modules](../software/modules.md).

## Problems

Error at submit time? See [Troubleshooting](troubleshooting.md).
Follow your jobs: [Monitoring](monitoring.md).
