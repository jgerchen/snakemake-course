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

>[!IMPORTANT]
> Note that installing conda packages and activating conda environments can be much slower on MetaCentrum than on your own laptop.


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
snakemake -j 100 --profile /storage/brno12-cerit/home/your_user_id/snakemake_course/snakemake_metacentrum output_file
```

+ If you want to run more than 1 job in parallel you have to set the -j parameter to the maximum number of jobs that should be run in parallel

+ You have to set the **system variable XGD_CACHE_HOME** to point to a writable folder in your home directory, so for example if you created the folder **source_cache** in your Snakemake folder it could look like this

```
XDG_CACHE_HOME="/storage/brno12-cerit/home/your_user_id/snakemake_course/source_cache" 
```

If you don't set this variable your **Snakemake jobs will crash for obscure reasons**. If you run Snakemake on the shell you only have to set this once as long as you keep the shell open, if you run Snakemake by submitting a job script include it at the top of the script.

## Adjusting your workflow to run on the cluster

### Log files

When we ran our Snakemake workflows locally all the output of jobs and the Snakemake command was printed directly to the command line. When jobs are run remotely on the cluster this does not happen anymore, but we still want to have the output of jobs. For this Snakemake needs the **log** part in your rules. Consider which we could have used in the previous part for running one replicate structure run, but now with log file:

```
rule structure:
	input:
		mainparams="out_{P23}_{P32}/mainparams",
		extraparams="out_{P23}_{P32}/extraparams",
		struct_inp="out_{P23}_{P32}/04_slim_{P23}_{P32}.struct"
	output: struct_out="out_{P23}_{P32}/04_slim_{P23}_{P32}_{rep}.out_f"
	conda:	"envs/structure.yaml"
    log: "log/structure_{P23}_{P32}_{rep}"
```

Here it's also a good idea to put all the log files into a new folder, which Snakemake will create for us if it doesn't exist. In general, Snakemake will now create the log file for us and we could redirect text output from our job into it by pointing **>** (stdout), **2>** (stderr) or **&>** (both stdout and stderr) to the log variable, for example like this:

```
shell:  "structure -o out_{wildcards.P23}_{wildcards.P32}/04_slim_{wildcards.P23}_{wildcards.P32}.out -K 3 &> {log}"
```

However, MetaCentrum already automatically creates separate log files for stdout and stderr by itself. In the end I implemented the log part in the scripts for running Snakemake on MetaCentrum so that these two scripts will be the name of the logfile defined in the rule definition with **.o1234567** (for stdout) and **.e1234567** (for stderr) where **1234567** is your job id.So in the end you will end up with three files in your log folder, for the example above they could be

```
log/structure_0.002_0.002_1.log
log/structure_0.002_0.002_1.log.o1234567
log/structure_0.002_0.002_1.log.e1234567
```

And if we don't do any redirection, the first file would be empty and the other too contain **stdout** and **stderr**, respectively. I think this makes sense because this way you don't have to bother with redirection and you automatically keep log files for both stderr and stdout even if you rerun jobs, while with redirection your logfile would always be overwritten.

Also note that the name of the log file includes all three wildcards from the output file, **{P23}**, **{P32}** and **{rep}**.

> [!IMPORTANT]
> **If the output files of your rule include wildcards they must also be included in the name of your log files!** Snakemake enforces this to prevent jobs from writing to the same log files, since the combination of wildcards should always be unique within a Snakemake run.

### Setting resources

Our computing jobs on MetaCentrum have resource requirements, which have to be defined beforehand for each job, specifically **memory**, **scratch space** and **runtime** and our jobs will get killed if they end up using more than they were assigned. Since different parts of our workflow will have different resource requirements we can set them for each rule as follows:

```
rule structure:
	input:
		mainparams="out_{P23}_{P32}/mainparams",
		extraparams="out_{P23}_{P32}/extraparams",
		struct_inp="out_{P23}_{P32}/04_slim_{P23}_{P32}.struct"
	output: struct_out="out_{P23}_{P32}/04_slim_{P23}_{P32}_{rep}.out_f"
	conda:	"envs/structure.yaml"
    log: "log/structure_{P23}_{P32}_{rep}"
    resources:
        mem_mb=2000,
        disk_mb=1000,
        runtime="1h"
```

Again, note the indentation after the resources part. Memory (**mem_mb**) and scratch space (**disk_mb**) have to be given in megabytes, and **runtime** in human readable format, so "1h" would be one our, "30m" 20 minutes and "1d" one day.

>[!CAUTION]
> Note that **mem_mb** and **disk_mb** are given as numbers, while **runtime** is given as **text string**, with quotes around it.

There is another separate resource-like part of your rule that you'll have to partially set yourself, which is **threads**, which is added as follows
```
rule structure:
	input:
		mainparams="out_{P23}_{P32}/mainparams",
		extraparams="out_{P23}_{P32}/extraparams",
		struct_inp="out_{P23}_{P32}/04_slim_{P23}_{P32}.struct"
	output: struct_out="out_{P23}_{P32}/04_slim_{P23}_{P32}_{rep}.out_f"
	conda:	"envs/structure.yaml"
    log: "log/structure_{P23}_{P32}_{rep}"
    resources:
        mem_mb=2000,
        disk_mb=1000,
        runtime="1h"
    threads: 4
