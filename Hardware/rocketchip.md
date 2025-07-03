---
riscv_hardware: true
cmake_plat: rocketchip
xcompiler_arg: -DRISCV64=1
platform: Rocketchip
arch: RV64IMAFDC
virtualization: "no"
iommu: "no"
simulation_target: false
Status: Unverified
Contrib: Data61
Maintained: seL4 Foundation
cpu: Rocket
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Rocketchip FPGA mapped to Zynq ZC706

The current rocketchip implementation only tested on ZC706 FPGA, it should work
for other Zynq FPGAs. Refer to
[https://github.com/ucb-bar/fpga-zynq](https://github.com/ucb-bar/fpga-zynq) for
details.

## Building the GCC toolchain

{% include risc-v.md %}

## Building seL4test

{% include sel4test.md %}
