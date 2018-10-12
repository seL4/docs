---
toc: true
---

{% assign tutorials = site.pages | where_exp: 'page', 'page.tutorial' | sort: 'tutorial-order' %}

# Tutorials

This page collates all available tutorials on seL4 material.

## Prerequisites

*  [set up your machine](/GettingStarted#setting-up-your-machine).

### Get the code
```
mkdir sel4-tutorials-manifest
cd sel4-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest -b refs/tags/{{site.sel4_master}}
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

### Tutorial tutorial

Before any other tutorial, do the hello-world tutorial:

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

You can try building and running [seL4test](../seL4Test)
