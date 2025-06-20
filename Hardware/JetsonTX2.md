---
arm_hardware: true
cmake_plat: tx2
xcompiler_arg: -DAARCH64=1
platform: TX2
arch: ARMv8A, AArch64 only
virtualization: "Yes"
iommu: "Yes"
soc: NVIDIA Tegra X2
cpu: Cortex-A57 Quad, Dual NVIDIA Denver
Status: "[FC complete, Integrity ongoing](/projects/sel4/verified-configurations.html#aarch64)"
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Jetson TX2

The Jetson TX2 is an embedded system-on-module (SOM) developed by NVIDIA.

<https://elinux.org/Jetson_TX2>

The seL4 kernel has a limited port to the TX2 which supports the SoM
only in 64-bit mode.

## Building seL4test

{% include sel4test.md %}

## Booting via PXE

A U-Boot uImage will be created by the seL4 build system. This can be booted
by U-Boot using PXE.
