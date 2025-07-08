---
arm_hardware: true
cmake_plat: imx8mm-evk
xcompiler_arg: -DAARCH64=1
platform: i.MX8M Mini
arch: ARMv8A
virtualization: "no"
iommu: "no"
soc: IMX8MM-EVK
cpu: Cortex-A53 Quad 1.8 GHz
Status: "FC"
verified: imx8mm
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# i.MX8M Mini

See also the NXP [i.MX8M Mini web page](https://www.nxp.com/products/i.MX8MMINI).

{% include hw-info.html %}

## Building seL4test

{% include sel4test.md %}

