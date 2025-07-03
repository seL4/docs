---
riscv_hardware: true
cmake_plat: polarfire
xcompiler_arg: -DSel4testAllowSettingsOverride=True -DElfloaderImage=binary -DKernelVerificationBuild=OFF
platform: Microchip PolarFire Icicle Kit
arch: RV64IMAC, RV64GC
virtualization: "no"
iommu: "no"
simulation_target: false
Status: Unverified
Contrib: "[DornerWorks](https://dornerworks.com)"
Maintained: "[DornerWorks](https://dornerworks.com)"
soc: PolarFire SoC FPGA
cpu: U54-MC, E51
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Microchip PolarFire Icicle Kit

Polarfire Icicle Kit is a RISC-V development board by Microchip. Check
[here](https://www.microchip.com/en-us/development-tool/MPFS-ICICLE-KIT-ES) for details.

Microchip maintains online material, including designs and documentation
[here](https://www.microchip.com/en-us/products/fpgas-and-plds/system-on-chip-fpgas/polarfire-soc-fpgas#documentation).

Additional documentation and resources can be found on the polarfire-soc github
[here](https://github.com/polarfire-soc/).

## Building
### seL4test

{% include sel4test.md %}

Converting to a u-boot uImage:
```bash
mkimage -A riscv -O linux -T kernel -C none -a 0x80000000 -e 0x80000000 -n sel4test -d \
images/sel4test-driver-image-riscv-polarfire images/seL4-uImage
cp kernel/kernel.dtb images/
```

### Hart Software Services

Install the SoftConsole software development environment from Microchip
[here](https://www.microchip.com/en-us/products/fpgas-and-plds/fpga-and-soc-design-tools/soc-fpga/softconsole).
The following instructions are based on SoftConsole v2022.2

1. Clone the Hart Software Services
```bash
git clone https://github.com/polarfire-soc/hart-software-services
```

2. Open SoftConsole and import a project from the newly cloned `hart-software-services` repo.

3. Build the project with the project defaults.

### hss-payload-generator
```bash
git clone https://github.com/polarfire-soc/hart-software-services
cd hart-software-services/tools/hss-payload-generator
make
```

This generates a `hss-payload-generator` ELF.

### U-Boot
```bash
git clone https://github.com/polarfire-soc/u-boot
cd u-boot
CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv make microchip_mpfs_icicle_defconfig
CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv make
```

This generates a `u-boot-dtb.bin` binary.

In order boot u-boot from the HSS, the `u-boot-dtb.bin` needs to be packaged as an HSS payload using
the hss-payload-generator tool but first a payload configuration yaml file needs to be created:

```yaml
#
# HSS Payload Generator - U-Boot Payload
#

set-name: 'PolarFire-SoC-HSS::U-Boot'

hart-entry-points: {u54_1: '0x1000200000', u54_2: '0x1000200000', u54_3: '0x1000200000', u54_4: '0x1000200000'}

payloads:
  u-boot.bin: {exec-addr: '0x1000200000', owner-hart: u54_1, secondary-hart: u54_2, secondary-hart: u54_3, secondary-hart: u54_4, priv-mode: prv_s }

```

The payload can then be generated using this yaml file.
```bash
./hss-payload-generator -c u-boot.yaml uboot-payload.bin
```

This generates a `uboot-payload.bin` binary.

## Booting via SD card

Prepare the SD card
```sh
sudo sgdisk -Zo --new=1:2048:2099199 --typecode=1:0700 \
     --new=2:2099200:4196351 --typecode=2:EF02 /dev/sdX
sudo dd if=images/uboot-payload.bin of=/dev/sdX2
sudo mkfs.vfat -F16 /dev/sdX1
sudo mount /dev/sdX1 /mnt
sudo cp images/seL4-uImage /mnt
sudo cp images/kernel.dtb /mnt
```

Insert the SD card into the Icicle Kit then power on the board, and drop into the u-boot
prompt. When you're at the prompt, type the following:
```bash
fatload mmc 0 0x1000200000 seL4-uImage
fatload mmc 0 0x1020200000 kernel.dtb
bootm 0x1000200000 - 0x1020200000
```
