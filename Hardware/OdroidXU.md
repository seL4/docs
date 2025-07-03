---
arm_hardware: true
cmake_plat: exynos5410
xcompiler_arg: -DAARCH32=1
platform: OdroidXU
arch: ARMv7A
virtualization: "yes"
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

# seL4 on the Odroid XU

This page provides info on the
[Odroid-XU](https://www.hardkernel.com/shop/odroid-xu/)
Exynos 5 board

{% include hw-info.html %}

seL4 assumes that one boots in HYP mode. To do this, one needs a new
signed bootloader.

Follow the instructions
[on the HardKernel Forum](http://forum.odroid.com/viewtopic.php?f=64&t=2778&sid=be659cc75c16e1ecf436075e3c548003&start=60#p33805) to get and flash the firmware

The standard U-Boot will allow booting via Fastboot or by putting the
bootable ELF file onto an SD card or the eMMC chip.

## Run seL4test using fastboot

### Get and build sel4test

{% include sel4test.md %}

### Put seL4test onto the board

Boot the Odroid, with serial cable
attached, and a terminal emulator attached to the serial port.

Interrupt U-Boot's autoboot by hitting SPACE

Enter Fastboot mode by typing fastboot

On the host,

```bash
mkimage -A arm -a 0x48000000 -e 0x48000000 -C none -A arm -T kernel -O qnx -d images/sel4test-driver-image-arm-exynos5 image
fastboot boot image
```
