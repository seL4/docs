---
arm_hardware: true
cmake_plat: exynos4
xcompiler_arg: -DAARCH32=1
platform: OdroidX
arch: ARMv7A
virtualization: false
iommu: false
soc: Exynos4412
cpu: Cortex-A9
Status: "Verified"
verified: exynos4
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Odroid-X

seL4 supports the Odroid-X Exynos4412 board.

{% include hw-info.html %}

&nbsp;

{% include note.html  %}
This board is discontinued by the manufacturer. The instructions here are
provided to keep existing setups working. See support for other more recent
Odroid boards on [Supported platforms](./).
{% include endnote.html %}

## Client setup

### Hardware requirements:

1. 5V power supply
1. RS232 or USB to UART converter
1. USB OTG cable

{% include note.html %}
The USB-UART converter that is shipped with the board requires a
Linux kernel version > 3.2
{% include endnote.html %}

### Serial port setup

Open minicom on `/dev/ttyUSB*` and set the serial port settings to: `115200N1`

- 115200bps
- parity-none
- 1 stop bit

### udev

You may also like to set up a udev rule for Fastboot:

```none
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="0002", MODE="660", GROUP="dialout"
```

### U-Boot

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

  2. On the client machine, run sudo fastboot devices to ensure that the device
     has been recognised. The device should have the label `SMDKEXYNOS-01`.
     Note that fastboot fails silently if you do not have permissions to access
     the device. In that case, try running with `sudo`.

  3.  On the client machine, run fastboot boot sel4-uImage

To boot from mmc:

  1.  At the U-Boot prompt type
      `fatload mmc 0:2 0x42000000 <filename> bootm 0x42000000`

## References

<https://wiki.postmarketos.org/wiki/Samsung_Exynos_4>
