The TK1-SOM from Colorado engineering is a small form-factor system based on the Nvidia Tegra K1. Details and ordering are at https://tk1som.com/products/tk1-som

We are in the process of porting seL4 to this board.

For now, you can get U-Boot source that works from https://github.com/data61/u-boot-tk1-som 
A slightly different (reviewed) patch has been submitted for inclusion in upstream U-Boot.

The Pinmux spreadsheet, for use with [[https://github.com/NVIDIA/tegra-pinmux-scripts|https://github.com/NVIDIA/tegra-pinmux-scripts]] is [[attachment:CEI_TK1_SOM_customer_pinmux_v11.xlsm|here.]]

As with the [[Hardware/jetsontk1|Jetson]] with this u-boot, set the environment variable `bootm_boot_mode` to `nonsec`
In this boot mode, the standard Linux kernel will not boot: recompile with `CONFIG_ARM_PSCI` on and `CONFIG_CPU_IDLE` off.
