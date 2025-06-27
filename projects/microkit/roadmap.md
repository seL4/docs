---
title: Microkit roadmap
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 UNSW
---

# Microkit roadmap

Microkit is actively developed and so there are various features that
intend to be added to support the community's needs.

This page talks about major features, for smaller improvements or
bugs see [GitHub issues](https://github.com/seL4/microkit/issues).

If you have a particular feature that is not listed here or need clarity
on its status, please [open an issue on GitHub](https://github.com/seL4/microkit/issues)
or [contact the developers](https://sel4.systems/support.html).

| Feature | Current status | Timeline | Availability |
|-----------------------------------------------------------|
| Multi-core support | Working state, needs cleanup for merging. | Q3'25 | [Branch 'smp'](https://github.com/seL4/microkit/tree/smp) |
| [x86 support](#x86) | Actively worked on | Q4'25 | [PR #244](https://github.com/seL4/microkit/pull/244) |
| [Multi-kernel support](#multikernel) | Actively worked on. | Q4'25 | N/A |
| [PD templates](#templates) | Initial work explored, requires more experimentation and development. | Q1'26 | N/A |

## Feature details

### x86 support {#x86}

Microkit support AArch64 and RISC-V (64-bit), x86-64 support is being worked on. There
has been initial work to get x86-64 working however there are some remaining issues that
need to be resolved before merging is possible.

Most of the current friction with x86 is that, unlike ARM and RISC-V, the hardware layout
(e.g main memory and devices) is not statically known which is currently what Microkit
expects. We are working on addressing this.

### Multi-kernel support {#multikernel}

seL4 supports running on multiple cores, however there are no verified multi-core configurations.
As verified multi-core is a while away, one strategy to get a multi-core system working with
single-core seL4 is to run an instance of seL4 on each core. This feature requires a number of internal
changes but should be mostly transparent to the user.

This is being actively worked on.

### PD templates {#templates}

Microkit systems have a 'static architecture', each PD declares what resources it needs at
build-time. This restriction provides useful properties but can be too limiting for certain
systems.

PD templates aim to allow PDs to be loaded at run-time and claim different resources. The
total potential resources any PD might have at a given time is still known at build-time,
but this allows some flexibilty particularly when doing something like live-upgrading a
system.

This feature is still in the somewhat early stages so is unlikely to be available soon.
