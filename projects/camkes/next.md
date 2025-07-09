---
redirect_from:
  - /CAmkESNext
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# CAmkES Next


CAmkES Next refers to the "next" branch of camkes-tools. It is the
active development branch of camkes.

Github: <https://github.com/seL4/camkes-tool/tree/next>

Main CAmkES page: [CAmkES](/CAmkES)

Summary of differences between CAmkES next and CAmkES master:
[differences](/projects/camkes/differences.html)

VisualCAmkes, a GUI tool to view a CAmkES system: [VisualCAmkES](/VisualCAmkES/)

## Setting up your machine


The following commands were tested on a fresh installation of Ubuntu
16.04. This will install the tools and libraries required to build seL4
and CAmkES Next. Note that the dependencies are different from those of
the "master" branch of CAmkES.
```
apt-get install git repo libncurses-dev python-pip libxml2-utils cmake ninja-build clang libssl-dev libsqlite3-dev \
libcunit1-dev gcc-multilib expect qemu-system-x86 qemu-system-arm gcc-arm-none-eabi binutils-arm-none-eabi

pip install six plyplus pyelftools orderedset jinja2

curl -sSL https://get.haskellstack.org/ | sh
```

If you are using Ubuntu 14.04, then you will need to install some extra
packages and update your compiler. Instead of the above do the following
(the main changes are: replace repo with phablet-tools, add python-dev,
and install gcc-5 and gcc-5-multilib from the PPA and set it as the
default gcc):
```
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get update
apt-get install git phablet-tools libncurses-dev python-dev python-pip libxml2-utils cmake ninja-build clang libssl-dev \
libsqlite3-dev libcunit1-dev gcc-multilib expect qemu-system-x86 qemu-system-arm gcc-arm-none-eabi binutils-arm-none-eabi \
gcc-5 gcc-5-multilib
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60

pip install camkes-deps

curl -sSL https://get.haskellstack.org/ | sh
```

On Archlinux:
```
pacman -S binutils gcc-multilib arm-none-eabi-binutils arm-none-eabi-gcc ccache clang moreutils cpio python python-pip expect \
cmake ninja m4 automake autoconf pkg-config valgrind cppcheck python-pylint qemu qemu-arch-extra openssl bcunit

yaourt -S bcunit-cunit-compat spin

pip install camkes-deps

curl -sSL https://get.haskellstack.org/ | sh
```

If you are using Debian, or Ubuntu 16.10 or higher, you'll need to
modify the compiler/linker flags for building ghc. Modify
`~/.stack/programs/x86_64-linux/ghc-8.0.1/lib/ghc-8.0.1/settings`.
Replace the lines:
```
 ("C compiler flags", " -fno-stack-protector"),
 ("C compiler link flags", ""),
```
with
```
 ("C compiler flags", " -fno-PIE  -fPIC -fno-stack-protector"),
 ("C compiler link flags", "-no-pie -fPIC"),
```

See [this stack issue on GitHub](https://github.com/commercialhaskell/stack/issues/2712) for more information.

## Download and build example CAmkES app


Create and enter an empty working directory before running the commands
below.
```bash
# Download CAmkES, seL4, user libraries and example apps
repo init -u https://github.com/seL4/camkes-manifest.git -m next.xml
repo sync

# Select an app to build (build configs for example apps can be found in the "configs" directory)
make arm_simple_defconfig

# Compile it
make

# Run the app in qemu
qemu-system-arm -M kzm -nographic -kernel images/capdl-loader-experimental-image-arm-imx31
```
