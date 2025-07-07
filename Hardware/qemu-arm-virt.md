---
arm_hardware: true
simulation_target: true
simulation_only: true
xcompiler_arg: '-DSIMULATION=1'
cmake_plat: qemu-arm-virt
platform: Qemu Arm Virt
arch: ARMv7A, ARMv8A
virtualization: "yes"
iommu: "no"
soc: Qemu
cpu: Multiple
Status: "N/A"
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 seL4 Project a Series of LF Projects, LLC.
---

# Qemu Arm virtual platform

This is a simulation-only target for running the Arm version of seL4 on the [Qemu]
simulator with and without virtualisation support.

{% include hw-info.html %}

## Supported Configurations

The default CPU for simulation on `qemu-arm-virt` is Cortex A53. If
`KernelSel4Arch` is set to `aarch32` or `arm_hyp`, the default is Cortex A15.

Supported values for the optional build parameter `ARM_CPU` are: `cortex-a7`,
`cortex-a15`, `cortex-a53`, `cortex-a57`, and `cortex-a72`.

## Running seL4 test

{% include sel4test.md %}

[Qemu]: https://www.qemu.org
