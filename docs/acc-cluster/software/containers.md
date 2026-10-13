---
tags:
  - containers
  - apptainer
  - slurm
---

# Containers on the ACC cluster

The ACC cluster runs containers with [Apptainer](https://apptainer.org) (currently version 1.5.3). Apptainer is installed on the login node and on all compute nodes. You do not need administrator rights, and you do not need Docker: Apptainer runs Docker and OCI images directly.

For the general concepts, see [Containers](../../containers/overview.md). Only use images that meet the [image policy](../../containers/image-policy.md).

!!! warning "Run pulls, builds and containers in a batch job"
    Do not pull or build images on the login node. Converting an image uses a lot of CPU and temporary disk space, and the login node is shared and has limited local space. Submit a job instead; the compute nodes have a large node-local `/tmp`.

## Files and storage

| What | Where | Notes |
|---|---|---|
| Image files (`.sif`) | The directory you pull or build into, normally in your home directory | Counts against your home quota |
| Downloaded layers (cache) | `~/.apptainer` | Counts against your home quota |
| Temporary build files | `/tmp` on the compute node | Node-local, removed when the job ends |

Your home directory has a limited quota (see [Storage](../storage.md)). Images can get large, so check your usage from time to time. If you need more space or better performance for your images, contact [support](../support.md) to request a project folder on `/scratch`. `/scratch` has no backup.

Images downloaded from a registry can be fetched again, but images you build yourself should be kept elsewhere as well, together with their definition file.

### Managing the cache

```bash
apptainer cache list          # show what is cached and how much space it uses
apptainer cache clean         # remove cached layers
```

Once you have a project folder on `/scratch`, you can move the cache there by setting this before you pull or build:

```bash
export APPTAINER_CACHEDIR=<your-project-folder>/apptainer-cache
```

## Run a container in a job

Set `--time`, and request cores and memory as described in [Time and memory](../time-memory.md).

```bash
#!/bin/bash
#SBATCH --job-name=container-test
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --output=container-test-%j.out

apptainer exec docker://alpine:3.20 cat /etc/os-release
```

Submit it with `sbatch container-test.sh`. The image is downloaded on first use and stored in the cache.

### Download an image once, run it many times

Downloading from a registry in every job is slow and can hit the registry's download limits. Pull the image to a `.sif` file once, in a job:

```bash
apptainer pull alpine.sif docker://alpine:3.20
```

Then use the file in your jobs:

```bash
apptainer exec alpine.sif cat /etc/os-release     # run one command
apptainer run alpine.sif                          # run the image's default action
```

### Files and directories inside the container

These are available inside the container with the same path as outside, with no extra options:

- your home directory
- `/scratch`
- `/tmp` (the node-local `/tmp` of the compute node)

To make a directory available at a different path inside the container, use `--bind source:destination`:

```bash
apptainer exec --bind $HOME/input:/data alpine.sif ls /data
```

Your environment variables are passed into the container. Add `--cleanenv` to start the container with a clean environment.

### Several tasks

`srun` starts the container command once per task:

```bash
#!/bin/bash
#SBATCH --ntasks=4
#SBATCH --time=00:10:00

srun apptainer exec alpine.sif hostname
```

## Build an image in a job

Write a definition file as described in [Building images](../../containers/building-images.md), then build it in a job. The `--fakeroot` option is enabled for all accounts.

```bash
#!/bin/bash
#SBATCH --job-name=build-image
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=build-image-%j.out

apptainer build --fakeroot python.sif python.def
```

Large base images or many packages need more time and memory.

## Registries

Docker Hub, GitHub Container Registry (`ghcr.io`), Quay (`quay.io`) and NVIDIA NGC (`nvcr.io`) are reachable from the cluster.

## Troubleshooting

**`Could not write info to setgroups: Permission denied` during a build**
:   The `--fakeroot` option is not set up for your account. Contact [support](../support.md).

**`toomanyrequests` when pulling from Docker Hub**
:   Docker Hub limits anonymous downloads. Pull once to a `.sif` file as shown above and reuse it. If the error persists, retry later or contact [support](../support.md).

**`No space left on device` or disk quota errors**
:   Images and the cache count against your home quota. Run `apptainer cache clean` and delete `.sif` files you no longer need. If you need more space, contact [support](../support.md) to request a project folder on `/scratch`.

**A path is not found inside the container**
:   Only your home directory, `/scratch` and `/tmp` are available by default. Add other directories with `--bind`.

**The build is killed or runs out of memory**
:   Request more memory with `--mem` and more time with `--time`.

*Last verified: 2026-10-12*
