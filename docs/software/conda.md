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
You can clone a provided environment, then activate your copy:

```bash
module load conda/2026.03
conda create --clone datascience-conda-env -n my-datascience
conda activate my-datascience
```

<!-- TODO: where new environments are stored and quota -->
<!-- TODO: using conda inside batch scripts -->
