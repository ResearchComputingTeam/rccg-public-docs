---
tags: [acc, storage]
---

# Storage

!!! warning "This is a computing system, not a storage platform"
    Upload the input data you need, and only data that has been approved through the data
    classification process. Run your jobs, then download your results and keep them on your own
    storage. There is **no backup and no restore**: keeping your data safe is your responsibility.

## Summary

The table below lists shared storage available from the login node and compute nodes. Compute-job local scratch is described separately below; it is not a shared filesystem.

| Shared path | What it is | Size | Quota | Notes |
|---|---|---|---|---|
| `/shared/home/<username>` (`$HOME`) | Persistent shared network storage, visible on all nodes | 1 TB | 40 GB per user | No backup. Survives jobs and node deallocation. |
| `/scratch` | Persistent shared Lustre filesystem for high-throughput, low-latency job data, visible on all nodes | 4 TB | 350 GB per group | No backup. Not a substitute for `$HOME`. No automatic cleanup at the moment. |

## Where to put things

- Keep your programs, input files and job scripts in your home directory or in `/scratch`.
  They are visible from every node.
- Use `/scratch` specifically for large temporary input, intermediate files or files that are shared among your project group.

## Compute-job local scratch

!!! warning "`/tmp` in a compute job is not the login node's `/tmp`"
    Use this scratch only from a job running on a compute node. On compute nodes, `/tmp` is a bind mount of that node's local NVMe directory, `/nvme/tmp`. The `/tmp` you see in a shell on the login/scheduler node belongs to the login node's own local storage. It is separate: it is not the compute-node NVMe, and files there are not the files your compute job sees.

Use `/tmp` inside the allocated compute node for high-I/O temporary work, checkpoints, and intermediate results. Create a private working directory, stage inputs from `$HOME` or `/scratch`, run the application there, and copy results you want to keep back to shared storage before the job ends:

```bash
work=$(mktemp -d "/tmp/${USER}.${SLURM_JOB_ID}.XXXXXX")
trap 'rm -rf -- "$work"' EXIT

cp "$SLURM_SUBMIT_DIR/input.dat" "$work/"
cd "$work"
# Run the application here, then copy needed results to /scratch or $HOME.
```

This is node-local scratch, not a private Slurm filesystem: jobs and users on the same compute node share the top-level directory. Its `1777` sticky-bit permissions protect entries from deletion or renaming by other users, but use a private subdirectory and restrictive permissions for your files. There is no quota or automatic cleanup at job end. Each compute node has its own `/tmp`, so files are not shared between nodes. Copy results to `/shared` or `/scratch` before the job ends or the node is deallocated; data on NVMe is ephemeral.

## Check your quota usage

```bash
du -xhd1 "$HOME" | sort -h
```

If your home directory is full, remove or archive data, or ask your administrator for a
quota review.

## If storage is missing

If `/shared` or `/scratch` is not mounted (`findmnt` shows nothing), stop the job and
contact an administrator. Do not write large data to the node OS disk as a workaround.
