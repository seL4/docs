---
arm_hardware: true
cmake_plat: rockpro64
xcompiler_arg: -DAARCH64=1
platform: ROCKPro64
arch: ARMv8A, AArch64
virtualization: "yes"
iommu: "no"
soc: RK3399 hexa-core
cpu: Cortex-A53 Quad 1.8 GHz
Status: Unverified
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# ROCKPro64

{% include hw-info.html %}

## Building seL4test

{% include sel4test.md %}

## Flashing the SPI with U-Boot

**WARNING! DO NOT POWER OFF THE DEVICE FOR ANY REASON DURING SPI FLASH! YOU WILL GET A (soft-) BRICKED DEVICE**

The first step is getting U-Boot onto the system. It is recommended, particularly for TFTP boot, to put U-Boot on the SPI flash.

If you have a "dirty" (any previously used) SPI flash, first:
1. Download https://github.com/sigmaris/u-boot/releases/download/v2020.01-ci/erase_spi.img.gz
2. Write it to an SD card
3. Boot from the SD card (will be done automatically if you don't have a very weird setup). Once it completes (see this over serial or when white LED becomes stable), remove the SD card, but DO NOT reset.

Then, to flash the actual image:
1. Get https://github.com/sigmaris/u-boot/releases/download/v2020.01-ci/flash_spi.img.gz and write it to an SD card.
2. Put the SD card into the ROCKPro64 and boot. Wait for completion (seen over serial or when white LED becomes stable).
3. Remove the SD card.
4. Reset and observe U-Boot come up.

Compiling u-boot onesself has not been done and has been left as an exercise to the reader if wanted. HINT: https://github.com/sigmaris/u-boot/blob/v2020.01-ci/.azure-pipelines.yml. This fork is used as it resolves a number of issues present in mainline U-Boot and has pre-built images.

## Setting up with TFTP, DHCP, UEFI (recommended!)

I assume you have:
- setup a TFTP server
- setup a DHCP server
- linked the TFTP and DHCP servers appropriately

Luckily the U-Boot defconfig for ROCKPro64 includes UEFI support. We are not using EDK2 because no stable and tested implementations exist for ROCKPro64.

Copy your seL4 image to the TFTP root under the name `sel4img` (or any other name of your choosing but you will have to adjust following commands).

### Manual method (well tested)

Drop into a U-Boot console when asked. Type in:

```
dhcp
tftpboot ${kernel_addr_r} sel4img
bootefi ${kernel_addr_r}
```

- Watch seL4 boot!

### Automated method

Create `pxelinux.cfg/default` in TFTP root:

```
menu title PXE!

timeout 200

label sel4
menu default
kernel /sel4img
```

Create `boot.scr`:

```
bootefi 0x2080000
```

Significance of 0x2080000 being where seL4 image is loaded by U-Boot.

Convert `boot.scr` to a uImage using `mkimage -A arm -T script -C none -n boot.scr -d boot.scr boot.scr.uimg`. Ensure `boot.scr.uimg` is in the TFTP root and `boot.scr` is removed.

### Building things

Ensure your `tools/seL4` has the appropriate commit (TODO)

## Setting up with UEFI, SD card

This process is similar to above with TFTP. The SD card should have one or more partitions, the first one must be ext2 and have the file files on it. (If required, you can change the 1:1 in the below commands to 1:2, 1:3 etc for using 2nd, 3rd, partition, etc).

Copy your `sel4img` aforementioned in UEFI section to SD card.

### Manual

Drop to a U-Boot console and type in:

```
ext2load mmc 1:1 ${kernel_addr_r} sel4img
bootefi ${kernel_addr_r}
```

### Automated

Create `boot.scr`:

```
ext2load mmc 1:1 ${kernel_addr_r} sel4img
bootefi ${kernel_addr_r}
```

Convert to uImage using `mkimage -A arm -T script -C none -n boot.scr -d boot.scr boot.scr.uimg`. Put in SD card and boot.
