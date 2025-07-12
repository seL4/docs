---
arm_hardware: true
cmake_plat: tqma8xqp1gb
xcompiler_arg: -DAARCH64=1
platform: TQMa8XQP 1GB
arch: ARMv8A, AArch64
virtualization: false
iommu: false
soc: i.MX8X Quad Plus
cpu: Cortex-A35
Status: Unverified
Contrib: Breakaway Consulting
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 seL4 Project a Series of LF Projects, LLC.
---

# TQMa8XQP 1GB

The
[TQMa8XQP](https://www.tq-group.com/en/products/tq-embedded/arm-architecture/tqma8xx/)
is a system-on-module designed by [TQ-Systems
GmbH](https://www.tq-group.com/en/). The modules incorporates an NXP i.MX8X Quad
Plus system-on-chip and 1GiB ECC memory.

{% include hw-info.html %}

The seL4 TQMa8XQP port currently only supports running the board in AArch64
mode. Virtualization support is untested.

## Building seL4test

{% include sel4test.md %}
