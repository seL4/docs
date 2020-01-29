---
riscv_hardware: true
cmake_plat: hifive
xcompiler_arg: -DRISCV64
platform: HiFive Unleashed
arch: RV64IMAC, RV64GC
virtualization: "No"
iommu: "No"
simulation_target: false
Status: "Unverified"
Contrib: "Data61"
Maintained: "Data61"
soc: Freedom U540
cpu:  U54-MC, E51
---

# HiFive Unleashed

HiFive Unleashed is a RISC-V development board by SiFive. Check
[here](https://www.sifive.com/boards/hifive-unleashed) for details.

{% include risc-v.md %}

## Building seL4test

{% include sel4test.md %}

## Booting via SD card

1. Set all DIP switches to 1(towards CPU).

2. Prepare the SD card
   ```sh
   sudo sgdisk --clear --new=1:2048:67583 --typecode=1:3000 /dev/sdX
   sudo dd if=images/sel4test-driver-image-riscv-hifive of=/dev/sdX1
   ```
3. Insert the SD card and connect the micro USB port(J7).
   Note that the UART device node is /dev/ttyUSB1
