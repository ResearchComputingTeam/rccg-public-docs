---
tags: [acc, slurm, monitoring]
---

# Monitoring jobs

## Your jobs

```bash
squeue --me
```

```text
JOBID PARTITION  NAME  USER ST  TIME NODES NODELIST(REASON)
  169    serial  wrap  user  R  0:07     1 node01
```

`R` means running.

## One job in detail

```bash
scontrol show job <jobid>
```

Useful fields: `JobState`, `Reason`, `RunTime`, `TimeLimit`, `Partition`, `Account`, `QOS`,
`ReqTRES` (what you asked for) and `AllocTRES` (what you got).

## Why is my job pending?

A new job can stay pending (`PD`) while the cluster creates compute nodes.
To see the reason:

```bash
squeue -j <job-id> -o "%.18i %.2t %.30R"
```

- `Resources` usually means nodes are scaling up — the job should start soon.
- Quota, capacity or configuration messages (for example an exhausted project
  allocation) require an administrator.

`scontrol show job <jobid>` also shows the pending reason in the `Reason` field.

## Running and finished jobs

```bash
sacct -j <jobid> --format=JobID,JobName,Partition,State,Elapsed,AllocNodes,AllocCPUS,MaxRSS,ExitCode
```

```text
JobID       JobName  Partition  State    Elapsed  Nodes  CPUs  MaxRSS  ExitCode
169         wrap     serial     RUNNING  00:00:35      1     1             0
169.batch   batch              RUNNING  00:00:35      1     1             0
```

`MaxRSS` (peak memory) and `ExitCode` are filled in when the job ends.

## Cancel a job

```bash
scancel <jobid>
```

## Partitions and nodes

```bash
sinfo -s
```

```text
PARTITION AVAIL  TIMELIMIT   NODES(A/I/O/T) NODELIST
serial*      up 7-00:00:00          0/8/0/8 node[01-08]
n1           up 4-00:00:00          0/8/0/8 node[01-08]
n2           up 4-00:00:00          0/8/0/8 node[01-08]
n3           up 3-00:00:00          0/8/0/8 node[01-08]
```

Node names are shortened here. The reserved `dynamic` partition is also listed on the cluster.

<!-- TODO: how to check remaining allocation -->
