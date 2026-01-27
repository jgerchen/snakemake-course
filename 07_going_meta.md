# 7. Going Meta. Setting up your workflow to run on MetaCentrum.

If you ran the script from the previous exercise you saw that replicate runs of the same rule were run consecutively, which could take some time and it would be much faster if we could run such jobs in parallel. We can do this and much more by running our Snakemake jobs on a cluster like MetaCentrum.

## Cluster support in Snakemake

Snakemake comes with a number of plugins which are supposed to make it easy to run it on various types of cluster and cloud architectures. In my experience this can work fairly well out of the box for example for clusters that use [slurm](https://slurm.schedmd.com/overview.html), but things are a bit more complicated for using MetaCentrum for multiple reasons:

+ **MetaCentrum is large and combines multiple queues and frontends.** When you submit a job it can end up on different queues and it may not always be possible to get the job status with the job ID alone without knowing the correct queue

+ **MetaCentrum can have weird stability issues.** It appears that approximately every ten hours the job scheduler restarts and for about a minute it will not give status updates. This minute is enough to crash default cluster plugins, so that longer running Snakemake workflows may also crash after that time

To get over these issues I developed some scripts that allow Snakemake to run jobs on MetaCentrum despite these issues and in this session we will set them up together.

## Installing conda and snakemake on MetaCentrum

First log into your MetaCentrum account and go to your home directory. Create a new folder in which we will put everything related to this course and enter it. Now first we can download Miniforge again using

```
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" 
```

And start the installer using


```
bash Miniforge3-$(uname)-$(uname -m).sh
```

And follow the installation instructions as you did before. Again, let's create a new conda environment called **snakemake** and install the latest snakemake version using

```
conda create -n snakemake
conda activate snakemake
mamba install -c bioconda snakemake
```

## Setting up the MetaCentrum cluster profile

You can directly clone [the github repository that contains the scripts for running Snakemake jobs on MetaCentrum](https://github.com/jgerchen/snakemake_metacentrum) using


```
git clone https://github.com/jgerchen/snakemake_metacentrum
```

This will create a folder called **snakemake_metacentrum** at your current location. For running the scripts there are a few more steps you need to set up:

+ Install the [generic cluster execution plugin](https://snakemake.github.io/snakemake-plugin-catalog/plugins/executor/cluster-generic.html) into your snakemake conda environment using

```
mamba install -c bioconda snakemake-executor-plugin-cluster-generic
```

+ You have to provide an absolute path to the location of the cluster profile (the folder with the scripts you cloned above) to your Snakemake commands using the **--profile** parameter like below

```
snakemake -j 100 --profile /storage/brno12-cerit/home/your_user_id/snakemake_course/snakemake_metacentrum
```

+ If you want to run more than 1 job in parallel you have to set the -j parameter to the maximum number of jobs that should be run in parallel

+ You have to set the **system variable XGD_CACHE_HOME** to point to a writable folder in your home directory, so for example if you created the folder **source_cache** in your Snakemake folder it could look like this

```
XDG_CACHE_HOME="/storage/brno12-cerit/home/your_user_id/snakemake_course/source_cache" 
```

If you don't set this variable your **Snakemake jobs will crash for obscure reasons**. If you run Snakemake on the shell you only have to set this once as long as you keep the shell open, if you run Snakemake by submitting a job script include it at the top of the script.


## Your turn: run your workflow on MetaCentrum

For now let's just try to run the workflow you previously generated on Metacentrum.

+ Copy your Snakefile and the relevant scripts to MetaCentrum and try to rerun it with the configuration set up as above


