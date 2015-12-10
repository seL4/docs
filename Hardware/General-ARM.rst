= Loading onto ARM Hardware =
== Fastboot ==
Most ARM platforms other than the Beagles that seL4 can use support booting via fastboot.

To boot via fastboot, you need to convert the image file produced by the seL4 build system into a u-boot image.

{{{
mkimage -A arm -a 0x48000000 -e 0x48000000 -C none -A arm -T kernel -O qnx -d INPUT_FILE OUTPUT_FILE
}}}
The reason we choose qnx is because we exploit the fact that, like seL4, qnx expects to be elf-loaded. The alternative is to convert our elf file into a binary file using objcopy.

The address to use varies from board to board.  unless you change the load address, use these:
||<tablewidth="534px" tableheight="105px">'''Platform''' ||'''Address''' ||
||Arndale, Odroid-X, Odroid-XU ||0x48000000 ||
||Sabre Lite ||0x30000000 ||
||Panda, Panda ES ||0x80000000 ||




When you have your image, put the board into fastboot mode (interrupt u-boot, and type ''fastboot''), then do:

{{{
  fastboot boot OUTPUT_FILE
}}}
== Beagle Board ==
You can compile a u-boot for beagle that supports fastboot, or you can use ''dfu-util'' with the standard u-boot to transfer the image to the board.

The address that the file downloads to is controlled by the ''$loadaddr'' environment variable in u-boot. You can either download an  ELF file, and then run bootelf on the u-boot command-line, or download a u-boot image file (created with `mkimage`) and use ''bootm'' to run it. You may need to take care that the ELF sections or image regions do not overlap with the location of the ELF/image itself, or loaded to nonexistent memory address (0x81000000 works fine, but 0x90000000 won't work on the original beagle since there's no RAM there)

{{{
  dfu-util -D sel4test-image-arm
}}}
== Booting from SD card ==
Pull out the SD card from your board, and put it into an SD card reader attached to your build host.

Mount the (MS-DOS) filesystem on the first partition on the SD card,   and copy your image to it

Unmount the filesystem, and put the card back into your board.

Reset the board (by power cycling, or pressing the reset button).

To run the image:

{{{
  mmc init
  mmcinfo
  fatload mmc 0 ${loadaddr} sel4test-image-arm
  bootelf ${loadaddr}
}}}
You can use

{{{
  fatls mmc 0
}}}
to see what is there.  Most u-boot implementations define a suitable ''loadaddr'' in their environment.

== TFTP booting ==
Setting up a DHCP and TFTP server are out of scope for this document. Once you have done that, however, and installed a tftp-enabled u-boot on your board if it doesn't already have one.

You can then power up the device and stop U-Boots auto boot feature if enabled by pressing a key, and do:

{{{
  dhcp file address
  bootelf address
}}}
