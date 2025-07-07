---
redirect_from:
  - /CAmkES/
project: camkes
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# CAmkES

 CAmkES (component architecture for microkernel-based embedded
systems) is a software development and runtime framework for quickly and
reliably building microkernel-based multiserver (operating) systems. It
follows a component-based software engineering approach to software
design, resulting in a system that is modelled as a set of interacting
software components. These software components have explicit interaction
interfaces and a system design that explicitly details the connections
between the components.

The development framework provides:

- a language to describe component interfaces, components, and whole
      component-based systems
- a tool that processes these descriptions to combine
      programmer-provided component code with generated scaffolding and
      glue code to build a complete, bootable, system image
- full integration in the seL4 environment and build system

## Get CAmkES

- Make sure that you already have the tools to [build seL4 and CAmkES](/Resources#setting-up-your-machine).
- Download CAmkES:

```
mkdir camkes-project
cd camkes-project
repo init -u https://github.com/seL4/camkes-manifest.git
repo sync
```

## Build and run simple application

The following will configure, build, and run a simple example CAmkES
system:

```
cd camkes-project
mkdir build
cd build
../init-build.sh -DPLATFORM=sabre -DAARCH32=1 -DCAMKES_APP=adder -DSIMULATION=1
ninja
./simulate
```

## Read Tutorial


To learn about developing your own CAmkES application, read the
[Tutorials#CAmkES_tutorials](/tutorials#camkes-tutorials).

## CAmkES Terminology/Glossary


Can be found [here](terminology).


## CAmkES Features

Information about CAmkES features can be found [here](features.html).


## CAmkES Components

Information about CAmkES components can be found [here](components.html).


## CAmkES VM


Information about the x86 camkes vm can be found [here](/VM/CAmkESX86VM).

## Visual CAmkES


CAmkES comes with a tool for visualising the components and connections
making up an application. For more info, see [here](visual-camkes).

## Changes in CAmkES 3


The current version of CAmkES introduces a number of syntactic and
functional changes. For details about what's changed, see
[here](differences).

## Internals


Here's some information about the internals of the CAmkES tool:
[CAmkESInternals](internals)

## Command Line Interface


There is an experimental command line interface for managing CAmkES
projects. Read more: [CAmkESCLI](cli)

