---
redirect_from:
  - /CAmkES/
project: camkes
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# CAmkES

CAmkES stands for component architecture for microkernel-based embedded systems.
It is a software development and runtime framework for quickly and reliably
building microkernel-based multi-server (operating) systems. It follows a
component-based software engineering approach, resulting in a system that is
modelled as a set of interacting software components. These software components
have explicit interaction interfaces and a system design that explicitly details
the connections between the components.

The development framework provides:

- a language to describe component interfaces, components, and whole
  component-based systems
- a tool that processes these descriptions to combine programmer-provided
  component code with generated scaffolding and glue code to build a complete,
  bootable, system image
- full integration in the seL4 environment and build system

## Overview

To get started with CAmkES we recommend following the [CAmkES
tutorial](../../Tutorials/hello-camkes-0.html)

The following additional resources are available:

- [Terminology and Glossary](manual.md#terminology)
- [CAmkES Manual](manual.md)
- List of [CAmkES features](features.md)
- List of pre-build [CAmkES components](components.md)
- [Virtual Machines](../virtualization/index.md) as CAmkES components
- [Visual CAmkES](visual-camkes/),  a tool for visualising the components and
  connections making up an application
- [Command Line Interface](cli.md) of the CAmkES tool
- [Implementation](internals.md)

## Get CAmkES

- Make sure that you already have the tools to [build seL4 and
  CAmkES](/projects/buildsystem/host-dependencies.html).
- Download CAmkES:

```sh
mkdir camkes-project
cd camkes-project
repo init -u https://github.com/seL4/camkes-manifest.git
repo sync
```

## Build and run simple application

The following will configure, build, and run a simple example CAmkES
system:

```sh
cd camkes-project
mkdir build
cd build
../init-build.sh -DPLATFORM=sabre -DAARCH32=1 -DCAMKES_APP=adder -DSIMULATION=1
ninja
./simulate
```