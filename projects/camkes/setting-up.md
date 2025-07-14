---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Setting up your machine to use CAmkES

This page describes how to set up your development host machine for building and
using the CAmkES component system on top of seL4. The first steps are the build
dependencies for the seL4 kernel. You will need these, including Google's repo
tool. The steps are repeated below for convenience. In addition, projects using
CAmkES need Haskell and some extra Python libraries. Instructions for these
are underneath.

{% include seL4-deps.md %}


## CAmkES Build Dependencies

### More Python

The Python dependencies required by the CAmkES build toolchain can be installed via pip:

```sh
pip3 install --user camkes-deps
```

{% include pip-instructions.md %}

### Haskell Dependencies

The CAmkES build toolchain additionally requires Haskell. You can install the
[Haskell stack](https://haskellstack.org) on your distribution by running:

```sh
curl -sSL https://get.haskellstack.org/ | sh
```

If you prefer not to bypass your distribution's package manager, you can do

```sh
sudo apt-get install haskell-stack
```

### Build Dependencies

{% include tabs.html %}

{% include tab.html title="Ubuntu" %}

These instructions are intended for Ubuntu LTS version 22.04.

Install the following packages:

```sh
sudo apt-get install clang gdb
sudo apt-get install libssl-dev libclang-dev libcunit1-dev libsqlite3-dev
sudo apt-get install qemu-kvm
```

{% include endtab.html %}

{% include tab.html title="Debian" %}

The dependencies listed in our docker files
[repository](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles) will work for
a Debian Bullseye installation or later. You can refer to this repository for an
up-to-date list of base build dependencies. Specifically refer to the
dependencies listed in the [CAmkES
docker setup](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles/blob/master/scripts/camkes.sh).

{% include endtab.html %}

{% include endtabs.html %}


### CAmkES repository collection checkout

To check out a consistent collection of CAmkEs, tools, libraries, and kernel
from the `camkes-manifest` repository, run the following:

```sh
mkdir camkes-project
cd camkes-project
repo init -u https://github.com/seL4/camkes-manifest.git
repo sync
```

To run a simple demo example:

```sh
cd camkes-project
mkdir build
cd build
../init-build.sh -DPLATFORM=sabre -DAARCH32=1 -DCAMKES_APP=adder -DSIMULATION=1
ninja
./simulate
```
