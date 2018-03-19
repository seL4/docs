---
toc: true
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

## Setting up your machine


- Before you can use any of the SEL4 related repositories, you must
  [get the "repo" tool by Google](http://source.android.com/source/downloading.html#installing-repo). SEL4 projects have multiple
  subproject dependencies, and repo will fetch all of them and
  place them in the correct subdirectories for you.
- Make sure that you already have the tools to build seL4
  ([seL4: Setting up your machine](/Getting_started#setting-up-your-machine))

## Build dependencies
  

* Getting dependencies differs across systems. Here's how to install dependencies for several systems:

  * Ubuntu 16.04
  
    ```bash
    apt-get install git repo libncurses-dev python-pip libxml2-utils cmake ninja-build clang \
    libssl-dev libsqlite3-dev libcunit1-dev gcc-multilib expect
    qemu-system-x86 qemu-system-arm gcc-arm-none-eabi binutils-arm-none-eabi
    ```

  * Ubuntu 14.04
  
    ```bash
    apt-get install git phablet-tools libncurses-dev python-dev python-pip libxml2-utils \
    cmake ninja-build clang libssl-dev libsqlite3-dev libcunit1-dev gcc-multilib expect \
    qemu-system-x86 qemu-system-arm gcc-arm-none-eabi binutils-arm-none-eabi \
    gcc-5 gcc-5-multilib

    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60
    ```
  * Archlinux

    ```bash
    pacman -S binutils gcc-multilib arm-none-eabi-binutils arm-none-eabi-gcc ccache clang \
    moreutils cpio python python-pip expect cmake ninja m4 automake autoconf pkg-config \
    valgrind cppcheck python-pylint qemu qemu-arch-extra openssl bcunit

    yaourt -S bcunit-cunit-compat spin
    ```
* Regardless of you system, you
will need to install haskell, and some python dependencies
  * Install [ haskell stack](<https://haskellstack.org> ) (haskell version and package manager)
      
    ```
    curl -sSL https://get.haskellstack.org/ | sh
    ```

  * Install python dependencies (via pip):
      
    ```
    pip install --user camkes-deps
    ```

## Download CAmkES


Download CAmkES source code from github:
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
make arm_simple_defconfig
make silentoldconfig
```

If you haven't done so already, change the toolchain to the one for your
system. You can do this by running `make menuconfig`, then going to
**Toolchain Options -> Cross compiler prefix**. You will most
likely be compiling with **arm-linux-gnueabi-**.
```
make
qemu-system-arm -M kzm -nographic -kernel images/capdl-loader-experimental-image-arm-imx31
```

In order to clean up after building (for example because you’ve set up a
new configuration and you want to make sure that everything gets rebuilt
correctly) do:

```
make clean
```

## Read Tutorial


To learn about developing your own CAmkES application, read the
[Tutorials#CAmkES_tutorials](/Tutorials#camkes-tutorials).

## Camkes Terminology/Glossary


Can be found [here](Terminology.md).

## CAmkES VM


Information about the x86 camkes vm can be found [here](/CAmkESVM).

## Visual CAmkES


CAmkES comes with a tool for visualising the components and connections
making up an application. For more info, see [here](/VisualCAmkES).

## Changes in CAmkES 3


The current version of CAmkES introduces a number of syntactic and
functional changes. For details about what's changed, see
[here](/CAmkESDifferences).

## Internals


Here's some information about the internals of the CAmkES tool:
[CAmkESInternals](/CAmkESInternals)

## Command Line Interface


There is an experimental command line interface for managing CAmkES
projects. Read more: [CAmkESCLI](/CAmkESCLI)

## Python Dependencies


The **Build Dependencies** section covers how to install the python
dependencies. The python metapackage,
[camkes-deps](https://pypi.python.org/pypi/camkes-deps), is
implemented in the CAmkES repo
[here](https://github.com/seL4/camkes-tool/blob/master/tools/python-deps/setup.py).
