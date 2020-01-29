---
riscv_hardware: true
cmake_plat: rocketchip
xcompiler_arg: -DRISCV64
platform: Rocketchip
arch: RV64IMAFDC
virtualization: "No"
iommu: "No"
simulation_target: false
Status: Unverified
Contrib: Data61
Maintained: Data61
cpu: Rocket
---
# Rocketchip FPGA mapped to Zynq ZC706

The current rocketchip implementation only tested on ZC706 FPGA, it should work
for other Zynq FPGAs. Refer to
[https://github.com/ucb-bar/fpga-zynq](https://github.com/ucb-bar/fpga-zynq) for
details.

{% include risc-v.md %}

## Building seL4test

{% include sel4test.md %}
