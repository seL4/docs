---
arm_hardware: true
cmake_plat: imx93
xcompiler_arg: -DAARCH64=1
platform: i.MX93 EVK
arch: ARMv8A, AArch64
virtualization: "yes"
iommu: "no"
soc: i.MX93
cpu: Cortex-A55
Status: Unverified
Contrib: Indan Zupancic, Proofcraft
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 seL4 Project a Series of LF Projects, LLC.
---

# i.MX93 Evaluation Kit

See also the NXP [i.MX93 EVK product
page](https://www.nxp.com/design/design-center/development-boards-and-designs/i.MX93EVK).

{% include hw-info.html %}

The seL4 i.MX93 port currently only supports running the board in AArch64
mode.

## Building seL4test

{% include sel4test.md %}
