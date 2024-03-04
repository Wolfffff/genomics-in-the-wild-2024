# Genomics in the Wild 2024

## Overview

This README document serves as a guide to help you navigate through the setup, execution, and understanding of the workflow utilized in

## Prerequisites
Here, the necessary tools and software for participating in the workshop are listed.

* Conda: A package manager that simplifies the installation and management of software dependencies. It's recommended to use Miniconda or Anaconda, which can be downloaded and installed from the official website.

* Snakemake: A workflow management tool that allows for the creation of reproducible and scalable data analyses. After setting up Conda, Snakemake is installed to manage the pipeline execution.

## Running the Workflow

* Data Preprocessing: Involves cleaning raw sequence data to remove adapters and low-quality bases, preparing it for further analysis.
* Quality Control: Uses tools like FastQC to evaluate the quality of the preprocessed data, ensuring that it meets the standards for accurate analysis.
* Sequence Analysis: Employs QIIME 2 (Quantitative Insights Into Microbial Ecology) for identifying and quantifying the microbial taxa present in the samples.
* Visualization: Generates reports and plots to help interpret the results, including the taxonomic composition and diversity within the sample set.


Run the following:

```bash
snakemake --snakefile workflow/Snakefile -c 64 --use-conda
```

### Distributed Execution via Slurm
For those with access to a Slurm-managed compute cluster, this section explains how to distribute the workflow across multiple nodes to increase processing speed and efficiency.

```bash
snakemake --snakefile workflow/Snakefile --profile profiles/slurm
```