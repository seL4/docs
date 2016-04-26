The [[http://www.nvidia.com/object/jetson-tk1-embedded-dev-kit.html|Jetson TK1]] is a affordable embedded system developed by NVIDIA. It runs seL4. We will explain how to run seL4 on the Tegra.

= Pre-Requisites =
 * One Tegra Board. See [[http://www.nvidia.com/object/jetson-tk1-embedded-dev-kit.html|Jetson TK1]]
 * The development environment fully working. See [[Getting started]]

= Getting Started =
To get started, check out the [[https://developer.nvidia.com/embedded-computing|NVIDIA developer page]], make sure your board is correctly configured and plugged.


= Build your first seL4 system =
First, check out the seL4 project.
{{{
$ mkdir tegra-test
$ repo init -u https://github.com/seL4/sel4test-manifest.git
$ repo sync
}}}

Then, use the default config for the tegra and build the system.
{{{
$ make tk1_debug_xml_defconfig
$ make
}}}

Once the system is compiled, you will have a new file creates in the ''images'' directory

{{{
$ ls images/
sel4test-driver-image-arm-tk1
$ 
}}}

To create the binary that will ultimately be executed, you can follow the same instructions as for the [[Beaglebone]]: 

{{{
arm-linux-gnueabi-objcopy --output-target binary images/sel4test-driver-image-arm-tk1 sel4test.bin
}}}

= Load the binary =
First of all, you should connect on the console of the tegra. To do so, you need a COM port to connect on the console port of the Tegra. I am using a USB/serial cable with a null modem.

Once you have the wires in place, you can connect to the console via screen. In the following, we assume that your COM port is /dev/ttyUSB0.

{{{
screen /dev/ttyUSB0 115200
}}}

When you start the board, you have the u-boot prompt. To load the binary you need to interact with u-boot. I personally uses a dhcp/tftp server to upload the binary directly on the board. I have the tegra connected on my computer. The tegra gets an IP address via the DHCP server and gets the binary.

The following command will then ask to get an address via the DHCP and get the sel4.img file on the tftp server at 192.168.1.1.

{{{
dhcp ${loadaddr} 192.168.1.1:sel4.img
}}}

Then, let's start the program.

{{{
go ${loadaddr}
}}}


= Flash u-boot =
