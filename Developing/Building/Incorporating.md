# Incorporating into your project

<!--excerpt-->

This section describes how pieces of the build system fit together and how you might use it in a new project.
There are a few different pieces that can be fit together in different ways depending on your project's needs
and desired customisation. This is reflected in the split of CMake files spread across several repositories.

<!--excerpt-->

### Basic structure

The build system here is in two pieces. One piece is in the seL4 kernel repository, which has all of the basic
compiler toolchain and flags settings as well as helpers for generating configurations. The other piece is in seL4_tools/cmake-tool,
which has helpers for putting libraries and binaries together into a final system image (along with the kernel).

This structure means that the kernel is completely responsible for building itself, but exports the settings
it uses and the binaries it creates so that the rest of this build system can use it and build the final image.

The cmake-tool directory has the following files:

 * `README.md` What you are reading
 * `default-CMakeLists.txt` An example CMakeLists.txt file that you could use as the CMakeLists.txt file in
   your top level directory. All this does is include `all.cmake`, under the assumption of a directory structure
   where this repository is in a directory named `tools`. It is the intention that a projects manifest xml
   would symlink this to the top level and call it CMakeLists.txt
 * `all.cmake` Helper file that is just a wrapper around including `base.cmake`, `projects.cmake` and
   `configuration.cmake` This serves convenience for projects that just want to include those three files
   for a default configuration without making any changes between them
 * `base.cmake` Includes the kernel as a subdirectory, includes some files of common helper routines, sets up
   the basic compilation flags as exported by the kernel and then adds libsel4 and the elfloader-tool as
   buildable targets. This file essentially sets up the basic build targets (kernel, libsel4, elfloader) and
   flags after which you could start defining your own build targets through `add_subdirectory` or otherwise
 * `projects.cmake` Adds default build targets through `add_subdirectory` assuming a default project layout.
   Essentially it adds any CMakeLists.txt files it finds in any subdirectories of the projects directory
 * `configuration.cmake` Provides a target for a library called `Configuration` that emulates the legacy
   `autoconf.h` header. Since the `autoconf.h` header contained configuration variables for the *entire* project
   this rule needs to come after all other targets and scripts that might add to the configuration space.
 * `common.cmake` File included by `base.cmake` that has some generic helper routines. There should be no need
   to include this file directly
 * `flags.cmake` Sets up build flags and linker invocations based off the exported kernel flags. This is included
   by `base.cmake` and there should be no need to include this file directly
 * `init-build.sh` shell script that performs the initial configuration and generation for a new CMake build directory.
 * `helpers/*` helper functions that are commonly imported by `common.cmake`

### Kernel directory

For simplicity of the common case `base.cmake` defaults to assuming that the seL4 kernel is in directory called
`kernel` that is in the same directory of wherever `base.cmake` is included from. This means that if you have a
directory structure like

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

Then when `awesome_system/` is used used as the root source directory to initialise a CMake build directory
the `tools/cmake-tool/all.cmake` file is included, that then includes `base.cmake`, which will then look for
`awesome_system/kernel` as the directory of the kernel.

If you decided to put the kernel into a differently named directory, for example:

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

Then you could override the default kernel location by passing `-DKERNEL_PATH=seL4` when first invoking `cmake`

### Advanced structures

Suppose you wanted to completely go away from the normal directory structure and instead have something like

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

In this example there is

 * No `CMakeLists.txt` file in the root directory
 * `tools` directory has been renamed
 * `kernel` directory has been renamed
 * No `projects` directory

If we want the `CMakeLists.txt` in the `awesome_system/awesome` directory then would initialise CMake,
assuming a build directory that is also in the `awesome_system` directory, do something like

```sh
cmake -DCROSS_COMPILER_PREFIX=toolchain-prefix -DCMAKE_TOOLCHAIN_FILE=../seL4/gcc.cmake -DKERNEL_PATH=../seL4 -G Ninja ../awesome
```

