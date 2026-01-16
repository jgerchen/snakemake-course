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
>As I wrote before, Snakemake is based on Python, so rules in Snakemake are written in an extended form of Python code. A big difference of Python to other programming languages is that indentation is an essential part of the code. This means that the way how parts of the code are moved to the right by inserting whitespace (tabs or multiple spaces) at the beginning of the line determines how python or Snakmake understand the structure of the code. Importantly, Python can use either tabs or multiple spaces as intendation, but its use has to be consistent across the file. The fact that tabs and multiple spaces are typically indistinguishable in most text editors can somtimes lead to issues when you open and edit a file that uses a different type of intendation.

Now that we gave our first rule a name lets define a file that the rule is supposed to create. So for example lets say our rule is supposed to create a file called **file1.txt** in the same folder as the Snakefile. To do this we can define **file1.txt** as an output of **rule_1** in the following way:


```
rule rule_1:
    output: "rule1.txt"
```
Note the intendation before the output statement, which tells Snakemake that the output part belongs to rule_1 and is not another independent python object.

>#### :snake: text strings
>Note that the filename "rule1.txt" is written in paranthesis this is how we define a text string in python, which may be familiar to you from other programming languages like R.





