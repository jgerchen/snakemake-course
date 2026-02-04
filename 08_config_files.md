# 8. Config files

As your workflows get larger and more complex and if you want to apply them to multiple datasets it is often helpful to set parameters not by using wildcards or by editing your workflow, but by setting up easily understandable config files. Snakemake has support for setting up your own config files, which you can use to define any types of values and variables.

## The yaml format

Snakemake config files are written in the easily readable [yaml format](https://yaml.org/). You already know some basic elements of the yaml format from writing the environment definitions for conda, but it can do more than that. In general you define a variable in your yaml file by a colon, a space and the value as follows:

```
variable_1: 1
variable_2: 0.02
variable_3: "Var three"
variable_4: ["This", "is", "a", "python", "array"]
```

In the examples above **variable_1** defines an integer, **variable_2** defines a floating point variable (a number with values after the comma), **variable_3** defines a string variable and **variable_4** defines a python array consisting of 5 string variables. 

You can tell snakemake to use your file using the **--configfile** parameter of the snakemake command as follows

```
snakemake -j1 --configfile your_config.yaml output_file.txt
```

## Using config files in your workflow

Within your Snakefile outside the shell part of your rules the variables defined in your config file are available as **python dictionaries**.

>### :snake: Python dictionaries
> Like arrays, dictionaries are python objects that contain a collection of data objects. Unlike arrays, the data objects in a dictionary have two parts: a **key** and a **value**. The values inside a dictionary are accessed using their keys. Python dictionaries are defined using curly brackets (yes, yet another use of curly brackets!) and key and value are separated by colons and individual key-value pairs are separated by commas as in the following examples
>
> dictionary_1={"key_1":"value_1", "key_2":"value_2", "key_3":"value_3"}
>
> dictionary_2={"key_1":1, "key_2":2, "key_3":3}
>
> dictionary_3={1:"value_1", 2:"value_2", 3:"value_3"}
>
> dictionary_4={1:1, 2:2, 3:3}
>
> Based on the examples above you can see that both keys and values can be numbers or strings (written in quotes) and also other python data types we will not get into here. We access the value of a dictionary using square brackets like in the following examples, so for example using **dictionary_1["key_2"]** will return **"value_2"** and using **dictionary_4[2]** will return **2**.

In the input and output part and other parts outside the shell part of your rules you can also access dictionaries by their values and if you supply snakemake with a config file it will generate a dictionary called **config** in which you can access the variables defined in your yaml file using square brackets, as described above. So for the example yaml file above **config["variable_1"]** will be replaced with **1** and **config["variable_4"]** will access the python array.

>[!IMPORTANT]
> Dictionaries are accessed differently than wildcards. While wildcards are accessed directly inside a string variable using curly brackets, we can't do the same with python objects like dictionaries. In the following part are some examples how we can access config files using dictionaries in snakemake and how we could implement them in different parts of our rule definition:

```
rule structure:
	conda:	config["conda_structure"]
    log: config["log_folder"]+"/structure_{P23}_{P32}_{rep}"
    resources:
        mem_mb=config["mem_structure"],
        disk_mb=config["disk_mb_structure"],
        runtime=config["runtime_structure"]
```

In the example above we added the option to set the conda environment used by the rule based on the config file, we set the option to define the location of the folder containing the log files and we could set all three resources. For the log file note that we didn't replace the complete filename, because the log file name still needs to contain the wildcards. Rather, we concatenated the output of the **log_folder** variable from the config file with the text string containing the wildcards.

>### :snake: Python concatenating string variables
> Conveniently, python allows you to directly concatenate multiple string variables using the **+** sign. However, all variables involved have to be of string type (with quotes around them), numeric variables have to be turned into strings before concatenating them with strings using the **str()** function. So if we wanted to access **variable_2** from the example yaml file above and turn it into a string we'd have to use **str(config["variable_2"])** instead.

## Accessing config files in the shell part of your rules

Now lets look at the shell part of our slim rule again, but this time let's assume that the migration rates **P23** and **P32** are not defined by a wildcard, but by values defined in our config file called **migration_P23** and **migration_P32**.

```
	shell: "slim -d P2_TO_P3={config[migration_P23]} -d P3_TO_P2={config[migration_P32]} -d \"OUTFILE='{output}'\" 04_slimulation.slim"
```

>[!CAUTION]
>Note that in the shell part our config file is also accessed with **curly brackets** and the names of the specific variables are accessed with **square** brackets. However, note that unlike in the other part of our rule here the variable names **must not have quotes around them!**

## Setting default config files

It iften makes sense to have a set of default values, which can be overwritten by the user if he wants to. This can be easily implemented in Snakemake using config files. You can tell Snakemake to load a config file in your workflow using

```
configfile: "config/default_config.yaml"
```

This will load the preexisting yaml file called **default_config.yaml** located in the config folder. Note that this command should be **outside your rule definition** and have no indentation and it would typically be put on the top of your Snakefile, before you define any rules. If you want to make it easier for other users (and for yourself after some time) to understand the default options you should **add comments to your yaml file explaining the individual parameters** using the hashtag as in the following example

```
#Migration rate from population P2 into population P3, defined as proportion of P3 offspring sired by P2 parents
migration_P23: 0.002
#Migration rate from population P3 into population P2, defined as proportion of P2 offspring sired by P3 parents
migration_P23: 0.002
```

Now the user can see what each of the options mean and if he wants to change them he can do this without changing the workflow or the default config file, by picking out the values he wants to change and writing including them in a new yaml file and supplying it using **--configfile** the config parameter to the snakemake command. This way the variables in the new yaml file will superseed the values in the default config file.

## Your turn: modify your workflow to use a config file and to put its plots into a report

Now we want your workflow more adaptable. Change your rules so that you can set **the number of replicate Snakemake runs** and the **resource requirements for each rule** using a config file. Also set sensible default values using a default config file.

