---
order_priority: 2
project: camkes
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
## CAmkES Build Dependencies

To build a CAmkES based project on seL4, additional dependencies need to be installed on your host machine. Projects using CAmkES (the seL4 component system) need Haskell and some extra Python libraries in addition to the standard build tools. The following instructions cover the CAmkES build dependencies for Ubuntu/Debian. Please ensure you have installed the dependencies listed in sections [seL4 Build Dependencies](#sel4-build-dependencies) and [Get Google's Repo tool](#get-googles-repo-tool) prior to building a CAmkES project.

### Python Dependencies

The Python dependencies required by the CAmkES build toolchain can be installed via pip:

```sh
pip3 install --user camkes-deps
```

{% include pip-instructions.md %}

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

These instructions are intended for Ubuntu LTS versions 20.04 and 22.04.

Install the following packages:

```sh
sudo apt-get install clang gdb
sudo apt-get install libssl-dev libclang-dev libcunit1-dev libsqlite3-dev
sudo apt-get install qemu-kvm
```

####  Debian

##### For Debian Stretch or later

The dependencies listed in our docker files [repository](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles) will work for a Debian installation. You can refer to this repository for an up-to-date list of base build dependencies. Specifically refer to the dependencies listed in the:

* [CAmkES Dockerfile](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles/blob/master/camkes.dockerfile)
