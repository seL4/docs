---
order_priority: 1
project: sel4
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

## seL4 Build Dependencies

To build seL4-based projects, ensure you have installed the dependencies described in the [Base Build Dependencies](#base-build-dependencies) and [Python Dependencies](#python-dependencies) sections below.

### Base Build Dependencies

To establish a usable development environment it is important to install your distributions basic build packages.

#### Ubuntu

> *The following instructions cover the build dependencies tested on [Ubuntu 18.04](http://releases.ubuntu.com/18.04/) LTS. Note that earlier versions of Ubuntu (e.g. 16.04) may not be sufficient for building as some default development packages are
stuck at older versions (e.g CMake 3.5.1, GCC 5.4 for 16.04).
As dependencies and packages may be frequently changed, deprecated or updated these instructions may become out of date. If you discover any missing dependencies and packages we welcome new [contributions](https://docs.sel4.systems/DocsContributing) to the page.*

> *Note that we require a minimum CMake version of 3.12.0 while Ubuntu 18.04 contains 3.10.2.  In order to correct this, a custom installation of CMake may be required which can be downloaded from: https://cmake.org/download/*

The basic build package on Ubuntu is the `build-essential` package. To install run:

```sh
sudo apt-get update
sudo apt-get install build-essential
```

Additional base dependencies for building seL4 projects on Ubuntu include installing:

```sh
sudo apt-get install cmake ccache ninja-build cmake-curses-gui
sudo apt-get install python-dev python-pip python3-dev python3-pip
sudo apt-get install libxml2-utils ncurses-dev
sudo apt-get install curl git doxygen device-tree-compiler
sudo apt-get install u-boot-tools
sudo apt-get install protobuf-compiler python-protobuf
sudo apt-get install gcc-8 g++8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
```

To build for ARM targets you will need a cross compiler. In addition, to run seL4 projects on a simulator you will need `qemu`. Installation of these additional base dependencies include running:


```sh
sudo apt-get install gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
sudo apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
sudo apt-get install qemu-system-arm qemu-system-x86 qemu-system-misc
```

(you can install  the hardware floating point versions as well if you wish"

```sh
sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
```

#### Debian

##### For Debian Stretch or later

The dependencies listed in our docker files [repository](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles) will work for a Debian installation. You can refer to this repository for an up-to-date list of base build dependencies. Specifically refer to the dependencies listed in the:

* [Base Tools Dockerfile](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles/blob/master/base_tools.dockerfile)
* [seL4 Dockerfile](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles/blob/master/sel4.dockerfile)

The version of `cmake` in Debian *stretch* is too old to build seL4 projects (*buster* and later are OK).  If you are on *stretch*, install `cmake` from stretch-backports:

Add the *stretch-backports* repository like this (substitute a local mirror for `ftp.debian.org` if you like)

```sh
sudo sh -c "echo 'deb http://ftp.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list"
```

Then install `cmake` with

```sh
sudo apt-get update
sudo apt-get -t stretch-backports install cmake
```

### Python Dependencies

Regardless of your Linux distribution, python dependencies are required to build seL4, the manual and its proofs. To install you can run:

```sh
pip3 install --user setuptools
pip3 install --user sel4-deps
# Currently we duplicate dependencies for python2 and python3 as a python3 upgrade is in process
pip install --user setuptools
pip install --user sel4-deps
```

(Some distributions use `pip` for python3 and `pip2` for python2; others uses `pip` for python2 and `pip3` for python3.  Use the Python 3 version for your distribution)
