---
arm_hardware: true
simulation_target: true
cmake_plat: sabre
xcompiler_arg: -DAARCH32=1
platform: Sabre Lite
arch: ARMv7A
virtualization: "No"
iommu: "No"
soc: i.MX6
cpu: Cortex-A9
Status: "[Verified](/projects/sel4/verified-configurations.html#arm-sabre-lite)"
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Sabre Lite

For board details see
[Sabre Lite](https://boundarydevices.com/product/bd-sl-i-mx6/)

# Booting on the Sabre Lite
## Hardware Requirements
* 5V/3A power supply
* RS232 cable (or USB-RS232 adapter)
* USB OTG cable for Fastboot or Ethernet cable for TFTPboot

## Board Setup
 The SabreLite can be configured to boot from either
USB or SPI flash. USB booting is typically only used when there is a
failure in the SPI flash resident bootloader. One may use USB boot to
temporarily boot u-boot and reflash the SPI memory.

SPI flash contains a simple boot loader that will can boot from either
SPI flash, or from an image starting at block 2 of the SD or μSD card
depending on which boot loader has been flashed.

## Booting U-Boot from USB
 USB booting offers a back door into the
system. This method is usually only used to reprogram the SPI flash boot
program.

You will first need to acquire and compile the IMX USB loader tool from
```bash
git clone git://github.com/boundarydevices/imx_usb_loader.git
```
NOTE 1: The Element14 Sabrelite platform has its DIP switch mounted
incorrectly.

NOTE 2: The connection order is important. You may find that your
USB-TTY converter has locked up.

  1.  Move the DIP switch nearest the Ethernet port to the OFF position
  2.  Move the DIP switch farthest from the Ethernet port to the
      ON position.
  3.  Plug the USB cable into the USB-OTG port located near the
      HDMI port.
  4.  Connect the RS232 port to your computer and open minicom.
  5.  Power up the device.

Now you are ready to load your image into memory and execute:
```bash
$ lsusb
....
Bus 001 Device 019: ID
15a2:0054 Freescale Semiconductor, Inc.
....
$ sudo ./imx_usb image_file
```
The image file that is used will typically be named
u-boot.bin

## Booting U-Boot from SPI Flash
 To boot from SPI flash:

  1.  Move the DIP switch nearest the Ethernet port to the OFF position
  2.  Move the DIP switch farthest from the Ethernet port to the OFF
      position
  3.  Connect the RS232 port to your computer and open minicom.
  4.  Insert an SD or μSD card depending on which boot loader is
      resident in SPI flash
  5.  Power up the device.

Now you are ready to load your image into memory and execute:
```bash
$ lsusb
....
Bus 001 Device 019: ID 15a2:0054 Freescale Semiconductor, Inc.
....
$ sudo ./imx_usb image_file
```

The image file that is used will typically be named
u-boot.bin

## Booting U-Boot from SPI Flash
 To boot from SPI flash:

  1.  Move the DIP switch nearest the Ethernet port to the OFF position
  2.  Move the DIP switch farthest from the Ethernet port to the OFF
      position
  3.  Connect the RS232 port to your computer and open minicom.
  4.  Insert an SD or μSD card depending on which boot loader is
      resident in SPI flash
  5.  Power up the device.

## SD and μSD cards
 To boot U-Boot from an SD or μSD card, one must
install the appropriate boot loader into SPI flash. The method and boot
loader images are provided in the SPI flash programming section. U-Boot
must be located at block 2 of the SD or μSD card. This can be achieved
with the following command, assuming that the SD or μSD device is
`/dev/sdb`.
```bash
dd if=u-boot.bin of=/dev/sdb seek=2 bs=512; sync
```

## U-Boot for the Sabre Lite
### Obtaining and Building
There are many versions of U-Boot available for the Sabre
Lite. The ones for Android support Fastboot; the mainline ones do not.

We use the one from
<git://github.com/boundarydevices/u-boot-2009-08.git> with these patches
applied:

|Name |Purpose |
|-|-|
|[01_android-imx6-uboot-enable_bootelf.patch](https://sel4.systems/Info/Hardware/sabreLite/01_android-imx6-uboot-enable_bootelf.patch)|Enable bootelf command |
|[02_android-imx6-uboot-fastbootfix.patch](https://sel4.systems/Info/Hardware/sabreLite/02_android-imx6-uboot-fastbootfix.patch)|Fix fastboot to allow the booting of elf and u-boot images |
|[03_android-imx6-uboot-extra_fs_features.patch](https://sel4.systems/Info/Hardware/sabreLite/03_android-imx6-uboot-extra_fs_features.patch)|Add some extra file systems and associated features |
|[04_android-imx6-uboot-update_env.patch](https://sel4.systems/Info/Hardware/sabreLite/04_android-imx6-uboot-update_env.patch)|Setup default environment. In particular, bootsel4_mmc and bootsel4_net |

Prebuilt:
[u-boot.bin](https://sel4.systems/Info/Hardware/sabreLite/u-boot.bin)

The prebuilt version is for booting from SPI.

To obtain and build U-Boot, do:
```bash
git clone git://github.com/boundarydevices/u-boot-2009-08.git
cd u-boot-2009-08
git checkout origin/boundary-imx_3.0.35_1.1.0 -b boundary-imx_3.0.35_1.1.0
export ARCH=arm
export CROSS_COMPILE=arm-none-eabi-
make mx6q_sabrelite_android_config
make all
ls -l u-boot.bin
```
### Installing U-Boot to SPI Flash
To install U-Boot, put u-boot.bin onto the first partition (either FAT16 or
EXT2) of an SD card, boot into U-Boot then do this at the U-Boot prompt:
```bash
# Initialise the SD card. Replace 1 with 0 for standard SD
mmc dev 1

# Load the file with name "u-boot.bin" from the 1st partition of the SD card to RAM at address 0x12000000
ext2load mmc 1:1 12000000 u-boot.bin

# Initialise the SPI flash subsystem
sf probe | sf probe 1

# Erase 0x100000 bytes from the SPI flash starting at address 0x00000000
# This covers both U-Boot and its saved environment.
sf erase 0 0x100000

# Copy ${filesize} bytes from RAM at address 0x12000000 to SPI flash at address 0x00000000
# Note that the filesize variable was set when the file was loaded into RAM
sf write 0x12000000 0 ${filesize}

# Ensure that the boot select switches are set appropriately, then reboot the Sabrelite
```
## Booting seL4 applications
This assumes that the U-Boot version above is installed in SPI flash.

|Command|Operation|
|-|-|
|run bootsel4_mmc |Scans through the SD card and their partitions looking for an elf file named "sel4-image" in the root directory. This file will be loaded and executed. |
|run bootsel4_net |Performs a DHCP request followed by a TFTPBoot request and attempts to load a file named "sabre/sel4-image". |
|run bootsel4_fastboot|Simple alias for the fastboot command |

## Running seL4 test

{% include sel4test.md %}
