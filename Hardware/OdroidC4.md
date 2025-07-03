---
arm_hardware: true
cmake_plat: odroidc4
xcompiler_arg: -DAARCH64=1
platform: Odroid-C4
arch: ARMv8A, AArch64 only
virtualization: "Yes"
iommu: "no"
soc: Amlogic S905X3
cpu: Cortex-A55
Status: "FC complete, Integrity ongoing"
verified: odroidc4
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Odroid-C4

The Odroid-C4 is a single board computer based on the Amlogic S905X3
System-on-Chip.

<https://wiki.odroid.com/odroid-c4/odroid-c4>

Note that only 64-bit mode is supported.

## Building seL4test

{% include sel4test.md %}

## Booting via TFTP

Make sure you've set up a TFTP server to serve the seL4 image.

```
dhcp
tftp 0x20000000 <YOUR_TFTP_SERVER_IP_ADDRESS>:sel4test-driver-image-arm-odroidc4
go 0x20000000
```
