---
archive: true
arm_hardware: true
cmake_plat: exynos5250
xcompiler_arg: -DAARCH32=1
platform: Arndale
arch: ARMv7A
virtualization: "yes"
iommu: "no"
soc: Exynos5
cpu: Cortex-A15
Status: Unverified
Contrib: Data61
Maintained: "No"
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Arndale

{% include note.html %}
This board is not being regression tested, but has same SoC as
[Odroid-XU](OdroidXU.html) (which is tested).
{% include endnote.html %}

seL4 supports the Arndale dual core A15 ARM development board.

{% include hw-info.html %}

## Client setup

### Hardware requirements:

1. 5V power supply, center +ve

## SD card setup

The offsets depend on which versions of bl1, bl2 and U-Boot you get.

For BL1 from the Android tree:

|Key|Position (block) |
|-|-|
|BL1 |1 |
|BL2 (uboot-module)|31 (8k) |
|u-boot |63 |
|!TrustZone |719 |

Note — U-Boot understands DOS filesystems (and ext2) so uImage, uInitrd
and the DTB could be normal files in a partition, rather than at a fixed
offset on the SD card.

These offsets are designed for a U-Boot environment like this:

```none
bootargs=root=/dev/mmcblk1p1 rw rootwait console=ttySAC2,115200n8 init --no-log
bootcmd=mmc read 40007000 451 2000;mmc read 42000000 2451 20;bootm 40007000 - 42000000
```

If you have a separate boot partition on your card you could instead
use: (untested as yet)

```none
kernel=0x40007000
dtb=42000000
bootcmd=mmc init; fatload mmc 0:1 ${kernel} uImage; fatload mmc 0:1 ${dtb} dtb; bootm ${kernel} - ${dtb}
```

### U-Boot

There are at least three versions available, the one in the Android tree (which
should have Fastboot) and the one from Linaro (which understands the USB and
network drivers).

There's also <http://www.spinics.net/lists/kvm-arm/msg02817.html> which
is supposed to enable the virtualisation features. I'm not sure at
present whether the difference is merely configuration or if there are
source differences. U-Boot.

Inside the Android environment do:

```bash
make ARCH=arm CROSS_COMPILE=arm-eabi-arndale
sudo dd iflag=dsync oflag=dsync if=u-boot.bin of=/dev/sdb seek=63
```

## seL4 Image file preparation

In most cases it is okay to simply load the elf file into memory and run
`bootelf`. However, Fastboot may require that the ELF file be packed into a U-Boot
application image file. Follow the below instructions to create this image.

```bash
sudo apt-get install uboot-mkimage
INPUT_FILE=images/sel4test-image-arm-exynos4
OUTPUT_FILE=sel4-uImage
mkimage -a 0x48000000 -e 0x48000000 -C none -A arm -T kernel -O qnx -d $INPUT_FILE $OUTPUT_FILE
```

The reason we choose QNX is because we exploit the fact that, like seL4, QNX
expects to be ELF-loaded. The alternative is to convert our ELF file into a
binary file using objcopy.

## Booting

### Building an image

{% include sel4test.md %}

### tftpboot

At the U-Boot prompt, type print to see the list of environment variables and
their values. Use the following commands to set any variables that are missing
from the list.

```none
setenv bootfile filename
setenv ethaddr 00:40:5c:26:0a:FF
setenv usbethaddr 00:40:5c:26:0a:FF
setenv pxefile_addr_r 0x50000000
```

Now run:

```none
usb start; dhcp; bootelf; bootm;
```

## References

- <https://arndaleboard.org/wiki/index.php/Main_Page>
