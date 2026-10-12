---
tags:
  - containers
  - apptainer
---

# Containers on the ACC cluster

The ACC cluster runs containers with [Apptainer](https://apptainer.org) (currently version 1.5.3). Apptainer is installed on the login node and on all compute nodes. You do not need administrator rights, and you do not need Docker: Apptainer runs Docker and OCI images directly.

## What you can do

| I want to... | Go to |
|---|---|
| Run a command or application from an existing image | [Running containers in jobs](running-on-slurm.md) |
| Add my own packages on top of an existing image | [Building images](building-images.md) |
| Check which images I am allowed to use | [Image policy](image-policy.md) |

## Images

An Apptainer image is a single file, usually ending in `.sif`. You can get images in three ways:

- **Pull** a Docker/OCI image from a public registry, for example `docker://ubuntu:24.04`. Docker Hub, GitHub Container Registry (`ghcr.io`), Quay (`quay.io`) and NVIDIA NGC (`nvcr.io`) are reachable from the cluster. Only use images that meet the [image policy](image-policy.md).
- **Build** your own image from a definition file ([Building images](building-images.md)).
- **Copy** a `.sif` file you already have into your storage.

!!! warning "Run pulls and builds in a batch job"
    Do not pull or build images on the login node. Converting an image uses a lot of CPU and temporary disk space, and the login node is shared and has limited local space. Submit a job instead; the compute nodes have a large node-local `/tmp`.

## Where files go

| What | Where | Notes |
|---|---|---|
| Image files (`.sif`) | The directory you pull or build into, normally in your home directory | Counts against your home quota |
| Downloaded layers (cache) | `~/.apptainer` | Counts against your home quota |
| Temporary build files | `/tmp` on the compute node | Node-local, removed when the job ends |

Your home directory has a limited quota (see [Storage](../acc-cluster/storage.md)). Images can get large, so check your usage from time to time. If you need more space or better performance for your images, contact [support](../acc-cluster/support.md) to request a project folder on `/scratch`. `/scratch` has no backup.

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

*Last verified: 2026-10-12*
