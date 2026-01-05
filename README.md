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

## How will this course be structured?

This is a practical course with the aim to give you the tools at hand to write your own bioinformatics workflows in Snakemake. We will start off with a bit of background to better understand what snakemake is, where it came from and what it's good for and then we will go directly into building your own workflow, step by step. 
In general I will introduce the elements that make up a Snakemake workflow in small steps, at each of which you will implement it on your own laptop in a minimal and abstract way. Then, at the end of each chapter, I will ask you to apply what you learned yourself in a more practical way. I thought it would be nice to have something more tangible for these parts, so you will implement running simulations using the individual-based simulation software [SlIM](https://messerlab.org/slim/) and do some nice looking popgen things with its output. 
However, this course is really not about how these simulations or the follow up programs work, but more generally how we can combine different types of software packages in a single Snakemake workflow. So you will not have to understand how this software works but rather be putting together scripts and commands that I will give you. But of course I'm happy to explain more details about this software as well if you have any questions.
I also don't know how long individual parts will take beforehand, so I will structure this course in a way that we should be able to get through the most important parts and add more optional parts at the end. So if we don't end up getting through everything together parts together you should still be able to build your own workflows with the stuff that we managed to do in person. Also this repository will remain publicly available here after the course, so you can go through things that we didn't manage to finish by yourself if it's relevant for you.

