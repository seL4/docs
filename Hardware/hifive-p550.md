---
riscv_hardware: true
cmake_plat: hifive-p550
xcompiler_arg: -DRISCV64=1
platform: HiFive Premier P550
arch: RV64GC
virtualization: false
iommu: false
simulation_target: false
Status: "Unverified"
Contrib: "Community"
Maintained: "seL4 Foundation"
soc: ESWIN EIC7700X
cpu: P550
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# HiFive Premier P550

The HiFive Premier P550 is a RISC-V development platform from SiFive based
on the ESWIN EIC7700X SoC. It is a quad-core SoC using the SiFive P550
CPU.

{% include hw-info.html %}

Details and links to manuals can be found on the [SiFive product
page](https://www.sifive.com/boards/hifive-premier-p550).

The SoC technical reference manual can be found [on
GitHub](https://github.com/eswincomputing/EIC7700X-SoC-Technical-Reference-Manual/releases).

The HiFive P550 arrives with the following boot process from the SPI flash:

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

Since we are using a `uImage` for the HiFive P550, U-Boot requires a Device Tree Blob (DTB) alongside
the binary image to boot.

The Device Tree Source (DTS) can be compiled from the seL4 tree with the Device Tree Compiler (`dtc`):
```sh
dtc -I dts -O dtb seL4/tools/dts/hifive-p550.dts > hifive_p550.dtb
```

### Booting via microSD card

These instructions expect the microSD card to be paritioned with FAT.

The microSD card slot registers as device `1` in U-Boot so to see if the device
is recognised run:

```sh
mmc dev 1
# Check that the card info is expected
mmc info
# List partitions
mmc part
```

To load and run the image:

```sh
fatload mmc 1:<PARTITION> 0x90000000 sel4test-driver-image-riscv-hifive-p550
fatload mmc 1:<PARTITION> 0xa0000000 hifive_p550.dtb
bootm 0x90000000 - 0xa0000000
```

### Booting via TFTP

If you have setup a TFTP server, enter the following commands on the U-Boot console
to load an image via the network.

```sh
dhcp
tftpboot 0x90000000 <YOUR_TFTP_SERVER_IP_ADDRESS>:sel4test-driver-image-riscv-hifive-p550
tftpboot 0x90000000 <YOUR_TFTP_SERVER_IP_ADDRESS>:hifive_p550.dtb
bootm 0x90000000 - 0xa0000000
```
