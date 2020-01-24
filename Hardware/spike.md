---
riscv_hardware: true
cmake_plat: spike
xcompiler_arg: -DRISCV64
platform: Spike
arch: RISC-V
virtualization: "No"
iommu: "No"
simulation_target: true
Status: "Unverified"
Contrib: "Data61, [Hesham Almatary](https://github.com/heshamelmatary)"
Maintained: "Data61"
---

# Spike

{% include risc-v.md %}

## Building seL4test

{% include sel4test.md %}

You can also use run the tests on the 32-bit spike platform by replacing
the `-DRISCV64=TRUE` option with `-DRISCV32=TRUE`.
