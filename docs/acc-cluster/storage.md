---
tags: [acc, storage]
---

# Storage

!!! warning "This is a computing system, not a storage platform"
    Upload the input data you need, and only data that has been approved through the data
    classification process. Run your jobs, then download your results and keep them on your own
    storage. There is **no backup and no restore**: keeping your data safe is your responsibility.

## Summary

| Path | What it is | Size | Quota | Notes |
|---|---|---|---|---|
| `/shared/home/<username>` (`$HOME`) | Persistent shared network storage, visible on all nodes | 1 TB | 40 GB per user | No backup. Survives jobs and node deallocation. |
| `/scratch` | Persistent shared Lustre filesystem for high-throughput, low-latency job data, visible on all nodes | 4 TB | 350 GB per group | No backup. Not a substitute for `$HOME`. No automatic cleanup at the moment. |
| `/tmp` (backed by `/nvme/tmp`) | Fast local NVMe scratch on each compute node | about 1.8 TiB available on the node checked | none | Shared with jobs on the same node; local to one node and ephemeral. Copy results out before the job ends or node deallocation. |

## Where to put things

- Keep your programs, input files and job scripts in your home directory or in `/scratch`.
  They are visible from every node.
- Use `/scratch` specifically for large temporary input, intermediate files or files that are shared among your project group.
- Use `/tmp` for temporary high-I/O work, checkpoints, and intermediate results. On the compute nodes, `/tmp` is a bind mount of `/nvme/tmp` on local NVMe. Both paths are accessible to regular users; `/tmp` is the recommended path. Create a unique job directory with `mktemp -d`, stage inputs from `$HOME` or `/scratch`, run the application there, then copy results you want to keep back to `$HOME` or `/scratch` before the job ends.
- `/tmp` is shared with other users and jobs on the same node; Slurm does not make it private to a job or automatically clean up its files. Its `1777` sticky-bit permissions prevent other users from deleting or renaming your directory entry, but use restrictive permissions for files and directories. It has no quota, so large writes can consume space needed by other jobs.
- Each node has its own `/tmp`; files are not shared between nodes. Data is ephemeral and will be lost when the node is deallocated or rebuilt. For multi-node jobs, stage files separately on each node. Keep the program's `/tmp` path local to the node; another node cannot see it (see [Troubleshooting](troubleshooting.md)).

## Check your quota usage

```bash
du -xhd1 "$HOME" | sort -h
```

If your home directory is full, remove or archive data, or ask your administrator for a
quota review.

## If storage is missing

If `/shared` or `/scratch` is not mounted (`findmnt` shows nothing), stop the job and
contact an administrator. Do not write large data to the node OS disk as a workaround.
