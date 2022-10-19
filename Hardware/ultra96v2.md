---
cmake_plat: ultra96v2
xcompiler_arg: -DAARCH64=1
arm_hardware: true
platform: Ultra96v2 Evaluation Kit
arch: ARMv8A
virtualization: ARM HYP
iommu: System MMU
soc: Zynq UltraScale+ MPSoC
cpu: Cortex-A53
Status: Unverified
Contrib: "[DornerWorks](https://dornerworks.com)"
Maintained: "[DornerWorks](https://dornerworks.com)"
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Ultra96v2

The board is an Avnet Ultra96v2, which is a low-cost Zynq MPSoC development platform developed by
AVNET.

AVNET maintains online material, including designs and documentation
[here](https://www.avnet.com/wps/portal/us/products/new-product-introductions/npi/aes-ultra96-v2/).

## Building
### seL4test

{% include sel4test.md %}

The Ultra96v2 also supports AArch32 mode. If you choose to build the AArch32 kernel,
please be sure to pass `-DAARCH32=1` instead of `-DAARCH64=1`. This requires modifications to u-boot
to execute in 32-bit mode. See the ZCU102 page for instructions.

## Booting via SD Card

The ultra96v2 comes with a pre-formatted SD card. Load the `sel4test-driver-image-arm-zynqmp` onto
the SD card, then insert the SD card into the Ultra96v2 and power on the board, dropping into the
U-boot prompt. When at the prompt, type the following to run sel4test:

```bash
fatload mmc 0 0x10000000 sel4test-driver-image-arm-zynqmp
bootelf 0x10000000
```
