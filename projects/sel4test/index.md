---
redirect_from:
  - /seL4Test
toc: true
project: sel4test
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# seL4Test

seL4test is a test suite for seL4. It is useful for developing seL4 itself, for
making sure that your development environment is set up correctly, and for
validating properties that are not part of the formal verification of seL4.

Sources:

- <https://github.com/seL4/sel4test-manifest>
- <https://github.com/seL4/sel4test>


## Getting the Code

First make sure you have [set up your
machine](../buildsystem/host-dependencies.html). Then run the following.

{%- assign manifest = "https://github.com/seL4/sel4test-manifest.git" %}

```bash
mkdir sel4test
cd sel4test
repo init -u {{manifest}}
repo sync
ls
# apps/ CMakeLists.txt init-build.sh kernel libs/ projects/ tools/
```

This clones the seL4 kernel, the test suite, some libraries used by the
tests, and some tools used in the build process. By default, the current
master branch of the kernel is cloned. To clone a specific version of
the kernel and compatible libraries and tools, replace the line

```bash
repo init {{manifest}}
```

above with e.g.:

```bash
repo init -u {{manifest}} -b refs/tags/{{site.sel4}}
```

In this example we clone version {{site.sel4}} of the kernel. For more
information on version numbers, see the [release page](../../releases.html) and
the list of [seL4 releases](../../releases/seL4.html).

## Building seL4test

### Configuration

The CMake build environment supports a number of platforms. For information on
which ones these are and their corresponding CMake configuration arguments, see
the [Supported Platforms](../../Hardware) page.

To start a build with a specific configuration we can create a new subdirectory
from the project root and initialise it with `init-build`:

```bash
# create build directory
mkdir build
cd build
# configure build directory
../init-build.sh -DPLATFORM=<platform-name> -DRELEASE=[TRUE|FALSE] -DSIMULATION=[TRUE|FALSE]
```

This configures your build directory with the necessary CMake configuration for
your chosen platform.

You can look at and edit the CMake configuration options from your build
directory using

```bash
ccmake .
```

It is also important to note that meta options such as `PLATFORM` and
`SIMULATION` will override various settings in the seL4test build system in
order to maintain the meta configuration. If you want to control these settings
yourself, this behaviour can be disabled by setting the
`Sel4testAllowSettingsOverride` variable.


### Building

When you've configured the system, you can build it by running:

```bash
ninja
```

## Running it

### IA32 Example

We will now build seL4test for IA32, to run on the QEMU simulator.

Passing `-DSIMULATION=TRUE` to CMake produces a script to simulate our release
IA32 build. The following commands will configure our CMake build:

```bash
mkdir ia32_build
cd ia32_build
../init-build.sh -DPLATFORM=ia32 -DRELEASE=TRUE -DSIMULATION=TRUE
```

Build it:

```bash
ninja
```

Executing the following commands will run QEMU and point it towards the image we
just built:

```bash
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

To exit QEMU, press `Ctrl-a`, then `x`. The text `All is well in the
universe` indicates a successful build.

## Testing a Customised Kernel

Suppose you've got seL4 checked out in `~/projects/seL4`, and `sel4test` in
`~/tests/sel4test`, and you have been making changes on a feature branch of seL4
named `awesome-new-feature`. You want to test if your modified kernel still
passes all the tests in `sel4test`:

```bash
cd ~/tests/sel4tests/kernel
git remote add feature ~/projects/seL4
git fetch feature
git checkout feature/awesome-new-feature
cd ..
```

Now the kernel in `sel4test` has been changed to your custom kernel.
Now just build and run the test suite as above.

## Running a subset of the tests

You can use a regular expression to select a subset of the tests. This can be
configured by setting the CMake variable `LibSel4TestPrinterRegex`. We can
modify this variable by running `ccmake .` in our build directory. By default
the test suite runs all tests.

## Configuration Options

The set of tests that get run will be different for different kernel
configurations. Each test can specify config requirements that will prevent the
test from being run if a certain config option is incompatible. This means that
changing the build configuration can change which tests will be run. To make it
easier to configure a build of seL4test that enables the right coverage of
tests, seL4test provides a selection of meta-configuration options, listed
below.

{% include component_list.md
           project='sel4test' list='configurations'
           status='Value' code='true' %}

For an overview of the CMake build system and further configuration options for
the kernel, including configuring for cross compilation (e.g., targeting Arm or
RISC-V on an x86 build machine), see the page on seL4's [CMake Build
System](../buildsystem/using.html).

## Implementation

This section gives a short overview of the implementation architecture of the
test suite.

### Test runner

seL4test must be started directly by seL4 as the root-task in the
system. This is the `sel4test-driver` binary, which also serves as the main
test runner. It runs the configured tests and sets up the required
environment for each test. It prints out test results over a serial connection.

### Test environments

Each test runs in a test environment. This environment provides the test with an
expected set of system resources required for it to run. There are currently two
test environments, listed below. It is possible to define more, for instance for
different system dependencies of the tests.

{% include component_list.md project='sel4test' type='test-environment' no_status=true %}


### Test declarations

Tests can be declared in any library that can be linked with sel4test
applications. A test is defined by using a preprocessor macro defined by its
test environment. This will place the test into a named linker section that the
test runner will use to launch the test at runtime inside its requested
environment.

See the [sel4test repository README](https://github.com/seL4/sel4test) for more
information on how to add new tests.
