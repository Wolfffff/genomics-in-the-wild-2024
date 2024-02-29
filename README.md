# Genomics in the Wild 2024

## Introduction

Make sure to install Snakemake first!


Run the following:

```bash
snakemake --snakefile workflow/Snakefile -c 64 --use-conda
```

To distribute this workflow, run

```bash
snakemake --snakefile workflow/Snakefile --profile profiles/slurm
```
