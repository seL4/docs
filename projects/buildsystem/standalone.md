---
redirect_from:
  - /Developing/Building/seL4Standalone
---

# Stand-alone seL4 builds

<!--excerpt-->

This page contains documentation for building the seL4 kernel standalone --- without a userlevel or any loaders that run before the kernel. This is typically used for verification or where a project wants to fully control userlevel and prekernel initialisation. We only maintain verification configurations for kernel only builds.  This page assumes familiarity with using the seL4 project build system and builds upon the previous documentation.

<!--excerpt-->

_Note: it is assumed that you know what to do with a generated kernel.elf binary.  For an explanation see at the bottom of the page._

## Building a kernel standalone

### Initialising build directory with existing configuration

Building the kernel standalone requires initialising a cmake build directory using the sel4 repo as the root CMake project:
```none
├── sel4/
│   └── CMakeLists.txt
├── build/ # Current directory
```

The build directory is initialised as follows:
```sh
cmake -DCROSS_COMPILER_PREFIX= -DCMAKE_TOOLCHAIN_FILE=../sel4/gcc.cmake -G Ninja -C ../sel4/configs/X64_verified.cmake ../sel4/
```
We use the X64_verified.cmake file for configuration values.

To find available verification configurations:

```sh
ls ../sel4/configs/*.cmake
# ../sel4/configs/ARM_HYP_verified.cmake  ../sel4/configs/X64_verified.cmake
# ../sel4/configs/ARM_verified.cmake
```
A typical verification configuration (`cat ../sel4/configs/X64_verified.cmake`):
```cmake
#
# Copyright 2017, Data61
# Commonwealth Scientific and Industrial Research Organisation (CSIRO)
# ABN 41 687 119 230.
#
# This software may be distributed and modified according to the terms of
# the GNU General Public License version 2. Note that NO WARRANTY is provided.
# See "LICENSE_GPLv2.txt" for details.
#
# @TAG(DATA61_GPL)
#
set(KernelArch "x86" CACHE STRING "")
set(KernelX86Sel4Arch "x86_64" CACHE STRING "")
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
```

At this point you could use `ccmake ../sel4` to browse the configuration.

### Building the kernel target

The kernel target needs to be specified to `ninja` otherwise it won't be built.

```sh
ninja kernel.elf
```

Looking in the build directory:
```sh
ls
# autoconf                 gen_config       kernel_all_pp.c                      kernel.elf
# build.ninja              generated        kernel_all_pp_prune.c                linker.lds_pp
# circular_includes_valid  generated_prune  kernel_all_pp_prune_wrapper_temp.c   linker_ld_wrapper_temp.c
# CMakeCache.txt           gen_headers      kernel_bf_gen_target_111_pbf_temp.c  rules.ninja
# CMakeFiles               kernel_all.c     kernel_bf_gen_target_11_pbf_temp.c
# cmake_install.cmake      kernel_all.i     kernel_bf_gen_target_1_pbf_temp.c
```

The kernel.elf can now be used in other build environments.

```sh
file kernel.elf
# kernel.elf: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped
```

## Why use stand alone build?

It is non-trivial to take a standalone kernel.elf and use it in another build environment.  This is because the system configuration is not exported with the kernel.elf and so a different build environment will need to know exactly how the kernel was configured so that bootloaders and userlevel applications can be configured in a compatible way.  Using the CMake scripts provided in seL4_tools and importing the kernel into an existing CMake project hierarchy will ensure that the system configuration is properly shared with other parts of the project.

However sometimes a standalone build is required when the kernel is being used in a different environment that doesn't use a CMake based build system.  One example of this is the verification project, L4V, that uses the stand alone build to poroduce the source and binary artifacts that the verification is performed on.

Other use cases include projects that want to build a non-C roottask, or projects that are already sophisticated enough to manage the different configuration settings that the kernel requires.  In these scenarios, it would be expected that these projects provide their own Configuration.cmake files that have correct configurations.
