---
arm_hardware: true
cmake_plat: maaxboard
xcompiler_arg: -DAARCH64=1
platform: Avnet MaaXBoard
arch: ARMv8A
virtualization: "No"
iommu: "No"
soc: i.MX8MQ
cpu: Cortex-A53 Quad 1.5 GHz
Status: Unverified
Contrib: "[Capgemini Engineering](https://capgemini-engineering.com)"
Maintained: "[Capgemini Engineering](https://capgemini-engineering.com)"
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2022 seL4 Project a Series of LF Projects, LLC.
---
# Avnet MaaXBoard

## Building seL4test

{% include sel4test.md %}
Also `-DAARCH32=1` is available.
