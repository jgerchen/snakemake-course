# Make? Snake?

This part will give you a bit of background into where the concepts that we will learning in this course are coming from.

# The beginning: GNU make

Snakemake is based on the concepts of [GNU make](https://www.gnu.org/software/make/), a common program which was developed to facilitate writing and building computer software. 

## Origins from software development

In general, there are two major types of programming languages:

+ interpreted languages, like python and R, where code is turned into computer code at runtime

+ compiled languages, like C, C++ and Rust, where code is turned into computer code before it is run using a software called a compiler.

In comparison to interpreted programming languages, compiled programming languages have the advantage at being much faster and potentially also more efficient at using memory, because the compiler can optimize code for the specific computing architecture and compiled programming languages also give more direct access to system functions and memory management to programmers, which also allows to write more optimized code. The downside to compiled languages is that compiling code takes time.

![Cartoon from xkcd.com](https://imgs.xkcd.com/comics/compiling.png)


