---
tags: [acc, slurm]
---

# Time and memory defaults

*Last verified: 2026-10-05*

## Time

If you omit `--time`, your job gets a limit of **1 hour** on every partition. Always set it:

```bash
sbatch --time=12:00:00 job.sh
```

The maximum per partition is in [Partitions and limits](partitions-limits.md).

## Memory

If you do not request memory, each allocated core gets **3,696 MiB**.

| Cores | Default memory |
|---|---|
| 1 | 3,696 MiB |
| 16 | 59,136 MiB |
| 120 (full node) | 443,520 MiB |

Request memory explicitly with one of:

```bash
sbatch --mem=32G job.sh              # per node
sbatch --mem-per-cpu=4G job.sh       # per core
```

On `serial`, the total memory of a job is limited to 59,136 MiB. Examples on `serial`:

| Request | Result |
|---|---|
| 1 core, `--mem-per-cpu=50G` | accepted |
| 1 core, `--mem=100G` | rejected: `Memory required by task is not available` |
| 16 cores, `--mem-per-cpu=27G` | rejected: `QOSMaxMemoryPerJob` |

Need more memory? See [Troubleshooting](troubleshooting.md).

<!-- TODO: memory limit on n1, n2, n3 -->
<!-- TODO: node start-up wait before a job runs -->
<!-- TODO: how start-up time counts against the allocation -->
