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
>As I wrote before, Snakemake is based on Python, so rules in Snakemake are written in an extended form of Python code. A big difference of Python to other programming languages is that indentation is an essential part of the code, while it is typically optional in other programming languages, but considered good practice to write readable code. This means that the way how parts of the code are moved to the right by inserting whitespace (tabs or multiple spaces) at the beginning of the line determines how python or Snakmake understand the structure of the code. Importantly, Python can use either tabs or multiple spaces as intendation, but its use has to be consistent across the file. The fact that tabs and multiple spaces are typically indistinguishable in most text editors can somtimes lead to issues when you open and edit a file that uses a different type of indentation.

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

Now our first rule is complete, so lets see if we can run it via Snakemake. First, if you created the file file1.txt on the command line already delete it. Second, make sure your **snakemake conda environment** is activated on the shell your currently working. Then you can run Snakemake using the following command:

```
snakemake -j1
```

Here we give just -j1 as a single parameter to the snakemake command. The -j parameter is required and tells snakemake how many jobs its supposed to run in parallel. Since at this point we're just running simple scripts locally we leave it at 1 for now and get back to it at a later point when we want to parallelize things.

This snakemake command should give you an output that ends like this:

>Finished jobid: 0 (Rule: rule_1)
>1 of 1 steps (100%) done

And you should notice that file1.txt should have been created in the same way as if we did it ourselves. Now if you rerun exactly the same command again you will get a different output, which should end like this:

>Nothing to be done (all requested files are present and up to date).

This is because **file1.txt** already exists and Snakemake will only recreate it again if we delete it.

> [!IMPORTANT]
> As long as their are no additional dependencies Snakemake will not recreate files that already exist.




