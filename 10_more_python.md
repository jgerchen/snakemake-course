# More useful features you can add to your workflow by using a bit more python code

Although Snakemake is based on python, the previous chapters showed you that you can build fairly sophisticated workflows while using surprisingly little python. In this part I will show you some useful examples how you can add very useful features to your workflow with writing a bit more python code.

## Input functions

Instead of explicitely defining the input files of our rules, we can also use self written python functions, whose return value are your input files. This is of course infinitely flexible, but here we will focus on the common case of reading a list of files from an input text file.

You define input functions as regular functions **outside the scope of your rules** (so at zero indentation level).

>### :snake: Python functions
> In python functions are defined by the key word **def** followed by a name and a list of names or unnamed parameters in brackets and a **colon**. Everything inside the function is defined by one level of indentation. Return values (or any python objects like arrays or dictionaries) are indicated with the keyword **return** at the start of the line.

Consider the following scenario:


