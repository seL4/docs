---
arm_hardware: true
cmake_plat: tx1
xcompiler_arg: -DAARCH64=1
platform: TX1
arch: ARMv8A, AArch64 only
virtualization: true
iommu: true
soc: NVIDIA Tegra X1
cpu: Cortex-A57 Quad
Status: Unverified
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Jetson TX1

{% include hw-info.html %}

The Jetson TX1 is a multimedia and DSP board with a highly
optimized 64-bit memory controller which supports low latency accesses
from the CPU, high bandwidth accesses from the GPU and bounded latency
accesses from real-time devices such as the display.

It has two multi-core CPU clusters, each with 4 identical cores (One
Cortex-A57 cluster and one Cortex-A53 cluster). Each cluster has its own
L2 cache. Both clusters are ARMv8 compliant platforms. In addition the
Tx1 has an ARM7 shadow Co-processor.

The seL4 kernel has a limited port to the TX1 which supports the SoC
only in 64-bit mode. SMP, SMMU, Hyp-mode, etc are not supported by the
current port of the seL4 kernel to the TX1.

The stock TX1 comes with support for booting using DFU, using an SD-card
or by copying the OS you would like to boot onto the internal 15 GiB USB
mass storage that comes with the TX1.

Unfortunately the stock U-boot that comes with the TX1 does not support
TFTP-boot over the Ethernet port. You can get U-boot to support the
TX1's Ethernet driver and enable TFTP-boot, but this is beyond the scope
of this article since it entails compiling a custom U-boot and then
flashing it onto the board.

## Building seL4test

{% include sel4test.md %}

The TX1 also supports AArch32 mode. If you choose to build the AArch32 kernel,
please be sure to pass `-DAARCH32=1` instead of `-DAARCH64=1`.

## Booting via TFTP
 Unfortunately the stock U-boot that comes with
the TX1 does not support TFTP because
[it does not come with an ethernet driver](https://devtalk.nvidia.com/default/topic/962946/tx1-pxe-boot/), but if you so choose, it
seems that it is possible to recomplile u-boot with support for the
ethernet driver, and then flash your custom U-boot onto your TX1.
Instructions on how to do this are not included here.

## Booting via DFU

To boot via DFU, attach the usb-mini end of a USB cable to the USB-mini
port on the TX1. Then plug in the power supply for the TX1 and power it
on. When the TX1 is powered on, pay attention to the text being printed
out so that you can stop the boot process at the U-boot command prompt.
When you have successfully got to the U-boot command prompt, enter the
following:
```
setenv dfu_alt_info "kernel ram 0x82000000 0x1000000"
setenv bootcmd_dfu "dfu 0 ram 0; go 0x82000000"
saveenv
```

To make U-boot enter its DFU server mode now, just type:
run bootcmd_dfu. U-boot should sit still waiting for a kernel image to
be uploaded. Now you should open up a new terminal on your PC, and type
the following:
```
dfu-util --device 0955:701a -a kernel -D <PATH_TO_YOUR_SEL4_IMAGE>/sel4test-driver-image-arm-tx1
```

You may need to give dfu-util root privileges. If dfu-util is unable to
find the TX1 device, try unplugging and replugging in the USB mini-cable
that connects your PC to the TX1.

## Booting via SD Card

Get an SD card and format it with either FAT32, EXT2 or EXT4. Then build
seL4test, or any of the other seL4 projects. The resulting image file
should be placed inside of /images within the build directory. Take that
image file, and copy it to the root folder of the SD card you intend to
use with your TX1.

Insert this SD card into your TX1 and then power on the TX1, and drop
into the U-boot command prompt. When you're at the prompt, please type
the following:

For FAT32:
```
fatload mmc 1 0x82000000 sel4test-driver-image-arm-tx1
go 0x82000000
```

For EXT2:
```
ext2load mmc 1 0x82000000 sel4test-driver-image-arm-tx1
go 0x82000000
```

For EXT4:
```
ext4load mmc 1 0x82000000 sel4test-driver-image-arm-tx1
go 0x82000000
```

## Internal 15 GiB USB mass storage

Booting off the internal USB mass storage is almost the same as booting
off the SD card, but in particular, you should do something along the
lines of:

Attach a USB mini cable to the mini-USB port on the TX1, and the other
end of the cable to your PC. Then power on the TX1 and drop into the
U-boot command line, and do the following:

```
ums mmc 0
```

Your PC should now show that a new USB mass storage device has been
connected. Copy the seL4 image into the root directory of this mass
storage device, then unmount it and remove it safely. Then go back to
the U-boot command line and press Ctrl+C to exit the mass-storage
server. Then, type the following, depending on the filesystem type that
you formatted the internal mass storage device to (or if you didn't
personally format it, then whatever filesystem already existed on the
internal mass storage):

For FAT32:
```
fatload mmc 0 0x82000000 sel4test-driver-image-arm-tx1
go 0x82000000
```

For EXT2:
```
ext2load mmc 0 0x82000000 sel4test-driver-image-arm-tx1
go 0x82000000
```

For EXT4:
```
ext4load mmc 0 0x82000000 sel4test-driver-image-arm-tx1
go 0x82000000
```
