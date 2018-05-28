# Configuring and building an seL4 project

<!--excerpt-->

This page contains documentation for how to interact with and build a project that is using this build system.
If you are developing a project then should read the [incorporating the build system](/Developing/Building/Incorporating) section.

<!--excerpt-->


#### Basic build initialisation

Assuming you are in the root directory of a seL4-based project you should start with

```sh
mkdir build
cd build
```

Then initialise CMake with something like

```sh
cmake -DCROSS_COMPILER_PREFIX=arm-linux-gnueabi- -DCMAKE_TOOLCHAIN_FILE=../kernel/gcc.cmake -G Ninja ..
```

Breaking down what each component means

 * `-D` means we are defining a variable in the form `X=Y`
 * `CROSS_COMPILER_PREFIX` is a variable that will be used later on and contains the prefix for the gcc based
    toolchain we want to use. You cannot change your toolchain once you have initialised a build directory
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

And the resulting binaries will be placed in the `images/` directory

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

#### Initial configurations

If a project supports different configurations they will typically provide some configuration `.cmake` files to
allow you to initialise the project in a certain way. Configurations are provided when initialising the build
directory by passing `-C <file>` to `cmake`. For example given some typical project structure the `cmake`
in the last example could become

```sh
cmake -C../projects/awesome_project/configs/arm_debug.cmake -DCROSS_COMPILER_PREFIX=arm-linux-gnueabi- -DCMAKE_TOOLCHAIN_FILE=../kernel/gcc.cmake -G Ninja ..
```

Note that multiple `-C` options can be given, although if they try and set the same options only one of the
settings will actually get used. This means in the previous example we might have two different configuration
files for `arm.cmake` and `x86.cmake`, and then two other files for `debug.cmake` and `release.cmake`. We could
now combine `arm.cmake` with either `debug.cmake` or `release.cmake`, similarly with `x86.cmake`. For example

```sh
cmake -C../projects/awesome_project/configs/arm.cmake -C../projects/awesome_project/configs/debug.cmake -DCROSS_COMPILER_PREFIX=arm-linux-gnueabi- -DCMAKE_TOOLCHAIN_FILE=../kernel/gcc.cmake -G Ninja ..
```

Nothing stops you from trying to initialise with both `arm.cmake` and `x86.cmake`, but since they are probably
setting some of the same options only one will actually take effect. If the project has multiple configuration
files you should check which can be composed.

#### [sel4test](https://github.com/seL4/sel4test) example

In the previous examples we ended up with some relatively long `cmake` invocations. These can be aliased/scripted
in various ways. One such example is in the [sel4test](https://github.com/seL4/sel4test) project, which has
a script for automatically picking a toolchain and composing configuration files.

Assuming sel4test is correctly checked out and you're in the root directory you would do something like

```sh
./projects/sel4test/configure ia32 debug simulation
```

This will create a `build_ia32_debug_simulation` directory and initialise it with the `ia32.cmake`, `debug.cmake`,
`simulation.cmake` and `sel4test.cmake` files from the `projects/sel4test/configs` directory. It will also
select the system `gcc` as the cross compiler under the assumption you are building on an x86 machine.

If you configured with something like

```sh
./projects/sel4test/configure sabre verification
```

It will create a `build_sabre_verification` directory and initialise with `sabre.cmake`, `verification.cmake`,
and `sel4test.cmake`. In this case it will also set the cross compiler to `arm-linux-gnueabi-`

Not all projects have the configuration complexity of sel4test, but this serves as an example of how a given
project might simplify its configuration process.

#### CMAKE_BUILD_TYPE

The `CMAKE_BUILD_TYPE` option is an option that will appear in the CMake configuration editors that is not
defined by a project, but is rather defined by CMake itself. This option configures the kind of build to do;
release, debug, release with debug information, etc. Note that the seL4 kernel ignores this setting as due
to the way the kernel has to be built it side steps many of the CMake systems.

