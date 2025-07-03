---
arm_hardware: true
cmake_plat: tk1
xcompiler_arg: -DAARCH32=1
platform: TK1-SOM
arch: ARMv7A
virtualization: "yes"
iommu: "yes"
soc: NVIDIA Tegra K1
cpu: Cortex-A15
Status: "[FC with HYP, no SMMU](/projects/sel4/verified-configurations.html#arm_hyp-tk1)"
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# TK1 som

The TK1-SOM from Colorado engineering is a small form-factor system
based on the NVIDIA Tegra K1. Details and ordering are at
<https://tk1som.com/products/tk1-som>

## Hardware modifications and Daughterboards


[Adding some missing connectors](Tk1SomMods) makes this board a
bit easier to use.

We have also developed 2 daughterboards for the TK1-SOM

- a [CAN daughterboard](CANBoard), that adds two CAN
        controllers on the SPI bus
- an [I/O daughterboard](DaughterBoard) that adds CAN
        controllers, various sensors and power management

## U-Boot

Upstream U-Boot now supports this board.

Follow the instructions for the [Jetson TK1](../jetsontk1#flash-u-boot), however:

- use <https://github.com/wom-bat/tegra-uboot-flasher-manifests>
        as the URL for repo
- don't apply the patch to increase the console buffer size
- use cei-tk1-som (instead of jetson-tk1) as the board ID

As with the [Jetson](../jetsontk1) with this u-boot, set the
environment variable bootm_boot_mode to nonsec In this boot mode, the
standard Linux kernel will not boot: recompile with CONFIG_ARM_PSCI on
and CONFIG_CPU_IDLE off.

The Pinmux spreadsheet, for use with
<https://github.com/NVIDIA/tegra-pinmux-scripts> is
[here.](CEI_TK1_SOM_customer_pinmux_v11.xlsm)

The original pinmux spreadsheet from Colorado is
[here](tk1-som_pinmux_V2.4.xlsm)

## Accessing the MMC
Attach a USB cable
between the TK1-SOM's OTG port and your host, then on the U-Boot console
type `ums mmc 0`.

A spinning wheel will appear on the console, and the entire MMC will be
presented as a USB storage device to your host. In the default
partitioning (as it comes from Colorado Engineering) partition 1 on the
device is the UBUNTU root partition.

The [instructions for booting from SD](../GeneralARM#sd)
are also valid for booting from MMC.

## Serial Connection
 The serial port is at 1V8 levels on J8, as
follows: (pin one is farthest from the ground hole)

|Pin|Function|Direction|
|-|-|-|
|1 |Rx |In |
|2 |Tx |Out |
|3 |CTS |In |
|4 |RTS |Out |

There is no ground connection. There is however an unpopulated hole next
to J8 that is connected to Ground. Alternatively one can use pin 1 of J5
on the bottom (PSU) board as a ground connection. The pins are
unlabelled; pin 1 is the one in the middle of the board, under the gap
between J5 and J7 on the GPU/processor board. It's easiest to connect to
this if you unscrew and take the thing apart. Please do this at a
static-controlled workstation!

If you need 1V8 as a reference (VDIO on some FTDI connectors), it's
available on the JTAG connector at pin 1. Pin one is the top right pin
if the ethernet port is to your left. It is marked with a dot on the
silk-screen.

Speed 115200 8bits no parity; the default Linux image has login ubuntu,
password ubuntu.

## Peripherals
 We have an open-hardware CAN and I2C board available,
see [CAN-Board](CANBoard)

## DFU: Loading kernels over USB
You can load seL4 kernels over USB using dfu-util. (you can also use fastboot,
but to boot a kernel over fastboot means making the ELF file produced
from the build system look like an ANDROID Linux kernel).

On the u-boot console do:
```
setenv dfu_alt_info "kernel ram $loadaddr 0x1000000"
saveenv
```
once.

Then to boot, on the u-boot console do:
```
dfu 0 ram 0
```
and on your host:

- install dfu-util (one time only: apt-get install dfu-util)
- connect to the TK1-SOM using a USB connector to the on-the-go
        port

- run dfu-util (you may need to run this with sudo)

      dfu-util --device 0955:701a -a kernel -D sel4test-driver-image-arm-tk1 .
      dfu-util --device 0955:701a -e

  (if the -e option isn't supported you
  can add -R to the above command or ignore it and manually Ctrl-C out
  of dfu in u-boot on the TK1-SOM)


This will load the `sel4test-driver-image-arm-tk1` file onto the TK1-SOM
at address `$loadaddr`. You can then run it in uboot with

    bootefi $loadaddr

If you want, you can automate all this with:

    setenv bootcmd_dfu "dfu 0 ram 0; bootefi $loadaddr" saveenv

then just

    run bootcmd_dfu

If you ''always'' want to do this you can do

    setenv bootcmd "run bootcmd_dfu"

# Booting from a USB storage device

You can boot from a USB storage device, by plugging it into the blue
port (on the power supply board). Patches are pending upstream to enable
the other port too. Use a FAT32 or ext2 partition on the storage; put
your image on it. You can either use a syslinux-style menu, or can boot
directly.
```
usb start
fatload usb 0:1 ${loadaddr} sel4test-image-arm
bootelf ${loadaddr}
```

# Using L4T from CEI


CEI provides modifications to L4T and instructions for getting it
running on the TK1-SOM. Unfortunately these seem to only be available on
a private FTP site, so you'll have to contact CEI for access to those.

Once you have access, follow the instructions in the README.txt.

If you have a recent distribution and use the instructions from
Colorado, you will end up with an unbootable system --- the format of
the ext4 filesystem, created by the flash.sh script has features that
the u-boot and kernel cannot understand. The simple change is to build
an ext3 filesystem instead.

Do:


```
sudo env ROOTFS_TYPE=ext3 ./flash.sh -L bootloader/ardbeg/u-boot.bin tk1-som mmcblk0p1
```
instead of using the instructions in the Colorado-provided
README.txt

Alternatively we have a customised image that we use: more information
at [L4TCan](L4TCan).
