---
arm_hardware: true
cmake_plat: rock3b
xcompiler_arg: -DAARCH64=1
platform: Rock3b
arch: ARMv8A, AArch64
virtualization: true
iommu: false
soc: RK3568 quad-core
cpu: Cortex-A55 Quad 2.0 GHz
Status: "Unverified"
Contrib: "UNSW"
Maintained: "UNSW"
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 seL4 Project a Series of LF Projects, LLC.
---

# Rock3b

{% include hw-info.html %}

## Obtaining TPL

Since some parts of the board are proprietary and need custom binaries, Rockchip provides the binaries that you need to download and include in both the TF-A and U-Boot builds. To obtain them simply execute:
```bash
git clone --depth 1 https://github.com/rockchip-linux/rkbin
```

## Compiling TF-A

ARM Trusted Firmware-A is necessary for the board to boot up properly. It is responsible for setting up all secure peripherals and pieces of the system that the regular user won't have access to.
To build it execute:
```bash
git clone --depth 1 https://github.com/TrustedFirmware-A/trusted-firmware-a.git
cd trusted-firmware-a
make realclean
make CROSS_COMPILE=aarch64-linux-gnu- PLAT=rk3358
cd ..
```

## Compiling U-Boot

In order to build U-Boot for the Rock3b, we need to first download or build the run the following commands:
```bash
git clone https://github.com/u-boot/u-boot.git u-boot
cd u-boot
make CROSS_COMPILE=aarch64-linux-gnu- rock-3b-rk3568_defconfig
make CROSS_COMPILE=aarch64-linux-gnu- BL31=../trusted-firmware-a/build/rk3568/release/bl31/bl31.elf ROCKCHIP_TPL=../rkbin/bin/rk35/rk3568_ddr_1560MHz_v1.13.bin
```

In the `u-boot` directory you should now see the U-Boot image `u-boot.bin` indicating that U-Boot has successfully compiled.

More information regarding U-Boot support for the Rock3b can be found [here](https://docs.u-boot.org/en/latest/board/rockchip/rockchip.html).

## Flashing the U-Boot on the SD-card

To write an image that boots from a SD card (check your device path!):

```bash
sudo dd if=u-boot.bin of=/dev/<device_path> seek=64
sync
```

## Flashing the U-Boot on the SPI Flash

If you want to boot from SPI Flash, you have to put the U-Boot image there first.

### Preparation of the SD-card

Prepare the SD-card by plugging it into your PC and running:

```bash
DEV=/dev/<your device name>

sudo wipefs -a "$DEV"

# Partition table + partitions (start at 16MiB to avoid overlapping bootloader areas)
sudo parted -s "$DEV" mklabel gpt
sudo parted -s "$DEV" mkpart BOOT fat32 16MiB 256MiB
sudo parted -s "$DEV" mkpart ROOT ext4 256MiB 100%

# Format
sudo mkfs.vfat -F 32 -n BOOT ${DEV}p1
sudo mkfs.ext4 -F -L ROOT ${DEV}p2

# Flash the non-SPI image onto SD-card
sudo dd if=u-boot-rockchip.bin of=/dev/sda seek=64

# Copy the SPI image onto the ext4 partition
sudo mkdir -p sd/
sudo mount ${DEV}p2 sd/
sudo cp u-boot-rockchip-spi.bin sd/
sync
sudo umount sd/
```

Then insert the SD-card into the Rock3b and run following there:
```bash
mmc list
# ensure you can see you SD-card here
sf probe
# ensure you can see the flash registering itself here
ls mmc 1:2
# ensure you can see the u-boot-rockchip-spi.bin here

load mmc 1:2 $kernel_addr_r u-boot-rockchip-spi.bin

sf update $fileaddr 0 $filesize
```

Poweroff the board, eject the SD-card and observe the board booting from flash.

## Building seL4test

{% include sel4test.md %}

## Running seL4test

You have two options of running the seL4test, either run it from the SD-card's partition or using TFTP. Here the option of running it via TFTP is described.

This assumes the Ethernet cable connected to the board and having a DHCP and TFTP servers running. When the board boots, enter its console and simply type `dhcp` to establish the connection and then copy over your image from the TFTP server by running:

```bash
tftp 0x02000000 sel4test-driver-image-arm-rk3568
go 0x02000000
```

This will launch seL4tests.
