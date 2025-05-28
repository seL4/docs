---
riscv_hardware: true
cmake_plat: cheshire
xcompiler_arg: -DRISCV64=1
platform: Cheshire
arch: RV64IMAFDC
virtualization: "No"
iommu: "No"
simulation_target: false
Status: "Unverified"
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

seL4 currently only provides Cheshire support for the [Genesys 2
board](https://reference.digilentinc.com/reference/programmable-logic/genesys-2/reference-manual).

## Building the GCC toolchain

{% include risc-v.md %}

## Building seL4test

{% include sel4test.md %}

## Running seL4test

Synthesising hardware for the Genesys 2 requires a Vivado Enterprise license.
Unfortunately there are no prebuilt bitstreams available. Vivado 2023.2 is recommended.

1. Synthesise the bitstream from source following the instructions from the [Cheshire
 Manual](https://pulp-platform.github.io/cheshire/tg/xilinx/). Follow setup instructions then run

   ```
   make chs-xilinx-genesys2
   ```

2. Program the FPGA using the Vivado Hardware Manager. Open the hardware manager GUI and choose
`/path/to/cheshire/target/xilinx/out/cheshire.genesys2.bit` as the bitstream file in the "Program
Device" dialog.

3. Prepare a device tree blob for OpenSBI.
   ```sh
   make sw/boot/cheshire.genesys2.dtb
   ```

4. In a new terminal, connect an OpenOCD session to the board over the JTAG micro-USB port.
   ```sh
   openocd -f /path/to/cheshire/util/openocd.genesys2.tcl
   ```

5. In another terminal, connect to OpenOCD using GDB from the RISC-V toolchain.
   ```sh
   riscv64-unknown-elf-gdb --eval-command "target extended-remote localhost:3333"
   ```

6. Use GDB to reset the board, then load the DTB, load OpenSBI and allow it to run.
   ```sh
   # Reset CPU and halt
   (gdb) monitor reset halt

   # Load DTB to 0x70000000
   (gdb) restore /path/to/cheshire.dtb binary 0x70000000

   # Set location of DTB and hart ID for OpenSBI when it boots. This step is normally
   # performed by the zero stage bootloader.
   (gdb) set $a0=0x70000000
   (gdb) set $a1=0

   # Load OpenSBI and run
   (gdb) load /path/to/opensbi

   # Run OpenSBI to allow it to do preliminary setup
   (gdb) c
   (CTRL+C) # Stop running once SBI prints "Running test payload"
   ```

7. Finally, load the seL4test binary, set the PC and run.
   ```sh
   (gdb) restore /path/to/sel4test-driver-image-riscv-cheshire binary 0x80200000
   (gdb) j *0x80200000
   ```

### Notes

This process can be expedited by using a GDB command file. If you paste the below into a file, it
may be used as `riscv64-unknown-elf-gdb --command=/path/to/run_sel4test.gdb` to complete step 6
and 7, up to the final jump which must be done manually:
   `run_sel4test.gdb`
   ```gdb
   target extended-remote localhost:3333
   monitor reset halt
   restore /path/to/cheshire.dtb binary 0x70000000
   set $a0=0x70000000
   set $a1=0
   restore /path/to/sel4test-driver-image-riscv-cheshire binary 0x80200000
   load /path/to/opensbi
   c
   ```

Finish with
```
   (gdb) j *0x80200000
```

If you encounter issues such as OpenOCD failing to connect, you should attempt to reset the JTAG
connection with `lsusb`. The JTAG device should have a name similar to `Future Technology Devices
International, Ltd FT2232C/D/H Dual UART/FIFO IC`. Note the `Bus XXX Device YYY` next to the
device and reset it with
   ```sh
   sudo usbreset XXX/YYY
   ```


Note: while it is possible to boot via u-boot as with most other platforms supported, it is easier and
far faster to follow the following steps to boot with GDB.
