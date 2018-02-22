The
[Jetson TK1](http://www.nvidia.com/object/jetson-tk1-embedded-dev-kit.html) is a affordable embedded system developed by NVIDIA. It runs
seL4. We will explain how to run seL4 on the Tegra.
<<TableOfContents>> = Pre-Requisites = \* One Tegra Board.
See
[Jetson TK1](http://www.nvidia.com/object/jetson-tk1-embedded-dev-kit.html) \* The development environment fully working. See [[Getting
started]]

# Getting Started
 To get started, check out the
[[<https://developer.nvidia.com/embedded-computing%7CNVIDIA> developer
page]], make sure your board is correctly configured and plugged.

# Build your first seL4 system
 First, check out the seL4 project.
{{{\#!highlight bash numbers=off $ mkdir tegra-test $ repo init -u
<https://github.com/seL4/sel4test-manifest.git> $ repo sync }}}

Then, use the default config for the tegra and build the system.
{{{\#!highlight bash numbers=off $ make tk1_debug_xml_defconfig $
make }}}

Once the system is compiled, you will have a new file creates in the
"images" directory

{{{\#!highlight bash numbers=off $ ls images/
sel4test-driver-image-arm-tk1 $ }}}

# Load the binary
 You need to be able to see output from the serial
console on the Tegra. Connect the serial port to your computer with a
serial cable, either a USB->RS232 converter, or if your computer has
a serial port, connect to it.

Once you have the wires in place, you can connect to the console via
screen (or you can use minicom or another serial console program). In
the following, we assume that the Tegra is connected to /dev/ttyUSB0.

`\#!highlight bash numbers=off screen /dev/ttyUSB0 115200 `

When you start the board, you will see the U-Boot prompt. To load the
binary you need to interact with U-Boot. I personally use a DHCP/TFTP
server to get the binary onto the board. Copy sel4.img onto the tftp
server; if you've set up DHCP properly it will pass the server IP to the
board. Otherwise you can specify the IOP address on the command. The
following command will then scan the PCI bus and enable the ethernet,
and then ask to get an address via the DHCP and get sel4.img file from
the TFTP server at 192.168.1.1.

` pci enum dhcp ${loadaddr} 192.168.1.1:sel4.img `

Then, let's start the program.

` bootelf ${loadaddr} `

# Flash U-Boot


Warning: This flashing procedure is for the Jetson TK1 by NVIDIA. There
is another TK1 board called the TK1-SOM by Colorado Engineering which
requires a different flashing procedure. Please be sure you're following
these instructions if you are truly trying to flash a '''Jetson''' and
not the '''TK1-SOM'''. If you are trying to flash a TK1-SOM, please
[[<https://wiki.sel4.systems/Hardware/CEI_TK1_SOM#U-Boot%7Cuse> the
procedure described here instead]].

The initial version of U-Boot does not provides all necessary
functionality. In particular, it boots the system in secure mode. To run
a virtual machine monitor, the Tegra needs to be booted in nonsecure or
HYP mode. After installing a new u-boot (instructions below) you can
boot in either secure on non-secure mode based on a u-boot environment
variable.

Do
==

setenv bootm_boot_mode nonsec saveenv }}} to boot in nonsecure (HYP)
mode. This also enables kvm if you boot Linux.

To go back to secure mode booting do {{{ setenv bootm_boot_mode sec
saveenv }}} == Getting the sources ==

{{{\#!highlight bash numbers=off mkdir tegra-u-boot-flasher cd
tegra-u-boot-flasher repo init -u
<git@github.com>:NVIDIA/tegra-uboot-flasher-manifests.git repo sync }}}

If you have some difficulties with the git:// protocol, (which will work
only if you have a github account, and have installed an SSH key there),
remove the new-u-boot-flasher directory, and start again thus:
{{{\#!highlight bash numbers=off mkdir tegra-u-boot-flasher cd
tegra-u-boot-flasher repo init -u
<https://github.com/NVIDIA/tegra-uboot-flasher-manifests.git> repo sync
}}}

## Patching the sources


Apply the following patch to increase the console buffer size.
{{{\#!highlight diff numbers=off diff --git
a/include/configs/tegra-common.h b/include/configs/tegra-common.h index
1c469d0..234023d 100644 --- a/include/configs/tegra-common.h +++
b/include/configs/tegra-common.h @@ -77,7 +77,7 @@ \* Increasing the
size of the IO buffer as default nfsargs size is more \* than 256 and so
it is not possible to edit it */ -\#define CONFIG_SYS_CBSIZE (256* 2)
/\* Console I/O Buffer Size */ +\#define CONFIG_SYS_CBSIZE (256* 3)
/\* Console I/O Buffer Size */ /* Print Buffer Size \*/ \#define
CONFIG_SYS_PBSIZE (CONFIG_SYS_CBSIZE +
sizeof(CONFIG_SYS_PROMPT) + 16) }}}

## Building
 To build the sources, build the necessary tools first.

Install autoconf, pkg-config, flex, bison, libcrypto++-dev and
libusb-1.0.0-dev for your distribution. On Debian or Ubuntu you can do:
{{{ sudo apt-get update sudo apt-get install build-essential autoconf
pkg-config flex bison libcrypto++-dev libusb-1.0.0-dev
gcc-arm-linux-gnueabi }}}

Then do: {{{\#!highlight bash numbers=off cd scripts ./build-tools build
}}}

Then, in the script directory, build everything.

{{{\#!highlight bash numbers=off ./build --socs tegra124 --boards
jetson-tk1 build }}}

## Flashing
 To flash, attach the Jetson board's OTG USB port to a USB
port on your machine. Hold down the FORCE RECOVERY button while pressing
the RESET button next to it; release FORCE RECOVERY a second or two
after releasing the reset button

Then issue: {{{\#!highlight bash numbers=off ./tegra-uboot-flasher flash
jetson-tk1 }}}

The board should now be updated.

## Running Linux with the new U-Boot
 To boot Linux in non-secure
mode, build the kernel with the Power-State Coordination Interface
(PSCI) enabled (CONFIG_ARM_PSCI=y, in Kernel Features menu)and
CPU-Idle PM support disabled (CONFIG_CPU_IDLE is not set in CPU Power
Management->CPU Idle). Without these changes the kernel will hang.
