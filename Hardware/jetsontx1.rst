The Jetson TX1 is a multimedia and DSP board with a highly optimized 64-bit memory controller which supports low latency accesses from the CPU, high bandwidth accesses from the GPU and bounded latency accesses from real-time devices such as the display.

It has two multi-core CPU clusters, each with 4 identical cores (One Cortex-A57 cluster and one Cortex-A53 cluster). Each cluster has its own L2 cache. Both clusters are ARMv8 compliant platforms. In addition the Tx1 has an ARM7 shadow Co-processor.

The seL4 kernel has a limited port to the TX1 which supports the SoC only in 64-bit mode. SMP, SMMU, Hyp-mode, etc are not supported by the current port of the seL4 kernel to the TX1.

The stock TX1 comes with support for booting using DFU, using an SD-card or by copying the OS you would like to boot onto the internal 15 GiB USB mass storage that comes with the TX1.

Unfortunately the stock U-boot that comes with the TX1 does not support TFTP-boot over the Ethernet port. You can get U-boot to support the TX1's Ethernet driver and enable TFTP-boot by [[https://devtalk.nvidia.com/default/topic/962946/tx1-pxe-boot/|following these instructions from the Nvidia forum]].