```

This would cause your structure run to run on a node with four cores, however structure does not have multi threading support and neither do any of the other scripts and programs we used in the examples. For programs that do you typically have to provide the number of threads in the shell command, which you can do by accessing the **{threads}** variable using curly brackets. So for example for a multi-threaded program like [bwa mem](https://github.com/lh3/bwa?tab=readme-ov-file) the shell command could then look like this:

```
shell: "bwa mem -t {threads} ref.fa read1.fq read2.fq "
```

### Working on Scratch

When working with jobs on Metacentrum you are supposed to copy all relevant files to a local scratch directory, while the computation is happening and then copy it to your output folder when the job is finished. We can do this in the same way in our Snakemake jobs as we would when we write a regular job script, by accessing the $SCRATCH variable.

In our previous workflows all our shell commands were simple, single line commands. However, we can also write multi line shell commands for our rules. One way to do this would be to separate commands in the shell part of our rules with semicolons, however this would quickly become unreadable as multiple commands get squeezed into a single line. A much better alternative is to use multi-line formatting, where we can write the shell part of our rules in the same way as we would in a regular shell script, and which looks as follows:

```
shell:
    """
    cp {input} $SCRATCH
    cd $SCRATCH
    do_what_ever
    cp what_ever_output {output}
    clean_scratch
    """
```

Note that here the beginning and end block of the shell part are defined by three quotes. Also note that these quotes are now in the line following the shell command and have one level of indentation.

Also note that we followed the guidelines of metacentrum and cleaned up after ourselves on the local scratch space using the **clean_scratch** command. However, if you have a job that produces large temporary files and that may crash, for example if it runs out of memory or wall time, this is not an ideal solution, because **clean_scratch** will only run if the job ran until the end. An alternative way to clean up the local scratch space even if your job crashes is to use a so-called **trap** as follows:

```
shell:
    """
	temp_folder=$SCRATCH/my_job
	mkdir -p $temp_folder
	trap 'rm -rf $temp_folder' TERM EXIT
    cp {input} $temp_folder
    cd $temp_folder
    do_what_ever
    cp what_ever_output {output}
    """
```

Here we created a new temporary folder called **my_job** on the scratch space of our job. We then used the **trap command** to set that the folder and all its content should be removed either when the script is finished or when it gets terminated. Then we copy our input files into this folder, run our commands in it and copy the results to our output files.

>[!CAUTION]
> When you run jobs locally on $SCRATCH like that think about absolute and relative file paths. **{input}** and **{output}** will point to the input and output files you defined, but if you change your directory to $SCRATCH, you will have to consider paths relative to your local directory and if you for example use scripts that are in your workflow folder, you'll either have to set the full path or you'd have to copy them to the local folder as well.


### Using MetaCentrum modules

MetaCentrum has its own system of providing software modules you may want to use instead of conda. You can load them inside a snakemake rule like [you would in any MetaCentrum job script](https://docs.metacentrum.cz/en/docs/software/modules) for example like

shell: 
    """
    module load bwa
    bwa mem -t {threads} ref.fa read1.fq read2.fq "
    """

>[!CAUTION]
> You can often run into issues when you try to use both conda and MetaCentrum modules at the same time, because they will often try to load the same libraries, which can then be mutually incompatible. **Try to avoid using both conda and MetaCentrum modules in the same rule**. 


### Running longer jobs

Until the last job of your workflow finished running, Snakemake itself has to keep running to monitor and submit jobs. Snakemake has a low cpu and memory footprint, so it should be ok to run it on the login node of MetaCentrum, at least for testing. However, for more complex jobs you also want to submit your Snakemake job as its own job, because MetaCentrum will revoke user permissions on the login node after ~10 hours, which will make it impossible for Snakemake to submit new jobs, while submitted jobs have permission to submit new jobs during their whole runtime.

In your job script you should load your snakemake conda environment and set the **XDG_CACHE_HOME** environmental variable as described above. For memory you will not need more than a few hundred mb and you don't need any scratch space. 

You can find an example job script [here](scripts/07_going_meta/run_snakemake.sh).

## Your turn: run your workflow on MetaCentrum

For now let's just try to run the workflow you previously generated on Metacentrum.

+ Copy your Snakefile and the relevant scripts to MetaCentrum and try to rerun it with the configuration set up as above and make sure to give each job a reasonable amount of resources

