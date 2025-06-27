{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}

## Get Google's Repo tool

The primary way of obtaining and managing seL4 project sources is through
Google's `repo` tool. To start with, get repo by following the
instructions in the section “Install” on the [repo
site](https://gerrit.googlesource.com/git-repo#install).

See the [repo cheatsheet](repo-cheatsheet.html) page for a quick explanation of
how we use repo.

## Docker or native

To compile and use seL4 you can either:

* *Recommended:* follow the [instructions here](/projects/dockerfiles/) to use
  Docker for isolating the dependencies from your machine, or
* install the build dependencies below on your local OS

The following instructions describe how to set up the required dependencies on
your local OS. This page assumes you are building in a Linux OS. We however
encourage site
[contributions](https://docs.sel4.systems/processes/docs-contributing.html) for
build instructions in other OSes (e.g. macOS).

## Ubuntu

These instructions are intended for Ubuntu LTS versions 20.04 and 22.04.

{% include note.html %}
If you discover any missing dependencies and packages we welcome new
[contributions](https://docs.sel4.systems/processes/docs-contributing.html) to
the page.
{% include endnote.html %}

### Base dependencies

The basic build package on Ubuntu is the `build-essential` package. To install run:

```sh
sudo apt-get update
sudo apt-get install build-essential
```

Additional base dependencies for building seL4 projects on Ubuntu include installing:

```sh
sudo apt-get install cmake ccache ninja-build cmake-curses-gui
sudo apt-get install libxml2-utils ncurses-dev
sudo apt-get install curl git doxygen device-tree-compiler
sudo apt-get install u-boot-tools
sudo apt-get install python3-dev python3-pip python-is-python3
sudo apt-get install protobuf-compiler python3-protobuf
```

### Simulating with QEMU

In order to run seL4 projects on a simulator you will need QEMU:

```sh
sudo apt-get install qemu-system-arm qemu-system-x86 qemu-system-misc
```

### Cross-compiling for ARM targets

To build for ARM targets you will need a cross compiler:

```sh
sudo apt-get install gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
sudo apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
```

(you can install the hardware floating point versions as well if you wish)

```sh
sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
```

### Cross-compiling for RISC-V targets

To build for RISC-V targets you will need a cross compiler:

{% include risc-v.md %}

### Building the seL4 manual

If you would like to build the seL4 manual, you will need the following LaTeX pacakges:

```sh
sudo apt-get install texlive texlive-latex-extra texlive-fonts-extra
```

## Debian

The dependencies listed in our Docker files
[repository](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles) will work for
a Debian Bullseye, most likely also for later releases. You can refer to this repository
for an up-to-date list of base build dependencies. Specifically refer to the
dependencies listed in the file here:

* [Base Tools](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles/blob/master/scripts/base_tools.sh)
* [seL4](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles/blob/master/scripts/sel4.sh)
* [LaTeX](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles/blob/master/scripts/apply-tex.sh)

## Python

A number of Python packages are required to build seL4 and its manual. To install these you can run:

```sh
pip3 install --user setuptools sel4-deps
```

(Some distributions use `pip` for python3, others use `pip3`.  Use the Python 3 version for your distribution)

{% include pip-instructions.md deps="sel4-deps" %}
