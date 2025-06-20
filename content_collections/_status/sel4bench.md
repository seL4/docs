---
title: Project Status
project: sel4bench
permalink: projects/sel4bench/status.html
redirect_from:
  - status/sel4bench.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# seL4bench Project Status

This project status page lists the status for currently supported features, components
and configurations for seL4bench and who is responsible for maintaining them.
Some benchmark results are regularly updated on the [sel4.systems website](http://sel4.systems/About/Performance/).

## Features

### Benchmark runner

seL4bench requires itself to be started directly by seL4 as the root-task in the system.
This is the `sel4bench` binary and it then also serves as the main benchmark runner.
It runs the configured benchmarks and sets up a new environment for each benchmark to run in.
When a benchmark completes, it reports the results back to the runner and the runner prints
the results out as JSON once all the benchmarks have run. `sel4bench` is maintained
by the seL4 Foundation and is currently the only benchmark runner that is expected to
run benchmarks targeting sel4bench.

### Benchmarking environment

Each benchmark runs in a separate process environment. Currently there is only a single environment
that all benchmarking apps are expected to execute in. This environment defines the set of
system resources that each benchmark is given to run with, and also provides the configuration
options for each benchmark. Each benchmark is able to provide an init function and parse results function
that will get called in the main `sel4bench` app. Otherwise all benchmark functionality runs in the environment.

The `libsel4benchsupport` is a library that provides the environment functions that the benchmarks can call.
This library is maintained by the seL4 Foundation and is extended to support new features as new benchmarks are added.


### Benchmarks

{% include component_list.md project='sel4bench' type='sel4bench-application' %}

## Project manifests

{% include component_list.md project='sel4bench' type='repo-manifest' %}



## Configurations

Different configurations can have a large effect on the end results reported by the benchmarks.
Some benchmarks also won't work unless certain configurations are set. To make it easier
to configure a build of seL4bench that has the right configuration values set there is
a selection of meta-configuration options that are specific to seL4bench. These options
are listed below and will be interpreted by seL4bench and used to set sensible default
configuration values.

{% include component_list.md project='sel4bench' list='configurations' %}
