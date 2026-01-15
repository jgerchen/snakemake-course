# 1. Setting up Snakemake using Conda

## Conda

Before we start we first have to install Snakemake using [Conda](https://docs.conda.io/projects/conda/en/latest/index.html). Conda is a package and environment management system, which allows you to install different versions  of software packages and dependencies. For our purpose using Conda has a number of advantages:

- It is platform independent, so we can run it under Linux, Mac and Windows (and we can also run it on MetaCentrum)
- Our Conda environment is contained in a local folder, so it does not rely on or interfere with other software you may have installed
- Conda has a wide range of bioinformatics packages available, specifically in the [bioconda channel](https://bioconda.github.io/)
- Conda is integrated into Snakemake, which has internal support for automatically installing and loading Conda packages

## How Conda works

## Creating a new environment

First, start your conda in a local shell. Under UNIX-like operating systems (Linux, Mac) I do this by running
```
source bin/activate
```

In your local Conda folder. After this the so-called **base** environment should be activated. You should also be able to see that the input prompt of your shell changes. In my case it looks like this before activating conda:

> fredo@krnpnq2:

And after activating, it should indicate the **base** environment like this:

> (base) fredo@krnpnq2:

Now lets create a new environment, that we will use to install Snakemake. We can give it any name using the **-n** parameter, in this case we will call it snakemake.

```
conda create -n snakemake
```
It will show you some output and ask you if you want to proceed

> Proceed ([y]/n)? 

If you just press enter it will create your new environment, which we can activate using

```
conda activate snakemake
```

And after activating, your shell prompt should indicate that now your **snakemake** environment is activated, in my case like this:

> (snakemake) fredo@krnpnq2:

> [!TIP]
> You can directly activate environments you created (in this example your **snakemake** environemnt) from the shell using

```
source bin/activate snakemake
```



## Installing software

> [!WARNING]
> Always make sure that the correct conda environment is activated before you install software. While it is also possible to install software into the base environment, you will sooner or later run into issues with incompatible versions and your conda will slow down substantially if you install your software into the base environemnt.

Now with the **snakemake** environment activate, we want to install the snakemake package into it using the [mamba package solver](https://mamba.readthedocs.io/en/latest/index.html). We will also want to tell mamba that we want to use the [bioconda channel](https://bioconda.github.io/) using the -c option.

```
mamba install -c bioconda snakemake
```

Mamba will give you a long list of packages it will install besides Snakemake. In that list you can find a line, which looks like this

> \+ snakemake   9.14.6  hdfd78af_0  bioconda    10kB



