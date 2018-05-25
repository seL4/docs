# Configuring and building an seL4 project

<!--excerpt-->

This page contains documentation for how to interact with and build a project that is using this build system.
If you are developing a project then should read the [incorporating the build system](/Developing/Building/Incorporating) section.

<!--excerpt-->


#### Basic build initialisation

In the root directly of a seL4-based project, first create a separate build
directory for the output binaries, then initialize CMake:

```sh
mkdir build
cd build
cmake -DCROSS_COMPILER_PREFIX=arm-linux-gnueabi- -DCMAKE_TOOLCHAIN_FILE=../kernel/gcc.cmake <OTHER_COMMAND_LINE_OPTIONS_HERE> -G Ninja ..
```

We also provide a shorthand wrapping script which hides all of these necessary
arguments other than the cross-compiler toolchain arguments, so you can instead
invoke cmake by proxy via our wrapping script, like this:

```sh
../init-build -DCROSS_COMPILER_PREFIX=arm-linux-gnueabi- <COMMAND_LINE_OPTIONS_HERE>
```


Breaking down what each component means

 * `-D` means we are defining a variable in the form `X=Y`
 * `CROSS_COMPILER_PREFIX` which is used to specify the toolchain to be used for
    cross-compilation. The toolchain cannot be changed after a build directory
    is initialised. For further details, please see the "Cross Compiling"
    section below.
 * `CMAKE_TOOLCHAIN_FILE` is variable understood by CMake and tells it to load the specified file as a
   'toolchain' file. A toolchain file is able to setup the C compiler, linker etc that should be used. In this
   case we assume a typical project layout with the seL4 kernel in a 'kernel' directory at the top level. The
   '[gcc.cmake](https://github.com/seL4/seL4/blob/master/gcc.cmake)' file in it sets up C compilers and linkers
   using the previously supplied `CROSS_COMPILER_PREFIX`
 * `-G Ninja` tells CMake that we want to generate Ninja build scripts as opposed to GNU Makefiles. Currently
   only Ninja scripts are supported by parts of the kernel
 * `..` is the path to the top level `CMakeLists.txt` file that describes this project, generally this is
   placed in the root directory so this parameter is typically `..`, but could be any path

If all goes well you should now be able to build by doing

```sh
ninja
```

And the resulting binaries will be placed in the `images/` subdirectory

### Configuration

Many projects will have some degree of customisation available to them. Assuming a build directory that has been
initialised with CMake you can do either

```sh
ccmake ..
```

for a ncurses based configuration editor or

```sh
cmake-gui ..
```

for a graphical configuration editor.  In both invocations the path `..` should be the same path as was used in the original `cmake` invocation.

CMake itself has two different kinds of options:

 * Booleans: These are either `ON` or `OFF`
 * Strings: These can be set to any value, although they may be restricted to a set of values by whoever wrote the project.

String options can have 'hints' given to them that they should only take on one of several fixed values. The
CMake configuration editors will respect these and provide a radio selection.

As you change configuration options the CMake scripts for the project are not continuously rerun. You can explicitly
rerun by telling it to '(c)onfigure'. This may result in additional options appearing in the configuration editor,
or some options being removed, depending on what their dependencies where. For example if there is option `A` that
is dependent on option `B` being true, and you change `B` to true, `A` will not show up until you (c)onfigure and
the CMake files are reprocessed.

When you are done changing options you can either '(g)enerate and exit' or '(q)uit without generation'. If you
quit without generating then your changes will be discarded, you may do this at any time. You will only be
allowed to generate if you run (c)onfigure after doing any changes and CMake believes your configuration has
reached a fixed point.

After changing any options and generating call

```sh
ninja
```

to rebuild the project.

#### Initial configuration:

Many of our projects support multiple configurations, where the following broad
approaches are used to present simple options to the user:

* **CMake cache scripts**: These files can set any number of configuration
  variables to an initial value. By combining one or more of these together you
  can coherently configure a system
* **Meta configuration options**:  Meta configuration options are normally
  passed as initial `-DVAR=FOO` command line arguments to CMake and will be
  programatically inspected by the projects CMake scripts to (re)configure the
  system.

##### CMake cache scripts:

The project may provide multiple `.cmake` files which each contain the cache
settings necessary to configure a single feature or option. By combining
multiple `.cmake` files, you initialise the project in a certain way.
Cache script configurations are provided when initialising the build directory
by passing `-C <file>` to `cmake`. For example given some typical project structure,
one might invoke `cmake` or `init-build.sh` with several of these partial
cache scripts as arguments.

You can pass multiple `-C` options on the command line, although if they try and set the same cache variables only one of the
settings will actually get used. This means we might have two different configuration
files for `arm.cmake` and `x86.cmake`, and then two other files for `debug.cmake` and `release.cmake`. We could
now combine `arm.cmake` with either `debug.cmake` or `release.cmake`, similarly with `x86.cmake`. For example:

```sh
cmake -C../projects/awesome_project/configs/arm.cmake -C../projects/awesome_project/configs/debug.cmake -DCROSS_COMPILER_PREFIX=arm-linux-gnueabi- -DCMAKE_TOOLCHAIN_FILE=../kernel/gcc.cmake -G Ninja ..
```

Nothing stops you from trying to initialise with both `arm.cmake` and `x86.cmake`, but since they are probably
setting some of the same options only one will actually take effect. If the project has multiple configuration
files you should check which can be composed.

##### Meta configuration options:

Not all projects follow this strictly but we have a set of top-level
meta-variables which, if they are used by a project, will have the same
behaviour:

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

#### [sel4test](https://github.com/seL4/sel4test) example:

Please see the [main page on seL4test](../../seL4Test) for more information on how to configure
and build seL4test.

### Cross compiling:

Cross compilation refers to compiling a program for a target machine which is
different from the machine you're building it on. When compiling low level
software you often find yourself needing to compile it on a machine which is
different from the machine it will eventually be executed on.

In order to cross-compile, you usually need a separate compiler which
specifically targets the foreign machine.

#### For ARM-based targets:

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

#### For RISC-V based targets:

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


#### CMAKE_BUILD_TYPE

The `CMAKE_BUILD_TYPE` option is an option that will appear in the CMake configuration editors that is not
defined by a project, but is rather defined by CMake itself. This option configures the kind of build to do;
release, debug, release with debug information, etc. Note that the seL4 kernel ignores this setting as due
to the way the kernel has to be built it side steps many of the CMake systems.

