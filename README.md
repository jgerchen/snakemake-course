# snakemake-course

## What is this course about?

This course aims to teach you how to build your own bioinformatics workflow using [Snakemake](https://snakemake.readthedocs.io/en/stable/) and will show you how to run them on a distrubuted computing cluster like [MetaCentrum](https://metavo.metacentrum.cz/en/about/index.html).

## When and where does it take place?

The course will take place from 2.2.2026 until 4.2.2026 (Mo-We) in Seminarium (Benatska 2, room BB) at the Department of Botany at Charles University.

## Who can join?

This course is intended for students of the Department of Botany at Charles University, who enrolled in the wildcard module (MB120P12 - Current approaches in plant ecology and evolution). However, we still have lots of space for other participants, so no matter if you're at a different department or if you're not a student, if you're interested in joining please send me a mail at gerchenj@natur.cuni.cz.

## What knowledge is expected for joining the course?

You should have basic knowledge of how to operate a UNIX environment (navigate the file system and run commands on the command line, create and edit scripts and text files) and have some idea of how a computing cluster like MetaCentrum works and how you can submit basic computing jobs to it. Snakemake code is written in the [Python programming language](https://www.python.org/), but I aim to explain any python code used in this course in detail, so you are not expected to know any python before. 

## What do I need to have/do before?

You need:

- Your own laptop with access to the eduroam Wifi (if you don't have reliable Wifi access let me know **before** and we'll figure out a solution).

- Access to the [MetaCentum distributed computing architecture](https://metavo.metacentrum.cz/en/about/index.html). Please ensure that you have access **before** the course, information on how to get an account can be found [here](https://metavo.metacentrum.cz/en/application/index.html).

- You need to download and install [miniforge](https://github.com/conda-forge/miniforge) to your own laptop. Miniforge is a minimal version of [conda](https://docs.conda.io/en/latest/), a software package and environment management system, which we will use to install all software used in this course. There are [installers](https://conda-forge.org/download/) available for Linux, Mac and Windows. Please download the installer appropriate for your system and install it according to the [instructions](https://conda-forge.org/download/). At the end of the installation it will ask you if it should activate conda by default when you log in, you can say no to that. Please try to get this running **before** the course starts and if you have any problems let me know so that we can have a look at it together.

- A proper text editor for writing code. There is a large number of [choices](https://maxwellj.vivaldi.net/2025/04/03/code-editors-my-top-7-picks/) with a wide range of features and I leave it up to select the one that suits you best. I know that [VSCode](https://marketplace.visualstudio.com/items?itemName=Snakemake.snakemake-lang), [Vim](https://github.com/snakemake/snakemake/tree/main/misc/vim) and [Nano](https://github.com/snakemake/snakemake/tree/main/misc/nano) support syntax highlighting (colouring different parts of your code according to function) specifically for Snakemake files, which I find very useful, but there may be some way to get this functionality also for other text editors too. Please make sure that you decided on a text editor that you feel comfortable using **before** the course, since we will not have time to get into these details during the course.


