---
arm_hardware: true
cmake_plat: odroidc2
xcompiler_arg: -DAARCH64=1
platform: Odroid-C2
arch: ARMv8A, AArch64
virtualization: "yes"
iommu: "no"
soc: Amlogic S905
cpu: Cortex-A53
Status: "FC complete, Integrity ongoing"
verified: odroidc2
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Odroid-C2

The [Odroid-C2](https://wiki.odroid.com/odroid-c2/odroid-c2) is a single board
computer based on the Amlogic S905 System-on-Chip.

{% include hw-info.html %}

Only 64-bit mode is supported both with and without SMP. Hypervisor
support has not been tested.

## U-Boot

The default U-Boot will allocate DMA regions that can corrupt seL4
kernel memory.
Mainline U-Boot can be used instead on this board.
Some Linux distributions include mainline U-Boot binaries compiled for
this board, or you can compile U-Boot yourself.

## Building seL4test

{% include sel4test.md %}

## Booting via TFTP

Make sure you've set up a TFTP server to serve the seL4 image.

```
dhcp
tftp 0x20000000 <YOUR_TFTP_SERVER_IP_ADDRESS>:sel4test-driver-image-arm-odroidc2
go 0x20000000
```
