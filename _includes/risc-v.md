## Build the GCC toolchain

1. Build the 64-bit toolchain, this will take an hour or two.

    ```sh
    cd "${RISCV}/riscv-tools"
    sed -i 's/build_project riscv-gnu-toolchain --prefix=$RISCV/build_project riscv-gnu-toolchain --prefix=$RISCV --with-arch=rv64imafdc --with-abi=lp64 --enable-multilib/g' ./build.sh
    ./build.sh
    ```

    If you are using a recent distribution like Ubuntu 18.04 you may need to disable -Wall (turn compiler warning into errors) in riscv-openocd and riscv-isa-sim.

    After it is built, add the $RISCV/bin folder to your path.

2. (Optional) Build the 32-bit toolchain, this will also take an hour or two.

    ```sh
    cd "${RISCV}/riscv-tools"
    ./build-rv32ima.sh
    ```
