---
arm_hardware: true
simulation_target: true
cmake_plat: kzm
xcompiler_arg: -DAARCH32=1
platform: KZM
arch: ARMv6A
virtualization: "No"
iommu: "No"
soc: i.MX31
cpu: ARM1136J
Status: Unverified
Contrib: Data61
Maintained: Data61
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# KZM

seL4 supports the the
KZM-ARM11-01, which can
also be simulated in qemu.

The KZM is deprecated, ARMv11 Hardware which was used for the original seL4 verification. The latest
verification platform is the [SabreLite](/Hardware/sabreLite).

## Simulation

{% include sel4test.md %}
