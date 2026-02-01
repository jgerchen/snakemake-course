# 5. Wildcards

Wildcards are one of the most powerful features of Snakemake, which allows for complex and dynamic workflows. However, there are also many cases where the behaviour of wildcards can be counterintuitive if we don't fully understand how they work, so let's try to approach wildcards in small steps to make sure we understand how they are implemented in Snakemake.

## What's a wildcard?

A wildcard is a type of variable in the filenames of the input or output files of your rules, which gets determined based on the upstream file names of rules for which these files are dependencies. **Wildcards are defined by curly brackets when those file names are defined in the rule definition**. Let's make this a bit clearer with an example. Lets assume we have two rules, **rule_1** and **rule_2**

```
rule rule_1:
	output: "{wc1}_file.txt"
	shell: "touch {output}"

 rule rule_2:
 	input: "new_file.txt"
	output: "new_file_copy.txt"
    shell: "cp {input} {output}"
```

In the output part of rule_1 we defined the wildcard {wc1} in the output file name. Now when we ask Snakemake to generate the output of rule_2 (**new_file_copy.txt**) it will try to meet the dependency **new_file.txt** based on either files existing files or other rules in the Snakefile. It will then see that the output of rule_1 matches with parts of the file name (**_file.txt**), while the rest of the file contains wildcard {wc1}. It will then replace {wc1} with "new" to fulfill the dependency. If the workflow is run, rule_1 will create the file **new_file.txt**, which will satisfy the dependency to create **new_file_copy.txt**. 

> [!IMPORTANT]
> It is the rule thats lower in the dependency graph (in this case **rule_2**) which determines how the wildcards for rules higher in the graph (in this case **rule_1**) are determined. Again, this may seem counterintuitive at first so it is important to keep in mind that Snakemake starts by building a graph of the workflow by going backwards through the dependencies of the output files it is supposed to create and this is also the order in which the values of wildcards are determined.

Now let's add a third rule called **rule_3**:

```
rule rule_3:
    input: "other_file.txt"
	output: "other_file_copy.txt"
	shell: "cp {input} {output}"
```
This rule will do the same thing as **rule_2**, with the only difference that it depends on a file called **other_copy.txt** instead of **new_copy.txt**. However, this can also be satisfied by replacing the wildcard {wc1} with **other**. If we run a workflow and ask it to generate **other_file_copy.txt** it will also run rule_1, which output **other_file.txt**. 

If we ask it to generate both **new_file_copy.txt** and **other_file_copy.txt** it will run **rule_1** twice, one time replacing **{wc1}** with **new** and one time with **other**.

> [!CAUTION]
> Wildcards are defined using curly brackets in the input and output parts of a rule. However, **these are not the same as the curly brackets in the shell part of the rule, which access variables provided by the rule!**. You will see how to specifically access wildcards in the shell part a bit further below in this session, but for now it is important not to confuse the meaning of curly brackets between input/output and shell parts of your rule.

## Wildcards can propagate through multiple levels of your workflow

We can get a more dynamic version of our workflow above by replacing **rule_2** and **rule_3** with a single rule that looks as follows:

```
rule rule_4:
 	input: "{wc1}_file.txt"
	output: "{wc1}_file_copy.txt"
	shell: "cp {input} {output}"
```

