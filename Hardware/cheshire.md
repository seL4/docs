---
riscv_hardware: true
cmake_plat: cheshire
xcompiler_arg: -DRISCV64=1
platform: Cheshire
arch: RV64IMAFDC
virtualization: false
iommu: false
simulation_target: false
verification: []
Contrib: "UNSW"
Maintained: "UNSW"
cpu: Cheshire
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

# Cheshire

Cheshire is a 6-stage RISC-V CPU. For details, refer to
[https://github.com/pulp-platform/cheshire](https://github.com/pulp-platform/cheshire)

{% include hw-info.html %}

seL4 currently only provides Cheshire support for the [Genesys 2
board](https://reference.digilentinc.com/reference/programmable-logic/genesys-2/reference-manual).

## Synthesising Cheshire

Synthesising hardware for the Genesys 2 requires a Vivado Enterprise license.
Unfortunately there are no prebuilt bitstreams available. Vivado 2023.2 is
recommended. Follow the [Cheshire Manual](https://pulp-platform.github.io/cheshire/tg/xilinx/)
to install dependencies, then:

1. Compile the device tree blob:

   ```sh
   make sw/boot/cheshire.genesys2.dtb
   ```

2. Synthesise the bitstream for the Genesys 2 board:

   ```sh
   export VIVADO=/path/to/xilinx/bin/vivado
   make chs-xilinx-genesys2
   ```

   This will produce a `.bit` file in `target/xilinx/out/cheshire.genesys2.bit`.


## Building the GCC toolchain

{% include risc-v.md %}

## Building OpenOCD

OpenOCD needs to be the RISC-V downstream fork. `6f84e90d` is a known working commit.
Follow the instructions in the README to find the required dependencies.

```sh
git clone https://github.com/riscv-collab/riscv-openocd.git
cd riscv-openocd
./bootstrap
./configure --disable-werror --enable-jtag_vpi \
           --enable-remote-bitbang --enable-ftdi \
           --prefix=/opt/riscv-openocd/ --exec-prefix=/opt/riscv-openocd
make -j$(nproc)
sudo make install
```

## Building OpenSBI

Cheshire needs a custom build of OpenSBI. It is recommended to compile the `FW_JUMP`
style image. The device tree blob `cheshire.genesys2.dtb` was build above. You
might need to use `rv64imafdc` or `rv64g` depending on your RISC-V toolchain as the ISA.

```sh
git clone https://github.com/pulp-platform/opensbi.git --branch cheshire
cd opensbi
make PLATFORM=fpga/cheshire CROSS_COMPILE=<RISCV_TOOLCHAIN> -j$(nproc) \
     PLATFORM_RISCV_XLEN=64 PLATFORM_RISCV_ISA=rv64imafdc_zicsr_zifencei PLATFORM_RISCV_ABI=lp64 \
     FW_JUMP=y FW_JUMP_ADDR=0x90000000 FW_FDT_PATH=/path/to/cheshire.genesys2.dtb
```

You can then find `build/platform/fpga/cheshire/firmware/fw_jump.elf`.

## Building seL4test

{% include sel4test.md %}

## Running seL4test

{% include note.html %}
Whilst it is possible to setup U-Boot off an SD Card as with other platforms,
Cheshire does not have an ethernet peripheral and so images need to be loaded over GDB.
{% include endnote.html %}

1. Program the FPGA using the Vivado Hardware Manager. Open the hardware manager
   GUI and choose `/path/to/cheshire/target/xilinx/out/cheshire.genesys2.bit` as
   the bitstream file in the "Program Device" dialog.

2. In a new terminal, connect an OpenOCD session to the board over the JTAG
   micro-USB port.

   ```sh
   openocd -f /path/to/cheshire/util/openocd.genesys2.tcl
   ```

3. In another terminal, connect to OpenOCD using GDB from the RISC-V toolchain.

   ```sh
   riscv64-unknown-elf-gdb --eval-command "target extended-remote localhost:3333"
   ```

4. Use GDB to reset the board, then load seL4test and OpenSBI.

   ```gdb
   # Reset CPU and halt
   (gdb) monitor reset halt

   # Load seL4 image (ELF), entry is 0x90000000
   (gdb) restore sel4test-driver-image-riscv-cheshire

   # openSBI compiled with FW_JUMP=y FW_JUMP_ADDR=0x90000000 and embedded DTB
   (gdb) set $a0=0
   (gdb) set $a1=0
   (gdb) load fw_jump.elf

   # Run OpenSBI which jumps to seL4
   (gdb) c
   ```

## Notes

If you encounter issues such as OpenOCD failing to connect, you should attempt
to reset the JTAG connection with `lsusb`. The JTAG device should have a name
similar to `Future Technology Devices International, Ltd FT2232C/D/H Dual UART/FIFO IC`.
Note the `Bus XXX Device YYY` next to the device and reset it with

```sh
sudo usbreset XXX/YYY
```

Loading the probes (`.ltx`) file in Vivado Hardware Manager it is also possible
to remotely reset the board using [Virtual IOs](https://pulp-platform.github.io/cheshire/tg/xilinx/#virtual-ios).
