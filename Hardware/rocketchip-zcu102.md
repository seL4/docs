---
riscv_hardware: true
cmake_plat: rocketchip-zcu102
xcompiler_arg: -DRISCV64=1
platform: Rocketchip
arch: RV64IMAFDC
virtualization: false
iommu: false
simulation_target: false
Status: Unverified
Contrib: '<a href="https://dornerworks.com">DornerWorks</a>'
Maintained: '<a href="https://dornerworks.com">DornerWorks</a>'
cpu: Rocket
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Rocketchip FPGA mapped to Zynq ZCU102

This rocketchip implementation will run on the ZCU102 FPGA fabric.

{% include hw-info.html %}

## Building the GCC toolchain

{% include risc-v.md %}

## Building seL4test

{% include sel4test.md %}

### Updating OpenSBI

In order to run on the ZCU102, the OpenSBI platform must be changed from `generic`.
[DornerWorks](https://github.com/dornerworks/opensbi/tree/bao/rocket) has forked a version of
OpenSBI from the bao-project that supports the ZCU104 platform, which is nearly identical to the
ZCU102. Perform the following commands in the seL4 codebase to set the OpenSBI target to
`rocket-fpga-zcu104`.

```sh
cd tools/opensbi
git remote add dornerworks https://github.com/dornerworks/opensbi/
git fetch dornerworks
git checkout dornerworks/bao/rocket
```

## Building the Rocketchip Bitstream

### Setting up the Repo

The following repository contains patches that will add virtualization support via the h-extensions
to the rocketchip. Clone the repo with the following command

```sh
git clone https://github.com/dornerworks/Vivado-Prebuilts
git clone https://github.com/dornerworks/bao-demos -b rocket rocketchip-h-extend
cd rocketchip-h-extend
```

Export the following variables for the scripts to work correctly. Please note that order is also
important since some of these variables use previous variables in their declaration.

```sh
export PLATFORM=rocket-fpga-zcu104
export DW_VIVADO_PREBUILTS=/PATH/TO/vivado-prebuilts
export BAO_DEMOS=/PATH/TO/rocketchip-h-extend
export BAO_DEMOS_WRKDIR=$BAO_DEMOS/wrkdir
export BAO_DEMOS_WRKDIR_SRC=$BAO_DEMOS_WRKDIR/srcs
export BAO_DEMOS_WRKDIR_PLAT=$BAO_DEMOS_WRKDIR/imgs/$PLATFORM
export BAO_DEMOS_CHIPYARD=$BAO_DEMOS_WRKDIR_SRC/chipyard
export BAO_DEMOS_ROCKETCHIP=$BAO_DEMOS_CHIPYARD/generators/rocket-chip
export BAO_DEMOS_VIVADO_SCRIPTS=$BAO_DEMOS/platforms/$PLATFORM/scripts
export BAO_DEMOS_ROCKET_CONFIG=RocketHypConfig$(echo $PLATFORM | awk '{split($0,A,"-"); print A[length(A)]}')
export BAO_DEMOS_OPENSBI=$BAO_DEMOS_WRKDIR_SRC/opensbi
export ARCH=riscv
export CROSS_COMPILE=riscv64-unknown-elf-
export VIVADO_CORES=$(nproc)

mkdir -p $BAO_DEMOS_WRKDIR
mkdir -p $BAO_DEMOS_WRKDIR_SRC
```

### Generate the SoC Design

With these variables in place use the following commands to generate the rocketchip design with the
h-extensions enabled:

```sh
git clone https://github.com/ucb-bar/chipyard.git $BAO_DEMOS_CHIPYARD
cd $BAO_DEMOS_CHIPYARD
git checkout 64632c8
./scripts/init-submodules-no-riscv-tools.sh
git apply $BAO_DEMOS/platforms/$PLATFORM/patches/0001-add-rocket-hyp-fpga-support.patch
git -C generators/boom apply $BAO_DEMOS/platforms/$PLATFORM/patches/0001-boom-add-usehyp-option.patch
git -C generators/ariane apply $BAO_DEMOS/platforms/$PLATFORM/patches/0001-ariane-add-usehyp-option.patch
cd $BAO_DEMOS_ROCKETCHIP
git remote add hyp https://github.com/dornerworks/rocket-chip.git
git fetch hyp
git checkout hyp
```

Next use the following command to build the bootROM:

```sh
make -C $BAO_DEMOS_CHIPYARD/bootromFPGA
```

Finally, use the following command to generate the verilog before building the design:

```sh
make -C $BAO_DEMOS_CHIPYARD/sims/vcs verilog SUB_PROJECT=rocket \
    CONFIG=$BAO_DEMOS_ROCKET_CONFIG
```

### Modifying the scripts

Before building the design, a few lines in the tcl scripts must be modified in order to ensure we
are building for the ZCU102. Change directory to `$BAO_DEMOS_VIVADO_SCRIPTS` and modify the switch
statement in `env.tcl` with the following information.

```
    zcu102 {
        set part xczu9eg-ffvb1156-2-e
        set board_part xilinx.com:zcu102:part0:3.1
    }
```

The board declaration must be changed to ZCU102 with the following line:

```
set board zcu102
```

### Building the SoC Design

Vivado can be used with the generated verilog to build the SoC Design. Ensure that Vivado 2020.2 is
on your path and run the following commands:

```sh
vivado -nolog -nojournal -mode batch -source $BAO_DEMOS_VIVADO_SCRIPTS/create_ip.tcl
vivado -nolog -nojournal -mode batch -source $BAO_DEMOS_VIVADO_SCRIPTS/create_design.tcl
vivado -nolog -nojournal -mode batch -source $BAO_DEMOS_VIVADO_SCRIPTS/build.tcl
```

## Prebuilt Rocketchip Bitstreams

DornerWorks has pre-built a version of the rocketchip with and without the h-extensions
available. The bitsteams, along with the corresponding `psu_init.tcl` scripts, can be found at the
following [repo](https://github.com/dornerworks/Vivado-Prebuilts). This repo also contains a script
to flash the rocketchip onto the ZCU102.

## Booting the Rocketchip

Use the Xilinx `xsct` tool to flash the ZCU102. Connect the JTAG and UART ports to your computer. If
using VMWare, ensure that USB3.0 is enabled. Set the ZCU102 to boot via JTAG and power on the board.


Open a `screen` session for the ZCU102 with the following command:

```sh
screen /dev/ttyUSB1 115200
```

Next, ensure the generated seL4 image is in the binary format. This will be the case when the
`ElfloaderImage` CMake variable is set to `binary`.

Finally, flash the ZCU102 with the following command:

```sh
xsct  $BAO_DEMOS_VIVADO_SCRIPTS/deploy.tcl /PATH/TO/BINARY/SEL4/IMAGE
```

Alternatively, if using the prebuilt bitstream provided by DornerWorks, the `Vivado-Prebuilts`
repository contains a `flash_rocket` shell script which can be invoked to flash the ZCU102 with the
prebuilt bitstream.

```sh
cd $DW_VIVADO_PREBUILTS
source flash_rocket.sh /PATH/TO/BINARY/SEL4/IMAGE
```
