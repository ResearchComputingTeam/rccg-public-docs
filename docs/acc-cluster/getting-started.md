---
tags: [acc, getting-started, slurm]
---

# Getting started

Your first job, in five steps. Connect first (see the [overview](index.md)).

## 1. Write a job script

Save as `first.sh`:

```bash
#!/bin/bash
#SBATCH --job-name=first
#SBATCH --time=00:05:00
#SBATCH --output=%x-%j.out
echo "Running on $(hostname)"
date
```

Without `--partition`, your job goes to `serial` (up to 16 cores, 7 days).
Without `--time`, the limit is 1 hour.

## 2. Submit it

```bash
sbatch first.sh
```

```text
Submitted batch job 123
```

## 3. Watch it

```bash
squeue --me
```

## 4. Read the output

The output file is named `<job-name>-<jobid>.out`:

```bash
cat first-123.out
```

## Next

- [Submitting jobs](submitting-jobs.md): batch, interactive, array and MPI jobs
- [Time and memory](time-memory.md) and [Partitions and limits](partitions-limits.md)
- [Monitoring](monitoring.md) and [Storage](storage.md)
