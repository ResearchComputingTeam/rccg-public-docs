---
tags:
  - containers
  - apptainer
  - slurm
---

# Running containers in jobs

Run containers inside a batch job, like any other application. Set `--time`, and request cores and memory as described in [Time and memory](../acc-cluster/time-memory.md).

## Run a command from a Docker image

```bash
#!/bin/bash
#SBATCH --job-name=container-test
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --output=container-test-%j.out

apptainer exec docker://alpine:3.20 cat /etc/os-release
```

Submit it with `sbatch container-test.sh`. The image is downloaded on first use and stored in the cache ([Containers overview](overview.md#managing-the-cache)).

## Download an image once, run it many times

Downloading from a registry in every job is slow and can hit the registry's download limits. Pull the image to a `.sif` file once, in a job:

```bash
apptainer pull alpine.sif docker://alpine:3.20
```

Then use the file in your jobs:

```bash
apptainer exec alpine.sif cat /etc/os-release     # run one command
apptainer run alpine.sif                          # run the image's default action
```

## Files and directories inside the container

These are available inside the container with the same path as outside, with no extra options:

- your home directory
- `/scratch`
- `/tmp` (the node-local `/tmp` of the compute node)

To make a directory available at a different path inside the container, use `--bind source:destination`:

```bash
apptainer exec --bind $HOME/input:/data alpine.sif ls /data
```

Your environment variables are passed into the container. Add `--cleanenv` to start the container with a clean environment.

## Several tasks

`srun` starts the container command once per task:

```bash
#!/bin/bash
#SBATCH --ntasks=4
#SBATCH --time=00:10:00

srun apptainer exec alpine.sif hostname
```

## Troubleshooting

**`toomanyrequests` when pulling from Docker Hub**
:   Docker Hub limits anonymous downloads. Pull once to a `.sif` file as shown above and reuse it. If the error persists, retry later or contact [support](../acc-cluster/support.md).

**`No space left on device` or disk quota errors**
:   Images and the cache count against your home quota. Run `apptainer cache clean` and delete `.sif` files you no longer need. If you need more space, contact [support](../acc-cluster/support.md) to request a project folder on `/scratch`.

**A path is not found inside the container**
:   Only your home directory, `/scratch` and `/tmp` are available by default. Add other directories with `--bind`.

*Last verified: 2026-10-12*
