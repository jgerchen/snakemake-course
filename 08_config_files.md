# 8. Config files and reports

As your workflows get larger and more complex and if you want to apply them to multiple datasets it is often helpful to set parameters not by using wildcards or by editing your workflow, but by setting up easily understandable config files. Snakemake has support for setting up your own config files, which you can use to define any types of values and variables.

## The yaml format

Snakemake config files are written in the easily readable [yaml format](https://yaml.org/). You already know some basic elements of the yaml format from writing the envrionment definitions for conda, but it can do more than that. In general you define a variable in your yaml file by a colon, a space and the value as follows:

```
variable_1: 1
variable_2: 0.02
variable_3: "Var three"
variable_4: ["This", "is", "a", "python", "array"]
```

In the examples above **variable_1** defines an integer, **variable_2** defines a floating point variable (a number with values after the comma), **variable_3** defines a string variable and **variable_4** defines a python array consisting of 5 string variables. 

## Using config files in you workflow

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
> Based on the examples above you can see that both keys and values can be numbers or strings (written in parentheses) and also other python data types we will not get into here. We access the value of a dictionary using square brackets like in the following examples, so for example using **dictionary_1["key_2"]** will return **"value_2"** and using **dictionary_4[2]** will return **2**.

In the input and output part and other parts outside the shell part of your rules you can also access dictionaries by their values and if you supply snakemake with a config file it will generate a dictionary called **config** in which you can access the variables defined in your yaml file using square brackets, as described above. So for the example yaml file above **config["variable_1"]** will be replaced with **1** and **config["variable_4"]** will access the python array.

>[!IMPORTANT]
> Dictionaries are accessed differently than wildcards. While wildcards are accessed directly inside a string variable using curly brackets, we can't do the same with python objects like dictionaries. In the following part are some examples how we can access config files using dictionaries in snakemake:






## Setting default config files



## Reports

## Your turn: modify your workflow to use a config file and to put its plots into a report

Now we want your workflow more adaptable. Change your rules so that you can set **the number of replicate Snakemake runs** and the resource requirements using a config file. Also set sensible default values using a default config file.

