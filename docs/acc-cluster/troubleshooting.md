---
tags: [acc, troubleshooting]
---

# Troubleshooting

## Messages when you submit a job

Your job is refused immediately and nothing is queued.

| Message | Cause | Fix |
|---|---|---|
| `Invalid account or account/partition combination specified` | The project does not exist, is misspelled, you are not a member, or it may not use this partition. | Check `-A <project>`. List your projects: `sacctmgr show assoc user=$USER format=Account` |
| `Memory required by task is not available` | You asked for more memory than the partition allows (on `serial`: 59,136 MiB). | Lower `--mem` or `--mem-per-cpu`. |
| `QOSMaxMemoryPerJob` (followed by `Job violates accounting/QOS policy ...`) | Cores × `--mem-per-cpu` is above the `serial` memory limit. | Lower the number of cores or `--mem-per-cpu`. |
| `QOSMaxCpuPerJobLimit` | More than 16 cores on `serial`. | Use `n1`, `n2` or `n3`, or ask for 16 cores or fewer. |
| `Requested time limit is invalid (missing or exceeds some limit)` | `--time` is above the partition maximum. | Lower `--time`. Limits: [Partitions and limits](partitions-limits.md) |
| `Node count specification invalid` | More nodes than the partition allows. | Lower `-N`, or use a partition with more nodes. |

<!-- TODO: pending reason when the allocation is used up -->
