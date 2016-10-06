The TK1-SOM from Colorado engineering is a small form-factor system based on the Nvidia Tegra K1. Details and ordering are at https://tk1som.com/products/tk1-som

We are in the process of porting seL4 to this board.

Upstream U-Boot now supports this board.

The Pinmux spreadsheet, for use with https://github.com/NVIDIA/tegra-pinmux-scripts is [[attachment:CEI_TK1_SOM_customer_pinmux_v11.xlsm|here.]]

As with the [[Hardware/jetsontk1|Jetson]] with this u-boot, set the environment variable `bootm_boot_mode` to `nonsec` In this boot mode, the standard Linux kernel will not boot: recompile with `CONFIG_ARM_PSCI` on and `CONFIG_CPU_IDLE` off.
== Serial Connection ==


The serial port is at 1V8 levels on J8, as follows: (pin one is farthest from  the ground hole)
|| '''Pin''' || '''Function''' ||  '''Direction''' ||
||1	||Rx||	In||
||2	||Tx	||Out||
||3	||CTS	||In||
||4	||RTS	||Out||

There is no ground connection.  There is however an unpopulated hole next to J8 that is connected to Ground.  Alternatively one can use pin 1 of J5 on the bottom (PSU) board as a ground connection.  The pins are unlabelled; pin 1 is the one in the middle of the board, under the gap between J5 and J7 on the GPU/processor board.  It's easiest to connect to this if you unscrew and take the thing apart.  Please do this at a static-controlled workstation!

If you need 1V8 as a reference (VDIO on some FTDI connectors), it's available on the JTAG connector at pin 1.

Speed 115200 8bits no parity; the default Linux image has login `ubuntu`, password `ubuntu`.

== DFU: Loading kernels over USB ==
You can load seL4 kernels over USB using `dfu-util`. (you can also use fastboot, but to boot a kernel over fastboot means making the ELF file produced from the buld system look like an ANDROID Linux kernel).

On the u-boot console do:

 `setenv dfu_alt_info "kernel ram $loadaddr 0x1000000"`
 `saveenv`

once.

Then to boot, on the u-boot console do:
 `dfu 0 ram 0`
and on your host (connected to the TK1-SOM using a USB connector to the on-the-go port), do:
 `dfu-util  --device 0955:701a -a kernel -D sel4test-driver-image-arm-tk1 -R`

This will load the `sel4test-driver-image-arm-tk1` file onto the TK1-SOM at address `$loadaddr`.
You can then run it with
 `bootelf $loadaddr`


If you want, you can automate all this with:
 
 `setenv bootcmd_dfu "dfu 0 ram 0; bootelf $loadaddr"`
 `saveenv`

then just 
 `run bootcmd_dfu`
If you ''always'' want to do this you can do
 `setenv bootcmd "run bootcmd_dfu"`
