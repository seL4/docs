---
redirect_from:
  - /PortingSeL4
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Porting seL4 to a new platform

This section covers porting seL4 to a new ARM or RISC-V platform if it is not
already covered in the list of [supported seL4 platforms](../../Hardware/).

## Setup

In order to load the seL4 image (via some means) it is important to have a working bootloader.
We tend to use [U-Boot](https://www.denx.de/wiki/U-Boot) as it is open source, reliable and supports many different architectures.

There are a variety of ways of loading an seL4 image from U-Boot such as eMMC, TFTP, and USB.

### TFTP setup

For setting up a TFTP server to transfer images over the network, you can follow the
[UNSW Advanced Operating Systems course guide](https://www.cse.unsw.edu.au/~cs9242/19/project/linux.shtml).

Once you get U-Boot up and running it is a good idea (if the platform is supported) to flash a
Linux image onto the board. This way you can find the correct address to load the image into memory.
This is also useful for debugging, as you can use the FDT file system to dump addresses from a running system.

Once you have found the correct address to load, declare the boot command (where address 0x20000000 as an example):

```sh
bootcmd="tftpboot 0x20000000 /path/to/image && go 0x20000000"
saveenv
```

For TFTP, you will also need to set some U-Boot environment variables:

```sh
setenv ipaddr <BOARD ADDRESS>
setenv serverip <SERVER ADDRESS>
saveenv
```

### eMMC/SD card setup

We can load an image with the following command (using `0x20000000` as an example):

```sh
fatload mmc 0 0x20000000 /path/to/image
```

You can find more details in the [U-Boot documentation](https://docs.u-boot.org/en/latest/usage/cmd/fatload.html).

## seL4

In order to have a successful port of seL4 to your target ARM or RISC-V platform you will need to go through the following steps.

### Device Tree

Device Trees are used by ARM and RISC-V platforms to describe the hardware platform.
seL4 makes use of Device Trees at build time, which is why acquiring a Device Tree Source (DTS)
for your platform is one of the first steps.

seL4 relies on the DTS for the location and size of main memory as well as information
about certain devices used by the kernel such as the timer. In debug mode, seL4 also
makes use of the default serial device for debug output.

Often the Device Tree Source will be included in the
[Linux kernel source](https://github.com/torvalds/linux), from there you can decompile
the device tree blob (DTB) from building the Linux kernel to get the Device Tree that
Linux uses.

You can compile the Linux Device Tree Sources into a final Device Tree Blob with:

```sh
make ARCH=<arm/arm64/riscv> CROSS_COMPILE=<TOOLCHAIN> defconfig
make ARCH=<arm/arm64/riscv> CROSS_COMPILE=<TOOLCHAIN> dtbs
```

The DTBs can be found in `arch/<ARCH>/boots/dts/`.

The following command allows you to decompile the DTB:

```sh
dtc -I dtb -O dts /path/to/dtb -o linux.dts
```

It should be noted that you may need to add device nodes depending on what Linux uses
and what is required by seL4. For example, some platforms do not include a node for
main memory in the Linux Device Tree. This is because Linux can get
this information at run-time from a previous bootloader. This is not the case for seL4
as it consumes the Device Tree at build-time.

In the seL4 source, each platform has an overlay DTS that is responsible for dealing
with seL4-specific device nodes. Below is an example
(from the [ROCKPro64](https://github.com/seL4/seL4/blob/master/src/plat/rockpro64/overlay-rockpro64.dts)):

```dts
/ {
    chosen {
        seL4,elfloader-devices =
            "serial2",
            &{/psci},
            &{/timer};
        seL4,kernel-devices =
            "serial2",
            &{/interrupt-controller@fee00000},
            &{/timer};
    };
};
```

These overlay files give a good idea of what nodes seL4 requires in the DTS other than
main memory.

You will need to create a similar overlay DTS in `src/plat/<platform>/overlay-<platform>.dts`
as part of the platform port.

### Hardware generation script

Depending on your platform and the way the DTS is defined you may need to modify the
`seL4/tools/hardware_gen.py` script.

From the above example the ROCKPro64 needed a memory node so that this script could
define working memory. Other gotchas could include interrupt cells, interrupt numbers being
mapped wrongly, or incorrect addresses.

The kernel also expects drivers for:

* the timer device.
* the serial device.
* the interrupt controller.
* the IOMMU if the kernel is being built with IOMMU support.

You can check all the supported drivers in `seL4/tools/hardware.yml`.

If the platform has devices that do not already have corresponding drivers, you can add
them in `seL4/src/drivers/` and `seL4/include/drivers/`.

### Kernel

You will need to add `seL4/libsel4/sel4_plat_include/<platform>/sel4/plat/api/constants.h`.
Depending on your platform, this is either empty or requires defining the value for `seL4_UserTop`.
Look in the other platform files for examples similar to your platform.

You will need to add a CMake configuration file for the platform at `kernel/src/plat/<platform>/config.cmake`.
It is best to base the contents of this file off of other platforms of the same architecture.

## Testing your seL4 port

When you contribute your port to seL4, sel4test must execute successfully and so the next
step to check that your port works would be to get
[the seL4test project](../sel4test/) working.

### ELF-loader

Before we can run sel4test, we need to have seL4 booting first.

Although we use U-Boot as a bootloader, there are additional steps needed to initialise the
hardware and setup system images before we can boot seL4. This is the purpose of the
[ELF-loader](../elfloader/).

The code for the ELF-loader can be found in the `elfloader-tool` directory at the root of
the [seL4_tools](https://github.com/seL4/seL4_tools) repository.

Depending on your platform, you may have to make changes to the ELF-loader, which is
responsible for loading the kernel and any user-programs. The ELF-loader outputs to the
serial, so needs to be able to access the UART.

On RISC-V, outputting to UART is done via a call to the SBI layer so no changes are necessary.

On ARM, there are a variety of existing UART drivers in `tools/elfloader-tool/src/drivers/uart/`.
If the default serial is not supported by any of these drivers, you will have to
provide a simple putchar implementation.

If the system image that is produced by the ELF-loader build system needs be a particular file
format (e.g binary or EFI) or needs to start at a particular physical address, you can
configure the default platform options in `seL4_tools/cmake-tool/helpers/application_settings.cmake`.

### seL4test

seL4test needs user level serial and timer drivers to run. Add these drivers and the following
files to [libplatsupport](https://github.com/seL4/util_libs/tree/master/libplatsupport)
in order to get the test suite running. The directory structure and
files will look something like the following. Some of these files may not have anything in
them but include them anyway to keep the build system happy.

Use the other platforms as examples; generally you will have to configure the timer driver by
reading the manual, it may have its own unique programming sequence and can sometimes be a bit tricky.

If the technical reference manual does not contain enough detail, you may be able to gain more
information by looking at the respective Linux driver for the device. This can be done by searching
for the value of the 'compatible' field that is on each device node in a DTS in the Linux source code.

You can find the physical addresses and interrupt numbers for each device in its platform reference
manual and copy them into the right places.

`util_libs/libplatsupport/plat_include/<platform>/`

* `clock.h`
* `gpio.h`
* `i2c.h`
* `mux.h`
* `serial.h`
* `timer.h`

`util_libs/libplatsupport/src/plat/<platform>/`

* `chardev.c`
* `ltimer.c`
* `serial.c`
* `timer.c`

### sel4test configurations

The default configuration of seL4 in sel4test is non-MCS, single-core, with no hypervisor mode.

After confirming that the default configuration successfully runs (in both debug and release mode),
it is a good idea to test the more complex configurations with your port as well.

### Gotchas

Incorrect address alignment and incorrect memory regions can cause instruction faults. One way to debug this, is
to shorten memory regions in DTS memory nodes to check you are touching the correct area.

## Contributing

Once you have a working port that passes seL4test, see the guides for
[contributing in general](https://sel4.systems/Contribute/)
and [contributing kernel changes](kernel-contribution.html).
