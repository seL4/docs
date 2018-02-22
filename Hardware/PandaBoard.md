{{{\#!wiki warning The following information is very out of date. Please
update if you know the current procedure. }}}

!PandaBoard is based on TI OMAP4 dual-core ARM CPU. The Fastboot is used
to upload and boot the kernel.

## Where to get the seL4 kernel for Pandaboard?
 The code now lives in
c-kernel-experimental arm-mpcore branch. The second core could be
activated or not according to your configuration. To build the kernel,
you need to use the Kbuild file under the top-level source tree instead
of Makefile.

## SD card setup
 ====== Prologue ====== The first stage boot loader
expects to find the TI X-loader in te root of a FAT filesystem, on the
first partition of the SD card with the name MLO.

MLO expects to find a file named u-boot.bin in the root directory of the
SD card.

###### Original panda
 Download to the SD card.

###### Panda ES
 Download to the SD card. These files will need to
be renamed to MLO and u-boot.bin respectively.

The reason to patch the u-boot is because the fastboot jumps to the
kernel entry point directly but seL4 image needs a elf-loader to parse
and load correctly, so in the lib_arm/armlinux.c file, insert
do_bootelf(0, 0, 1, 0) before theKernel(0, bd-&gt;bi_arch_number,
bd-&gt;bi_boot_params)

## Steps to boot seL4 kernel


:   1.  Download the tool. Alternatively, clone and build the tool from
        source &lt;TODO Fastboot link&gt;
    2.  Connect the serial cable for communication
    3.  Connect the usb cable to allow the flashing of your image via
        fastboot
    4.  Open minicom at 115200bps -- 8bit data -- No parity -- 1 stop
        bit

    1. after you power on the board, you should be able see the "Fastboot entered ..." in minicom. You can check that the device is ready by using "$&gt; fastboot devices".

    :   1.  NOTE! The panda ES seems to be particular about which
            tty-USB converter it will communicate with. Avoid using the
            HL-340 chipset
        2.  NOTE! fastboot fails silently if you do not have permissions
            to access the device. Try running with sudo.

    1.  Execute
        $&gt; fastboot -b 0x80000000 boot the_kernel_image_file_boundled_with_application
    2.  The kernel should boot and application gets executed.

# References
 ==== SD setup ====
<http://omappedia.org/wiki/4AI.1.4_OMAP4_Icecream_Sandwich_Panda_Notes#Patching_X-LOADER>

<http://isrcepeda.blogspot.com.au/2012/05/getting-ics-working-on-pandaboard-uboot.html>

### Hardware
 ||Model||SoC||Platform||
