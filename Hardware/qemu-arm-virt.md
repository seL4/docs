---
arm_hardware: true
simulation_target: true
simulation_only: true
xcompiler_arg: '-DSIMULATION=1'
cmake_plat: qemu-arm-virt
platform: QEMU Arm Virt
arch: ARMv7A, ARMv8A
virtualization: "yes"
iommu: "no"
soc: virt
cpu: Multiple
Status: "N/A"
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 seL4 Project a Series of LF Projects, LLC.
---

# QEMU Arm virtual platform

This is a simulation-only target for running the Arm version of seL4 on the
[QEMU] simulator with the [virt] platform.

{% include hw-info.html %}

## Supported Configurations

The default CPU for simulation on `qemu-arm-virt` is Cortex A53. If
`KernelSel4Arch` is set to `aarch32` or `arm_hyp`, the default is Cortex A15.

Supported values for the optional build parameter `ARM_CPU` are: `cortex-a7`,
`cortex-a15`, `cortex-a53`, `cortex-a57`, and `cortex-a72`.

## Running seL4 test

See the [machine setup] instructions for how to install build dependencies.

{% include sel4test.md %}

[QEMU]: https://www.qemu.org
[virt]: https://www.qemu.org/docs/master/system/arm/virt.html
[machine setup]: {{ '/projects/buildsystem/host-dependencies.html' | relative_url }}
