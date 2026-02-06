---
arm_hardware: true
cmake_plat: stm32mp2
xcompiler_arg: -DAARCH64=1
platform: STM32MP25 EV1
arch: ARMv8A, AArch64
virtualization: true
iommu: false
soc: STM32MP25
cpu: Cortex-A35
verification: [AARCH64]
Contrib: STMicroelectronics
Maintained: STMicroelectronics
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2026 seL4 Project a Series of LF Projects, LLC.
---

# STM32MP25 EV1

[STM32MP25 evaluation board](https://www.st.com/en/evaluation-tools/stm32mp257f-ev1.html)

{% include hw-info.html %}

## Building seL4test

{% include sel4test.md %}

## ARM Trusted Firmware (TF-A)
seL4 uses Trusted Firmware-A (TF-A) to start the AT35-TD BL2 U-boot and a secure monitor to serve RIF accesses. Instructions to install and use prebuild boot binaries are available on the [Starter package wiki](https://wiki.st.com/stm32mpu/wiki/STM32MP25_Evaluation_boards_-_Starter_Package#Downloading_the_image_and_flashing_it_on_the_board)

## Installation

The flash layout uses ext2 partitions for BL2 boot stage, the FIP binary and partitions used by the Linux image. For seL4 only the `bootfs` partition is required.

When connected with a USB Type-C cable, the partitions can be exported with the USB Mass Storage commands from the u-boot prompt:

```
STM32MP> ums 0 mmc 0
```
On the host side, install the boot binary on the `bootfs` partition

```
# sudo mount /dev/disk/by-partlabel/bootfs /media/bootfs
# sudo cp sel4boot.bin /media/bootfs
```

## Booting

Identify the partition number and verify the seL4 boot binary you just placed on your microSD card:
```
STM32MP> mmc part
STM32MP> ext2ls mmc 0:8
```
Load and boot the image using:
```
STM32MP> ext2load mmc 0:8 sel4boot.bin 0x88000000
STM32MP> go 0x88000000
```
