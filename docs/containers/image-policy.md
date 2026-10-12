---
tags:
  - containers
  - apptainer
  - policy
---

# Container image policy

This policy applies to every container image you run or build on the ACC cluster.

## Approved sources

Use images from trusted, publicly reputable sources:

- Official vendor registries: Docker Hub Official Images, NVIDIA NGC, GitHub Container Registry (`ghcr.io`) and Quay (`quay.io`)
- Images published by recognised scientific software projects
- Images maintained by the institution
- Images built by RCCG team

Do not use images from unknown, personal or unverified registries without a review. To request one, contact [support](../acc-cluster/support.md).

## Your responsibilities

- **Know your image.** You must be able to identify the source, version or tag, and any modifications of every image you use.
- **Follow the rules.** Images must comply with software licenses and institutional policies.
- **Keep it safe.** Images must not intentionally contain malware, unauthorized services, or mechanisms that bypass security controls.

RCCG may restrict or remove images that present security, legal or operational risks.

## Recommended practice

- **Use local images for production workloads.** Pull the image to a `.sif` file once and run that file, instead of pulling from an external registry every time a job runs. See [Running containers in jobs](running-on-slurm.md).
- **Keep the definition file.** Store the `.def` file next to every important research container, so that the image can be reproduced. See [Building images](building-images.md).
