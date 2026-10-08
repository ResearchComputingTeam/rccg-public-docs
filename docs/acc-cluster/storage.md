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
| `/nvme` | Local NVMe disk on each compute node | 2.1 TB | none | Lost when the node is deallocated. Copy what you need out before your job ends. |

## Where to put things

- Keep your programs, input files and job scripts in your home directory or in `/scratch`.
  They are visible from every node.
- Use `/scratch` specifically for large temporary input, intermediate files or files that are shared among your project group.
- Use `/nvme` for workloads that require extremely high I/O performance, such as temporary scratch files, checkpoints, or intermediate results. Storage under `/nvme` is local to the compute node running your job and is not shared with other nodes. Data stored there is temporary and WILL BE LOST when the node is deallocated. Create a job-specific directory in `/nvme`, stage input files from `$HOME` or `/scratch` at the start of the job, and copy any results that you want to keep back to `$HOME` or `/scratch` before the job ends.
- `/tmp` is local to each node. A program in `/tmp` cannot be found by the other nodes
  (`execve(): ... No such file or directory`, see [Troubleshooting](troubleshooting.md)).

## Check your quota usage

```bash
du -xhd1 "$HOME" | sort -h
```

If your home directory is full, remove or archive data, or ask your administrator for a
quota review.

## If storage is missing

If `/shared` or `/scratch` is not mounted (`findmnt` shows nothing), stop the job and
contact an administrator. Do not write large data to the node OS disk as a workaround.
