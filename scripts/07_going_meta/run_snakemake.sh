#!/bin/bash
#PBS -N Snakemake
#PBS -l select=1:ncpus=1:mem=400mb:scratch_local=200mb
### Adjust walltime
#PBS -l walltime=48:00:00 
#PBS -m n

### Change this to the path to the conda directory in your home directory
source /storage/brno12-cerit/home/your_username/your_counda_dir/bin/activate snakemake
### Change this to the path of your source_cache directory
XDG_CACHE_HOME="/storage/brno12-cerit/home/your_user_name/source_cache"
### Adjust path to your Snakemake profile (use absolute path) and the desired output file
snakemake -j 10 --profile /storage/brno12-cerit/home/your_username/snakemake_metacentrum your_snakemake_output


