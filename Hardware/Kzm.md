---
archive: true
simulation_target: true
simulation_only: false
cmake_plat: kzm
xcompiler_arg: -DAARCH32=1
platform: KZM
arch: ARMv6A
virtualization: false
iommu: false
soc: i.MX31
cpu: ARM1136J
Status: Unverified
Contrib: Data61
Maintained: false
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# KZM (Deprecated seL4 platform)

**seL4 previously supported the KZM-ARM11-01 until version 12.1.0, which can also be simulated in qemu.**
**Support for this platform has since been removed**

The KZM is deprecated, ARMv11 Hardware which was used for the original seL4 verification. The latest
verification platform is the [SabreLite](/Hardware/sabreLite.html).
