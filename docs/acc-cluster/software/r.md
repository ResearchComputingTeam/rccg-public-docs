---
tags: [software, r, researcher]
---

# R

*Last verified: 2026-11-05*

The `r` module provides R 4.4.0. Load it with:

```bash
module load r
```

Use an interactive session only for tiny tests. Run analysis and package
installation in batch jobs with `sbatch`; see [Submitting jobs](../submitting-jobs.md).
For partition limits and time and memory defaults, see [Partitions and limits](../partitions-limits.md)
and [Time and memory](../time-memory.md).

## Run R in a batch job

Save this as `r-example.sh` and submit it with `sbatch r-example.sh`:

```bash
#!/bin/bash
#SBATCH --job-name=r-example
#SBATCH --partition=serial
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=00:30:00
#SBATCH --output=%x_%j.out

module purge
module load r
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export R_LIBS_USER=$HOME/R/library
mkdir -p "$R_LIBS_USER"

Rscript my_analysis.R
```

For example, `my_analysis.R` can fit a model and save a plot to a file:

```r
set.seed(1)
x <- rnorm(1e5); y <- 2 * x + rnorm(1e5)
print(summary(lm(y ~ x)))
png("scatter.png", width = 800, height = 600)
plot(x[1:2000], y[1:2000])
dev.off()
```

R supports writing plots to PNG and PDF files. There is no graphical display, so
write plots to files with `png()` or `pdf()`.

## Install your own R packages

The module provides base R. Install additional CRAN, Bioconductor, or GitHub packages
into a personal library. Set `R_LIBS_USER` to that library and run package installs
in a batch job. The job template above creates `$HOME/R/library` for this purpose.

The home quota is limited. For a large package library, you can place it in a project
directory on scratch instead. Scratch is not backed up; see [Storage](../storage.md)
for storage details and warnings.

## Multithreading

R uses OpenBLAS with OpenMP threads. In a job, set `OMP_NUM_THREADS` to the allocated
CPU count, as in the job template above. For parallel R code using forked processes,
you can use:

```r
parallel::mclapply(items, FUN, mc.cores = as.integer(Sys.getenv("SLURM_CPUS_PER_TASK")))
```

## Example: installing ADMIXTOOLS 2

GitHub installs require internet access and can encounter GitHub rate limits. This
recipe installs ADMIXTOOLS 2 from GitHub in a batch job; use the personal library
setup described in [Install your own R packages](#install-your-own-r-packages).

```bash
#!/bin/bash
#SBATCH --job-name=r-install
#SBATCH --partition=serial
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --output=%x_%j.out

module purge
module load r
export R_LIBS_USER=$HOME/R/library
mkdir -p "$R_LIBS_USER"

Rscript -e 'install.packages("remotes", repos = "https://cloud.r-project.org"); remotes::install_github("uqrmaie1/admixtools")'
```

For VCF and genotype data tools used alongside R, see [Genomics and bioinformatics tools](bioinformatics.md).
