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
# AARCH64_imx8mm_verified.cmake     ARM_hikey_verified.cmake
# AARCH64_imx8mq_verified.cmake     ARM_HYP_exynos5_verified.cmake
# AARCH64_imx93_verified.cmake      ARM_HYP_exynos5410_verified.cmake
# AARCH64_maaxboard_verified.cmake  ARM_HYP_verified.cmake
# AARCH64_odroidc2_verified.cmake   ARM_imx8mm_verified.cmake
# AARCH64_odroidc4_verified.cmake   ARM_MCS_verified.cmake
# AARCH64_rockpro64_verified.cmake  ARM_omap3_verified.cmake
# AARCH64_tqma_verified.cmake       ARM_tk1_verified.cmake
# AARCH64_tx1_verified.cmake        ARM_verified.cmake
# AARCH64_ultra96v2_verified.cmake  ARM_zynq7000_verified.cmake
# AARCH64_verified.cmake            ARM_zynqmp_verified.cmake
# AARCH64_zynqmp_verified.cmake     RISCV64_MCS_verified.cmake
# ARM_am335x_verified.cmake         RISCV64_verified.cmake
# ARM_bcm2837_verified.cmake        X64_verified.cmake
# ARM_exynos4_verified.cmake
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
address translation for devices (System MMU or IOMMU), debug/profiling/printing
interfaces, or the kernel startup at boot.

The proofs for RISCV64\_MCS/ARM\_MCS (mixed-criticality extensions to real-time
seL4 features), as well as confidentiality proofs for AARCH64 are in progress.
Refer to the [roadmap](https://sel4.systems/roadmap.html) for status and
upcoming features.

### Arm Aarch32 (`ARM`) {#ARM}

Configurations that start with `ARM` are verified configurations for the
AArch23 architecture. Those with `MCS` in the name indicate configurations for
the ongoing MCS verification. Proofs for all other `ARM_*` configurations are
completed.

The following features are supported by verification in AArch32 configurations:

- Architecture: ARMv7-A 32-bit, kernel running in EL1
- Floating point support: No
- Hypervisor mode: No ([see separate AArch32/Hypervisor configurations](#ARM_HYP))

The following properties are verified:

- C-level functional correctness, including fast path
- integrity and availability (access control)
- confidentiality (information flow)
- binary correctness, covering C functions that have C-level verification
- model-level functional correctness of the capDL user-level system initialiser/root task

The following seL4 AArch32 platforms are supported by verification:

{%- assign sorted = site.pages | sort: 'platform' %}
{%- for plat in sorted %}
{%- if plat.arm_hardware and plat.Maintained -%}
{%-   if plat.verification contains "ARM" %}
- [{{plat.platform}}]({{plat.url}})
{%-   endif %}
{%- endif %}
{%- endfor %}


### Arm Aarch32 in Hypervisor mode (`ARM_HYP`) {#ARM_HYP}

Configurations that start with `ARM_HYP` are verified configurations for the
AArch32 architecture with hypervisor mode enabled. The seL4 kernel runs as
hypervisor in EL2.

The following features are supported by verification in ARM_HYP configurations:

- Architecture: ARMv7-A 32-bit, kernel running in EL2
- Floating point support: No
- Hypervisor mode: Yes

The following properties are verified:

- C-level functional correctness, including fast path

The following seL4 AArch32 platforms with hypervisor mode are supported by
verification:

{%- assign sorted = site.pages | sort: 'platform' %}
{%- for plat in sorted %}
{%- if plat.arm_hardware and plat.Maintained -%}
{%-   if plat.verification contains "ARM_HYP" %}
- [{{plat.platform}}]({{plat.url}})
{%-   endif %}
{%- endif %}
{%- endfor %}


### Arm AArch64 (`AARCH64`) {#AARCH64}

Configurations that start with `AARCH64` are verified configurations for the
AArch64 architecture with hypervisor mode enabled. The seL4 kernel runs as
hypervisor in EL2.

The following features are supported by verification in AARCH64 configurations:

- Architecture: ARMv8-A 64-bit, kernel running in EL2
- Floating point support: Yes
- Hypervisor mode: Yes

The following properties are verified:

- C-level functional correctness, including fast path
- integrity and availability (access control)

Further properties are under development. See also the
[roadmap](https://sel4.systems/roadmap.html) for status and schedule.

The following seL4 AArch64 platforms are supported by verification:

{%- assign sorted = site.pages | sort: 'platform' %}
{%- for plat in sorted %}
{%- if plat.arm_hardware and plat.Maintained -%}
{%-   if plat.verification contains "AARCH64" %}
- [{{plat.platform}}]({{plat.url}})
{%-   endif %}
{%- endif %}
{%- endfor %}


### RISC-V 64-bit (`RISCV64`) {#RISCV64}

Configurations that start with `RISCV64` are verified configurations for the
RISC-V 64-bit architecture. Those with `MCS` in the name indicate configurations
for the ongoing MCS verification.

The following features are supported by verification in RISCV64 configurations:

- Architecture: RISC-V 64 bit
- Floating point support: No
- Hypervisor mode: No

The following properties are verified:

- C-level functional correctness, no fast path
- integrity and availability (access control)
- confidentiality (information flow)

The following seL4 RISCV64 platforms are supported by verification:

{%- assign sorted = site.pages | sort: 'platform' %}
{%- for plat in sorted %}
{%- if plat.riscv_hardware and plat.Maintained -%}
{%-   if plat.verification contains "RISCV64" %}
- [{{plat.platform}}]({{plat.url}})
{%-   endif %}
{%- endif %}
{%- endfor %}


### Intel x64 (`X64`) {#X64}

Configurations that start with `X64` are verified configurations for the
x86-64 architecture.

The following features are supported by verification in X64 configurations:

- Architecture: Intel x64
- Floating point support: Yes
- Hypervisor/VT-x mode: No

The following properties are verified:

- C-level functional correctness, no fast path

The following seL4 X64 platforms are supported by verification:

{%- assign sorted = site.pages | sort: 'platform' %}
{%- for plat in sorted %}
{%- if plat.arch == "x64" and plat.Maintained -%}
{%-   if plat.verification contains "X64" %}
- [{{plat.platform}}]({{plat.url}})
{%-   endif %}
{%- endif %}
{%- endfor %}
