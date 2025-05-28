---
arm_hardware: true
cmake_plat: exynos5422
xcompiler_arg: -DAARCH32=1
platform: OdroidXU4
arch: ARMv7A
virtualization: ARM HYP
iommu: limited SMMU
soc: Exynos5
cpu: Cortex-A15
Status: "[FC with HYP, no SMMU](/projects/sel4/verified-configurations.html#arm_hyp-exynos5)"
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# seL4 on the Odroid XU4


This page provides info on the
[Odroid-XU4](https://www.hardkernel.com/main/products/prdt_info.php)
Exynos 5 board

### Get and build sel4test

{% include sel4test.md %}

