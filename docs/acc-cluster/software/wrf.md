# Running WRF / WPS on the ACC cluster

This page explains how to launch MPI-based WRF and WPS jobs on the ACC cluster.

## Software

WRF 4.5.1 and WPS 4.5 are pre-built with GCC 13.3.0 and Open MPI 5.0 (UCX, Slurm/PMIx). Load them with:

```bash
module load wrf/4.5.1-gcc-13.3.0
module load wps/4.5-gcc-13.3.0
```

Key directories:

| Variable | Path |
|----------|------|
| `WRF_DIR` | `/shared/software/wrf/4.5.1/WRF-SOURCE` |
| `WPS_DIR` | `/shared/software/wps/4.5/WPS-SOURCE` |
| `WRF_RUN` | `/shared/software/wrf/4.5.1/WRF-SOURCE/run` |

## Storage

- **Home** (`/shared/home/<username>`): scripts and small files.
- **Scratch** (`/scratch/<projectfolder>`, e.g. `/scratch/p26002`): large inputs, high-speed I/O and large outputs. Lustre parallel filesystem.
- Copy your final results to your home directory or your local machine once the run is complete.

## Partitions

| Partition | Use |
|-----------|-----|
| `serial` (default) | Single-node jobs. No `--partition` needed. |
| `n2` | Jobs that need 2 nodes. Add `--partition=n2`. |

Your default Slurm account is applied automatically, so `--account` is not needed.

## Example Slurm script

Place this file in your WRF working directory. Creating the working directory under `/scratch/<projectfolder>` is recommended.

```bash
#!/bin/bash
#SBATCH --job-name=WRF_RUN
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=24:00:00
#SBATCH --output=%j_wrf_log.out

# Load environment
module load wrf/4.5.1-gcc-13.3.0
module load wps/4.5-gcc-13.3.0

WRF_RUN=${WRF_RUN:-/shared/software/wrf/4.5.1/WRF-SOURCE/run}

# Link required tables and data files into the working directory
ln -sf ${WRF_RUN}/*.TBL .
ln -sf ${WRF_RUN}/URBPARM* .
ln -sf ${WRF_RUN}/CAMtr_volume_mixing_ratio* .
ln -sf ${WRF_RUN}/RRTMG_* .
# (use cp instead of ln -sf if you need to edit these files)

# WPS
./geogrid.exe >& log.geogrid
./ungrib.exe  >& log.ungrib
./metgrid.exe >& log.metgrid

# WRF
echo "Launching WRF simulation..."
srun --mpi=pmix ./real.exe
srun --mpi=pmix ./wrf.exe

echo "Workflow completed at $(date)"
```

### Running on 2 nodes

Change the header to:

```bash
#SBATCH --partition=n2
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
```

## Notes

- Each node has 120 cores, so `--ntasks-per-node` can go up to 120. Fewer, fully used nodes usually run faster than many partly used ones, because MPI traffic stays on the node.
- Default memory is about 3.6 GB per core. Add `--mem-per-cpu` or `--mem` if you need more.
- `geogrid.exe`, `ungrib.exe` and `metgrid.exe` run serially. If they are not in your working directory, link them from `${WPS_DIR}`, and make sure `geogrid/GEOGRID.TBL`, `metgrid/METGRID.TBL` and `Vtable` are set up as in a standard WPS run.
- Always launch WRF with `srun --mpi=pmix`, not `mpirun`.

See also [Modules](modules.md) and [MPI](mpi.md).
