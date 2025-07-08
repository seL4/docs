---
arm_hardware: true
cmake_plat: imx8mp-evk
xcompiler_arg: -DAARCH64=1
platform: i.MX8M Plus
arch: ARMv8A, AArch64
virtualization: "yes"
iommu: "no"
soc: IMX8MP-EVK
cpu: Cortex-A53 Quad 1.8 GHz
Status: Unverified
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# i.MX8M Plus

See also the NXP [i.MX8M Plus product
page](https://www.nxp.com/design/design-center/development-boards-and-designs/8MPLUSLPD4-EVK>).

{% include hw-info.html %}

The seL4 i.MX8 port currently only supports running the board in AArch64 mode.

## Building seL4test

{% include sel4test.md %}
