---
tags: [acc, getting-started, slurm]
---

# Getting started

Your first job, in five steps. Connect first (see the [overview](index.md)).

## 1. Check the environment

After signing in, check Slurm and the mounted storage:

```bash
hostname
sinfo
squeue -u "$USER"
findmnt /shared
findmnt /scratch
df -h "$HOME" /scratch
```

Your home directory is persistent shared storage, under `/shared/home`.
Use `$HOME` rather than hard-coding that path in scripts.
`/scratch` is a Lustre filesystem, optimized for high-throughput, low-latency
job data. Scratch is not a substitute for your persistent home directory.
See [Storage](storage.md) for the details of the storage strategy.

## 2. Write a job script

Save as `first.sh`:

```bash
#!/bin/bash
#SBATCH --job-name=first
#SBATCH --time=00:05:00
#SBATCH --output=%x-%j.out

set -e
echo "Running on $(hostname)"
date
```

Without `--partition`, your job goes to `serial` (up to 16 cores, 7 days).
Without `--time`, the limit is 1 hour.

## 3. Submit it

```bash
sbatch first.sh
```

```text
Submitted batch job 123
```

## 4. Watch it

```bash
squeue --me
```

## 5. Read the output

The output file is named `<job-name>-<jobid>.out`:

```bash
cat first-123.out
```

Do not run compute-heavy applications on the login node outside a Slurm
allocation — submit a job or start an
[interactive session](submitting-jobs.md#interactive-session) instead.

## Next

- [Submitting jobs](submitting-jobs.md): batch, interactive, array and MPI jobs
- [Time and memory](time-memory.md) and [Partitions and limits](partitions-limits.md)
- [Monitoring](monitoring.md) and [Storage](storage.md)
