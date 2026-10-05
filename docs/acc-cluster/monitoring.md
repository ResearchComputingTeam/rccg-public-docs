---
tags: [acc, slurm, monitoring]
---

# Monitoring jobs

## Your jobs

```bash
squeue --me                         # your queued and running jobs
squeue -j <jobid>                   # one job
scontrol show job <jobid>           # full details
```

## Finished jobs

```bash
sacct -j <jobid> --format=JobID,JobName,Partition,State,Elapsed,AllocCPUS,MaxRSS
```

## Cancel

```bash
scancel <jobid>
scancel -u $USER                    # all your jobs
```

## Partitions and nodes

```bash
sinfo
```

<!-- TODO: how to check remaining allocation -->
