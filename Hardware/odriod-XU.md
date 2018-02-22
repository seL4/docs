# seL4 on the Odroid XU


This page provides info on the
[Odroid-XU](http://www.hardkernel.com/main/products/prdt_info.php?g_code=G137510300620)
Exynos 5 board

seL4 assumes that one boots in HYP mode. To do this, one needs a new
signed bootloader.

Follow the instructions
\[\[<http://forum.odroid.com/viewtopic.php?f=64&t=2778&sid=be659cc75c16e1ecf436075e3c548003&start=60#p33805%7Con>
the HardKernel Forum\]\] to get and flash the firmware

The standard U-Boot will allow booting via Fastboot or by putting the
bootable ELF file onto an SD card or the eMMC chip.

## Run seL4test using fastboot
 === Get and build sel4test ===
{{{\#!highlight bash numbers=off mkdir seL4test cd seL4test repo init -u
<https://github.com/seL4/sel4test-manifest.git> repo sync make
odroidxu\_release\_xml\_defconfig }}} As always, you may need to change
the CROSS\_COMPILE\_PREFIX by doing make menuconfig.

### Put seL4test onto the board
 Boot the Odroid, with serial cable
attached, and a terminal emulator attached to the serial port.

Interrupt U-Boot's autoboot by hitting SPACE

Enter Fastboot mode by typing fastboot

On the host,

{{{\#!highlight bash numbers=off

:   mkimage -A arm -a 0x48000000 -e 0x48000000 -C none -A arm -T kernel
    -O qnx -d images/sel4test-driver-image-arm-exynos5 image

fastboot boot image }}}
