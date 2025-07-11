---
parent: /projects/buildsystem/
redirect_from:
  - /Developing/Building/Incorporating
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Incorporating into your project

<!--excerpt-->

This page describes the CMake-based build system in detail, with sufficient information for integrating it into new projects.
There are a few different pieces that can be fit together in different ways depending on your project's needs
and desired customisation. This is reflected in the split of CMake files spread across several repositories.

<!--excerpt-->

#### Basic structure

The build system is in two pieces. One piece is in the [seL4 kernel repository](https://github.com/seL4/seL4), which contains the
compiler toolchain and flags settings as well as helpers for generating configurations. The other piece is in
[seL4_tools/cmake-tool](https://github.com/seL4/seL4_tools/tree/master/cmake-tool),
which contains helpers for combining libraries and binaries into a final system image (along with the kernel).

This structure means that the kernel is completely responsible for building itself, but exports the settings
and binaries for use by the rest of the build system.

The `cmake-tool` directory has the following files of interest:

 * `default-CMakeLists.txt`: An example `CMakeLists.txt` file, which could be used as the `CMakeLists.txt` file in
   the top-level directory of a project. Simply, this file includes `all.cmake`, under the assumption of a directory structure
   where the `cmake-tool` repository is in a directory named `tools`. To use this file, [project manifests](/projects/buildsystem/repo-cheatsheet.html) are
   expected to create a symbolic link to this file, named `CMakeLists.txt`, at the top-level project directory.
 * `all.cmake`: A wrapper that includes `base.cmake`, `projects.cmake` and
   `configuration.cmake`. This file can be used by projects which do not alter these three files.
 * `base.cmake`: Constructs the basic build targets (`kernel`, `libsel4`, and `elfloader-tool`), in addition to
   basic compilation flags and helper routines, required to build an seL4 project, and can be used
   as a base for further targets in a project through the `add_subdirectory` routine or otherwise.
 * `projects.cmake`: Adds build targets through `add_subdirectory` assuming a default project layout.
   Essentially it adds any `CMakeLists.txt` files it finds in any subdirectories of the projects directory.
 * `configuration.cmake`: Provides a target for a library called `Configuration` that emulates the legacy
   `autoconf.h` header. Since the `autoconf.h` header contained configuration variables for the *entire* project
   this rule needs to come after all other targets and scripts which add to the configuration space.
 * `common.cmake`: File included by `base.cmake` with some generic helper routines.
 * `flags.cmake`: File included by `base.cmake` which sets up build flags and linker invocations.
 * `init-build.sh`: A shell script which performs the initial configuration and generation for a new CMake build directory.
 * `helpers/*`: Helper functions that are commonly imported by `common.cmake`

### Kernel directory

The file `base.cmake` assumes that the seL4 kernel is in a specific location. Consider the following example:

```none
awesome_system/
├── kernel/
│   └── CMakeLists.txt
├── projects/
│   ├── awesome_system/
│   │   └── CMakeLists.txt
│   └── seL4_libs/
│       └── CMakeLists.txt
├── tools/
│   └── cmake-tool/
│       ├── base.cmake
│       ├── all.cmake
│       └── default-CMakeLists.txt
├── .repo/
└── CMakeLists.txt -> tools/cmake-tool/default-CMakeLists.txt
```

When `awesome_system/` is used as the root source directory to initialise a CMake build directory
and  `tools/cmake-tool/all.cmake` is used, `base.cmake` expects the kernel to be at
`awesome_system/kernel`.

The kernel can be placed in a different location, as described below.

```none
awesome_system/
├── seL4/
│   └── CMakeLists.txt
├── projects/
│   ├── awesome_system/
│   │   └── CMakeLists.txt
│   └── seL4_libs/
│       └── CMakeLists.txt
├── tools/
│   └── cmake-tool/
│       ├── base.cmake
│       ├── all.cmake
│       └── default-CMakeLists.txt
├── .repo/
└── CMakeLists.txt -> tools/cmake-tool/default-CMakeLists.txt
```

For the example above, where the kernel is in a directory called `seL4`, the default kernel location can be overriden when invoking `cmake` with `-DKERNEL_PATH=seL4`.

### Advanced structures

Other project layouts can be used. Consider the following example:

```none
awesome_system/
├── seL4/
│   └── CMakeLists.txt
├── awesome/
│   └── CMakeLists.txt
├── seL4_libs/
│   └── CMakeLists.txt
├── buildsystem/
│   └── cmake-tool/
│       ├── base.cmake
│       ├── all.cmake
│       └── default-CMakeLists.txt
└── .repo/
```

The example above departs from the default in the following ways:

 * no `CMakeLists.txt` file in the root directory,
 * `tools` directory has been renamed to `buildsystem`,
 * `kernel` directory has been renamed to `seL4`,
 * and the `projects` directory is omitted.

We now describe how to achieve such a project structure:

To place the `CMakeLists.txt` in `awesome_system/awesome` directory then initialise CMake,
assuming a build directory that is also in the `awesome_system` directory, do something like:

```sh
sel4@host:~/awesome_directory$ cmake -DCROSS_COMPILER_PREFIX=toolchain-prefix -DCMAKE_TOOLCHAIN_FILE=../seL4/gcc.cmake -DKERNEL_PATH=../seL4 -G Ninja ../awesome
```

Importantly, the path for `CMAKE_TOOLCHAIN_FILE` is resolved immediately by CMake, and so is
relative to the build directory, whereas the `KERNEL_PATH` is resolved whilst processing `awesome_system/awesome/CMakeLists.txt` and is relative to that directory.

The contents of `awesome_system/awesome/CMakeLists.txt` would be something like:

```cmake
cmake_minimum_required(VERSION 3.7.2)
include(../buildsystem/cmake-tool/base.cmake)
add_subdirectory(../seL4_libs seL4_libs)
include(../buildsystem/cmake-tool/configuration.cmake)
```

This looks pretty much like `all.cmake` except that we do not include `projects.cmake` as we do not have a
projects folder. `projects.cmake` would be redundant to include, as it would not resolve any files.
`all.cmake` cannot be included as we need to include specific subdirectories (in the example `seL4_libs`)
between setting up the base flags and environment and finalising the Configuration library.
We needed to give an explicit build directory (the second argument in `add_subdirectory`) as we are giving
a directory that is not a subdirectory of the root source directory.

For simplicity, the kernel path can be encoded directly into the projects top-level `CMakeLists.txt`. To
achieve this the following line:

```cmake
set(KERNEL_PATH ../seL4)
```

should be included before

```cmake
include(../buildsystem/cmake-tool/base.cmake)
```

in `awesome_system/awesome/CMakeLists.txt`, thus removing the need for `-DKERNEL_PATH` in the `cmake`
invocation.

### Configuration

For compatibility with the legacy build system, various helpers and systems exist in order to
achieve the following:

 * Automate configuration variables that appear in the `cmake-gui` with various kinds of dependencies.
 * Generate C-style configuration headers that declare these variables in format similar to the legacy build system.
 * Generate `autoconf.h` headers so legacy code using `#include <autoconf.h>` works.

The following fragment of CMake script demonstrates how these three things fit together:

```cmake
set(configure_string "")
config_option(EnableAwesome HAVE_AWESOME "Makes library awesome" DEFAULT ON)
add_config_library(MyLibrary "${configure_string}")
generate_autoconf(MyLibraryAutoconf "MyLibrary")
target_link_libraries(MyLibrary PUBLIC MyLibrary_Config)
target_link_libraries(LegacyApplication PRIVATE MyLibrary MyLibraryAutoconf)
```

In the above example, line by line:

 * `set(configure_string "")`: Initialise `configure_string` as blank, as various `config_*` helpers automatically append to this variable.
 * `config_option(EnableAwesome HAVE_AWESOME "Makes library awesome" DEFAULT ON)`: Declare a configuration
   variable which appears in CMake scripts and the `cmake-gui` as `EnableAwesome`, while appearing in C headers as `CONFIG_HAVE_AWESOME`.
 * `add_config_library(MyLibrary "${configure_string}")`: Generate a `MyLibrary_Config` target, which is an
 [interface library](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#interface-libraries) that has a generated C header based on the configuration string. Also add `MyLibrary` to
   a global list of configuration libraries, which can be used to generate a library containing
   contains "all the configurations in the system" (`autoconf.h` in the legacy build system).
 * `generate_autoconf(MyLibraryAutoconf "MyLibrary")`: Generates a `MyLibraryAutoconf` target, which is an
 [interface library](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#interface-libraries) that depends upon `MyLibrary_Config`, and provides an `autoconf.h` file including the configuration
   header from `MyLibrary_Config`.
 * `target_link_libraries(MyLibrary PUBLIC MyLibrary_Config)`: Allows `MyLibrary` to `#include` the generated
   configuration header by doing `#include <MyLibrary/gen_config.h>`
 * `target_link_libraries(LegacyApplication PRIVATE MyLibrary MyLibraryAutoconf)` Allows `LegacyApplication` to
   `#include <autoconf.h>` from `MyLibraryAutoconf`. The `autoconf.h` in this case will contain `#include <MyLibrary/gen_config.h>`.

For more details of the different `config_*` helpers read the comments on the functions in [kernel/tools/helpers.cmake](https://github.com/seL4/seL4/blob/master/tools/helpers.cmake).

### Helper functions

Several CMake functions exist for reuse in seL4 projects, which we now describe.

#### Kernel provided helpers

All of the helper functions described in the above section are provided in `tools/helpers.cmake` in the seL4 repository. Other functions in this file are only useful for the kernel build itself.

#### `cmake-tool` provided helpers

<!-- TODO once page defining root server exists, link -->
<!-- TODO once page describing how we use CPIO exists, link -->

These helper functions are provided for user-level projects, in `common.cmake` and
all the files in `helpers/`. Notable functions are:
- `DeclareRootserver(rootserver_target)`: Declares a CMake executable, `rootserver_target`, as the root server for
the system. This can only be used once in a project and does the following:
  - changes build flags for the target,
  - creates necessary extra targets for chain loading,
  - creates the `rootserver_image` target which will create the final binary images in `images`.
- `MakeCPIO`: Declares rules to create a linkable CPIO archive from a list of input files.
- `GenerateSimulateScript`: Creates a target called `simulate_gen` which will generate a `./simulate` shell script
  in the build directory for simulating the project on [QEMU](https://www.qemu.org/) if the target platform is supported. An application is
  responsible for ensuring that the system configuration can be simulated if it uses this function. Other functions are
  provided such as `SetSimulationScriptProperty` to allow the application's CMake scripts to customise the simulation
  command generated.
- `ApplyCommonSimulationSettings`: Attempts to change the kernel system configuration to disable
  features that are not compatible with simulation.
- `ApplyCommonReleaseVerificationSettings(release, verification)`: Sets flags for different combinations of
  'release' (performance optimized builds) and 'verification' (verification friendly features) builds. Please see [/Developing/Building/Using#Meta-configuration-options] for more detail on these options.

#### Other provided helpers

Projects such as [CAmkES](/CAmkES), the [CAmkES x86 VMM](/projects/camkes-vm/), and [Rumprun](https://github.com/seL4/rumprun-sel4-demoapps) may provide additional helper functions
to allow applications to configure themselves. Generally helper scripts will be called some variant
of `helpers.cmake`, and should be included in any CMake scripts that use them.
