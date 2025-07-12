---
arm_hardware: true
cmake_plat: exynos5422
xcompiler_arg: -DAARCH32=1
platform: OdroidXU4
arch: ARMv7A
virtualization: true
iommu: limited
soc: Exynos5
cpu: Cortex-A15
Status: "FC with HYP, no SMMU"
verified: arm_hyp-exynos5
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# seL4 on the Odroid XU4

This page provides info on the
[Odroid-XU4](https://www.hardkernel.com/shop/odroid-xu4-special-price/)
Exynos 5 board

{% include hw-info.html %}

## Get and build sel4test

{% include sel4test.md %}
