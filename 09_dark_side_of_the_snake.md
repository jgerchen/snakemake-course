# 9. The dark side of the Snake. Common Snakemake issues and how to fix them

There are several issues me and other people I knew commonly run when running snakemake workflows or when building your own workflow. In this chapter I will go through some of them and show you why they happen and how to fix them or how to prevent them from happening in the first place.

## After the Snakemake process crashes or gets killed because it ran out of walltime Snakemake complains that the directory is locked and won't let you rerun your previous Snakemake command

Snakemake stores a lot of Metadata in a hidden directory called **.snakemake**, typically in the folder were also your Snakefile is located. It is important that only one Snakemake workflow at the same time is trying to write to those metadata, otherwise things will get messy. To prevent multiple instances of the same workflow from running at the same time Snakemake has some internal variable inside this metadata that tells other instances of the workflow that the directory is locked and it will set it to unlocked again when the Snakemake command is finished. 

However, if the Snakemake command doesn't finish it will also not change this variable back to unlocked again and we have to do this by hand by running the snakemake command using the **--unlock** parameter.


```
snakemake --unlock
```

This will reset the directory to unlocked and you should now be able to rerun your previous command. Note that with the **--unlock** parameter active snakemake will not run any actual rules, so you can run this directly on the login node on MetaCentrum.

## You either updated some files or edited some part of the workflow that you already partially ran and now Snakemake wants to rerun everything from the beginning although you can see that all files are present and all dependencies are fulfilled.

**This is actually not a bug, but a fundamental feature of Snakemake**. Based on your dependency graph Snakemake will see if either timestands of dependencies are younger than downstream files or it will detect that the shell part of your rule were changed and will assume that dependent files have to be recreated.

However, there are many situation where you don't want this behaviour and you know that the files you already generated are fine and you want to just make Snakemake continue on the files that are already there. There is a Snakemake parameter called **--touch** which will tell Snakemake to reset the timestamps of all present files relevant in your workflow in a way that it will continue only with files that are not present yet.

```
snakemake -j1 --touch output_file.txt
```

This command will not run any actual snakemake rules, however it will resolve the DAG and go through any files that already exist and adjust their timestamp, while it will ignore files that don't exist and would be created by running their rules without the **--touch** parameter. Since this is also not very computationally intensive you can also run it on the login node on MetaCentrum.

## Snakemake resolves my wildcards in really weird ways and not how I intended




> [!TIP]
> Many more common issues with Snakemake are discusses [here](https://snakemake.readthedocs.io/en/stable/project_info/faq.html)
