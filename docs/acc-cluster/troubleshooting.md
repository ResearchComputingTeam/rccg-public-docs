---
tags: [acc, troubleshooting]
---

# Troubleshooting

## Messages when you submit a job

Your job is refused immediately and nothing is queued.

| Message | Cause | Fix |
|---|---|---|
| `Invalid account or account/partition combination specified` | The project does not exist, is misspelled, you are not a member, or it may not use this partition. | Check `-A <project>`. List your projects: `sacctmgr show assoc user=$USER format=Account` |
| `Memory required by task is not available` | `--mem` is above the `serial` limit of 59,136 MiB. | Lower `--mem`, or use `n1`. |
| `QOSMaxMemoryPerJob` | Cores × `--mem-per-cpu` is above the `serial` limit of 59,136 MiB. | Lower the number of cores or `--mem-per-cpu`, or use `n1`. |
| `QOSMaxCpuPerJobLimit` | More than 16 cores on `serial`. | Use `n1`, `n2` or `n3`, or ask for 16 cores or fewer. |
| `Requested node configuration is not available` | More cores (120) or memory (443,596 MiB) per node than a node has. | Lower `--ntasks-per-node` or `--mem`, or spread the job over more nodes (`n2`, `n3`). |
| `Requested time limit is invalid (missing or exceeds some limit)` | `--time` is above the partition maximum. | Lower `--time`. Limits: [Partitions and limits](partitions-limits.md) |
| `Node count specification invalid` | More nodes than the partition allows. | Lower `-N`, or use a partition with more nodes. |

The two `QOS...` errors are followed by `allocation failure: Job violates accounting/QOS policy (job submit limit, user's size and/or time limits)`.

<!-- TODO: pending reason when the allocation is used up -->

## Errors when the job runs

| Message | Cause | Fix |
|---|---|---|
| `error: execve(): <path>: No such file or directory` | The program is not visible on the compute node. `/tmp` is local to each node. | Keep programs and input files in your home directory or `/scratch`. |
