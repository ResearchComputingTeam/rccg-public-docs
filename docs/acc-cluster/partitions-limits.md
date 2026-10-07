---
tags: [acc, slurm, limits]
---

# Partitions and limits

*Last verified: 2026-10-07*

## Hardware

Each compute node has 120 cores and 443,596 MiB of memory. There are 8 nodes and no GPUs.
Cores are allocated individually and nodes are not oversubscribed.

## Partitions

If you do not choose a partition with `-p`, your job goes to `serial`.

| Partition | Nodes per job | Max cores | Max time | Max memory |
|---|---|---|---|---|
| `serial` (default) | 1 | 16 | 168 h (7 days) | 59,136 MiB |
| `n1` | 1 | 120 | 96 h (4 days) | 443,596 MiB per node |
| `n2` | up to 2 | 240 | 96 h (4 days) | 443,596 MiB per node |
| `n3` | up to 3 | 360 | 72 h (3 days) | 443,596 MiB per node |

Check the current values:

```bash
sinfo -o "%P %l %D %c %m"
```

The `dynamic` partition is reserved for administrators.

## Limits

| Limit | Value |
|---|---|
| Cores per user, running at once | 360 |
| Cores per project, running at once | 480 |

## Project allocation

Each project has a core-hour allocation that does not decay over time.
When it is used up, your jobs stay pending.

<!-- TODO: how to check remaining allocation -->

## Accounts

You need to belong to a project to submit jobs. If you belong to several, choose one with `-A`:

```bash
sbatch -A <project> job.sh
```

See [Time and memory defaults](time-memory.md) and [Troubleshooting](troubleshooting.md).
Software and containers: [Software](../software/index.md), [Containers](../containers/index.md).
