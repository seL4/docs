# Host Dependencies

This page describes how to set up your host machine to build and run seL4 and its supported projects. To compile and use seL4 you can either:

* *Recommended:* Use Docker to isolate the dependencies from your machine. Detailed instructions for using Docker for building seL4, Camkes, and L4v can be found [here](Docker.md).
* Install the following dependencies on your local OS

The following instructions describe how to set up the required dependencies on your local OS. This page assumes you are building in a Linux OS. We however encourage site [contributions](https://docs.sel4.systems/DocsContributing) for building in alternative OSes (e.g. macOS).

## seL4 Build Dependencies

To build seL4-based projects, ensure you have installed the dependencies described in the [Base Build Dependencies](#base-build-dependencies) and [Python Dependencies](#python-dependencies) sections below.

### Base Build Dependencies

To establish a usable development environment it is important to install your distributions basic build packages.

####  Ubuntu

> *The following instructions cover the build dependencies tested on [Ubuntu 18.04](http://releases.ubuntu.com/18.04/) LTS. Note that earlier versions of Ubuntu (e.g. 16.04) may not be sufficient for building as some default development packages are
stuck at older versions (e.g CMake 3.5.1, GCC 5.4 for 16.04).
As dependencies and packages may be frequently changed, deprecated or updated these instructions may become out of date. If you discover any missing dependencies and packages we welcome new [contributions](https://docs.sel4.systems/DocsContributing) to the page.*

The basic build package on Ubuntu is the `build-essential` package. To install run:

```
sudo apt-get update
sudo apt-get install build-essential
```

Additional base dependencies for building seL4 projects on Ubuntu include installing:
```
sudo apt-get install cmake ccache ninja-build cmake-curses-gui
sudo apt-get install python-dev python-pip python3-dev python3-pip
sudo apt-get install libxml2-utils ncurses-dev
sudo apt-get install curl git doxygen device-tree-compiler
sudo apt-get install u-boot-tools
```

To build for ARM targets you will need a cross compiler. In addition, to run seL4 projects on a simulator you will need `qemu`. Installation of these additional base dependencies include running:


```
sudo apt-get install gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
sudo apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
sudo apt-get install qemu-system-arm qemu-system-x86
```

(you can install  the hardware floating point versions as well if you wish"
```
sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
```
####  Debian

##### For Debian Stretch or later

The dependencies listed in our docker files [repository](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles) will work for a Debian installation. You can refer to this repository for an up-to-date list of base build dependencies. Specifically refer to the dependencies listed in the:

* [Base Tools Dockerfile](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles/blob/master/base_tools.dockerfile)
* [seL4 Dockerfile](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles/blob/master/sel4.dockerfile)

The version of `cmake` in Debian *stretch* is too old to build seL4 projects (*buster* and later are OK).  If you are on *stretch*, install `cmake` from stretch-backports:

Add the *stretch-backports* repository like this (substitute a local mirror for `ftp.debian.org` if you like)
```
sudo sh -c "echo 'deb http://ftp.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list"
```
Then install `cmake` with
```
sudo apt-get update
sudo apt-get -t stretch-backports install cmake
```

### Python Dependencies

Regardless of your Linux distribution, python dependencies are required to build seL4, the manual and its proofs. To install you can run:

```
pip install --user setuptools
pip install --user sel4-deps
```

## Get Google's Repo tool

The primary way of obtaining and managing seL4 project source is through the use of Google's repo tool. To get repo, follow the instructions described in the section “Installing Repo” [here](http://source.android.com/source/downloading.html#installing-repo).

See the [RepoCheatsheet](/RepoCheatsheet) page for a quick explanation of how we use Repo.

## CAmkES Build Dependencies

To build a CAmkES based project on seL4, additional dependencies need to be installed on your host machine. Projects using CAmkES (the seL4 component system) need Haskell and some extra python libraries in addition to the standard build tools. The following instructions cover the CAmkES build dependencies for Ubuntu/Debian. Please ensure you have installed the dependencies listed in sections [sel4 Build Dependencies](#sel4-build-dependencies) and [Get Google's Repo tool](#get-googles-repo-tool) prior to building a CAmkES project.

### Python Dependencies

The python dependencies required by the CAmkES build toolchain can be installed via pip:

```
pip install --user camkes-deps
```

### Haskell Dependencies

The CAmkES build toolchain additionally requires Haskell. You can install the [Haskell stack](https://haskellstack.org) on your distribution by running:
```
curl -sSL https://get.haskellstack.org/ | sh
```
If you prefer not to bypass your distribution's package manager, you can do
```
sudo apt-get install haskell-stack
```

### Build Dependencies

####  Ubuntu
> *Tested on Ubuntu 18.04 LTS*

Install the following packages on your Ubuntu machine:

```
sudo apt-get install clang gdb
sudo apt-get install libssl-dev libclang-dev libcunit1-dev libsqlite3-dev
sudo apt-get install qemu-kvm
```

####  Debian

##### For Debian Stretch or later

The dependencies listed in our docker files [repository](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles) will work for a Debian installation. You can refer to this repository for an up-to-date list of base build dependencies. Specifically refer to the dependencies listed in the:

* [CAmkES Dockerfile](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles/blob/master/camkes.dockerfile)


## Building Proofs (l4v dependencies)

The proofs in the [L4.verified](https://github.com/seL4/l4v) repository use `Isabelle2017`. To best way to make sure you have all the dependencies on your host machine is to follow the instructions listed in sections [Base Build Dependencies](#base-build-dependencies). However you can get away with avoiding a full cross compiler setup. The dependencies for Isabelle you will need at least are listed below:

### Ubuntu

> *Tested on Ubuntu 18.04 LTS*

```
sudo apt-get install libwww-perl libxml2-dev libxslt-dev
sudo apt-get install mlton rsync
sudo apt-get install texlive-fonts-recommended texlive-latex-extra texlive-metapost texlive-bibtex-extra
```

###  Debian

#### For Debian Stretch or later

The dependencies listed in our docker files [repository](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles) will work for a Debian installation. You can refer to this repository for an up-to-date list of base build dependencies. Specifically refer to the dependencies listed in the:

* [l4v Dockerfile](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles/blob/master/l4v.dockerfile)

### Haskell Dependencies

The Haskell tool-stack is required to build the Haskell kernel model. You can install [Haskell stack](https://haskellstack.org) on your distribution by running:

```
curl -sSL https://get.haskellstack.org/ | sh
```

If you prefer not to bypass your distribution's package manager, you can do
```
sudo apt-get install haskell-stack
```

### Setup Isabelle

To setup Isabelle, you will firstly need to pull the [L4.verified](https://github.com/seL4/l4v) project source using the Google repo tool (installing the Google repo tool is described in the [Get Google's Repo tool](#get-googles-repo-tool) section. The following steps to setup Isabelle:

```
# Create a directory to store the project source
mkdir lv4_repo
cd lv4_repo
# Initialise the project repo
repo init -u https://github.com/seL4/verification-manifest.git
repo sync
cd l4v
mkdir -p ~/.isabelle/etc
cp -i misc/etc/settings ~/.isabelle/etc/settings
./isabelle/bin/isabelle components -a
./isabelle/bin/isabelle jedit -bf
./isabelle/bin/isabelle build -bv HOL-Word
```

