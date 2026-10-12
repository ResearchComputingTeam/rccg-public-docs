---
tags: [acc, slurm, allocation]
---

# Project allocation

*Last verified: 2026-10-07*

## What it is

Each project has a **core-hour allocation**, shared by all members of the project.
It does not decay or refill over time. Your project is set when you are onboarded, and your
jobs are charged to it automatically.

## How a job is charged

A job is charged for the cores it was allocated, multiplied by the hours it ran,
whether or not the program uses all of them.

| Job | Charge |
|---|---|
| 1 core for 10 hours | 10 core-hours |
| 16 cores for 2 hours | 32 core-hours |
| 240 cores (`n2`, 2 nodes) for 24 hours | 5,760 core-hours |

Request only the cores you need.

## Check your usage

```bash
acc-usage
```

Example output:

```text
Project:    <project>
Allocation: 280,000.0 core-hours
Used:         1,234.5 core-hours
Remaining:  278,765.5 core-hours
```

## When it runs out

New jobs of your project are still accepted but stay pending, with the reason `QOSGrpCPUMinutesLimit`:

```bash
  squeue --me -o "%i %T %r"
```

```text
  JOBID STATE REASON
  203 PENDING QOSGrpCPUMinutesLimit
```

## Running at once

Besides the allocation, two limits apply at any moment: 360 cores per user and 480 cores per project.
See [Partitions and limits](partitions-limits.md).

## Questions

Contact [support](support.md).
