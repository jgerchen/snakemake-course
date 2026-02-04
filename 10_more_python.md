# More useful features you can add to your workflow by using a bit more python code

Although Snakemake is based on python, the previous chapters showed you that you can build fairly sophisticated workflows while using surprisingly little python. In this part I will show you some useful examples how you can add very useful features to your workflow with writing a bit more python code. This is all a bit more advanced, so completely understanding all the python in this part may be beyond the scope of this course, but I think it can show you what's possible and it can also give you a starting point to think about how to implement things like this yourself.

## Input functions

Instead of explicitely defining the input files of our rules, we can also use self written python functions, whose return value are your input files. This is of course infinitely flexible, but here we will focus on the common case of reading a list of files from an input text file.

You define input functions as regular functions **outside the scope of your rules** (so at zero indentation level). This function must have **wildcards** as parameter.

>### :snake: Python functions
> In python functions are defined by the key word **def** followed by a name and a list of names or unnamed parameters in brackets and a **colon**. Everything inside the function is defined by one level of indentation. Return values (or any python objects like arrays or dictionaries) are indicated with the keyword **return** at the start of the line.

### Reading a list

Consider the following scenario:
We want to load all files that are listed in the file **input_list.txt** (one file per line).

```
def load_file(wildcards):
    file_list=[]
    with open("input_list.txt") as l_file:
        for l_line in l_file:
            file_list.append(l_line.strip())
    return file_list

rule rule_1:
    input: load_file
```

There are multiple parts here we have to understand. First lets try to understand what the function load file does, which involves understanding some more basic python commands. 

>### :snake:
> In the first line we create an empty python array called **file_list** using empty square brackets. This is a python array as you already saw in the previous part, but the only difference here is that it contains no elements whatsoever for now. In the next line we use the **with** statement of python followed by the **open** function, which is used to read in a text file line by line, and the object used to access that text file is called **l_file**. In the next step we go over each line of the opened text file object **l_file** using a for loop, which will give us a string called **l_line**, containing each line. We use the **append** function to add the value of each line to the previously empty array file list, however we apply the **strip** function to that line first to remove new-line characters at the end of it. Then we return the array **file_list**, which is now filled the value from each line.

Then we can directly use the name of this function as parameters for the input part of our rule. Note that we just use the name and no brackets here.

### Globbing

Let's consider a different way how we may want to use input functions and python. Let's assume one of our rules wants to use all files with a specific ending (like **.txt**) in a specific folder called **files**. To get this we can use a preexisting function called **glob**. To load python's **glob** function, we have to load a library called **glob** which comes with the python standard library.

```
import glob
def load_glob(wildcards):
    return glob.glob("files/*.txt")

rule rule_1:
    input: load_glob
```

Here we first import the **glob python library**

>### :snake:
> We can import any python libraries that are installed in our snakemake conda environment into snakemake using **import**

The we define a new input function which directly returns the output of the **glob** function from the **glob** library. The parameter we give to the glob function is the folder files, followed by the **shell wildcard \* **, which means any characters, followed our desired file ending, **.txt**

### Unpacking dictionaries

We can also use input funtions to generate named input files using dictionaries. Let's assume we have a file with two rows, the first rows being variable names and the second rows being file names as follows:

```
inp1    input_file1.txt
inp2    input_file2.txt
inp3    input_file3.txt
```

Now we want to used each line as named input file, which we can do as follows:

```
def load_dict(wildcards):
    file_dict={}
    with open("input_table.txt") as d_file:
        for d_line in d_file:
            d_key=d_line.strip().split()[0]
            d_value=d_line.strip().split()[1]
            file_dict.update({d_key:d_value})
    return file_dict

rule rule_1:
    input: unpack(load_dict)
    output: "out_unpack.txt"
    shell: "cat {input.f2} {input.f1} {input.f3} > {output}"
```

Here we used a function to return a dictionary instead of a list.

>### :snake:
> In the first line we create an empty dictionary called **file_dict** using empty curly brackets. In the next line we again use the **with** statement of python followed by the **open** function, which is used to read in a text file line by line, and the object used to access that text file is called **d_file**. In the next step we again go over each line of the opened text file object **d_file** using a for loop, which will give us a string called **d_line**, containing each line. We then first use the **strip()** function of the string to remove new lines at the end and then we use the **split** function to split each line at the tab in the middle. Split returns an array with two elements we access the first element with square brackets and the **index 0 (remember that python starts counting at 0)** and call it **d_value** and access the second element with the **index 1**. We then add **d_key** and **d_value** as a key-value pair to the dictionary **file_dict** using the **update method**. Finally we return **file_dict** from the function **load_dict**.

