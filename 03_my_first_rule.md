# 3. My first rule!

## Rules

The main building block of Snakemake workflows are called **Rules**. Basically, a rule determines which code has to be run to generate one or multiple files and on what other file or files are required for this. Based on these dependencies between files Snakemake builds a graph and determines if and how a specific file can be generated and it then runs the rules in the appropriate order.

### Let's start simple

Lets start by creating a simple example. First, create a folder somewhere on your file system in which we will create our practice workflow. In this folder create an empty textfile named **Snakefile** (capital S, no file extension). A Snakefile is snakemake's equivalent to GNU make's makefile, and it's the file in which we define the rules that we use to build our workflow.

We can now create our first rule definition. We tell Snakemake that we want to define a rule with the keyword rule, followed by an arbitrary name (but without spaces or other special characters) and a colon (:), so for example if we want to define a rule named rule_1 we'd start by writing


```
rule rule_1:
```

>#### :snake: indentation
>As I wrote before, Snakemake is based on Python, so rules in Snakemake are written in an extended form of Python code. A big difference of Python to other programming languages is that indentation is an essential part of the code, while it is typically optional in other programming languages, but considered good practice to write readable code. This means that the way how parts of the code are moved to the right by inserting whitespace (tabs or multiple spaces) at the beginning of the line determines how python or Snakmake understand the structure of the code. Importantly, Python can use either tabs or multiple spaces as indentation, but its use has to be consistent across the file. The fact that tabs and multiple spaces are typically indistinguishable in most text editors can somtimes lead to issues when you open and edit a file that uses a different type of indentation.

Now that we gave our first rule a name lets define a file that the rule is supposed to create. So for example lets say our rule is supposed to create a file called **file1.txt** in the same folder as the Snakefile. To do this we can define **file1.txt** as an output of **rule_1** in the following way:

```
rule rule_1:
    output: "file1.txt"
```
Note the intendation before the output statement, which tells Snakemake that the output part belongs to rule_1 and is not another independent python object.

>#### :snake: text strings
>Note that the filename "rule1.txt" is written in parantheses. This is one way to define a text string in python. The other is to use 'single quotes', which may have subtle differences in behaviour in some situations, which are not relevant at this point.

Finally, we also have to define how **rule_1** is supposed to generate **file1.txt**. For the purpose of this exercise let's just use the UNIX **touch** command. If we run the command

```
touch file1.txt
```

on the command line it will do one of two things:

+ It will create an empty file called file1.txt if file1.txt does not exist

+ It will update the time stamp of file1.txt if file1.txt does exist

So lets add this behaviour to **rule_1** in the following way

```
rule rule_1:
    output: "file1.txt"
    shell: "touch file1.txt"
```

The **shell** part indicates which shell command has to be run in order to create **file1.txt**.

Now our first rule is complete, so lets see if we can run it via Snakemake. First, if you created the file file1.txt on the command line already delete it. Second, make sure your **snakemake conda environment** is activated on the shell your currently working on and that you're in the **same directory as your Snakefile**. Then you can run Snakemake using the following command:

```
snakemake -j1
```

Here we give just -j1 as a single parameter to the snakemake command. The -j parameter is required and tells snakemake how many jobs its supposed to run in parallel. Since at this point we're just running simple scripts locally we leave it at 1 for now and get back to it at a later point when we want to parallelize things. Besides that Snakemake will automatically look for a file named **Snakefile** and try to generate the output of the first rule.

This snakemake command should give you an output that ends like this:

>Finished jobid: 0 (Rule: rule_1)
>1 of 1 steps (100%) done

And you should notice that file1.txt should have been created in the same way as if we did it ourselves. Now if you rerun exactly the same command again you will get a different output, which should end like this:

>Nothing to be done (all requested files are present and up to date).

This is because **file1.txt** already exists and Snakemake will only recreate it again if we delete it.

> [!IMPORTANT]
> As long as there are no additional reasons based on dependencies Snakemake will not recreate files that already exist. It also doesn't matter for Snakemake that the files generated using touch are completely empty, the only thing that matters for Snakemake are if a file exists and its timestamp.

## My second rule!

Now let's introduce **dependencies between files**. File dependencies are the essential components that structure a Snakemake workflow. So let's create a new rule which creates a new file called **file2.txt**, which depends on the presence of **file1.txt**, which we created in the first step. For simplicity, let's assume file2.txt is simply a copy of file1.txt, which we can generate with the shell command
```
cp file1.txt file2.txt
```
To integrate this into your Snakemake workflow add a second rule, called **rule_2** to the bottom of your **Snakefile** like this

```
rule rule_2:
    input: "file1.txt"
    output: "file2.txt"
    shell: "cp file1.txt file2.txt"
```
First, note that there is no indentation in the first line, where we define the rule. This tells Snakemake that we left the scope of the previous rule object and we are starting a new one. Second, note that we added the **input** part, which contains the output of rule_1 (**file1.txt**). Now let's do a few things with this two rule system to better understand how Snakemake works.
If we rerun Snakemake with the previous command

```
snakemake -j1
```

