---
tags: [acc, slurm]
---

# Time and memory defaults

*Last verified: 2026-10-07*

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

Limits:

- `serial`: the total memory of a job is limited to 59,136 MiB.
- `n1`, `n2`, `n3`: up to the memory of a node, 443,596 MiB per node.

Examples:

| Request | Result |
|---|---|
| `serial`, 1 core, `--mem-per-cpu=50G` | accepted |
| `serial`, 1 core, `--mem=100G` | rejected: `Memory required by task is not available` |
| `serial`, 16 cores, `--mem-per-cpu=3696M` | accepted (59,136 MiB in total) |
| `serial`, 16 cores, `--mem-per-cpu=4G` | rejected: `QOSMaxMemoryPerJob` |
| `n1`, 1 node, `--mem=400G` | accepted |
| `n1`, 1 node, `--mem=500G` | rejected: `Requested node configuration is not available` |

Need more memory than `serial` allows? Use `n1`. See [Troubleshooting](troubleshooting.md).

<!-- TODO: node start-up wait before a job runs -->
<!-- TODO: how start-up time counts against the allocation -->
