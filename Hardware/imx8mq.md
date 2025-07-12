---
arm_hardware: true
cmake_plat: imx8mq-evk
xcompiler_arg: -DAARCH64=1
platform: i.MX8M Quad
arch: ARMv8A, AArch64
virtualization: true
iommu: false
soc: MCIMX8M-EVKB
cpu: Cortex-A53 Quad 1.5 GHz
Status: Unverified
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# i.MX8M Quad

See also the the NXP [i.MX8M Quad fact
sheet](https://www.nxp.com/docs/en/fact-sheet/IMX8MQUADEVKFS.pdf).

{% include hw-info.html %}

The seL4 i.MX8M Quad port currently only supports running the board in AArch64
mode.

## Building seL4test

{% include sel4test.md %}

