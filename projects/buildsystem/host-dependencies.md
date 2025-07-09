---
redirect_from:
  - /HostDependencies
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Setting up your machine to build seL4

This page describes how to set up your development host machine for building and
running the seL4 kernel. There are additional steps if you are planning to use
[CAmkES] or [Rust] on top of seL4. You do not need this step if you are using
the Microkit, because it comes with pre-compiled seL4 binaries.

[CAmKES]: {% link projects/camkes/setting-up.md %}
[Rust]: {% link projects/rust/how-to-use.md %}

{% include seL4-deps.md %}

## Test

To test whether your build environment works, we recommend running the seL4 test
suite in `quemu`. For instance:

```sh
# target directory
mkdir sel4test
cd sel4test

# get the sources
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync

# create build directory
mkdir build
cd build

# configure build
../init-build.sh -DSIMULATION=TRUE -DAARCH32=TRUE -DPLATFORM=sabre

# build
ninja

# run
./simulate
```

This should start `qemu` and run a series of tests. Don't worry if error
messages appear, they are explicit tests for errors.

An output of `All is well in the universe` at the end indicates a successful
test run. To exit `qemu`, press `Ctrl-a`, then `x`.
