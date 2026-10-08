---
tags: [acc, slurm, mpi]
---

# Submitting jobs

Always give a time limit with `--time`.
Defaults: [Time and memory](time-memory.md). Partitions: [Partitions and limits](partitions-limits.md).
Use `sbatch` for normal job submission. Use `srun` when you need an interactive
shell, to test commands, or to run short-lived applications.

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
srun --nodes=1 --ntasks=1 --time=00:30:00 --pty bash
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
module load openmpi/5.0.10-gcc-13.3.0
srun --mpi=pmix ./hello
```

More: [MPI](software/mpi.md).

## Software in job scripts

Load the module first, then your modules:

```bash
module load <app>
./<app> --input mydataset
```

More: [Modules](software/modules.md).

## Job-specific scratch directory

Keep source code, scripts, small inputs and final results in `$HOME`. Stage large
temporary input into a job-specific scratch directory, and copy valuable outputs back
before the job ends:

```bash
SCRATCH_DIR="/scratch/$USER/$SLURM_JOB_ID"
mkdir -p "$SCRATCH_DIR"
cp -a "$HOME/my-project/input/." "$SCRATCH_DIR/"

# Run the application against files in $SCRATCH_DIR.

mkdir -p "$HOME/my-project/results/$SLURM_JOB_ID"
cp -a "$SCRATCH_DIR/output/." "$HOME/my-project/results/$SLURM_JOB_ID/"
rm -rf "$SCRATCH_DIR"
```

Use one directory per job or experiment, and include `$SLURM_JOB_ID` in log and
scratch paths. Always copy final results to `$HOME` and clean up scratch data when it
is no longer needed.

## Best practices

- Request only the nodes, tasks, memory and wall time the job needs.
- Use `/scratch` for I/O-intensive MPI runs; keep final results in `$HOME`.
- Record loaded modules with `module list` and MPI details with `mpirun --version`
  in the job output, for reproducibility.
- Never store private SSH keys, passwords or access tokens in job scripts.

## Problems

Error at submit time? See [Troubleshooting](troubleshooting.md).
Follow your jobs: [Monitoring](monitoring.md).
