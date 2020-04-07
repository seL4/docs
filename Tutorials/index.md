---
toc: true
redirect_from:
  - /projects/sel4-tutorials
layout: project
project: sel4-tutorials
---

# Tutorials

{% assign tutorials = site.pages | where_exp: 'page', 'page.tutorial' | sort: 'tutorial-order' %}

We have developed a series of tutorials to introduce seL4 and
developing systems on seL4.

## How to use the tutorials

Depending on your goals and what you want to do with seL4, we suggest
different paths to follow through the tutorial material.  Choose the
most relevant category below and follow the tutorials in the suggested
order.

Note that all of these these tutorials require C programming
experience and some understanding of operating systems and computer
architecture.  Suggested resources for these include:

- C programming language
	- [C tutorial](https://www.cprogramming.com/tutorial/c-tutorial.html)
- Operating Systems:
	- [Modern Operating Systems (book)](https://www.amazon.com/Modern-Operating-Systems-Andrew-Tanenbaum/dp/013359162X)
	- [COMP3231 at UNSW](http://www.cse.unsw.edu.au/~cs3231)
- Computer Architecture
	- [Computer Architecture (wikipedia)](https://en.wikipedia.org/wiki/Computer_architecture)
	- [Instruction Set Architecture (wikipedia)](https://en.wikipedia.org/wiki/Instruction_set_architecture)

### Evaluation

Goal:

- You want to understand what seL4 is and what benefits it gives.
- You want to understand how seL4 can be used to develop trustworthy systems.
- You want to get your hands a little dirty and see, compile, and run some code.

Follow these tutorials:

1. [seL4 overview](https://sel4.systems/About/seL4-whitepaper.pdf)
2. [Introduction tutorial](#introduction-tutorial)

### System Building

Goal:

- You want to build systems based on seL4.
- You want to know what tools are available to do so and how to use those tools.
- You want experience with how to use seL4 and the tools to build trustworthy systems.

Follow these tutorials:

1. [seL4 overview](https://sel4.systems/About/seL4-whitepaper.pdf)
2. [Introduction tutorial](#introduction-tutorial)
3. [CAmkES tutorials](#camkes-tutorials)
4. [Virtualisation tutorials](#virtual-machines)
5. [MCS tutorial](#mcs-extensions)

### Platform Development

Goal:

- You want to contribute to development of the seL4 (user-level) platform.
- You want to develop operating system services and device drivers.
- You want to develop seL4-based frameworks and operating systems.

Follow these tutorials:

1. [seL4 overview](https://sel4.systems/About/seL4-whitepaper.pdf)
2. [Introduction tutorial](#introduction-tutorial)
3. [seL4 mechanisms tutorial](#seL4-mechanisms-tutorials)
4. [Rapid prototyping tutorials](#rapid-prototyping-tutorials)
5. [CAmkES tutorials](#camkes-tutorials)
6. [Virtualisation tutorial](#virtual-machines)
7. [MCS tutorial](#mcs-extensions)
<!-- 8. Device driver tutorial [TBD?] -->

### Kernel Development

Goal:

- You want to contribute to the seL4 kernel itself.
- You want to port seL4 to a new platform.
- You want to add new features to the kernel.

Read this first:

- [Contributing to kernel code](/projects/sel4/kernel-contribution.html)

Then follow these tutorials:

1. [seL4 overview](https://sel4.systems/About/seL4-whitepaper.pdf)
2. [Introduction tutorial](#introduction-tutorial)
3. [seL4 mechanisms tutorial](#seL4-mechanisms-tutorials)
4. [MCS tutorial](#mcs-extensions)

# The Tutorials

## Prerequisites

*  [set up your machine](/GettingStarted#setting-up-your-machine).

### Python Dependencies
Additional python dependencies are required to build tutorials. To install you can run:
```
pip install --user aenum
pip install --user pyelftools
```

### Get the code
```
mkdir sel4-tutorials-manifest
cd sel4-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest
repo sync
```

### Doing the tutorials

The top of the source tree contains the kernel itself, and the tutorials are found in the subfolder: "`projects/sel4-tutorials`". The tutorial consists of some pre-written sample applications which have been deliberately half-written. You will be guided through filling in the missing portions, and thereby become acquainted with seL4. For each of the sample applications however, there is a completed solution that shows all the correct answers, as a reference.
When completing the tutorials you will be initialising and building your solutions with CMake. The general flow of completing a tutorial exercise involves:
```
# creating a Tutorial directory
mkdir tutorial
cd tutorial
# initialising the build directory with a tutorial exercise
../init --plat <platform> --tut <tutorial exercise>
# building the tutorial exercise
ninja
```

After initialising your directory you will be setup with half-written source for you to complete. Additinally, a build
directory will be created based on your directory name eg `tutorial_build`.

Your job is to follow the tutorial instructions to complete the application in the tutorial folder.

- The completed sample applications showing the solutions to the
        tutorial challenges can be retrieved by initialsing a directory with the `--solution` argument
        e.g. `../init --plat <platform> --tut <tutorial exercise> --solution`

## List of tutorials

### Introduction tutorial

Before starting tutorials, make sure that you have read through the
[Prerequisites](#prerequisites) and in particular [Doing the
tutorials](#doing-the-tutorials).

Then, before any other tutorial, do the hello-world tutorial:

{%- for t in tutorials %}
{%- if t.tutorial-order contains '0-hello' %}
1. [{{t.title}}]({{t.url}}) {{t.description}}
{%- endif %}
{%- endfor %}

which will ensure your setup is working correctly.

### seL4 mechanisms tutorials

This set of tutorials are for people keen to learn about the base mechanisms provided
by the seL4 kernel. You will learn about the kernel API through small exercises
that show basic examples.

{% assign tutorials = site.pages | where_exp: 'page', 'page.tutorial' | sort: 'tutorial-order' %}
{%- for t in tutorials %}
{%- if t.tutorial-order contains 'mechanisms' %}
1. [{{t.title}}]({{t.url}}) {{t.description}}
{%- endif %}
{%- endfor %}

### Rapid prototyping tutorials

This set of tutorials provides walkthroughs and exercises for using the dynamic
libraries provided in [seL4_libs](TODO LINK). These libraries are provided as is,
and have been developed for rapidly prototyping systems on seL4. They have not been
through intensive quality assurance and do have bugs. Contributions are welcome.

{%- for t in tutorials %}
{%- if t.tutorial-order contains 'dynamic' %}
1. [{{t.title}}]({{t.url}}) {{t.description}}
{%- endif %}
{%- endfor %}

* The slide presentations to guide you through the tutorials are in the following files:

  - `projects/sel4-tutorials/docs/seL4-Overview.pdf`: This
            is an overview of the design and thoughts behind seL4, and
            we strongly recommend you read it before starting
            the tutorials.
  - `projects/sel4-tutorials/docs/seL4-APILib-details.pdf`: This is the actual tutorial.

### CAmkES tutorials

These tutorials get you started with our component system CAmkES, which
is allows you to configure static systems through components. CAmkES
generates the glue code for interacting with seL4 and is designed for building
high-assurance, static systems.

These tutorials work similarly to the SEL4 tutorials in that they are
guided by a slide presentation. There are half-completed sample
applications, with a set of slides giving instructions, with TASK
challenges once again. There are also completed sample solutions.

{%- for t in tutorials %}
{%- if t.tutorial-order contains 'camkes' %}
1. [{{t.title}}]({{t.url}}) {{t.description}}
{%- endif %}
{%- endfor %}

- The slide presentations to guide you through the tutorials are
        in this
        file: `projects/sel4-tutorials/docs/CAmkESTutorial.pdf`.

### Virtual machines

These tutorials show how to run Linux guests on Camkes and how to communicate between them.
Currently these tutorials are for x86 only.

{%- for t in tutorials %}
{%- if t.tutorial-order contains 'vm' %}
1. [{{t.title}}]({{t.url}}) {{t.description}}
{%- endif %}
{%- endfor %}

### MCS extensions

The MCS extensions are upcoming API changes to seL4.

{%- for t in tutorials %}
{%- if t.tutorial-order contains 'mcs' %}
1. [{{t.title}}]({{t.url}}) {{t.description}}
{%- endif %}
{%- endfor %}

## What next?

You can try building and running [seL4test](../seL4Test).

Next steps include working on one of our [suggested
projects](/SuggestedProjects.html) or helping to expand the collection
of [libraries and
components](/projects/available-user-components.html) available to
build seL4-based systems.
