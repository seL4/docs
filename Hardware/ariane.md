---
riscv_hardware: true
cmake_plat: ariane
xcompiler_arg: -DRISCV64
platform: Ariane
arch: RISC-V, RISCV64
virtualization: "No"
iommu: "No"
simulation_target: false
Status: "Unverified"
Contrib: "Data61"
Maintained: "Data61"
---

# Ariane

Ariane is a 6-stage RISC-V CPU. For details, refer to
[https://github.com/pulp-platform/ariane](https://github.com/pulp-platform/ariane)

{% include risc-v.md %}

## Building seL4test

{% include sel4test.md %}

## Running seL4test
Ariane only provides support for the [Genesys 2
board](https://reference.digilentinc.com/reference/programmable-logic/genesys-2/reference-manual)

1. Compile the bitstream from source or download the pre-build bitstream from
   [here](https://github.com/pulp-platform/ariane/releases).

2. Prepare the SD card
   ```sh
   sudo sgdisk --clear --new=1:2048:67583 --new=2 --typecode=1:3000 --typecode=2:8300 /dev/sdX
   sudo dd if=images/sel4test-driver-image-riscv-ariane of=/dev/sdX1
   ```
   Note that the "sgdisk" command above also creates a second partition for
   Linux rootfs, you could download a pre-build Linux kernel from
   [here](https://github.com/pulp-platform/ariane-sdk/releases) to verify that
   the FPGA is working correctly.

3. Booting from the SD card and observing the output from the UART port.
