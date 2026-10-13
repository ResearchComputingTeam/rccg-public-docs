---
tags:
  - containers
  - apptainer
---

# Containers

A container packages an application together with the libraries and tools it needs, so it runs the same way on any system. Our clusters run containers with [Apptainer](https://apptainer.org), which works without administrator rights and can run Docker and OCI images directly.

## What you can do

| I want to... | Go to |
|---|---|
| Add my own packages on top of an existing image | [Building images](building-images.md) |
| Check which images I am allowed to use | [Image policy](image-policy.md) |
| Run or build containers on the ACC cluster | [Containers on the ACC cluster](../acc-cluster/software/containers.md) |

## Images

An Apptainer image is a single file, usually ending in `.sif`. You can get images in three ways:

- **Pull** a Docker/OCI image from a registry, for example `docker://ubuntu:24.04`.
- **Build** your own image from a definition file ([Building images](building-images.md)).
- **Copy** a `.sif` file you already have.

Only use images that meet the [image policy](image-policy.md).

## Basic commands

```bash
apptainer pull ubuntu.sif docker://ubuntu:24.04     # download an image to a .sif file
apptainer exec ubuntu.sif cat /etc/os-release       # run one command inside the image
apptainer run ubuntu.sif                            # run the image's default action
apptainer build my.sif my.def                       # build an image from a definition file
```

Pulling and building use a lot of CPU and disk space, so run them where your cluster allows it. The cluster-specific page tells you how.

## Cluster-specific instructions

- [ACC cluster](../acc-cluster/software/containers.md): job scripts, storage, cache, and troubleshooting.
