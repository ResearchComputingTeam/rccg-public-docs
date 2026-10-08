---
tags: [software, python, conda]
---

# Python and Conda

## Ready-made environments

Two read-only environments (Python 3.12) are provided. Load one and use it directly;
you do not need to load `conda` first.

| Module | Includes |
|---|---|
| `datascience-conda-env/2026.09` | numpy, pandas, scikit-learn, jupyterlab |
| `ml-cpu-conda-env/2026.09` | scikit-learn, xgboost, lightgbm, catboost, dask, dask-ml, optuna, joblib, statsmodels, pandas, numpy, scipy, matplotlib, seaborn, jupyterlab |

```bash
module load datascience-conda-env/2026.09
python --version
```

The cluster has no GPUs, so `ml-cpu-conda-env` is CPU-only.

## Your own environment

`conda/2026.03` provides Miniforge (conda and mamba, conda-forge channel only).
List the environments, then clone one into your home directory:

```bash
module load conda/2026.03
conda env list
conda create --clone datascience-2026.09 -p ~/envs/my-datascience
conda activate ~/envs/my-datascience
```

Use `-p` to choose where the copy is stored. For the ML environment, clone `ml-cpu-2026.09`.
Conda keeps downloaded packages in `~/.conda/pkgs` (your home directory).

## In a batch script

```bash
#!/bin/bash
#SBATCH --time=01:00:00
module load conda/2026.03
conda activate ~/envs/my-datascience
python my_script.py
```
