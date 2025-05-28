---
arm_hardware: true
cmake_plat: exynos4
xcompiler_arg: -DAARCH32=1
platform: OdroidX
arch: ARMv7A
virtualization: "No"
iommu: "No"
soc: Exynos4412
cpu: Cortex-A9
Status: "[Verified](/projects/sel4/verified-configurations.html#exynos4)"
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Odroid-X

seL4 supports the
[Odroid-X](http://www.hardkernel.com/main/products/prdt_info.php?g_code=G135235611947)
Exynos4412 board.

## Client setup
#### Hardware requirements:
1. 5V power supply
1. RS232 or USB to UART converter
1. USB OTG cable

Note: The USB-UART converter that is shipped with the board requires a
Linux kernel version > 3.2

##### Serial port setup
 Open minicom on `/dev/ttyUSB*` and set the
serial port settings to: `115200N1`

- 115200bps
- parity-none
- 1 stop bit

##### udev
 You may also like to set up a udev rule for Fastboot:
```
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="0002", MODE="660", GROUP="dialout"
```

## SD card setup
 An image file can be found here: TODO Add sd image

This image contains both U-Boot and Android. This should set up SD card
partitions properly. seL4 image can be uploaded via Fastboot.

To prepare the SD card, run
```bash
$ sudo dd if=<image file> of=</dev/sdx>
```

Where `sdx` is the device that is associated with your SD card.

##### U-Boot
 \<TODO> Uboot source?

U-Boot must reside at a magical offset in a special partition of the SD
card. To copy U-Boot and the other boot loaders to the SD card:
```bash
cd sd_fusesudo
./sd_fusing_4412.sh /dev/sdx
```

## seL4 Image file preparation

{% include sel4test.md %}

The seL4 image file must be converted
into a U-Boot application file. The first step is to strip the elf file
into a binary file. Next we use mkimage to create the image.
```bash
sudo apt-get install uboot-mkimage
INPUT_FILE=images/sel4test-image-arm-exynos4
OUTPUT_FILE=sel4-uImage
mkimage -a 0x48000000 -e 0x48000000 -C none -A arm -T kernel -O qnx -d $INPUT_FILE $OUTPUT_FILE
```

The reason we choose QNX is because we exploit the fact that, like seL4,
QNX expects to be ELF-loaded. The alternative is to convert our ELF file
into a binary file using objcopy.

## Booting
 Fastboot will be used to upload images to the device. The
tool can be found here: or here: you can clone and build the tool from
source

\<TODO> add fastboot link

Follow these steps to boot your program:

  1.  Connect the USB cable between the ODROID and the client
  2.  Connect the UART converter between the ODROID and the client
  3.  Insert your SD card into the ODROID
  4.  Connect the 5V power supply
  5.  Open minicom
  6.  Hold the power button for 3 seconds
  7.  In minicom, press a key to stop the auto boot process or hold the
      user button on the board during the boot process

To boot using fastboot:

  1.  At the u-boot prompt, type fastboot

  1. On the client machine, run sudo fastboot devices to ensure that the device has been recognised. The device should have the label "SMDKEXYNOS-01".

      1.  NOTE: fastboot fails silently if you do not have permissions
          to access the device. Try running with sudo.

  1.  On the client machine, run fastboot boot sel4-uImage

To boot from mmc:

  1.  At the U-Boot prompt type
      `fatload mmc 0:2 0x42000000 <filename> bootm 0x42000000`

## References

<http://www.hardkernel.com/renewal_2011/products/prdt_info.php>

<http://dev.odroid.com/projects/odroid-xq/#s-2.2.1> <- This should be
replaced with the official Samsung exynos4412 "User manual"

[Android - uboot
sources and instructions](http://dev.odroid.com/projects/ics/#s-6.2)
