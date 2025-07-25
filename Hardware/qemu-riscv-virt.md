---
riscv_hardware: true
simulation_target: true
simulation_only: true
xcompiler_arg: '-DSIMULATION=1'
cmake_plat: qemu-riscv-virt
platform: QEMU RISC-V
arch: RV32GC, RV64IMAC
virtualization: false
iommu: false
soc: virt
cpu: rv32, rv64
Status: "N/A"
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 seL4 Project a Series of LF Projects, LLC.
---

# QEMU RISC-V virtual platform

This is a simulation-only target for running the RISC-V version of seL4 on the
[QEMU] simulator with the [virt] platform.

{% include hw-info.html %}

## Supported Configurations

The values `riscv64` and `riscv32` are supported for `KernelSel4Arch`.

## Running seL4 test

See the [machine setup] instructions for how to install build dependencies.

{% include sel4test.md %}

[QEMU]: https://www.qemu.org
[virt]: https://www.qemu.org/docs/master/system/riscv/virt.html
[machine setup]: {{ '/projects/buildsystem/host-dependencies.html' | relative_url }}
