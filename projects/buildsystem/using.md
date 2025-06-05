---
redirect_from:
  - /Developing/Building/Using
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Configuring and building an seL4 project

<!--excerpt-->

This page contains documentation for how to interact with and build a project that is using this build system.
For new project development, see [incorporating the build system](/Developing/Building/Incorporating).

<!--excerpt-->

#### Basic build initialisation

In the root directory of an seL4-based project, first create a separate build
directory for the output binaries, then initialize CMake:

```sh
mkdir build
cd build
cmake -DCROSS_COMPILER_PREFIX=arm-linux-gnueabi- -DCMAKE_TOOLCHAIN_FILE=../kernel/gcc.cmake <OTHER_COMMAND_LINE_OPTIONS_HERE> -G Ninja ..
```

We now break down each component in the above invocation:

 * `-D` defines a variable, in the form `X=Y`.
 * `CROSS_COMPILER_PREFIX` specifies the toolchain for cross-compilation, which cannot be changed after
    build directory initialisation. For further details, please see "Cross Compiling"
    below.
 * `CMAKE_TOOLCHAIN_FILE` which indicates that CMake should load the specified file as a
   'toolchain' file. A toolchain file is able to set up the C compiler, linker etc., for building the project.
    In the example we assume a typical project layout, where seL4 is in the 'kernel' directory, at the top level.
    The [gcc.cmake](https://github.com/seL4/seL4/blob/master/gcc.cmake)' file from the seL4 repository sets
     up C compilers and linkers using the `CROSS_COMPILER_PREFIX`.
 * `-G Ninja` tells CMake to generate Ninja build scripts as opposed to GNU Makefiles. Only Ninja scripts are supported by parts of the kernel.
 * `..` is the path to the top-level `CMakeLists.txt` file describing this project, which in this
   case is placed in the root directory of the project.


We also provide a shorthand wrapping script which abstracts the above into a shorter command:

```sh
../init-build -DCROSS_COMPILER_PREFIX=arm-linux-gnueabi- <COMMAND_LINE_OPTIONS_HERE>
```

After configuration, you can build the project by invoking ninja:

```sh
ninja
```

After the build has completed, the resulting binaries will be in the `images/` subdirectory.

### Configuration

#### Types of Options

CMake has two types of configuration options:

 * *Boolean options*, which are are either `ON` or `OFF`,
 * *String options*, which can be set to any value, subject to restrictions set by the project authors.

String options can have 'hints', which specify can one of several fixed values.
CMake configuration editors respect these and provide a radio selection.


#### Selecting Options

Many projects have some degree of customisation available via configuration options. Once the build directory is initialised,
you can use the following approaches to bring up a user-interface for option configuration:

 * A `ncurses` based configuration:

```sh
ccmake .
```

 * Graphical configuration:

```sh
cmake-gui .
```

In both cases the path `.` should resolve to the same directory used in the build configuration.

#### Changing option values

Any changes to configuration options will not be reflected in the user interface unless explicitly
requested by using `(c)onfigure`, which may result in changes to the options available.
For example if option `A` depends on boolean option `B`, `A` will not show up until `B` is enabled and
`(c)onfigure` is used to reprocess the CMake files.

To exit the configuration interface, use `(g)enerate and exit` or `(q)uit without generation`. CMake
will not permit generation if the configuration is incomplete (`(c)onfigure` must be run and all
options set).

To rebuild after changing configuration options, invoke ninja:

```sh
ninja
```

#### Initial configuration:

Many of our projects support multiple configurations, where the following broad
approaches are used to present simple options to the user:

* **CMake cache scripts**: These files can assign initial values to any number of configuration
  variables. By combining one or more of these together you
  can configure an entire system.
* **Meta configuration options**:  Meta configuration options are normally
  passed as initial `-DVAR=FOO` command line arguments to CMake and will be
  programatically inspected by projects' CMake scripts to (re)configure the
  system.

##### CMake cache scripts:

CMake cache scripts provide subsets of preconfigured options, which allow the user of a project to
avoid manually setting each option. Cache scripts have the file extension `.cmake`.

Projects may provide cache script files which each contain the cache
settings necessary to configure a single feature or option. By combining
multiple `.cmake` files, a project can be initialised in a specific way.
Cache script configurations are provided
by passing `-C <file>` to `cmake` when initialising the build directory. 
For example, given a typical project structure,
one might invoke `cmake` or `init-build.sh` with several of
cache scripts as arguments.

Multiple cached scripts can be specified on the command line, although if the same option is set twice
only one value is used. Consider an example with several cache scripts for setting the architecture
details (`arm.cmake`, `x86.cmake`) and for setting build options (`debug.cmake`, `release.cmake`).
The intended usage is that one architectural cache file is used, and one build options file, as
demonstrated below:

```sh
cmake -C../projects/awesome_project/configs/arm.cmake -C../projects/awesome_project/configs/debug.cmake -DCROSS_COMPILER_PREFIX=arm-linux-gnueabi- -DCMAKE_TOOLCHAIN_FILE=../kernel/gcc.cmake -G Ninja ..
```

While nothing prevents the usage of both `arm.cmake` and `x86.cmake` at the same time, this does not
make sense, and only one value for each option will be used.  For projects with multiple cache scripts,
check which can be used together.

##### Meta configuration options:

Some seL4  projects provide top-level variables which, used across projects, have the same behaviour.
These options are as follows:

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
* `-DSMP`: Set to `0` or `1`: Turns SMP (symmetric multiprocessing) support on or
  off. By default it will enable support for up to 4 processors. To explicitly
  set the maximum number of supported CPUs, try setting
  `-DKernelMaxNumNodes=<YOUR_PREFERENCE>`.
* `-DSIMULATION`: Set to `0` or `1`: This produces a build of the project which
   is suited for running in an emulator such as QEMU.

Both the [seL4test](/seL4Test) and [seL4bench](https://github.com/seL4/sel4bench-manifest) projects follow this form.

#### [sel4test](https://github.com/seL4/sel4test) example:

For more information on configuring, building and running the sel4test suite, please see the [main page on seL4test](../../seL4Test).

### Cross compiling:

[Cross compilation](https://en.wikipedia.org/wiki/Cross_compiler) refers to compiling a program
for a target machine which is different from the machine you are using to compile the program.

Generally, in order to cross-compile, a separate compiler is required which
specifically targets the foreign machine.

#### For ARM-based targets:

You can use the following command line options when when cross-compiling for an ARM-based machine:

* `-DAARCH32=TRUE`: Tells the build system that you are building for a 32-bit
  ARM target. This will cause the build system to assume that you have a
  cross compiler installed which targets a system with the triplet name
  `arm-linux-gnueabi-`.
* `-DAARCH32HF=TRUE`: Tells the build system you're building for a 32-bit ARM
  target which has hardware floating point support. Assumes you have a cross-
  compiler installed which targets `arm-linux-gnueabihf-`.
* `-DAARCH64=TRUE`: Tells the build system you're building for a 64-bit ARM
  target. Assumes you have a cross-compiler installed which targets
  `aarch64-linux-gnu-`.

Another option is to explicitly specify the toolchain through `-DCROSS_COMPILER_PREFIX`,
which can be used to set the prefix of the
cross-compiler to use.

#### For RISC-V based targets:

You can use the following options when cross compiling for a RISC-V target:

* `-DRISCV32=TRUE`: Tells the build system that you are building for a 32-bit RISC-V
  target. This will cause the build system to assume that you have a cross-
  compiler installed which targets a system with the triplet name
  `riscv32-unknown-elf-`.
* `-DRISCV64=TRUE`: Tells the build system you're building for a 64-bit RISC-V
  target. Assumes you have a cross-compiler installed which targets
  `riscv64-unknown-elf-`.

Like ARM, you can explicitly specify the toolchain through `-DCROSS_COMPILER_PREFIX`,
which can be used to set the prefix of the
cross-compiler to use.

#### CMAKE_BUILD_TYPE

The `CMAKE_BUILD_TYPE` option appears in CMake configuration editors and allows users to configure
that build type (release, debug etc.). Note that this option is not respected by the seL4 kernel.

### Building with Clang

The kernel as well as, some other projects, can be built using the [clang](https://clang.llvm.org/) compiler. To select this configuration,
the `-DTRIPLE` variable must be set in the initial configuration step i.e pass in as an argument to the `init-build` script.

The value of the `TRIPLE` should be the [target](https://releases.llvm.org/8.0.0/tools/clang/docs/CrossCompilation.html#target-triple) for which you are compiling.
```sh
../init-build -DTRIPLE=x86_64-linux-gnu <COMMAND_LINE_OPTIONS_HERE>
```
The `CROSS_COMPILER_PREFIX` argument is unnecessary and ignored when compiling with clang. When building for arm based targets, the target `TRIPLE` will be equal
to the `CROSS_COMPILER_PREFIX` (when using gcc) without the trailing '-'.

Using clang to compile for RISC-V based targets is currently not supported.
