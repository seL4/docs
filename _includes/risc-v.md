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
