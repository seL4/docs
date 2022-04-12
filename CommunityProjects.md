---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Community Projects

This page collects seL4-based projects. If you know of a project that
you'd like to be listed here, add it.

## Application areas

The seL4 kernel is currently used in various projects from different application
areas:

- Automotive
- Aviation, e.g.
  - [SMACCM](https://trustworthy.systems/projects/TS/SMACCM)
  - [CASE](https://trustworthy.systems/projects/TS/CASE)
- Connected Consumer Devices
- SCADA, e.g.
  - [Laot](https://trustworthy.systems/projects/TS/laot)
- Spaceflight, e.g.
  - [UNSW QB50](https://trustworthy.systems/projects/TS/qb50) satellite
- Virtualization
  - [in general](https://trustworthy.systems/projects/TS/virtualisation/about)
      and especially for [Linux](https://trustworthy.systems/projects/TS/virtualisation)

See also the list of [Projects at Trustworthy Systems](https://trustworthy.systems/projects)

## OS Personalities and Frameworks

- [CamkES](https://trustworthy.systems/projects/TS/camkes) to build
    [Trustworthy components](https://trustworthy.systems/projects/TS/trustcomp)
- [seL4 Core Platform](https://github.com/BreakawayConsulting/sel4cp)
personality for seL4
- [Genode](https://genode.org)
- [RefOS](https://github.com/seL4/refos) was created as reference OS
- [Neptune OS](https://github.com/cl91/NeptuneOS) is a WinNT personality
- [UX/RT](https://gitlab.com/uxrt) is a QNX-like and Linux-compatible OS
personality for seL4

## Languages and Runtimes

- C is the default seL4 language
- C++
- Rust:
  - The [Robigalia](https://rbg.systems) project:
      building a robust Rust ecosystem around seL4
  - [ferros](https://github.com/auxoncorp/ferros):
      A Rust-based userland which also adds compile-time assurances to seL4 development.
- Python
- [WasmEdge](https://github.com/WasmEdge/WasmEdge) for
    [porting a Cloud-native WebAssembly Runtime to seL4](https://github.com/second-state/wasmedge-seL4)
- [Ivory](http://ivorylang.org/ivory-introduction.html)
- [Pancake](https://trustworthy.systems/projects/TS/drivers/pancake)
