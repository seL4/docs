---
riscv_hardware: true
cmake_plat: bananapi-f3
xcompiler_arg: -DRISCV64=1
platform: Banana Pi BPI-F3
arch: RV64GCVB
virtualization: false
iommu: false
simulation_target: false
verification: []
Contrib: "Community"
Maintained: "10xEngineers"
soc: SpacemiT K1
cpu: X60
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 10xEngineers
---

# Banana Pi BPI-F3

The Banana Pi BPI-F3 is an industrial-grade RISC-V single-board computer
from Banana Pi, based on SpacemiT K1 SoC. It has an octa-core RISC-V (8 × X60)
CPU, with integrated 2.0 TOPs AI computing power.

{% include hw-info.html %}

Details and links to manuals can be found on the [Banana Pi product
page](https://docs.banana-pi.org/en/BPI-F3/BananaPi_BPI-F3).

The SoC technical reference manual can be found [on
SpacemiT website](https://developer.spacemit.com/documentation?token=GAmMwCrRUiZAo5kXKUQcNNacnwb&type=pdf).

The Banana Pi BPI-F3 arrives with the following boot process:

1. Firmware starts
2. OpenSBI starts
3. U-Boot proper starts

From U-Boot proper you can then load and start an seL4 image, see below for details.

## Building the GCC toolchain

{% include risc-v.md %}

## Building seL4test

{% include sel4test.md %}

## Booting

There are multiple ways to boot from U-Boot, documented below is booting via TFTP and from
a microSD card.

### Obtaining the DTB {#dtb}

Since we are using a `uImage` for the Banana Pi BPI-F3, U-Boot requires a Device Tree Blob (DTB) alongside
the binary image to boot.

The Device Tree Source (DTS) can be compiled from the seL4 tree with the Device Tree Compiler (`dtc`):
```sh
dtc -I dts -O dtb sel4/tools/dts/bananapi-f3.dts > bananapi-f3.dtb
```

### Booting via microSD card

These instructions expect the microSD card to be paritioned with FAT.

The microSD card slot registers as device `0` in U-Boot so to see if the device
is recognised run:

```sh
mmc dev 0
# Check that the card info is expected
mmc info
# List partitions
mmc part
```

To load and run the image:

```sh
fatload mmc 0:<PARTITION> 0x200000 sel4test-driver-image-riscv-bananapi-f3
fatload mmc 0:<PARTITION> 0x31000000 bananapi-f3.dtb
bootm 0x200000 - 0x31000000
```

### Booting via TFTP

If you have setup a TFTP server, enter the following commands on the U-Boot console
to load an image via the network.

```sh
dhcp
tftpboot 0x200000 <YOUR_TFTP_SERVER_IP_ADDRESS>:sel4test-driver-image-riscv-bananapi-f3
tftpboot 0x31000000 <YOUR_TFTP_SERVER_IP_ADDRESS>:bananapi-f3.dtb
bootm 0x200000 - 0x31000000
```
