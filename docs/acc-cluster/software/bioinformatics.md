---
tags: [software, genomics, researcher]
---

# Genomics and bioinformatics tools

*Last verified: 2026-11-05*

These single-node tools can be combined in workflows that read, filter, convert,
and summarize variant data. Their modules are built for the cluster CPUs with GCC
13.3.0; they are not MPI programs.

| Tool | Version | Module | Use |
|---|---:|---|---|
| PLINK | 1.9 (`PLINK v1.90b6.27`) | `plink` | Population-genetics analysis and genotype conversion |
| SAMtools | 1.19.2 | `samtools` | Read, sort, and index sequence alignment files |
| BCFtools | 1.19 | `bcftools` | Inspect, filter, and query variant call files |
| HTSlib | 1.19.1 | `htslib` | C library and the `bgzip` and `tabix` tools |
| VCFtools | 0.1.16 | `vcftools` | Filter and summarize VCF files |

## PLINK

Load the module with `module load plink`. For a VCF whose sample IDs do not contain
underscores, use `--double-id` when importing it:

```bash
plink --vcf input.vcf.gz --double-id --make-bed --out data
```

!!! warning "Set PLINK memory and threads"
    PLINK detects the node's total RAM and by default reserves half of it. Always
    pass `--memory` in MB, using about 75% of the job's `--mem` request, and set
    `--threads "$SLURM_CPUS_PER_TASK"`.

## SAMtools

Load the module with `module load samtools`. Common operations include viewing,
sorting, and indexing alignment files:

```bash
samtools view -b input.sam -o input.bam
samtools sort input.bam -o sorted.bam
samtools index sorted.bam
```

## BCFtools

Load the module with `module load bcftools`; its HTSlib dependency loads automatically.
For example, inspect a VCF, calculate summary statistics, or query selected fields:

```bash
bcftools view input.vcf.gz
bcftools stats input.vcf.gz > stats.txt
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' input.vcf.gz
```

Use `--threads` where supported, such as `bcftools view --threads "$SLURM_CPUS_PER_TASK"`.

## HTSlib

Load the module with `module load htslib`. It provides the HTSlib C library and the
`bgzip` and `tabix` tools. Compress a VCF and build its index with:

```bash
bgzip input.vcf
tabix -p vcf input.vcf.gz
```

## VCFtools

Load the module with `module load vcftools`. Calculate allele frequencies from a
compressed VCF with:

```bash
vcftools --gzvcf input.vcf.gz --freq --out frequencies
```

## Tools not provided centrally: install them yourself

ADMIXTURE, EIGENSOFT, KING, and PLINK 2 are group-specific tools and are not installed
centrally. If several groups need a tool, it can be considered for a central module;
contact RCCG. ADMIXTURE and KING are free for academic use only. You are responsible
for following their licence terms.

The following installation pointers are **UNTESTED** and are general guidance only:

- For a single precompiled binary such as ADMIXTURE, KING, or PLINK 2, download the
  official Linux binary into `~/bin` and add `~/bin` to your `PATH`.
- For EIGENSOFT, install it into a personal Conda environment as described on the
  [Python and Conda](conda.md) page. EIGENSOFT requires the Bioconda channel; the
  provided Conda setup is conda-forge only, so this channel requirement must be
  addressed when preparing the personal environment.

## Example job script (template)

This self-contained example creates a toy VCF and runs all five tools. Replace the
“Make toy data” block with your own VCF and adjust the commands and resource requests
to your workload. See [Submitting jobs](../submitting-jobs.md) for job submission,
[Partitions and limits](../partitions-limits.md) for available resources, and
[Getting started](../getting-started.md#4-watch-it) for the node startup delay some
jobs may encounter.

Save as `bio-example.sh` and submit with `sbatch bio-example.sh`. Check the job with
`squeue` and read `bio-example_<jobid>.out`. Set `--time` realistically for the work.
The results are written to scratch, which is not backed up; see [Storage](../storage.md).

```bash
#!/bin/bash
#SBATCH --job-name=bio-example
#SBATCH --partition=serial
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=00:30:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

set -euo pipefail

module purge
module load htslib samtools bcftools vcftools plink

# Work on project scratch (replace <project_code> with your project folder)
WORKDIR=/scratch/<project_code>/bio_example_${SLURM_JOB_ID}
mkdir -p "$WORKDIR" && cd "$WORKDIR"

# ---- 1. Make toy data (replace with your own VCF) ----------------------
awk -v nvar=2000 -v nsamp=20 'BEGIN{
  srand(42)
  print "##fileformat=VCFv4.2"
  print "##contig=<ID=1,length=1000000>"
  print "##FORMAT=<ID=GT,Number=1,Type=String,Description=\"Genotype\">"
  printf "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT"
  for (s = 1; s <= nsamp; s++) printf "\tS%d", s
  printf "\n"
  for (v = 1; v <= nvar; v++) {
    printf "1\t%d\tsnp%d\tA\tG\t.\t.\t.\tGT", v * 400, v
    for (s = 1; s <= nsamp; s++) {
      r = rand(); g = (r < 0.5) ? "0/0" : ((r < 0.85) ? "0/1" : "1/1")
      printf "\t%s", g
    }
    printf "\n"
  }
}' > toy.vcf
bgzip toy.vcf
tabix -p vcf toy.vcf.gz

# ---- 2. BCFtools: summary and filtering -------------------------------
bcftools stats toy.vcf.gz > bcftools_stats.txt
bcftools view --threads "$SLURM_CPUS_PER_TASK" -v snps -m2 -M2 toy.vcf.gz -Oz -o toy_snps.vcf.gz
tabix -p vcf toy_snps.vcf.gz

# ---- 3. VCFtools: allele frequencies ----------------------------------
vcftools --gzvcf toy_snps.vcf.gz --freq --out vcftools_freq

# ---- 4. PLINK: convert and QC (always set --memory and --threads) ------
plink --vcf toy_snps.vcf.gz --double-id --make-bed --out toy_plink \
      --memory 6000 --threads "$SLURM_CPUS_PER_TASK"
plink --bfile toy_plink --freq --missing --out toy_qc \
      --memory 6000 --threads "$SLURM_CPUS_PER_TASK"

echo "Done. Results in $WORKDIR"
ls -lh
```

For R workflows that use these tools, see the [R guide](r.md).
