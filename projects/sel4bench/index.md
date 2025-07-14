---
project: sel4bench
toc: true
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# The sel4bench Suite

_sel4bench_ is an application and support library for benchmarking the
performance of the seL4 kernel.

A selection of benchmarking results are continually updated on the main [seL4
website](https://sel4.systems/performance.html#perf-numbers). The page also
shows the build options used to obtain those results.

Sources:

- <https://github.com/seL4/sel4bench-manifest>
- <https://github.com/seL4/sel4bench>

## Getting the code

First make sure you have [set up your
machine](../buildsystem/host-dependencies.html). Then run the following.

{%- assign manifest = "https://github.com/seL4/sel4bench-manifest.git" %}

```bash
mkdir sel4bench
cd sel4bench
repo init -u {{manifest}}
repo sync
```

This clones the seL4 kernel, the benchmarking suite including libraries, and
tools used in the build process. By default, the current master branch of the
kernel is cloned. To clone a specific version of the kernel and compatible
libraries and tools, replace the line

```bash
repo init {{manifest}}
```

above with e.g.:

```bash
repo init -u {{manifest}} -b refs/tags/{{site.sel4}}
```

This example clones version {{site.sel4}} of the kernel. For more information on
version numbers, see the [release page](../../releases.html) and the list of
[seL4 releases](../../releases/seL4.html).

## Building and running sel4bench

### Configuration

The CMake build environment supports a number of platforms. For information on
which ones these are and their corresponding CMake configuration arguments, see
the [Supported Platforms](../../Hardware) page.

For the available meta configuration options, see [below](#configuration-options).

For example, to enable the optional _Fault_ benchmark set and build for the
`sabre` platform, we would use the following invocation.

```bash
# create build directory
mkdir build
cd build
# configure build directory
../init-build.sh -DPLATFORM=sabre -DFAULT=ON
```

### Building

After you have configured the system, you can build it by running:

```bash
ninja
```

### Running it

The build step above will produce a bootable image file in the `images/`
directory. Please refer to the documentation of the respective build platform
for how to boot the specific board with such an image.

## Available Benchmarks

The following table lists the available benchmark sets. _Measured from user
space_ means that the benchmark is not instrumenting the kernel. This means it
measures unmodified kernel code, but may consequently have lower precision
than some of the other benchmarks.

{% include config_list.md project='sel4bench' list='components'
           type='sel4bench-application' code=false no_status=true %}

## Configuration Options

Kernel configuration settings can have a large effect on the end results
reported by the benchmarks. Some benchmarks will only work in certain
configurations. To make it easier to configure a build of seL4bench that has the
right configuration values set, use the meta-configuration options listed below.

{% include config_list.md project='sel4bench' %}

## Implementation

### Benchmark runner

seL4bench must be started directly by seL4 as the root-task in the system. This
is the `sel4bench` binary, which also serves as the main benchmark runner. It
runs the configured benchmarks and sets up a new environment for each benchmark
to run in. When a benchmark completes, it reports the results back to the runner
and the runner prints the results out as JSON once all the benchmarks have
completed.

### Benchmarking environment

Each benchmark runs in a separate process environment. Currently there is only a
single kind of environment that all benchmarking apps are expected to execute
in. This environment defines the set of system resources that each benchmark is
given to run with. It also provides the configuration options for each
benchmark. Each benchmark can provide an `init` function and a `parse_results`
function that will get called in the main `sel4bench` app. Otherwise all
benchmark functionality runs in the environment.

The `libsel4benchsupport` library provides environment functions that the
benchmarks can call.

### Adding a new benchmark

For adding new benchmarks see the [sel4bench repository
README](https://github.com/sel4/sel4bench/).
