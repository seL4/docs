# RISC-V

This is a guide to setting up the 64-bit RISC-V tools and running the seL4 test suite for the Spike
platform (the standard RISC-V simulator provided by UC Berkeley), via QEMU.

## Running seL4test on RISC-V

### Dependencies

Make sure the [standard seL4 dependencies](GettingStarted.html#setting-up-your-machine) are installed.

The following packages are required for the RISC-V tools:

~~~bash
autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config
libglib2.0-dev zlib1g-dev libpixman-1-dev
~~~

On Ubuntu, these can be obtained with apt.

### Build the tools

1. Set up a directory for the RISC-V tools, and the RISCV environment variable, which we refer to in
   future steps.

    ~~~bash
    mkdir riscv
    cd riscv
    export RISCV=${PWD}
    ~~~

2. Get the RISC-V tools

    ~~~
    cd ${RISCV}
    git clone https://github.com/riscv/riscv-tools.git
    cd riscv-tools
    git submodule update --init --recursive
    ~~~

3. Get RISC-V qemu sources, and build them:

    ~~~bash
    cd ${RISCV}/riscv-tools
    git clone https://github.com/heshamelmatary/riscv-qemu.git
    cd riscv-qemu
    git checkout sfence
    git submodule update --init dtc
    ./configure --target-list=riscv64-softmmu,riscv32-softmmu --prefix=${RISCV}
    make -j8 && make install
    ~~~

4. Build the 64-bit toolchain, this will take an hour or two.

    ~~~bash
    cd ${RISCV}/riscv-tools
    sed -i 's/build_project riscv-gnu-toolchain --prefix=$RISCV/build_project riscv-gnu-toolchain --prefix=$RISCV --with-arch=rv64imafdc --with-abi=lp64 --enable-multilib/g' ./build.sh
    ./build.sh
    ~~~
    
    If you are using a recent distribution like Ubuntu 18.04 you may need to disable -Wall (turn compiler warning into errors) in riscv-openocd and riscv-isa-sim.
    
    After it is built, add the $RISCV/bin folder to your path for step 6.


5. Get sel4test sources. If you have them already make sure you are up to to date with the latest
   source.

    ~~~bash
    mkdir sel4test && cd sel4test
    repo init -u https://github.com/seL4/sel4test-manifest.git
    repo sync
    ~~~

6. Build the RISC-V sel4test image and run sel4test

    ~~~bash
    cd sel4test
    make bamboo_riscv64_defconfig
    make -j8
    make simulate-spike64
    ~~~
    
    If make fails, you may need to install a few required python packages: sudo pip install tempita future

### Continuing development

For further development, you only need to rebuild sel4test and rerun qemu, repeating step 6 above.
