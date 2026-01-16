# Make? Snake?

This part will give you a bit of background into where the concepts that we will learning in this course are coming from. 

# The beginning: GNU make

Snakemake is based on the concepts of [GNU make](https://www.gnu.org/software/make/), a common program which was developed to facilitate writing and building computer software. 

## Origins from software development

In general, there are two major types of programming languages:

+ interpreted languages, like python and R, where code is turned into computer code at runtime

+ compiled languages, like C, C++ and Rust, where code is turned into computer code before it is run using a software called a compiler.

In comparison to interpreted programming languages, compiled programming languages have the advantage at being much faster and are potentially also more efficient at using memory, because the compiler can optimize code for the specific computing architecture and compiled programming languages also give more direct access to system functions and memory management to programmers, which also allows to write more optimized code. This is a feature that is often also used by interpreted languages in the background. For example when you install an R package a lot the more computationally intensive parts are often written in a compiled language like C, which are then called by R code. The downside to compiled languages is that compiling code takes time.

![Cartoon from xkcd.com](https://imgs.xkcd.com/comics/compiling.png)
Cartoon by [XKCD](https://xkcd.com/)

Compile time can become a particular issue when you are developing software, where you often make small and incremental changes to your code. With every change you'd have to recompile your code to test it. However, more complex computer programs are commonly written in a modular way, so that different components of the software are split across different files. These individual files can be compiled separately and are then linked together to make the finished executable program. This approach has numerous advantages, because such a structured codebase is easier to understand and maintain and it allows to easily implement code with general functions written by other people that can be reused. Importantly, it also means that only parts of the code have to be re-compiled when changes are made, which can dramatically speed up compile times. 

GNU make was developed to automate this process, by determining which files depend on which other files and what parts of a software project will have to be recompiled when something changes. It also automatically determines the proper order for updating files. As a result, if you change a few files and then run Make, it does not need to recompile all of your program. It updates only those files that depend directly or indirectly on the source files that you changed. GNU make does this by building a graph of dependencies between files, which are defined by **rules** in so-called **Makefiles**.

## Bioinformatics applications

When we look at a typical bioinformatics project, we often run into similar issues that GNU make addresses in software development projects:

+ We often have complex dependencies, where files that are created in one step will be the input for a following step and we would like to have a concise way to logically connect the  individual steps.

+ We often want to rerun parts of our workflow, for example when we change parameters or when we fix something in part of our scripts. Having this ability is often even more important than in software development, because bioinfomratics jobs tend to be much more time consuming and resource intensive than compiling software.

However, in bioinformatics we often have additional requirements, for which GNU make is not well suited:

+ We often want to run jobs on a computing cluster, and we'd like some way for our jobs to be automatically submitted and monitored

+ We may want to be more flexible in how we determine the order of rules. For example, when running simulations we often run the same job multiple times and then collect the results. So we would like to have some easy way to create multiple instances of the same task in parallel, which as far as I know is not a common thing you'd want to do in software development.

+ We want clearer and more readable code than GNU make, which can often look obscure and daunting to non-professional coders

+ We may want integration with a wider range of software packages and programming languages, which we'd have to implement by hand if we used GNU make


## Snakemake

Out of these and other considerations **Snakemake** was born. Snakemake is based on the principles underlying GNU make, and it can generate dependencies between files and determine the best way to run them and which jobs have to be rerun. Similar to GNU make these dependencies are defined by **rules** in **Snakefiles**, the snakemake equivalent of Makefiles. However, Snakemake is based on the [python programming language](https://www.python.org/) and it comes with a lot of additional features that GNU make doesn't have. Specifically, Snakemake...

+ ...has support for different computing cluster architectures and support for building your own implementations of unsupported architectures

+ ...is based on python, which means that you can use python code to adjust how it does a job, which gives extreme flexibility to implement complex workflows with very little code. Also the underlying python code is clear and easily understandable.

+ ...comes with a wide range of supported programming languages, software package management systems and cloud computing platforms

