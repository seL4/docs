---
toc: true
redirect_from:
  - /VerifiedConfigurations
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Verified Configurations

This page describes which architecture/platform/configuration
combinations of seL4 have verified properties, which configurations
possess which properties, and how to obtain an seL4 version for a
specified configuration.

At this time, verification of seL4 remains a more time-intensive process
than software development. Consequently, while seL4 has been ported to
multiple architectures, and its build system allows further
configuration of internal and hardware features, verified configurations
are necessarily both less numerous and more specific.

These configurations are also referred to as *verification platforms*,
currently constituting: AARCH64, ARM, ARM\_HYP, X64, RISCV64, ARM\_MCS, RISCV64\_MCS

Please consult [Frequently Asked
Questions](/FrequentlyAskedQuestions), as well as the [proof and
assumptions page](http://sel4.systems/Info/FAQ/proof.pml) for a better
understanding of the intersection of verification and seL4.

## Examining and Building Verified Configurations

Current verified configurations can be found in seL4 sources in the
`configs` folder:
```sh
ls configs/*_verified.cmake
#configs/AARCH64_verified.cmake     configs/RISCV64_MCS_verified.cmake
#configs/ARM_HYP_verified.cmake     configs/RISCV64_verified.cmake
#configs/ARM_MCS_verified.cmake     configs/X64_verified.cmake
#configs/ARM_verified.cmake
```

To obtain specific source code and build for a given configuration (e.g.
ARM) in a build directory:
```sh
mkdir build
cd build
cmake -P ../config/ARM_verified.cmake
```

Notably ``kernel.elf`` is the kernel binary, and ``kernel_all_pp.c`` is
the kernel source code after preprocessing, which is used as the basis
for verification efforts.

Also see [Stand-alone seL4 builds](/Developing/Building/seL4Standalone)
for general guidelines on generating an seL4 binary from an existing
configuration and what to do with a ``kernel.elf`` file.

## Available Verified Configurations

### Unverified Features

At present, none of our verified configurations take into account
address translation for devices (System MMU or IOMMU), debug/profiling
interfaces, or the kernel startup at boot.

The proofs for RISCV64\_MCS/ARM\_MCS (mixed-criticality extensions to real-time
seL4 features), as well as proofs for AARCH64 are in progress. Refer to the
[roadmap](/projects/roadmap.html) for status and upcoming features.

## ARM

| File | `ARM_verified.cmake`
| Architecture | ARMv7
| Platform | iMX.6 (e.g. Sabre Lite)
| Floating-point support | No
| Hypervisor mode | No
| **Verified properties** | functional correctness incl fast path, integrity (access control), confidentiality (information flow), binary correctness (covers all verified C code), user-level system initialisation

## ARM_MCS

File | `ARM_MCS_verified.cmake`
Architecture | ARMv7
Platform | iMX.6 (e.g. Sabre Lite)
Floating-point support | No
Hypervisor mode | No
Mixed-Criticality-Systems API | Yes
**Verified properties** | in progress (design-level functional correctness completed)

## ARM\_HYP

File | `ARM_HYP_verified.cmake`
Architecture | ARMv7
Platform | Tegra TK1
Floating-point support | No
Hypervisor mode | Yes
**Verified properties** | functional correctness, incl fast path

## AARCH64

| File | `AARCH64_verified.cmake`
| Architecture | ARMv8
| Platform | Tegra X2 (e.g. Jetson TX2)
| Floating-point support | Yes
| Hypervisor mode | Yes
| **Verified properties** | in progress

## X64

File | `X64_verified.cmake`
Architecture/Platform | x86 64-bit
Floating-point support | Yes
Hypervisor mode | No
**Verified properties** | functional correctness, no fast path

## RISCV64

File | `RISCV64_verified.cmake`
Architecture | RISC-V 64-bit
Platform | HiFive
Floating-point support | No
Hypervisor mode | No
**Verified properties** | functional correctness, integrity (access control), confidentiality (information flow); verification of fast path in progress

## RISCV64_MCS

File | `RISCV64_MCS_verified.cmake`
Architecture | RISC-V 64-bit
Platform | HiFive
Floating-point support | No
Hypervisor mode | No
Mixed-Criticality-Systems API | Yes
**Verified properties** | C verification in progress (design-level functional correctness completed)
