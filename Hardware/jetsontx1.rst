= Summary =
The Jetson TX1 is a multimedia and DSP board with a highly optimized 64-bit memory controller which supports low latency accesses from the CPU, high bandwidth accesses from the GPU and bounded latency accesses from real-time devices such as the display.

It has two multi-core CPU clusters, each with 4 identical cores (One Cortex-A57 cluster and one Cortex-A53 cluster). Each cluster has its own L2 cache. Both clusters are ARMv8 compliant platforms. In addition the Tx1 has an ARM7 shadow Co-processor.

The seL4 kernel has a limited port to the TX1 which supports the SoC only in 64-bit mode. SMP, SMMU, Hyp-mode, etc are not supported by the current port of the seL4 kernel to the TX1.

The stock TX1 comes with support for booting using DFU, using an SD-card or by copying the OS you would like to boot onto the internal 15 GiB USB mass storage that comes with the TX1.

Unfortunately the stock U-boot that comes with the TX1 does not support TFTP-boot over the Ethernet port. You can get U-boot to support the TX1's Ethernet driver and enable TFTP-boot, but this is beyond the scope of this article since it entails compiling a custom U-boot and then flashing it onto the board.

== Internal USB mass storage ==

== DFU ==

Before attempting to boot over DFU on the TX1, be sure to double check that the seL4 build process is outputting a raw binary and not an ELF. You can ascertain this by doing a `make menuconfig` and then proceeding through:
`Tools` => `Build elfloader` => `Boot image type`

Be sure that `Binary Boot Image` is selected.

To boot via DFU, attach the usb-mini end of a USB cable to the USB-mini port on the TX1. Then plug in the power supply for the TX1 and power it on. When the TX1 is powered on, pay attention to the text being printed out so that you can stop the boot process at the U-boot command prompt. When you have successfully got to the U-boot command prompt, enter the following:

{{{
 setenv dfu_alt_info "kernel ram 0x82000000 0x1000000"
 setenv bootcmd_dfu "dfu 0 ram 0; go 0x82000000"
 saveenv
}}}

To make U-boot enter its DFU server mode now, just type: `run bootcmd_dfu`. U-boot should sit still waiting for a kernel image to be uploaded. Now you should open up a new terminal on your PC, and type the following:

{{
 dfu-util --device 0955:701a -a kernel -D <PATH_TO_YOUR_SEL4_IMAGE>/sel4test-driver-image-arm-tx1.bin
}}

You may need to give dfu-util root privileges. If `dfu-util` is unable to find the TX1 device, try unplugging and replugging in the USB mini-cable that connects your PC to the TX1.
