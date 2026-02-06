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

## Installation

Instructions to boot the board are available on the [Starter package wiki](https://wiki.st.com/stm32mpu/wiki/STM32MP25_Evaluation_boards_-_Starter_Package#Downloading_the_image_and_flashing_it_on_the_board). These notes describe how to create a raw image to flash a Linux boot on a MicroSD card.
The flash layout uses ext2 partitions, for seL4 only the `bootfs` partition is used.

### ARM Trusted Firmware (TF-A)

seL4 uses TF-A to start the AT35-TD BL2 U-boot and a secure monitor to serve RIF accesses. The default configuration enables a system watchdog that causes a reset if not rearmed, which might not be long enough for seL4 components.

If necessary, disable the watchdog in `fdts/stm32mp257f-ev1.dts`. Build details are available on the [How to configure TF-A wiki](https://wiki.st.com/stm32mpu/wiki/How_to_configure_TF-A_BL2)

```
&iwdg1 {
        timeout-sec = <32>;
-       status = "okay";
+       status = "disabled";
 };
```

## Booting

Identify the partition number and verify the seL4 boot binary you just placed on your microSD card.
Load and boot the image at `0x88000000`.

```
STM32MP> mmc part
...
STM32MP> ext2ls mmc 0:8
...
STM32MP> ext2load mmc 0:8 0x88000000 loader.img
STM32MP> go 0x88000000
```
