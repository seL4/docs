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

## Getting the Simulator
You can use either [RISC-V ISA
Simulator](https://github.com/riscv/riscv-isa-sim) or QEMU >= v4.2 shipped with
your Linux distribution.

If you prefer to build qemu from source, make sure you have the correct target
enabled.

```sh
git clone https://git.qemu.org/git/qemu.git
cd qemu
mkdir build
cd build
../configure --prefix=/opt/riscv --target-list=riscv64-softmmu,riscv32-softmmu
make
```

## Building seL4test

{% include sel4test.md %}

You can also use run the tests on the 32-bit spike platform by replacing
the `-DRISCV64=TRUE` option with `-DRISCV32=TRUE`.
