---
tags: [acc, storage, scp, rsync]
---

# Transferring files

How to move data between your local machine and the ACC cluster.

The cluster has no backup and no restore, so keep your data safe. See
[Storage](storage.md) for where to put your files on the cluster.

## Upload to the cluster

Copy a file or directory from your local machine to the cluster.

### rsync

`rsync` is recommended: it is fast, resumes interrupted transfers, and skips files
that are already up to date.

```bash
rsync -avz -e ssh /path/to/local/file_or_dir username@acc-cluster:/path/to/destination/
```

Replace `/path/to/local/file_or_dir` with the local path and
`username@acc-cluster` with your cluster username and hostname. Adjust the
destination path on the cluster as needed.

To sync a directory recursively, use `-r` (already included in `-a`).

To show progress, add `--info=progress2`.

### scp

`scp` is simpler but slower for large datasets and does not resume interrupted
transfers.

```bash
scp -r /path/to/local/file_or_dir username@acc-cluster:/path/to/destination/
```

The `-r` flag copies directories recursively. For large files, add `-C` to
enable compression.

## Download from the cluster

Copy a file or directory from the cluster to your local machine.

### rsync

```bash
rsync -avz -e ssh username@acc-cluster:/path/to/remote/file_or_dir /path/to/local/destination/
```

### scp

```bash
scp -r username@acc-cluster:/path/to/remote/file_or_dir /path/to/local/destination/
```

## Operating system differences

The commands above are the same on all platforms, but the syntax for paths and
the availability of `rsync` differ slightly.

=== "Mac/Linux"

    On macOS and Linux, `rsync` and `scp` are built in. Use forward slashes for
    paths, and use absolute paths to avoid ambiguity.

    ```bash
    # Upload
    rsync -avz -e ssh ~/data/dataset.bam username@acc-cluster:/shared/home/username/

    # Download
    rsync -avz -e ssh username@acc-cluster:/scratch/username/results/ ~/results/
    ```

=== "Windows"

    On Windows, `rsync` and `scp` are not built in. Install [Git for
    Windows](https://git-scm.com/download/win), which provides them in Git Bash, or
    use [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/)
    (WSL). With WSL you get native `rsync` and `scp`.

    In PowerShell or Command Prompt, forward slashes work, but in Git Bash use
    forward slashes as well.

    ```bash
    # Git Bash or WSL
    rsync -avz -e ssh C:/Users/me/data/dataset.bam username@acc-cluster:/shared/home/username/
    ```

    For `scp` in PowerShell (OpenSSH client built into Windows 10/11):

    ```powershell
    scp -r C:\Users\me\data\dataset.bam username@acc-cluster:/shared/home/username/
    ```

## Tips

- Use your home directory (`/shared/home/<username>`) or `/scratch` for cluster
  storage. See [Storage](storage.md).
- For very large files, `rsync` with `--partial` keeps partially transferred
  files so you can resume with the same command.
- Avoid transferring to `/tmp`: it is local to each node and not visible
  elsewhere.