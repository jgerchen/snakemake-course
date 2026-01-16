# 3. My first rule!

## Rules

The main building block of Snakemake workflows are called **Rules**. Basically, a rule determines which code has to be run to generate one or multiple files and on what other file or files are required for this. Based on these dependencies between files Snakemake builds a graph and determines if and how a specific file can be generated and it then runs the rules in the appropriate order.

### Let's start simple

Lets start by creating a simple example. First, create a folder somewhere on your file system in which we will create our practice workflow. In this folder create an empty textfile named **Snakefile** (capital S, no file extension). A Snakefile is snakemake's equivalent to GNU make's makefile, and it's the file in which we define the rules that we use to build our workflow.

We can now create our first rule definition. We tell Snakemake that we want to define a rule with the keyword rule, followed by an arbitrary name (but without spaces or other ) and a colon (:), so for example if we want to define a rule named rule_1 we'd start by writing


```
rule rule_1:
```







