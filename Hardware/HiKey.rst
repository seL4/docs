= Pre-Requisites =
 * One Hikey Board. See [[http://www.96boards.org/products/ce/hikey/|Hikey 96Board]]
 * Fully working development environment. See [[https://wiki.sel4.systems/Getting%20started|Getting started]]

= Getting Started =
Hikey board is based around the [[https://github.com/96boards/documentation/blob/master/hikey/Hi6220V100_Multi-Mode_Application_Processor_Function_Description.pdf|HiSilicon Kirin 620]] eight-core ARM Cortex-A53 64-bit SoC running at 1.2GHz. However, before start using 32-bit seL4 some changes should be made to the firmware. Check out the [[https://github.com/96boards/documentation/wiki/HiKeyUEFI|HiKeyUEFI]] page, make sure your board is correctly configured and plugged.

 * Before compiling the '''linaro-edk2''', make sure to appy [[https://stage.sel4.systems/hikey.patch|this patch]].
 * When creating the '''boot-fat.uefi.img''' partition, replace the default fastboot with newly generated one.
 * Copy the file '''noboot.efi''' to '''boot-fat.uefi.img''' partition.
 * Use UART0 instead of UART3 as the console by uncomment the appropriate line(s) in '''LinaroPkg/platforms.config''' before compiling the '''linaro-edk2'''.

= Build your first seL4 system =

First, check out the seL4 project.
{{{
$ mkdir hikey-test
$ repo init -u https://github.com/seL4/sel4test-manifest.git
$ repo sync
}}}
Then, use the default config for the hikey and build the system.

{{{
$ make hikey_aarch32_debug_xml_defconfig
}}}
Then, use ''menuconfig > Tools > Build elfloader > Boot image type'' and choose ''Binary Boot Image''

{{{
$ make menuconfig
$ make
}}}
Once the system is compiled, you will have a new image file created in the images directory

{{{
$ ls images/sel4test-driver-image-arm-hikey.bin $
}}}
= Load the binary =
First of all, you should connect to the console of the hikey. To do so, you need a COM port to connect on the console port of the Hikey. I am using a USB/serial cable with a null modem. Once you have the wires in place, you can connect to the console via ''minicom''. When you start the board, interrupt the default boot process to start the fastboot or use that jumper of pin5-pin6 on J15 to select fastboot as default, [[https://github.com/96boards/documentation/wiki/HiKeyUEFI#run-fastboot-from-uefi|see this]].

use ''fastboot'' to start the image
{{{
fastboot boot image/images/sel4test-driver-image-arm-hikey.bin -c mode=32bit
}}}
