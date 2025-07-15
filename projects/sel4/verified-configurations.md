---
redirect_from:
  - /VerifiedConfigurations
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Verified Configurations

This page describes which architecture/platform/configuration combinations of
seL4 have verified properties, which configurations possess which properties,
and how to obtain an seL4 version for a specified configuration. For an overview
of these properties and their explanations, please see the [verification page on
the seL4 website](https://sel4.systems/Verification/). The [Frequently Asked
Questions](https://sel4.systems/About/FAQ.html#verification) also as a section
on the formal verification of seL4.

The formal proofs for seL4 are hosted at <https://github.com/seL4/l4v>.  They
are written in the [Isabelle/HOL](https://isabelle.in.tum.de) theorem prover. See
the [README](https://github.com/seL4/l4v/) file in the l4v repository for build
and setup instructions if you want to run and check the proofs against a
specific version and configuration of seL4.

## Examining and Building Verified Configurations

Current verified configurations can be found in seL4 sources in the
`configs` folder:

```sh
cd configs/
ls *_verified.cmake
# AARCH64_bcm2711_verified.cmake    ARM_exynos5410_verified.cmake
# AARCH64_hikey_verified.cmake      ARM_exynos5422_verified.cmake
# AARCH64_odroidc2_verified.cmake   ARM_hikey_verified.cmake
# AARCH64_odroidc4_verified.cmake   ARM_imx8mm_verified.cmake
# AARCH64_verified.cmake            ARM_tk1_verified.cmake
# AARCH64_zynqmp_verified.cmake     ARM_verified.cmake
# ARM_HYP_exynos5410_verified.cmake ARM_zynq7000_verified.cmake
# ARM_HYP_exynos5_verified.cmake    ARM_zynqmp_verified.cmake
# ARM_HYP_verified.cmake            RISCV64_MCS_verified.cmake
# ARM_MCS_verified.cmake            RISCV64_verified.cmake
# ARM_exynos4_verified.cmake        X64_verified.cmake
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

Also see [standalone seL4 builds](../buildsystem/standalone.md) for
general guidelines on generating an seL4 binary and build system information
from an existing configuration.

## Available Verified Configurations

### Unverified Features

At present, none of our verified configurations take into account
address translation for devices (System MMU or IOMMU), debug/profiling
interfaces, or the kernel startup at boot.

The proofs for RISCV64\_MCS/ARM\_MCS (mixed-criticality extensions to real-time
seL4 features), as well as security proofs for AARCH64 are in progress. Refer to
the [roadmap](https://sel4.systems/roadmap.html) for status and upcoming features.

### ARM Sabre Lite

| File | `ARM_verified.cmake`
| Architecture | ARMv7, 32 bit
| Platform | i.MX6 (Sabre Lite)
| Floating-point support | No
| Hypervisor mode | No
| **Verified properties** | functional correctness incl fast path, integrity (access control), confidentiality (information flow), binary correctness (covers all verified C code), user-level system initialisation

### ARM Exynos 4 {#exynos4}

| File | `ARM_exynos4_verified.cmake`
| Architecture | ARMv7, 32 bit
| Platform | Exynos4412
| Floating-point support | No
| Hypervisor mode | No
| **Verified properties** | functional correctness incl fast path, integrity (access control), confidentiality (information flow), binary correctness (covers all verified C code), user-level system initialisation

### ARM Exynos 5

| File | `ARM_exynos5410_verified.cmake` and `ARM_exynos5422_verified.cmake`
| Architecture | ARMv7, 32 bit
| Platform | Exynos5410 and Exynos5422
| Floating-point support | No
| Hypervisor mode | No
| **Verified properties** | functional correctness incl fast path, integrity (access control), confidentiality (information flow), binary correctness (covers all verified C code), user-level system initialisation

### ARM Hikey

| File | `ARM_hikey_verified.cmake`
| Architecture | ARMv7, 32 bit
| Platform | HiKey
| Floating-point support | No
| Hypervisor mode | No
| **Verified properties** | functional correctness incl fast path, integrity (access control), confidentiality (information flow), binary correctness (covers all verified C code), user-level system initialisation

### ARM TK1 {#tk1}

| File | `ARM_tk1_verified.cmake`
| Architecture | ARMv7, 32 bit
| Platform | Jetson TK1
| Floating-point support | No
| Hypervisor mode | No
| **Verified properties** | functional correctness incl fast path, integrity (access control), confidentiality (information flow), binary correctness (covers all verified C code), user-level system initialisation

### ARM Zynq7000 {#zynq7000}

| File | `ARM_zynq7000_verified.cmake`
| Architecture | ARMv7, 32 bit
| Platform | Zynq7000
| Floating-point support | No
| Hypervisor mode | No
| **Verified properties** | functional correctness incl fast path, integrity (access control), confidentiality (information flow), binary correctness (covers all verified C code), user-level system initialisation


### ARM ZynqMP

| File | `ARM_zynqmp_verified.cmake`
| Architecture | ARMv7, 32 bit
| Platform | ZCU102 and ZCU106 in 32 bit mode
| Floating-point support | No
| Hypervisor mode | No
| **Verified properties** | functional correctness incl fast path, integrity (access control), confidentiality (information flow), binary correctness (covers all verified C code), user-level system initialisation

### ARM IMX8MM-EVK {#imx8mm}

| File | `ARM_imx8mm_verified.cmake`
| Architecture | ARMv7, 32 bit
| Platform | IMX8MM-EVK
| Floating-point support | Yes
| Hypervisor mode | No
| **Verified properties** | functional correctness incl fast path

### ARM\_HYP TK1

File | `ARM_HYP_verified.cmake`
Architecture | ARMv7, 32 bit
Platform | Tegra TK1
Floating-point support | No
Hypervisor mode | Yes
**Verified properties** | functional correctness, incl fast path

### ARM\_HYP Exynos5

File | `ARM_HYP_exynos5_verified.cmake` and `ARM_HYP_exynos5410_verified.cmake`
Architecture | ARMv7, 32 bit
Platform | Odroid XU and Odroid XU4
Floating-point support | No
Hypervisor mode | Yes
**Verified properties** | functional correctness, incl fast path

### ARM\_MCS

File | `ARM_MCS_verified.cmake`
Architecture | ARMv7, 32 bit
Platform | i.MX 6 (Sabre Lite)
Floating-point support | No
Hypervisor mode | No
Mixed-Criticality-Systems API | Yes
**Verified properties** | in progress (design-level functional correctness completed)

### AARCH64

| File | `AARCH64_verified.cmake`
| Architecture | ARMv8, 64 bit
| Platform | Tegra X2 (Jetson TX2)
| Floating-point support | Yes
| Hypervisor mode | Yes
| **Verified properties** | functional correctness, incl fast path completed; integrity proof in progress

### AARCH64 RPI4 {#bcm2711}

| File | `AARCH64_bcm2711_verified.cmake`
| Architecture | ARMv8, 64 bit
| Platform | BMC2711 (Raspberry Pi 4)
| Floating-point support | Yes
| Hypervisor mode | Yes
| **Verified properties** | functional correctness, incl fast path completed; integrity proof in progress

### AARCH64 Hikey {#hikey}

| File | `AARCH64_hikey_verified.cmake`
| Architecture | ARMv8, 64 bit
| Platform | HiKey
| Floating-point support | Yes
| Hypervisor mode | Yes
| **Verified properties** | functional correctness, incl fast path completed; integrity proof in progress

### AARCH64 Odroid C2 {#odroidc2}

| File | `AARCH64_odroidc2_verified.cmake`
| Architecture | ARMv8, 64 bit
| Platform | OdroidC2
| Floating-point support | Yes
| Hypervisor mode | Yes
| **Verified properties** | functional correctness, incl fast path completed; integrity proof in progress

### AARCH64 Odroid C4 {#odroidc4}

| File | `AARCH64_odroidc4_verified.cmake`
| Architecture | ARMv8, 64 bit
| Platform | OdroidC4
| Floating-point support | Yes
| Hypervisor mode | Yes
| **Verified properties** | functional correctness, incl fast path completed; integrity proof in progress

### AARCH64 ZynqMP {#zynqmp}

| File | `AARCH64_zynqmp_verified.cmake`
| Architecture | ARMv8, 64 bit
| Platform | ZynqMP (ZCU102 and ZCU106)
| Floating-point support | Yes
| Hypervisor mode | Yes
| **Verified properties** | functional correctness, incl fast path completed; integrity proof in progress

### RISCV64

File | `RISCV64_verified.cmake`
Architecture | RISC-V 64-bit
Platform | HiFive
Floating-point support | No
Hypervisor mode | No
**Verified properties** | functional correctness, integrity (access control), confidentiality (information flow); verification of fast path in progress

### RISCV64\_MCS

File | `RISCV64_MCS_verified.cmake`
Architecture | RISC-V 64-bit
Platform | HiFive
Floating-point support | No
Hypervisor mode | No
Mixed-Criticality-Systems API | Yes
**Verified properties** | C verification in progress (design-level functional correctness completed)

### X64

File | `X64_verified.cmake`
Architecture/Platform | X86 64-bit
Floating-point support | Yes
Hypervisor mode | No
**Verified properties** | functional correctness, no fast path