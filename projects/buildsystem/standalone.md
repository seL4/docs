---
redirect_from:
  - /Developing/Building/seL4Standalone
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Standalone seL4 builds

This page contains documentation for building the seL4 kernel as a standalone
binary without any user-level system image or any loaders that run before the
kernel. This is typically used when a project wants to fully control the
user-level image and pre-kernel initialisation. The only standalone kernel
builds the seL4 Foundation currently maintains are for verified configurations.
This page assumes familiarity with using `cmake`.

{% include note.html %}
This text assumes that you know what to do with a generated `kernel.elf` binary.
For an explanation see at the bottom of the page.
{% include endnote.html %}

## Building a kernel standalone

### Initialising build directory with existing configuration

Building the kernel standalone requires initialising a CMake build directory
using the seL4 repo as the root CMake project:

```none
├── seL4/
│   └── CMakeLists.txt
├── build/
```

The build directory is initialised as follows:

```sh
cd build/
cmake -DCROSS_COMPILER_PREFIX= -DCMAKE_TOOLCHAIN_FILE=../seL4/gcc.cmake -G Ninja -C ../seL4/configs/X64_verified.cmake ../seL4/
```

The example uses the `X64_verified.cmake` file for configuration values.

To find available verified configurations:

```sh
ls ../seL4/configs/*.cmake
# ../seL4/configs/ARM_HYP_verified.cmake  ../seL4/configs/X64_verified.cmake
# etc
```

A typical verified configuration (`cat ../seL4/configs/X64_verified.cmake`):

```cmake
#!/usr/bin/env -S cmake -P
#
# Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
#
# SPDX-License-Identifier: GPL-2.0-only
#

# If this file is executed then build the kernel.elf and kernel_all_pp.c file
include(${CMAKE_CURRENT_LIST_DIR}/../tools/helpers.cmake)
cmake_script_build_kernel()

set(KernelPlatform "pc99" CACHE STRING "")
set(KernelSel4Arch "x86_64" CACHE STRING "")
set(KernelVerificationBuild ON CACHE BOOL "")
set(KernelMaxNumNodes "1" CACHE STRING "")
set(KernelOptimisation "-O2" CACHE STRING "")
set(KernelRetypeFanOutLimit "256" CACHE STRING "")
set(KernelBenchmarks "none" CACHE STRING "")
set(KernelDangerousCodeInjection OFF CACHE BOOL "")
set(KernelFastpath ON CACHE BOOL "")
set(KernelPrinting OFF CACHE BOOL "")
set(KernelNumDomains 16 CACHE STRING "")
set(KernelMaxNumBootinfoUntypedCap 166 CACHE STRING "")
set(KernelRootCNodeSizeBits 19 CACHE STRING "")
set(KernelMaxNumBootinfoUntypedCaps 50 CACHE STRING "")
set(KernelFSGSBase "inst" CACHE STRING "")
```

At this point you could use `ccmake .` to browse the configuration.

### Building the kernel target

To build the kernel target, run

```sh
ninja kernel.elf
```

Looking in the build directory:

```sh
ls
# autoconf                            generated                           kernel_bf_gen_target_11_pbf_temp.c
# build.ninja                         generated_prune                     kernel_bf_gen_target_111_pbf_temp.c
# circular_includes_valid             kernel_all_copy.c                   kernel.elf
# cmake_install.cmake                 kernel_all_pp_prune_wrapper_temp.c  libsel4
# CMakeCache.txt                      kernel_all_pp_prune.c               linker_ld_wrapper_temp.c
# CMakeFiles                          kernel_all.c                        linker.lds_pp
# gen_config                          kernel_all.i
# gen_headers                         kernel_bf_gen_target_1_pbf_temp.c
```

The `kernel.elf` can now be used in other build environments.

```sh
file kernel.elf
# kernel.elf: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped
```

Note the directory `gen_config/` which contains configuration info for this
build as `.h`, `.json` and `.yaml` files for use in further build stages or
other build systems.

## Installing

The build directory contains many more artefacts than needed to use a standalone
kernel build.

If you have used `-DCMAKE_INSTALL_PREFIX=<install dir>` when configuring CMake
and then run `cmake --install <build dir>`, you can have all the install
artefacts placed in `<install dir>`. The directory structure is the following:

```none
├── bin/
│   └── kernel.elf
├── libsel4/
|   ├── include/
|   |   └── ...
|   |   └── kernel/
|   |       └── ...
|   |       └── gen_config.json
|   └── src/
```

## Why use stand alone build?

For CMake-based build environments, the standalone build is usually not needed.

However, the standalone build is useful when the kernel is being used in a
different environment that does not use CMake. One example for this is the
[Microkit](../microkit/) which comes with pre-built kernel binaries and config
information. Another example is the formal verification project which uses the
standalone build to produce the source and binary artefacts that the
verification is performed on.

Other use cases include projects that want to build a non-C root task, for
instance in the [Rust support](../rust/).
