---
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
| Multi-core support | Merged, available in 2.1.0 | Q4'25 | [PR #353](https://github.com/seL4/microkit/pull/353) |
| [x86 support](#x86) | Merged, available in 2.1.0 | Q4'25 | [PR #337](https://github.com/seL4/microkit/pull/337) |
| [Multi-kernel support](#multikernel) | Actively worked on. | Q4'25 | [Branch](https://github.com/au-ts/multikernel-manifest/) |
| [PD templates](#templates) | Initial work explored, requires more experimentation and development. | Q1'26 | N/A |

## Feature details

### x86 support {#x86}

x86-64 support is available in the latest Microkit (since [PR #337](https://github.com/seL4/microkit/pull/337)),
but not in an available release. The next release will contain x86-64 support.

### Multi-kernel support {#multikernel}

seL4 supports running on multiple cores, however there are no verified multi-core configurations.
As verified multi-core is a while away, one strategy to get a multi-core system working with
single-core seL4 is to run an instance of seL4 on each core. This feature requires a number of internal
changes but should be mostly transparent to the user.

This is being actively worked on, more details can be found [here](https://github.com/au-ts/multikernel-manifest/).

### PD templates {#templates}

Microkit systems have a 'static architecture', each PD declares what resources it needs at
build-time. This restriction provides useful properties but can be too limiting for certain
systems.

PD templates aim to allow PDs to be loaded at run-time and claim different resources. The
total potential resources any PD might have at a given time is still known at build-time,
but this allows some flexibilty particularly when doing something like live-upgrading a
system.

This feature is still in the somewhat early stages so is unlikely to be available soon.
