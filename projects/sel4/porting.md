---
redirect_from:
  - /PortingSeL4
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Porting seL4 to a new platform

## Setup

In order to load the seL4 image (via some means) it is important to have a working bootloader.
We tend to use [U-boot](https://www.denx.de/wiki/U-Boot) as it is open source, reliable and supports many different architectures.

For initial setup you can follow the instructions on the UNSW advanced operating systems website regarding [setting up a tftp server](https://www.cse.unsw.edu.au/~cs9242/19/project/linux.shtml).

Once you get U-boot up and running it is a good idea (if the platform is supported) to flash a
Linux image onto the dev board. This way you can find the correct address to load the image into memory.
This is also useful for debugging, as you can use the FDT file system to dump addresses from a running system.

Once you have found the correct address to load, you can use the command `bootcmd="tftpboot 0x20000000 sel4_image && go 0x20000000"`
(using 0x20000000 as an example) followed by `saveenv` to save the starting address onto the boards flash memory.
You will also need to set the 'ipaddr' and 'serverip' details can be found in the link above.

## seL4

In order to have a successful port of seL4 to your target ARM platform you will need to go through the following steps.

### DTS

Look for DTS and drivers inside the [Linux repository](https://github.com/torvalds/linux), normally they will be supported. If they are supported clone Linux and modify the `update-dts.sh` to add your target. Run the script located in `kernel/tools/dts/update-dts.sh` at the cloned Linux repository. This will create a "platform.dts" file from Linux inside the dts folder in the kernel. You may need to add device nodes depending on what Linux uses and what is required by seL4. For example, in the port of the Rockpro64 a memory node and an extra timer node were needed so these had to be defined manually.

### Hardware generation script

Depending on your platform and the way the DTS is defined you may need to modify the hardware_gen.py script.
From the above example the Rockpro64 needed a memory node so that this script could define working memory.
Other gotchas could include interrupt cells, interrupt numbers being mapped wrongly, or incorrect addresses.
Also serial and timer drivers will need to be added to the kernel if they don't already exist. You can check this through
the DTS device strings and compare to the hardware.yml file in `kernel/tools/hardware.yml`. If needed add the required drivers in `kernel/drivers/`.

### Kernel

You will need to add `libsel4/sel4_plat_include/<platform>/sel4/plat/api/constants.h` and add sel4_UserTop depending on what you support. Look in the other platform files for examples similar to your platform.

### CMake-build system

You will need to modify the build system in two places. Firstly in the kernel's platform folder, you define `kernel/src/plat/<platform>/config.cmake`, again you can look at other platforms for examples.
Secondly, you will need to add 'KernelPlatform' to the cmake and elf-loader tools. You can do this by editing
`tools/cmake-tool/helpers/application_settings.cmake` and `tools/elfloader-tool/CMakeLists.txt`.

### ELF-loader

You will need to add directories and files `tools/elfloader-tool/src/plat/<platform>/sys_fputc.c` and
`tools/elfloader-tool/include/plat/<platform>/platform.h` which will provide a simple implementation of putchar with a physical address for uart for the elf loader to use.

## seL4 test

seL4test needs user level serial and timer drivers to run. Add these drivers and the following files to libplatsupport in
order to get the test suite running. The directory structure and files will look something like the following. Some of these
files may not have anything in them but include them anyway to keep the build system happy.

Use the other platforms as examples; generally you will have to configure the timer driver by reading the manual, it may have it's
own unique programming sequence and can sometimes be a bit tricky.

You can find the physical addresses and interrupt numbers for each device in its platform reference manual and copy them into the right places.

`libplatsupport/plat_include/<platform>/`
	-`clock.h`
	-`gpio.h`
	-`i2c.h`
	-`mux.h`
	-`serial.h`
	-`timer.h`
`libplatsupport/src/plat/<platform>/`
	-`chardev.c`
	-`ltimer.c`
	-`serial.c`
	-`timer.c`

### Gotchas

Incorrect address alignment and incorrect memory regions can cause instruction faults. One way to debug this, is
to shorten memory regions in DTS memory nodes to check you are touching the correct area.

Once you have succeeded with your port and have seL4 test passing in release mode, you can add an entry to the CHANGES file describing the platform you added and submit a pull request on the seL4 github.
