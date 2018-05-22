---
toc: true
---

# seL4's CMake Build System

This article seeks to give an overview of the build system design that our
repositories and larger projects use.

## General Usage:

We wrap CMake behind a shell script called `init-build` -- use this script as
a proxy when invoking the build system. So instead of calling `cmake` directly,
try:

```
mkdir build
cd build
../init-build <COMMAND_LINE_OPTIONS_HERE>
```

## Cross compiling:

Cross compilation refers to compiling a program for a target machine which is
different from the machine you're building it on. When compiling low level
software you often find yourself needing to compile it on a machine which is
different from the machine it will eventually be executed on.

In order to cross-compile, you usually need a separate compiler which
specifically targets the foreign machine.

### For ARM-based targets:

You must explicitly always pass in the command line argument `-DAARCH32` or
`-DAARCH64` when cross-compiling for an ARM-based chipset -- **or** you can
make use of `-DCROSS_COMPILER_PREFIX`.

* `-DAARCH32`: Tells the build system that you are building for a 32-bit
  ARM target. This will cause the build system to assume that you have a
  cross compiler installed which targets a system with the triplet name
  `arm-linux-gnueabi-`.
* `-DAARCH32HF`: Tells the build system you're building for a 64-bit ARM
  target which has hardware floating point support. Assumes you have a cross-
  compiler installed which targets `arm-linux-gnueabihf-`.
* `-DAARCH64`: Tells the build system you're building for a 64-bit ARM
  target. Assumes you have a cross-compiler installed which targets
  `aarch64-linux-gnu-`.

**OR** you can always just pass in `-DCROSS_COMPILER_PREFIX=<TARGET_TRIPLET>`
which can be used to explicitly set the target-triplet prefix of the
cross-compiler which you would prefer to use to compile your binaries.

### For RISC-V based targets:

You must explicitly always pass in the command line argument `-DRISCV32` or
`-DRISCV64` when cross compiling for a RISC-V target -- **or** you can make use
of `-DCROSS_COMPILER_PREFIX`.

* `-DRISCV32`: Tells the build system that you are building for a 32-bit RISC-V
  target. This will cause the build system to assume that you have a cross-
  compiler installed which targets a system with the triplet name
  `riscv32-unknown-elf-`.
* `-DRISCV64`: Tells the build system you're building for a 64-bit RISC-V
  target. Assumes you have a cross-compiler installed which targets
  `riscv64-unknown-elf-`.

**OR** you can always just pass in `-DCROSS_COMPILER_PREFIX=<TARGET_TRIPLET>`
which can be used to explicitly set the target-triplet prefix of the
cross-compiler which you would prefer to use to compile your binaries.

## General form:

Several of our projects follow a general form, which is documented below.

Not all projects follow this strictly but we have a set of top-level variables
which, if they are used by a project, will have the same behaviour:

* `-DPLATFORM=<YOUR_PREFERENCE>`: Selects the target system for the resulting
  binaries. Valid values for this variable are the first value (preceding the
  semicolon) on each line of the `config_choice` directive for each
  architecture:
  * For ARM: [List in source](https://github.com/seL4/seL4/blob/master/src/arch/arm/config.cmake#L21).
  * For X86: [List in source](https://github.com/seL4/seL4/blob/master/src/arch/x86/config.cmake#L15).
  * For RISC-V: [List in source](https://github.com/seL4/seL4/blob/master/src/arch/riscv/config.cmake#L15).

* `-DRELEASE`: Set to `0` or `1`: Turning this off compiles a debug build.
  Turning it on compiles the project without debugging features enabled.
* `-DVERIFICATION`: Set to `0` or `1`: This is used to generate the version of
  the seL4 kernel source which is **VERIFIABLE**. This does not produce a binary
  for the **verified** kernel platform.
* `-DSMP`: Set to `0` or `1`: Turns SMP (symmetric multiprocesing) support on or
  off. By default it will enable support for up to 4 processors. To explicitly
  set the max number of supported CPUs, try setting
  `-DKernelMaxNumNodes=<YOUR_PREFERENCE>`.
* `-DSIMULATION`: Set to `0` or `1`: This produces a build of the project which
   is suited for running in an emulator such as Qemu.

seL4test and seL4bench follow this form.

Projects which don't follow this form will describe their variables in their
`README` file.