Now we replaced **new** and **other** with **{wc1}** also in the rule that generates the output file. Now if we ask Snakemake to generate either **new_file_copy.txt** or **other_file_copy.txt** we get the same result as before. This is because now the wildcard **{wc1}** is determined based on the output file of **rule_4** we want to create (either **new** for **new_file_copy.txt** or **other** for **other_file_copy.txt**. Based on this Snakemake determines that it also has to replace **{wc1}** in the same way in the input file, which will in turn determine how **{wc1}** has to be replaced in **rule_1** to fulfill the dependency of **rule_4**. This way, **{wc1}** defined by our output file can propagate through an arbitrary number of steps in our workflow. This also means if we have a wildcard in the input and output files of all of your rules, you could generate two completely separate sets of output files, just based on the name of the output file you ask Snakemake to create.

## Use unambiguous filenames!

Consider what happens when we add another rule to our Snakefile, which differs only in the name of the wildcard from **rule_1**, where instead of **{wc1}** we now have **{wc2}**.

```
rule rule_5:
 	output: "{wc2}_file.txt"
	shell: "touch {output}"
```

If we now ask Snakemake to generate **new_file_copy.txt** it will fail with the message

> Rules rule_1 and rule_5 are ambiguous for the file new_file.txt.

This is because it can generate **new_file.txt**, the dependency of **rule_4** by replacing either **{wc1}** (the wildcard in the output of **rule_1**) or **{wc2}** (the wildcard in the output of **rule_5**) with **new**. In this situation Snakemake does not know what rule to use and it will refuse to resolve the graph.

> [!CAUTION]
> There are often situations like this where the naming of your files is important when resolving wildcards. Try to use clear and unambiguous naming for the files in your workflow to avoid this.

## Multiple wildcards   

Files can contain more than one wildcard or the same wildcard multiple times. Consider the following example:

```
rule rule_1:
	output: "{wc1}_{wc2}_file.txt"
	shell: "touch {output}"

rule rule_2:
 	input: "{wc1}_new_file.txt"
	output: "{wc1}_file_copy.txt"
	shell: "cp {input} {output}"
```

In the output of **rule_1** **{wc2}** will be replaced with **new** based on the input of **rule_2**, while **{wc1}** will propagate through **rule_1** and will be determined based on our desired output file.


## Using wildcards directly in your shell commands

In the previous parts the wildcards were only used indirectly in your shell commands, by accessing the **{input}** and **{output}** variables, parts of which contained the values of wildcards. However, you can also directly assess wildcards in your shell command. This can be very useful, because you can set parameters for your programs based on the names of your output files, because wildcards can also be numbers. Imagine the following scenario:

```
rule tail:
    input: "{filename}.txt"
 	output: "last_{n_tail}_lines_of_{filename}.txt"
	shell: "tail -n {wildcards.n_tail} {output}"
```

This rule would implement the tail command, which returns **-n** lines at the end of a file. In this case we could generate the output of any file that ends with **.txt** based on the output file name, so for example for a file called **longfile.txt** we could get the last 100 lines as follows

```
snakemake -j1 last_100_lines_of_longfile.txt
```

> [!CAUTION]
> Be aware that wildcards are accessed differently in the input an output part of your rule, where they are surrounded by curly brackets and inside the shell part, where they are also surrounded by curly brackets, but they have to be preceded by **wildcards.**, in the same way as you would access named output or input files. Forgetting to put the **wildcards.** part in fromt of the names of wildcards is also one the mistakes I make all the time. 

## Using directories

When you create multiple sets of output files it can often make sense to put them in separate folders. So for example if we want to put the output files of **rule_1** and **rule_4** into  a separate folder we can do it like this:

```
rule rule_1:
	output: "out_{wc1}/{wc1}_file.txt"
	shell: "touch {output}"

rule rule_4:
 	input: "out_{wc1}/{wc1}_file.txt"
	output: "out_{wc1}/{wc1}_file_copy.txt"
	shell: "cp {input} {output}"
```

For our Snakemake command we now have to provide the complete path of our output file, with your wildcards replaced appropriately.

```
snakemake -j1 out_new/new_file_copy.txt
```

Conveniently, **Snakemake creates folders for your output files for you if they don't exist**. 

## Your turn: modify your workflow to set migration rates using wildcards

This time we will not write a new workflow from scratch, but you will modify the one you build in the previous session by varying the migration rate of our slimulation using wildcards. 
In the [slim script you used in the previous session](scripts/04_branches_and_variables/04_slimulation.slim) the migration rate from population P2 into P3 is set internally to 0.001 based on a variable called **P2_TO_P3**. This means that every generation 0.1% of the parents of individuals in population P3 will be chosen from population P2. However, it also contains a variable called **P3_TO_P2**, which defines geneflow in the other direction and which is set to 0 by default. Finally, there is a third variable called **OUTFILE**, which defines the name of the output VCF file, which is **04_slim_output.vcf** by default.

In SLiM you can set numeric variables, like **P2_TO_P3** and **P3_TO_P2** using the **-d** command line argument. So for example if you want to change **P2_TO_P3** to 0.002 you could use

```
slim -d P2_TO_P3=0.002 04_slimulation.slim
```

And if you want to change multiple variables at the same time you can supply the **-d** argument multiple times, so if you want to set both **P2_TO_P3** and **P3_TO_P2** to 0.002 you could do it like this

```
slim -d P2_TO_P3=0.002 -d P3_TO_P2=0.002 04_slimulation.slim
```

You can also use the -d argument to change string variables like **OUTFILE**, but here things are a bit more complicated. Because of the way how SLiM uses quotes to define strings internally the command we would have to type in the command line to change the name of the output file to **05_slim_output.vcf** would be

```
slim -d "OUTFILE='05_slim_output.vcf'" 04_slimulation.slim
```
Note the regular quotes around the variable definition and the single quote around the value of the string variable. However, if we want to use this command in the shell part of one of our Snakemake rules we run into a problem: because we supply the shell command in the form of a python string, which is also delimited by quotes, Snakemake will think the string will end with the first quote at the beginning of the variable definition and the remainder of the line will not make sense for it, resulting in some error message. 

> [!IMPORTANT]
> The solution for this dilemma is if we want quotes to be interpreted literally inside a string and not as a string delimiter we have to **escape them using a backslash (\\)** like this:

```
shell: "slim -d \"OUTFILE='05_slim_output.vcf'\" 04_slimulation.slim"
```

With the ability to change the the migration rates and the name of the output files modify your workflow so that you can set both migration rates using the name of your ouput files (so your PCA plot and your structure bar blot) and automatically put all output files for different combinations of mutation rates in separate folders. Then make sure this works by running the workflow for a few combinations of migration rates and see how your plots change.
