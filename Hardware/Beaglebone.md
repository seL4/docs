---
arm_hardware: true
cmake_plat: am335x-boneblack
xcompiler_arg: -DAARCH32=1
platform: BeagleBone Black / Blue
arch: ARMv7A
virtualization: false
iommu: false
soc: AM335x
cpu: Cortex-A8
Status: Unverified
Contrib: Community
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# BeagleBone Black / Blue

This page contains info about building seL4 on
[BeagleBone Black](https://beagleboard.org/black) and
[BeagleBone Blue](https://beagleboard.org/blue).

{% include hw-info.html %}

## Building for the BeagleBone Black / Blue

These instructions were written by Tim Newsham. The BeagleBone is
a community-supported port.

### Requirements

We suggest using the `arm-linux-gnueabi-` cross-compilers. Use
[the instructions on getting a toolchain](/projects/buildsystem/host-dependencies.html).

### Building

#### seL4test

For BeagleBone Blue, substitute `am335x-boneblack` with `am335x-boneblue`.

{% include sel4test.md %}

## Booting on the BeagleBone Black / Blue

### Hardware Requirements (BeagleBone Black)

* Power supply (5V DC or miniUSB cable)
* Serial adapter <http://elinux.org/Beagleboard:BeagleBone_Black_Serial>
* microSD card for file booting or Ethernet cable for network boot

### Hardware Requirements (BeagleBone Blue)

* Power supply (12V DC, 2S LiPo battery or microUSB)
* Serial adapter (Connect to UT0 header)
* microSD card for file booting or microUSB cable for network boot

### Interacting with U-Boot

Connect a serial adapter between your development box and the BeagleBone. Use
a serial program such as `picocom` or `screen` to connect to the serial port:

```sh
picocom /dev/ttyUSB0 -b 115200
```

Power on the device and hit space a few times to interrupt the normal boot
process and get a U-Boot prompt.

#### Booting from microSD card

To boot from a microSD card, copy the `sel4test-driver-image-arm-am335x` file
to a FAT32 partition the microSD card and insert the card in the BeagleBone.

At the U-Boot prompt, enter the following to load and run the image:

```none
fatload mmc 0 ${loadaddr} sel4test-driver-image-arm-am335x
bootm ${loadaddr}
```

#### Booting from TFTP

To boot over Ethernet, configure your DHCP server to provide a DHCP lease and
to specify the `sel4test` image as the boot file.
Configure a TFTP server to serve the `sel4test-driver-image-arm-am335x` file.

For BeagleBone Black, plug in an Ethernet cable. For BeagleBone Blue, make sure
a microUSB cable is plugged in and connected to a computer running a DHCP
server. Then, at the U-Boot prompt enter:

```none
dhcp
bootm ${loadaddr}
```

To load an alternate image from the TFTP server at 1.2.3.4, use:

```none
dhcp ${loadaddr} 1.2.3.4:refos-image-arm-am335x
bootm ${loadaddr}
```

## Other resources

* [Supporting the UART1 interface with CAmkES](http://julien.gunnm.org/geek/sel4/beaglebone%20black/2016/06/15/beaglebone-black-sel4-uart1/)
