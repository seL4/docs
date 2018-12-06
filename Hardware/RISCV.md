---
cmake_plat: spike
xcompiler_arg: -DRISCV64
simulation_target: true
---

# RISC-V

This is a guide to setting up the 64-bit RISC-V tools and running the seL4 test suite for the Spike
platform (the standard RISC-V simulator provided by UC Berkeley), via QEMU.

## Running seL4test on RISC-V

### Dependencies

Make sure the [standard seL4 dependencies](/GettingStarted.html#setting-up-your-machine) are installed.

The following packages are required for the RISC-V tools:

```bash
autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config
libglib2.0-dev zlib1g-dev libpixman-1-dev
```

On Ubuntu, these can be obtained with apt.

### Build the tools

1. Set up a directory for the RISC-V tools, and the RISCV environment variable, which we refer to in
   future steps.

    ```bash
    mkdir riscv
    cd riscv
    export RISCV=${PWD}
    ```

2. Get the RISC-V tools

    ```
    cd ${RISCV}
    git clone https://github.com/riscv/riscv-tools.git
    cd riscv-tools
    git submodule update --init --recursive
    ```

3. Get RISC-V qemu sources, and build them:

    ```bash
    cd ${RISCV}/riscv-tools
    git clone https://github.com/heshamelmatary/riscv-qemu.git
    cd riscv-qemu
    git checkout sfence
    git submodule update --init dtc
    ./configure --target-list=riscv64-softmmu,riscv32-softmmu --prefix=${RISCV}
    make -j8 && make install
    ```

4. Build the 64-bit toolchain, this will take an hour or two.

    ```bash
    cd ${RISCV}/riscv-tools
    sed -i 's/build_project riscv-gnu-toolchain --prefix=$RISCV/build_project riscv-gnu-toolchain --prefix=$RISCV --with-arch=rv64imafdc --with-abi=lp64 --enable-multilib/g' ./build.sh
    ./build.sh
    ```

    If you are using a recent distribution like Ubuntu 18.04 you may need to disable -Wall (turn compiler warning into errors) in riscv-openocd and riscv-isa-sim.

    After it is built, add the $RISCV/bin folder to your path for step 6.


5. (Optional) Build the 32-bit toolchain, this will also take an hour or two.

    ```bash
    cd ${RISCV}/riscv-tools
    ./build-rv32ima.sh
    ```

## Running seL4 test

You will need to make sure that `$RISCV/bin` has been added to your `PATH`.

{% include sel4test.md %}

    You can also use run the tests on the 32-bit spike platform by
    replacing the `-DRISCV64=TRUE` option with `-DRISCV32=TRUE`.

### Continuing development

For further development, you only need to rebuild sel4test and rerun qemu, repeating step 6 above.
