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

Compile time can become a particular issue when you are developing software, where you often make small and incremental changes to your code. With every change you'd have to recompile your code to test it. However, more complex computer programs are commonly written in a modular way, so that different components of the software are split across different files. These individual files can be compiled separately and are then linked together to make the finished executable program. This approach has numerous advantages, because such a structured codebase is easier to understand and maintain and it allows to easily implement code with general functions written by other people that can be reused. Importantly, it also means that only parts of the code have to be re-compiled when changes are made, which can dramatically speed up compile times. GNU make has been developed to automate this process, by determining which files depend on which other files and what parts of a software project will have to be recompiled when something changes.



