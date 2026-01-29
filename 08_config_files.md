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

In the examples above **variable_1** defines an integer, **variable_2** defines a floating point variable (a number with values after the comma), **variable_3** defines a string variable and variable_4 defines a python array consisting of 5 string variables. 

## Using config files in you workflow

Within your Snakefile outside the shell part of your rules the variables defined in your config file are available as **python dictionaries**.





## Setting default config files



## Reports

## Your turn: modify your workflow to use a config file and to put its plots into a report
