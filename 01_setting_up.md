# 1. Setting up Snakemake using Conda

## Conda

Before we start we first have to install Snakemake using [Conda](https://docs.conda.io/projects/conda/en/latest/index.html). Conda is a package and environment management system, which allows you to install different versions  of software packages and dependencies. For our purpose using Conda has a number of advantages:

- It is platform independent, so we can run it under Linux, Mac and Windows (and we can also run it on MetaCentrum)
- Our Conda environment is contained in a local folder, so it does not rely on or interfere with other software you may have installed
- Conda has a wide range of bioinformatics packages available, specifically in the [bioconda channel](https://bioconda.github.io/)
- Conda is integrated into Snakemake, which has internal support for automatically installing and loading Conda packages

## How Conda works