What is important here is that the path for `CMAKE_TOOLCHAIN_FILE` is resolved immediately by CMake, and so is
relative to the build directory, where as the `KERNEL_PATH` is resolved whilst processing `awesome_system/awesome/CMakeLists.txt`
and so is relative to that directory.

The contents of `awesome_system/awesome/CMakeLists.txt` would be something like

```cmake
cmake_minimum_required(VERSION 3.7.2)
include(../buildsystem/cmake-tool/base.cmake)
add_subdirectory(../seL4_libs seL4_libs)
include(../buildsystem/cmake-tool/configuration.cmake)
```

This looks pretty much like `all.cmake` except that we do not include `projects.cmake` as we do not have a projects
folder. It wouldn't be harmful to include it since it would just resolve no files, but is redundant. We cannot
simply include `all.cmake` was we need to include our subdirectories (in this case just seL4_libs) between setting
up the base flags and environment and finalising the Configuration library. We needed to give an explicit build
directory (the second argument in `add_subdirectory`) as we are giving a directory that is not a subdirectory of
the root source directory.

For simplicity, the kernel path could be encoded directly into the projects CMakeLists.txt, so you could
add

```cmake
set(KERNEL_PATH ../seL4)
```

before

```cmake
include(../buildsystem/cmake-tool/base.cmake)
```

in `awesome_system/awesome/CMakeLists.txt`, removing the need for `-DKERNEL_PATH` in the `cmake` invocation.

### Configuration

To provide a configuration system that was compatible with how the previous build system provided configuration
various helpers and systems exist to:

 * Automate configuration variables that appear in the cmake-gui with various kinds of dependencies
 * Generate C configuration headers that declare these variables in format similar to what Kconfig did
 * Generate 'autoconf.h' headers so old code that does `#include <autoconf.h>` still work

A simple fragment of a CMake script that demonstrates how these three things fit together is

```cmake
set(configure_string "")
config_option(EnableAwesome HAVE_AWESOME "Makes library awesome" DEFAULT ON)
add_config_library(MyLibrary "${configure_string}")
generate_autoconf(MyLibraryAutoconf "MyLibrary")
target_link_libraries(MyLibrary PUBLIC MyLibrary_Config)
target_link_libraries(LegacyApplication PRIVATE MyLibrary MyLibraryAutoconf)
```

Stepping through line by line

 * `set(configure_string "")` for simplicity the various `config_*` helpers automatically add to a variable called
   `configure_string`, so we become by making sure this is blank
 * `config_option(EnableAwesome HAVE_AWESOME "Makes library awesome" DEFAULT ON)` this declares a configuration
   variable that will appear in CMake scripts and the cmake-gui as `EnableAwesome` and will appear in the generated
   C header as `CONFIG_HAVE_AWESOME`
 * `add_config_library(MyLibrary "${configure_string}")` generates a `MyLibrary_Config` target, which is an interface
   library that has a generated C header based on the provided configuration string. It also adds `MyLibrary` to
   a global list of configuration libraries. This global list can be used if you want to generate a library that
   contains "all the configurations in the system" (which is what the original `autoconf.h` was)
 * `generate_autoconf(MyLibraryAutoconf "MyLibrary")` generates a `MyLibraryAutoconf` target, which is an interface
   library that depends upon `MyLibrary_Config` and will provide an `autoconf.h` file that includes the configuration
   header from `MyLibrary_Config`
 * `target_link_libraries(MyLibrary PUBLIC MyLibrary_Config)` allows `MyLibrary` to `#include` the generated
   configuration header by doing `#include <MyLibrary/gen_config.h>`
 * `target_link_libraries(LegacyApplication PRIVATE MyLibrary MyLibraryAutoconf)` allows `LegacyApplication` to
   `#include <autoconf.h>` from `MyLibraryAutoconf`. The `autoconf.h` in this case will contain `#include <MyLibrary/gen_config.h>`

For more details of the different `config_*` helpers read the comments on the functions in `kernel/tools/helpers.cmake`

