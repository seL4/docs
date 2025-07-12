---
arm_hardware: true
cmake_plat: tk1
xcompiler_arg: -DAARCH32=1
platform: Jetson TK1
arch: ARMv7A
virtualization: true
iommu: true
soc: NVIDIA Tegra K1
cpu: Cortex-A15
Status: "Verified"
verified: tk1
Contrib: Data61
Maintained: seL4 Foundation
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Jetson TK1

The [Jetson TK1](http://www.nvidia.com/object/jetson-tk1-embedded-dev-kit.html)
is a affordable embedded system developed by NVIDIA.

{% include hw-info.html %}

## Pre-Requisites

* One Tegra Board. See [Jetson TK1](http://www.nvidia.com/object/jetson-tk1-embedded-dev-kit.html)
* A working development environment. See the [set up
  instructions](/projects/buildsystem/host-dependencies.html).

## Getting Started

 To get started, check out the [NVIDIA developer
page](https://developer.nvidia.com/embedded-computing), make sure your board is
correctly configured and plugged.

## Build your first seL4 system

{% include sel4test.md %}

## Load the binary

You need to be able to see output from the serial console on the Tegra. Connect
the serial port to your computer with a serial cable, either a USB->RS232
converter, or if your computer has a serial port, connect to it.

Once you have the wires in place, you can connect to the console via
`screen` (or you can use minicom or another serial console program). In
the following, we assume that the Tegra is connected to `/dev/ttyUSB0`.

```sh
screen /dev/ttyUSB0 115200
```

When you start the board, you will see the U-Boot prompt. To load the
binary you need to interact with U-Boot. I personally use a DHCP/TFTP
server to get the binary onto the board. Copy `sel4.img` onto the tftp
server; if you've set up DHCP properly it will pass the server IP to the
board. Otherwise you can specify the IOP address on the command. The
following command will then scan the PCI bus and enable the ethernet,
and then ask to get an address via the DHCP and get `sel4.img` file from
the TFTP server at `192.168.1.1`.

```sh
pci enum dhcp ${loadaddr} 192.168.1.1:sel4.img
```

Then, let's start the program.

```sh
bootefi ${loadaddr}
```

## Flash U-Boot


Warning: This flashing procedure is for the Jetson TK1 by NVIDIA. There
is another TK1 board called the TK1-SOM by Colorado Engineering which
requires a different flashing procedure. Please be sure you're following
these instructions if you are truly trying to flash a **Jetson** and
not the **TK1-SOM**. If you are trying to flash a TK1-SOM, please
[use the procedure described here instead](CEI_TK1_SOM/#u-boot).

The initial version of U-Boot does not provides all necessary
functionality. In particular, it boots the system in secure mode. To run
a virtual machine monitor, the Tegra needs to be booted in nonsecure or
HYP mode. After installing a new u-boot (instructions below) you can
boot in either secure on non-secure mode based on a u-boot environment
variable.

Do

```sh
setenv bootm_boot_mode nonsec
saveenv
```

to boot in nonsecure (HYP)
mode. This also enables kvm if you boot Linux.

To go back to secure mode booting do

```sh
setenv bootm_boot_mode sec
saveenv
```

## Getting the sources

```bash
mkdir tegra-u-boot-flasher
cd tegra-u-boot-flasher
repo init -u https://github.com/NVIDIA/tegra-uboot-flasher-manifests.git
repo sync
```

## Building

To build the sources, build the necessary tools first.

Install autoconf, pkg-config, flex, bison, libcrypto++-dev and libusb-1.0.0-dev
for your distribution. On Debian or Ubuntu you can do:

```sh
sudo apt-get update
sudo apt-get install build-essential autoconf pkg-config flex bison libcrypto++-dev libusb-1.0.0-dev gcc-arm-linux-gnueabi
```

Then do:

```bash
cd scripts
./build-tools build
```

Then, in the script directory, build everything.

```bash
./build --socs tegra124 --boards jetson-tk1 build
```

## Flashing

To flash, attach the Jetson board's OTG USB port to a USB port on your machine.
Hold down the FORCE RECOVERY button while pressing the RESET button next to it;
release FORCE RECOVERY a second or two after releasing the reset button

Then issue:

```bash
./tegra-uboot-flasher flash jetson-tk1
```

The board should now be updated.

## Running Linux with the new U-Boot

To boot Linux in non-secure mode, build the kernel with the Power-State
Coordination Interface (PSCI) enabled (`CONFIG_ARM_PSCI=y`, in Kernel Features
menu)and CPU-Idle PM support disabled (`CONFIG_CPU_IDLE is not set` in CPU Power
Management->CPU Idle). Without these changes the kernel will hang.
