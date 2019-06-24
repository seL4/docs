---
arm_hardware: true
cmake_plat: am335x-boneblack
xcompiler_arg: -DAARCH32=1
platform: BeagleBone Black / Blue
arch: ARMv7A
virtualization: "No"
iommu: "No"
soc: AM335x
cpu: Cortex-A8
Status: Unverified
Contrib: Community
Maintained: Data61
---
# BeagleBone Black / Blue

This page contains info about
building seL4 on [BeagleBone Black](https://beagleboard.org/black) and
[BeagleBone Blue](https://beagleboard.org/blue).

## Building for the BeagleBone Black / Blue
 These instructions were written
by Tim Newsham. The BeagleBone is a community-supported port.

### Requirements
 We suggest using the `arm-linux-gnueabi-`
cross-compilers. Use
[the instructions on getting a toolchain](/GettingStarted#getting-cross-compilers).

### Building
#### seL4test

For BeagleBone Blue, substitute `am335x-boneblack` with `am335x-boneblue`.

{% include sel4test.md %}

## Booting on the BeagleBone Black / Blue
### Hardware Requirements (BeagleBone Black)
* power supply
* serial adapter <http://elinux.org/Beagleboard:BeagleBone_Black_Serial>
* SDCard for file booting or Ethernet cable for network boot

### Hardware Requirements (BeagleBone Blue)
* Power supply (12V DC, 2S LiPo battery or microUSB)
* Serial adapter (Connect to UT0 header)
* microSD card

### Interacting with U-Boot
 Connect a serial adapter between your
development box and the BeagleBone. Use a serial program such as
minicom or screen to connect to the serial port at 115200 bps
```bash
screen /dev/ttyUSB0 115200
```
Power on the device and hit enter a few times to interrupt the
normal boot process and get a U-Boot prompt.

#### Booting from microSD card

To boot from SDcard, copy the sel4test-driver-image-arm-am335x binary to a FAT32 partition
on an SDCard and place the card in the BeagleBone. Connect the
serial device, power up the Beaglebone, and hit ENTER to interrupt
the normal boot process. Finally, enter the following commands at the
U-Boot prompt to load and run the image:
```
fatload mmc 0 ${loadaddr} sel4test-driver-image-arm-am335x
go ${loadaddr}
```

#### Booting from TFTP (BeagleBone Black only)

To boot over Ethernet, configure your DHCP server to provide a DHCP
lease and to specify sel4test (or refos) as the boot file.
Configure a TFTP server to serve sel4test-driver-image-arm-am335x file. Plug the Ethernet
cable and connect the serial device to the Beaglebone black. Power the
device up and hit ENTER to interrupt the normal boot process. Then, at
the U-Boot prompt enter:
```
dhcp
go ${loadaddr}
```
To load an alternate image from the TFTP server at 1.2.3.4, use:
```
dhcp ${loadaddr} 1.2.3.4:refos-image-arm-am335x
go ${loadaddr}
```
## Other resources
* [Supporting the UART1 interface with CAmkES](http://julien.gunnm.org/geek/sel4/beaglebone%20black/2016/06/15/beaglebone-black-sel4-uart1/)
