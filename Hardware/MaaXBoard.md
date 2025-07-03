---
arm_hardware: true
cmake_plat: maaxboard
xcompiler_arg: -DAARCH64=1
platform: Avnet MaaXBoard
arch: ARMv8A
virtualization: "yes"
iommu: "no"
soc: i.MX8MQ
cpu: Cortex-A53 Quad 1.5 GHz
Status: Unverified
Contrib: '<a href="https://capgemini-engineering.com">Capgemini Engineering</a>"'
Maintained: '<a href="https://capgemini-engineering.com">Capgemini Engineering</a>"'
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2022 seL4 Project a Series of LF Projects, LLC.
---

# Avnet MaaXBoard

{% include hw-info.html %}

## Building seL4test

{% include sel4test.md %}
Also `-DAARCH32=1` is available.
