---
tags:
  - containers
  - apptainer
---

# Building images

You can build your own images on the cluster without administrator rights, for example to add packages on top of a published image. Builds use the `--fakeroot` option: inside the build you are "root" and can install packages, while outside you remain a normal user.

!!! warning "Build in a batch job"
    Build on a compute node through a batch job, not on the login node ([Containers overview](overview.md)).

## 1. Write a definition file

`python.def` adds Python and NumPy on top of Ubuntu 24.04:

```text
Bootstrap: docker
From: ubuntu:24.04

%post
    apt-get update
    apt-get install -y --no-install-recommends python3 python3-numpy
    apt-get clean
    rm -rf /var/lib/apt/lists/*

%runscript
    exec python3 "$@"
```

- `Bootstrap` and `From` choose the base image.
- `%post` runs once during the build, as root inside the image.
- `%runscript` runs when you use `apptainer run`.

## 2. Build it in a job

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

## 3. Use the image

```bash
apptainer run python.sif -c "import numpy; print(numpy.__version__)"
apptainer exec python.sif python3 --version
```

To test commands as root inside an image, add `--fakeroot` to `exec`: `apptainer exec --fakeroot python.sif id -u` prints `0`. Files you create in your home directory stay owned by you.

## Keep the definition file

Store the `.def` file next to the `.sif` file. It documents what is in the image and lets you rebuild it. See the [image policy](image-policy.md).

## Build on top of your own image

Use an existing `.sif` file as the base:

```text
Bootstrap: localimage
From: python.sif

%post
    apt-get update
    apt-get install -y --no-install-recommends python3-scipy
```

```bash
apptainer build --fakeroot python-scipy.sif python-scipy.def
```

## Troubleshooting

**`Could not write info to setgroups: Permission denied`**
:   The `--fakeroot` option is not set up for your account. Contact [support](../acc-cluster/support.md).

**The build is killed or runs out of memory**
:   Request more memory with `--mem` and more time with `--time`.

**`No space left on device`**
:   Check your home quota, run `apptainer cache clean` and delete images you no longer need. If you need more space, contact [support](../acc-cluster/support.md) to request a project folder on `/scratch`.

*Last verified: 2026-10-12*
