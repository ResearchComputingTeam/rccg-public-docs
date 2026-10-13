---
tags: [acc, login-node, slurm]
---

# Using the login node

The login node is a shared entry point for all cluster users. Use it to edit
files, manage small amounts of data, check job status, and submit jobs. Do not
use it for long-running or resource-intensive work.

Examples of work to run on a compute node instead:

- Compiling a large or complex application, or building software with many
  dependencies.
- Downloading large datasets or container images, or building container images.
- Preprocessing or analyzing large datasets, or running CPU- or memory-intensive
  calculations.
- Running parallel or multithreaded applications outside a Slurm allocation.

These tasks can use enough CPU, memory, disk, network, or shared filesystem
resources to make the login node slow or unresponsive. That affects your work and
the other users who share the node.

Run this work on a compute node through an [interactive session](submitting-jobs.md#interactive-session)
for short tests, or submit a [batch job](submitting-jobs.md#batch-job) for longer
work. The [Submitting jobs](submitting-jobs.md) page shows how to request both.
