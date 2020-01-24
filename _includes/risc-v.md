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

{% if page.simulation_target %}

## Build the QEMU simulator

1. Set up a directory for the RISC-V tools, and the RISCV environment variable, which we refer to in
   future steps.

    ```sh
    mkdir riscv
    cd riscv
    export RISCV=${PWD}
    ```

2. Get the RISC-V tools

    ```sh
    cd "${RISCV}"
    git clone https://github.com/riscv/riscv-tools.git
    cd riscv-tools
    git submodule update --init --recursive
    ```

3. Get RISC-V qemu sources, and build them:

    ```sh
    cd "${RISCV}/riscv-tools"
    git clone https://github.com/heshamelmatary/riscv-qemu.git
    cd riscv-qemu
    git checkout sfence
    git submodule update --init dtc
    ./configure --target-list=riscv64-softmmu,riscv32-softmmu --prefix="${RISCV}"
    make -j8 && make install
    ```

{% endif %}
