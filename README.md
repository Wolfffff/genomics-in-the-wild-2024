# Genomics in the Wild 2024

## Introduction

Add to .bashrc

```bash
export PATH=$PATH:/Genomics/argo/users/swwolf/miniforge3/bin
```

Run the following:

```bash
snakemake --snakefile workflow/Snakefile -c 64 --use-conda
```


To distribute this workflow, run

```bash
snakemake --snakefile workflow/Snakefile --profile profiles/slurm
```
