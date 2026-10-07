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
| `/shared/home/<username>` (`$HOME`) | Shared network storage, visible on all nodes | 1 TB (shared by all users) | 40 GB per user | No backup |
| `/scratch` | Shared parallel filesystem (Lustre), visible on all nodes | 4 TB | 350 GB per group | No backup. No automatic cleanup at the moment; this may change. |
| `/nvme` | Local NVMe disk on each compute node | 2.1 TB | none | Lost when the node is deallocated. Copy what you need out before your job ends. |

## Where to put things

- Keep your programs, input files and job scripts in your home directory or in `/scratch`.
  They are visible from every node.
- `/tmp` is local to each node. A program in `/tmp` cannot be found by the other nodes
  (`execve(): ... No such file or directory`, see [Troubleshooting](troubleshooting.md)).
- `/nvme` is fast but temporary and private to the node. Use it only for data you can recreate.

<!-- TODO: guidance for intermediate files -->
<!-- TODO: how to check quota usage -->
