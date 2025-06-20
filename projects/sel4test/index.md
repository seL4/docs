---
redirect_from:
  - /seL4Test

project: sel4test
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# seL4Test

[sel4test](https://github.com/seL4/sel4test-manifest) is a test suite for seL4.

First make sure you have
[set up your machine](/HostDependencies#sel4-build-dependencies).

## Getting the Code

```bash
mkdir sel4test
cd sel4test
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
ls
# apps/ CMakeLists.txt init-build.sh kernel libs/ projects/ tools/
```

This clones the seL4 kernel, the test suite, some libraries used by the
tests, and some tools used in the build process. By default, the current
master branch of the kernel is cloned. To clone a specific version of
the kernel and compatible libraries and tools, replace the
```
repo init
```
line above with:
```
repo init -u https://github.com/seL4/sel4test-manifest.git -b refs/tags/{{site.sel4_master}}
```

In this example we clone version {{site.sel4_master}} of the kernel. For more information on version
numbers, see [ReleaseProcess](/ReleaseProcess#version-numbers).

## Build it
### Configuration

The CMake build environment supports a number of platforms. For information regarding our supported hardware platforms and their corresponding CMake
configuration arguments, see the [Supported Platforms](/Hardware) page. Platforms that we test and are in-regression are listed as being maintained by the seL4 Foundation.

To start a build with a specific configuration we can create a new subdirectory from the project root
and initialise it with CMake:

```
# create build directory
mkdir build
cd build
# configure build directory
../init-build.sh -DPLATFORM=<platform-name> -DRELEASE=[TRUE|FALSE] -DSIMULATION=[TRUE|FALSE]
```
This configures your build directory with the necessary CMake configuration for your chosen platform.

You can look at and edit the CMake configuration options from your build directory using

```
ccmake .
```

It is also important to note that meta options such as `PLATFORM` and `SIMULATION` will override various settings in the
seL4test build system in order to maintain the meta configuration. This can however be disabled if you first
enable the `Sel4testAllowSettingsOverride` variable.

### Useful configuration options
For an overview of the CMake build system and further configuration options, including configuring for
cross compilation (targeting ARM), see [seL4's CMake Build System](/Developing/Building/Using).

## Building
When you've configured the system, you can build it by running:

```
ninja
```

## Running it

### IA32 Example
We will now build seL4test for ia32, to run on the QEMU simulator.

Passing `-DSIMULATION=TRUE` to CMake produces a script to simulate our release ia32 build. The following commands
will configure our CMake build:

```bash
mkdir ia32_build
cd ia32_build
../init-build.sh -DPLATFORM=ia32 -DRELEASE=TRUE -DSIMULATION=TRUE
```

Build it:
```
ninja
```

Executing the following commands will run qemu and point it towards the image we just built:
```
./simulate
...
ELF-loading userland images from boot modules:
size=0x1dd000 v_entry=0x806716f v_start=0x8048000 v_end=0x8225000 p_start=0x21f000 p_end=0x3fc000
Moving loaded userland images to final location: from=0x21f000 to=0x12e000 size=0x1dd000
Starting node #0 with APIC ID 0
Booting all finished, dropped to user space
...
Starting test 18: BIND0001
Running test BIND0001 (Test that a bound tcb waiting on a sync endpoint receives normal sync ipc and notification notifications.)
Test BIND0001 passed
Starting test 19: BIND0002
Running test BIND0002 (Test that a bound tcb waiting on its bound notification recieves notifications)
Test BIND0002 passed
Starting test 20: BIND0003
Running test BIND0003 (Test IPC ordering 1) bound tcb waits on bound notification 2, true) another tcb sends a message)
Test BIND0003 passed
...
```
To exit qemu, press `Ctrl-a`, then `x`. The text string` All is well in the universe` indicates a successful build.

We can further configure the test suite build to print out JUnit-style XML. Thus enabling the output to be parsed by various tools.
To do so, edit the build settings through `ccmake`, enabling the `Sel4testAllowSettingsOverride` and `LibSel4TestPrintXML` variables.

## Testing a Customised Kernel

Suppose you've got seL4 checked out in `~/projects/seL4`, and sel4test in
`~/tests/sel4test`, and you have been making changes on a feature branch of seL4 named
`awesome-new-feature`. You want to test if your modified kernel
still passes all the tests in sel4test.

```bash
cd ~/tests/sel4tests/kernel
git remote add feature ~/projects/seL4
git fetch feature
git checkout feature/awesome-new-feature
cd ..
```

Now the kernel in sel4test has been changed to your custom kernel.
Now just build and run the test suite as above.

## Running a subset of the tests
You can use a regular expression to select a subset of the
tests. This can be configured by setting the CMake variable `LibSel4TestPrinterRegex`. We can modify this
variable by running `ccmake .` in our build directory. By default the test suite runs all tests.
