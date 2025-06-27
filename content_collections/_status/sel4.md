---
project: sel4
permalink: /projects/sel4/status.html
redirect_from:
  - status/sel4.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# seL4 Project Status

The seL4 project contains a lot of different features and components that work across
different hardware platforms and configurations. This page tries to give an overview
of what exists, its development status, what level of support it has, who is
responsible for maintaining it and where to find more information.

## Verification Status

See status about [Verified Configurations](/projects/sel4/verified-configurations.html)

## Features

### Architectures

{% include component_list.md project='sel4' list='features' type='architecture' %}

### Virtualization extensions

{% include component_list.md project='sel4' list='features' type='hyp-support' %}

### Multicore

{% include component_list.md project='sel4' list='features' type='smp-support' %}


### Mixed criticality

{% include component_list.md project='sel4' list='features' type='mcs-support' %}


### Fastpath
{% include component_list.md project='sel4' list='features' type='fastpath-support' %}


### IOMMU

{% include component_list.md project='sel4' list='features' type='iommu-support' %}

## Hardware platforms

See status about [Supported platforms](/Hardware).


## Components

Components are parts of the project that are more likely to be independent or substituted
with other components.  They can also be used as building blocks in parts of a wider system.

### Verified configurations

A veried configuration is a CMake settings file that is expected to produce a unique kernel
image that can be used as an input to he L4.verified project for verification.
See [Verified Configurations](/projects/sel4/verified-configurations.html) for more information.
A verified configuration can be imported into a CMake build system that targets seL4 to set
valid verification compatible configuration options. It can also be used to produce a standalone
kernel image.

{% include component_list.md project='sel4' type='sel4-configuration' %}

### libsel4

The libsel4 contains the interface that seL4 provides to user-level threads, including system calls,
capability types, and definitions of the key data structures (e.g., boot_info).
### Manual

The manual contains the source files for generating the [seL4 reference manual](https://sel4.systems/Info/Docs/seL4-manual-latest.pdf).

### Kernel drivers

#### Timer
{% include component_list.md project='sel4' type='kernel-driver-timer' %}


#### Serial
{% include component_list.md project='sel4' type='kernel-driver-serial' %}


#### Interrupt controllers
{% include component_list.md project='sel4' type='kernel-driver-irq' %}

#### IOMMUs
{% include component_list.md project='sel4' type='kernel-driver-iommu' %}


### Device trees
{% include component_list.md project='sel4' type='kernel-device-tree' %}


## Testing and Benchmarking

### Testing

In addition to its verification, there is also an seL4 test suite [sel4test](/projects/sel4test)
that can be built for a particular seL4 configuration.  The test suite is self-hosted and starts
as the initial roottask on seL4.

### Benchmarking

A suite of benchmarks for measuring different seL4 operations are provided by [sel4bench](/projects/sel4bench).
This project is also built as a self-hosted root-task application on seL4.

## Configurations

seL4 has several different options available for configuring seL4 to execute in different
scenarios. Many of these options are only expected to used during application or kernel
development and may not be suitable for a final release deployment that wants to leverage
seL4's full capabilities.

*Due to the experimental nature of many of the options, there may be undocumented incompatabilities
when trying to configure several options together. seL4test, seL4bench or other user level examples
can be used to test a baseline level of configuration correctness.*

### Generic configuration options

{% include component_list.md project='sel4' list='configurations' type='generic' %}


### Scheduling configuration options
{% include component_list.md project='sel4' list='configurations' type='scheduling' %}


### Debug configuration options
{% include component_list.md project='sel4' list='configurations' type='debug' %}

### Performance analysis and profiling configuration options
{% include component_list.md project='sel4' list='configurations' type='profiling' %}

### Target hardware architecture/platform options

{% include component_list.md project='sel4' list='configurations' type='platform' %}

#### x86

{% include component_list.md project='sel4' list='configurations' type='platform-x86' %}

#### Arm
{% include component_list.md project='sel4' list='configurations' type='platform-arm' %}
