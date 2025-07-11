---
arm_hardware: true
cmake_plat: omap3
xcompiler_arg: -DAARCH32=1
platform: BeagleBoard
arch: ARMv7A
virtualization: "no"
iommu: "no"
soc: OMAP3
cpu: Cortex-A8
Status: Unverified
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# seL4 on the BeagleBoard

This page documents booting seL4 on the
[Beagleboard](http://beagleboard.org/beagleboard), Omap 3530

{% include hw-info.html %}

See also [Tim Newsham's
post](https://lists.sel4.systems/hyperkitty/list/devel@sel4.systems/message/AHWTG4D3W6OYF4QPUILMBTU4COP4KH4A/)
on the mailing list for his experience with running seL4 on this board.

## Preparing your SD card

### Prologue

These instructions are for later versions of the Beagleboard. Before the Xm,
U-Boot and MLO were held in flash.

The first stage boot loader expects to find the TI X-loader in the root of a FAT
filesystem, on the first partition of the SD card with the name MLO.

MLO expects to find a file named u-boot.bin in the root directory of the SD
card.

## Setting up Minicom

Plug the board in. seL4 userspace currently does no power management — you will
probably need a 5V power source, and not rely on powering the board over USB

If you do not have minicom installed:

```bash
sudo apt-get install minicom
```

If you are connecting via a USB serial adapter:

```bash
sudo minicom -s ttyUSB0
```

And if you were connecting via a **real** serial port:

```bash
sudo minicom -s ttyS0
```

In either case, this will take you to a configuration menu.

1.  Choose Serial Port Setup
2.  Set A: Serial Device to `/dev/ttyUSB0` or `/dev/ttyS0` depending on
    which serial device you want to use.
3.  Set F: Hardware Flow Control to No
4.  Set speed to `115200` and eight bit no parity.
5.  Save setup as `ttyUSB0` or `ttyS0`
6.  Exit Minicom

You can now connect to the !BeagleBoard using Minicom:

```bash
minicom ttyUSB0
```

Or:

```bash
minicom ttyS0
```

### Permissions

If you get permissions errors you need to add yourself to the
appropriate group. Find out which group on your machine has access to
the serial ports (on Debian, it's usually `dialout`):

```bash
$ ls -l /dev/ttyUSB0
crw-rw---- 1 root dialout 188, 0 Aug 11 09:43 /dev/ttyUSB0
```

Then add yourself to the right group:

```bash
sudo usermod -G dialout -a your_login_name
```

### U-Boot

Now minicom should connect to what it thinks is a "modem", and then give you a
good old console to work with. You are now in the bootloader, U-Boot, of the
BeagleBoard. You can type commands here and it'll display the results.

Some quick useful commands:

|Command|Description|
|-|-|
|help |display list of commands |
|printenv|lists defined environment variables |
|mmc init |initialise MMC (to read the the SD card) |
|mmcinfo |display current SD card info |
|fatls mmc 0 |display list of files on SD card 0 |
|fatload |load script/image into some RAM address to be run |
|run |run scripts |
|bootelf |boot into en ELF image |


### dfu-util

An alternative is to use `dfu-util` with the standard U-Boot to transfer the
image to the board.

The address that the file downloads to is controlled by the `loadaddr`
environment variable in U-Boot. You can either download an  ELF file, and then
run `bootelf` on the U-Boot command-line, or download a U-Boot image file
(created with `mkimage`) and use `bootm` to run it. You may need to take care
that the ELF sections or image regions do not overlap with the location of the
ELF/image itself, or loaded to non-existent memory address (0x81000000 works
fine, but 0x90000000 won't work on the original Beagle Board since there's no
RAM there).

```none
dfu-util -D sel4test-image-arm
```

## Running seL4test

{% include sel4test.md %}

Which after a few minutes should give you:

Now, the ELF image we boot into is the `sel4test-driver-image-arm-omap3` file.
Copy that file onto the sdcard (the boot loader will be able to load images into
RAM from a FAT image: there is no need to do an image copy). If your SD card is
not formatted, just format it using FAT32. Plug the SD card back into the
BeagleBoard and reset the board by pressing the `S2` (reset) button.

### To run the image

```uboot
mmc init
mmcinfo
fatload mmc 0 ${loadaddr} sel4test-driver-image-arm-omap3
bootelf ${loadaddr}
```

where `loadaddr` is some address, in this example defined as an environment
variable.

{% include note.html %}
By default, the image produced is relocated to run at address 0x82000000.
If you want to change the address, you need to modify the file
`projects/tools/elfloader-tool/gen_boot_image.sh` (look for the omap3 case). For
the Beaglebone Black Rev A5, RAM is from address 0x80000000 - 0x9FFFFFFF.
{% include endnote.html %}

Depending on the uBoot version present on the Beaglebone, the `bootelf` command
might not be present. You can use the `go` command instead. E.g.:

```uboot
mmc init
mmcinfo
fatload mmc 0 0x82000000 sel4test-driver-image-arm-omap3
go 0x82000000
```

After this you should start seeing output from seL4test.

Tip: if you don't remember the name of the images on your SD card, you can use:

```uboot
fatls mmc 0
```

to see what is on the SD card.
