# More useful features you can add to your workflow by using a bit more python code

Although Snakemake is based on python, the previous chapters showed you that you can build fairly sophisticated workflows while using surprisingly little python. In this part I will show you some useful examples how you can add very useful features to your workflow with writing a bit more python code.

## Input functions

Instead of explicitely defining the input files of our rules, we can also use self written python functions, whose return value are your input files. This is of course infinitely flexible, but here we will focus on the common case of reading a list of files from an input text file.

You define input functions as regular functions **outside the scope of your rules** (so at zero indentation level).

>### :snake: Python functions
> In python functions are defined by the key word **def** followed by a name and a list of names or unnamed parameters in brackets and a **colon**. Everything inside the function is defined by one level of indentation. Return values (or any python objects like arrays or dictionaries) are indicated with the keyword **return** at the start of the line.

Consider the following scenario:
We want to load all files that are listed in the file **input_list.txt** (one file per line).

```
def load_file():
    file_list=[]
    with open("input_list.txt") as l_file:
        for l_line in l_file:
            file_list.append(l_line.strip())
    return l_line

rule rule_1:
    input: load_file
```

There are multiple parts here we have to understand. First lets try to understand what the function load file does, which involves understanding some more basic python commands. 

>### :snake:
> In the first line we create an empty python array called **file_list** using empty square brackets. This is a python array as you already saw in the previous part, but the only difference here is that it contains no elements whatsoever for now. In the next line we use the **with** statement of python followed by the **open** function, which is used to read in a text file line by line, and the object used to access that text file is called **l_file**. In the next step we go over each line of the opened text file object **l_file** using a for loop, which will give us a string called **l_line**, containing each line. We use the **append** function to add the value of each line to the previously empty array file list, however we apply the **strip** function to that line first to remove new-line characters at the end of it. Then we return the array **file_list**, which is now filled the value from each line.

Then we can directly use the name of this function as parameters for the input part of our rule. Note that we just use the name and no brackets here.

Let's consider a different way how we may want to use input functions and python. Let's assume one of our rules wants to use all files with a specific ending (like **.txt**) in a specific folder called **files**. To get this we can use a preexisting function called **glob**. To load python's **glob** function, we have to load a library called **glob** which comes with the python standard library.

```
import glob
def load_glob():
    return glob.glob("files/*.txt")

rule rule_1:
    input: load_glob
```

Here we first import the **glob python library**

>### :snake:
> We can import any python libraries that are installed in our snakemake conda environment into snakemake using **import**

The we define a new input function which directly returns the output of the **glob** function from the **glob** library. The parameter we give to the glob function is the folder files, followed by the **shell wildcard \* **, which means any characters, followed our desired file ending, **.txt**

Finally, we can also use input funtions to generate named input files using dictionaries. Consider the following example:

```
def load_dict():
    file_dict={}
    with open("input_list.txt") as d_file:
        for l_line in l_file:
            l_key
    return l_line

rule rule_1:
    input: load_glob
```












