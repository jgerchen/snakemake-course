# 4. Branches and variables

In the previous part we saw how to build a simple two-rule system. However, our bioinformatics workflows usually involve more then two rules, which are not always connected in a linear way. In this part we'll get into how to organize our workflow into more complex patterns involving more rules, how to simplify how we specify our rules using variables and how to plot more complex workflows.

## Using variables in shell commands

When we look again at the shell command from our previous part, we explicitely point to **file1.txt** twice. Once in the output part:

>output: "file1.txt"

and once in the shell part:

>shell: "touch file1.txt"

For the shell part, we can replace **file1.txt** with a variable, which points to **file1.txt** in the output part by changing the shell part in the following way:

>shell: "touch {output}"

Now the variable {output} in the shell script gets replaced by **file1.txt**, as it is defined in the output part of the rule. In general, inside the shell part different types of variables provided by Snakemake variables are defined by **{curly brackets}** around them. 


> [!CAUTION]
> Some shell commands you may want to include in your snakemake workflow use curly brackets on their own. For example consider the scripting language awk, where the command for plotting the first column of a tab separated file is like the following:
>
>awk '{print $1}' file.tsv
>
>If we want to use such a command in the shell part from Snakemake we have to **escape the curly brackets** by adding an extra pair of curly brackets around them, so that your snakemake shell command would look as follows:
>
>awk '**{{**print $1**}}**' file.tsv








>shell: "cp file1.txt file2.txt" 