It will give us the output

>Nothing to be done (all requested files are present and up to date).

And it will not create **file2.txt**. This is because without any additional parameters will only run the the **first rule in the Snakefile, but nothing else**. We could change this by moving rule_2 to the top of the Snakefile, or we could tell Snakemake explicitely which file to generate, in this case file2.txt. To do this, we have to give the filename of our desired output file to the snakemake command like this and Snakemake will create file2.txt.

```
snakemake -j1 file2.txt
```

Now to better understand how dependencies work lets first **delete file1.txt and file2.txt**. Now if your rerun the previous command Snakemake will create **both file1.txt and file2.txt**, although we only told it to create **file2.txt**. This is because of the depedencies: we told Snakemake that **file2.txt** depends on **file1.txt**, so it knows it has to create **file1.txt** before it can create **file2.txt**.

Now lets remove both files again, but this time we create **file1.txt** by hand using

```
touch file1.txt
```

Now if we rerun the same Snakemake command it will **only create file2.txt**. This is because the dependency **file1.txt** already exists. 

> [!IMPORTANT]
> It doesn't matter for Snakemake if a dependency is based on a rule or a file that already exists. 

Now finally let's rerun

```
touch file1.txt
```
Now if we rerun Snakemake it will **create file2.txt again, despite the fact that it already exists.** Why is that? If you remember the earlier part of this session, when we run **touch** on a file that already exists, it will only **update that files time stamp**. Snakemake sees that the time stamp of **file2.txt** is now younger than that of **file1.txt** and the dependency of **file2.txt** on **file1.txt** implies that we also have to update file2.txt. 

> [!IMPORTANT]
> Time stamps are an essential part, which Snakemake uses to decide if a rule is supposed to be rerun. 

## Loading software using Conda

We saw how to create a conda environment, how to install software and how to activate it in the previous chapter. We can tell Snakemake to do all of this for us automatically by adding a **conda** environment definition file to a rule.

For our rule_1 this would look like this:

```
rule rule_1:
    output: "file1.txt"
    conda: "envs/rule1.yaml"
    shell: "touch file1.txt"
```

Here envs/rule1.yaml points to a file, which desired defines the content of our conda environment and which we have to create ourselves. First, create a folder called envs on your practice workflow folder. Second, create a new text file called rule1.yaml in this folder. This file is build up like in the following example:

```
channels:
  - conda-forge
dependencies:
  - r-base
```

So in your yaml file you have to provide a list of channels and a list of dependencies. In this case this would create a new conda environemnt and install **R** in it. If we want to install a specific version of a software package we can define it directly, so if we want to install R version 4.52 we could change the entry in the yaml file to

```
  - r-base=4.52
```

If you want Snakemake to use the Conda environment you defined you have to run it with the addtional parameter **--use-conda**. Snakemake will then create a local conda environment the first time you run it or load the conda environment for a specific rule if it already was created in its local directory of temporary files. You can also tell Snakemake to use the mamba package solver for installing conda environments (which is faster than the default and can in sometimes install more recent software versions) by adding the option **--conda-frontend 'mamba'** to your Snakemake command.

> [!NOTE]
> Snakemake stores lots of Metainformation about your Snakemake workflow in a hidden folder called **.snakemake** in the directory were you run your workflow. This folder is also where Snakemake puts the conda environments it creates, but you can change this to a different folder using by adding the **--conda-prefix** parameter command to your snakemake command.

## Your turn: run a slimulation and make a simple plot based on its output!

Now it's your turn to apply what you learned in the previous part and to build a simple two rule system, which the first rule runs an individual based simulation using SLiM (aka a **slimulation**) and the second rule takes its output and generates a plot of the data.

You will find two scripts in the [scripts folder for this session](scripts/03_my_first_rule):

+ [03_slimulation.slim](scripts/03_my_first_rule/03_slimulation.slim): this is the input file that defines how our slimulations behave. This is a simple model, which simulates a single 1 Mb chromosome, which is neutrally evolving at constant population size of 500 individuals based on a basic Wright-Fisher model. After 10000 generations it will output the genotypes of a sample of 50 individuals and write them to a VCF file called **03_slim_output.vcf**. If slim is installed, it can be run using the command

```
slim 03_slimulation.slim
```

+ [03_plot_vcf.R](scripts/03_my_first_rule/03_plot_vcf.R): this is an R script that takes a VCF file as first input parameter (**input_file** below) and generates an output file (**output_file** below) as second parameter. So to run this on the command line you'd have to use a command like this:

```
Rscript vcf_file output_file
```

Both scripts have software dependencies you should have Snakemake install automatically using conda:

+ For slim we want the latest version (5.1), which is found on the [bioconda channel](https://anaconda.org/channels/conda-forge/packages/slim/overview)

+ For the R script we want an environment that includes
    + R (the package is called [r-base](https://anaconda.org/channels/conda-forge/packages/r-base/overview))
    + vcfR for reading VCF files into R (the package is called [r-vcfr](https://anaconda.org/channels/bioconda/packages/r-vcfr/overview))