Then we use snakemakes **unpack function**, which when applied to function which returns a dictionary will give us named input files based on the dictionaries keys and values.

## using wildcards in functions

In the previous part we used a function to return a dictionary to python. However, imagine a different more plausible scenario, were we give a sample an individual name defined by a wildcard and were then we have a table, which matches the name of the wildcard to a longer complex file name, that could be somewhere outside of your workflow folder. Imagine a table as follows, where the first column are identifiers of samples, while the second column are paths to file names.

```
f1    /storage/brno12-cerit/your_username/data/s1.data
f2    /storage/brno12-cerit/your_username/data/s2.data
f3    /storage/brno12-cerit/your_username/data/s3.data
```

Previously, we made a function that returns a dictionary from a file it reads, which makes sense if we do it just once. However, we may have different rules (for each sample) accessing the input table, so it may make more sense to only read the table into python once and then have a function access that dictionary. To do this we could read in the dictionary directly in the Snakemake file as follows:

```
file_dict={}
with open("input_table.txt") as d_file:
    for d_line in d_file:
        d_key=d_line.strip().split()[0]
        d_value=d_line.strip().split()[1]
        file_dict.update({d_key:d_value})
print(file_dict)

def get_sample(wildcards):
    print(wildcards)
    return file_dict[wildcards.sample]

rule rule_1:
    input: get_sample
    output: "out_{sample}.txt"
    shell: "echo {wildcards.sample} > {output}" 

rule rule_2:
    input: expand("out_{wc}.txt", wc=file_dict.keys())
    output: "out_wildcards.txt"
    shell: "cat {input} > {output}" 
```

Note that we now open the dictionary the same way as before, but we do it **outside** of our input function. This means that the python object containing the dictionary is not specific to the input function, but available to all snakemake objects. Also note that the **get_sample** input function now got a parameter called **wildcards**. Snakemake will understand that when it gets an input function with the parameter **wildcards**, that it will pass an objections containing the values of wildcards for that function and in this case we can then access the value of the wildcard **sample** using **wildcards.sample**. We then use the value of this wildcards to access the corresponding key in **file_dict** using square brackets.

## Using functions for cluster resources 

Instead of using python functions for inferring input files, we can also use functions for generating values for cluster resources (like memory, diskspace or walltime). This can make sense if you automatically want snakemake to automatically rerun rules that crash with increased resources. For example let's assume that we want to rerun structure if it crashed and increase the amount of memory we want to give it when it is rerun:

```
def structure_set_mem_mb(wildcards, attempt):
   return 10000*attempt 

rule structure:
	input:
		mainparams="out_{P23}_{P32}/mainparams",
		extraparams="out_{P23}_{P32}/extraparams",
		struct_inp="out_{P23}_{P32}/04_slim_{P23}_{P32}.struct"
	output: struct_out="out_{P23}_{P32}/04_slim_{P23}_{P32}_{rep}.out_f"
	conda:	"envs/structure.yaml"
    log: "log/structure_{P23}_{P32}_{rep}"
    resources:
        mem_mb=structure_set_mem_mb,
        disk_mb=1000,
        runtime="1h"
```

For resources, functions can use the parameter **attempt**, which tells Snakemake how many times it tried to rerun the rule already. If snakemake runs the rule for the first time, the **attempt** parameter will be 1, so the function will return 10000\*1, so it will set **mem_mb** to 10000. However, if Snakemake runs the rule for the second time, **mem_mb** will be set to 10000\*2, so **mem_mb** will be doubled to 20000. If you want snakemake to try rerunning rules that crashed, you have to add the **--retries** parameter to your snakemake command, with the number of times it should try to rerun a rule before it fails.

> [!CAUTION]
> Snakemake does not know why any of your rules failed, so if you keep giving it more memory, it will continue to retry, even if memory wan't the issue in the first place.

# More Snakemake resources

In this workflow I included the parts that I think are most important to allow you to build your own workflows on MetaCentrum. However, this is by no way comprehensive and snakemake has many more options and use cases than we could cover in this course. If you want to read more the best starting point is the [extensive documentation on the official Snakemake site](https://snakemake.readthedocs.io/en/stable/), which also comes with multiple tutorials, a [general tutorial](https://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html#tutorial) and a more [specific tutorial on interaction, visualization and reporting](https://snakemake.readthedocs.io/en/stable/tutorial/interaction_visualization_reporting/tutorial.html#interaction-visualization-reporting-tutorial), which covers advanced aspects, most of which we didn't have time to cover in this course.
