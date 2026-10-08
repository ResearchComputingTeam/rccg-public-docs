---
tags: [acc, troubleshooting]
---

# Troubleshooting

## Connection

| Symptom | What to check |
|---|---|
| SSH times out | Confirm network access and the current login endpoint. |
| SSH says Permission denied | Confirm your Slurm account, user name, key permissions (`chmod 600 <key>`), and that your SSH key is registered. |

## Messages when you submit a job

Your job is refused immediately and nothing is queued.

| Message | Cause | Fix |
|---|---|---|
| `Invalid account or account/partition combination specified` | Your default account does not exist, is misspelled, you are not a member, or it may not use this partition. | List your projects: `sacctmgr show assoc user=$USER format=Account`. If it persists, contact your administrator. |
| `Memory required by task is not available` | `--mem` is above the `serial` limit of 59,136 MiB. | Lower `--mem`, or use `n1`. |
| `QOSMaxMemoryPerJob` | Cores × `--mem-per-cpu` is above the `serial` limit of 59,136 MiB. | Lower the number of cores or `--mem-per-cpu`, or use `n1`. |
| `QOSMaxCpuPerJobLimit` | More than 16 cores on `serial`. | Use `n1`, `n2` or `n3`, or ask for 16 cores or fewer. |
| `Requested node configuration is not available` | More cores (120) or memory (443,596 MiB) per node than a node has. | Lower `--ntasks-per-node` or `--mem`, or spread the job over more nodes (`n2`, `n3`). |
| `Requested time limit is invalid (missing or exceeds some limit)` | `--time` is above the partition maximum. | Lower `--time`. Limits: [Partitions and limits](partitions-limits.md) |
| `Node count specification invalid` | More nodes than the partition allows. | Lower `-N`, or use a partition with more nodes. |

The two `QOS...` errors are followed by `allocation failure: Job violates accounting/QOS policy (job submit limit, user's size and/or time limits)`.

## Job stays pending

A new job can stay pending (`PD`) while the cluster creates compute nodes.
To see the reason:

```bash
squeue -j <job-id> -o "%.18i %.2t %.30R"
```

`Resources` means nodes are scaling up. Quota, capacity or configuration
messages require an administrator. See [Monitoring](monitoring.md#why-is-my-job-pending).

## Errors when the job runs

| Message | Cause | Fix |
|---|---|---|
| `error: execve(): <path>: No such file or directory` | The program is not visible on the compute node. `/tmp` is local to each node. | Keep programs and input files in your home directory or `/scratch`. |
| `module: command not found`, or a module or MPI version is missing | The module is not installed, or its name differs from what you loaded. | Run `module avail`; load the exact installed name, or report the missing module to an administrator. |
| MPI uses TCP or performs poorly | The job lacks RDMA-capable nodes, or the fabric variables are not set. | Confirm the job has at least two RDMA-capable nodes and prints `FI_PROVIDER=mlx`, `I_MPI_OFI_PROVIDER=mlx` and `I_MPI_FABRICS=shm:ofi`. See [MPI](software/mpi.md). |
| `/shared` or `/scratch` is absent | The storage is not mounted. | Stop the job and contact an administrator; do not write large data to the node OS disk as a workaround. See [Storage](storage.md#if-storage-is-missing). |
| Home directory is full | The 40 GB per-user quota is reached. | Run `du -xhd1 "$HOME" \| sort -h`; remove or archive data, or request a quota review. See [Storage](storage.md#check-your-quota-usage). |
