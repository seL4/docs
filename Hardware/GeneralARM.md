---
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Loading seL4 onto ARM Hardware

The ARM platform has many ways to boot into an operating system. Typically there
is some low-level ROM code (very specific to each device) that turns on RAM, and
turns on enough clocks to be able to load a second-stage bootloader which does
the work. Some do this in several stages, to enable Trust Zone, HYP-mode etc.

The main bootloaders after the ROM are U-Boot, UEFI, Loki (for Samsung devices)
and simpleboot.  Most of these provide Fastboot over USB to allow software
loading.

 On UEFI for arm: [http://blog.hansenpartnership.com/efitools-for-arm-released/](http://blog.hansenpartnership.com/efitools-for-arm-released/) On U-Boot for arm: [http://www.denx.de/wiki/U-Boot](http://www.denx.de/wiki/U-Boot)

Load from U-Boot, from SD card or flash, or using Fastboot or TFTP. Most
applications have two parts: treat the "kernel" part as a kernel, and the
"application" part like an initial root disk. If there is only one part to an
image (e.g., seL4test for some platforms) treat it like a kernel.

Detailed instructions differ from board to board. See the [Supported
Platforms](index.html) page for links to board-specific instructions.

## Fastboot

Most ARM platforms other than the Beagle Boards that seL4 can use support
booting via Fastboot.

To boot via Fastboot, you need to convert the image file produced by the seL4
build system into a U-Boot image.

```bash
mkimage -A arm -a 0x48000000 -e 0x48000000 -C none -A arm -T kernel -O qnx -d INPUT_FILE OUTPUT_FILE
```

The reason we choose `-O qnx` is because we exploit the fact that, like seL4,
QNX expects to be ELF-loaded. The alternative is to convert our ELF file into a
binary file using `objcopy`. The address to use varies from board to board.
Unless you change the load address, use these:

| **Platform** | **Address** |
| :------------ | :----------|
| Arndale, Odroid-X, Odroid-XU | 0x48000000|
| Sabre Lite |0x30000000|
| Panda, Panda ES | 0x80000000|

When you have your image, put the board into Fastboot mode (interrupt U-Boot,
and type "fastboot"), then do:

```fastboot
fastboot boot OUTPUT_FILE
```

## Booting from SD card

Pull out the SD card from your board, and put it into an SD card reader attached
to your build host. Mount the (MS-DOS) filesystem on the first partition on the
SD card and copy your image to it. Unmount the filesystem, and put the card back
into your board. Reset the board (by power cycling, or pressing the reset
button). To run the image:

```
mmc init
mmcinfo
fatload mmc 0 ${loadaddr} sel4test-image-arm
bootelf ${loadaddr}
```

You can use

```
fatls mmc 0
```

to see what is there. Most U-Boot implementations define a suitable `loadaddr`
in their environment.

## TFTP booting

Setting up a DHCP and TFTP server are out of scope for this document. Once you
have done that, however, and installed a TFTP-enabled U-Boot on your board if it
doesn't already have one.

You can then power up the device and stop U-Boot's auto boot feature if
enabled by pressing a key, and do:

```
dhcp file address
bootelf address
```
