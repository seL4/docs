---
arm_hardware: true
archive: true
cmake_plat: hikey
xcompiler_arg: -DAARCH64=1
platform: HiKey
arch: ARMv8A
virtualization: true
iommu: false
soc: Kirin 620
cpu: Cortex-A53
Status: Verified
verified: hikey
Contrib: Data61
Maintained: false
parent: /Hardware/
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# HiKey

{% include note.html kind="Warning" %}
This board is currently not in the seL4 hardware regression test.
These instructions may be out of date.
{% include endnote.html %}

{% include hw-info.html %}

## Pre-Requisites


- One HiKey Board. See
        [Hikey 96Board](http://www.96boards.org/products/ce/hikey/)
- Fully working development environment. See
        the [set up instructions](/projects/buildsystem/host-dependencies.html) page.

## Getting Started

The Hikey board is based around the [HiSilicon Kirin
620](https://github.com/96boards/documentation/blob/master/consumer/hikey/hikey620/hardware-docs/Hi6220V100_Multi-Mode_Application_Processor_Function_Description.pdf)
eight-core ARM Cortex-A53 64-bit !SoC running at 1.2GHz. Toe start using 32-bit
seL4 follow the below instructions. They will walk you step by step beginning
from the source files and ultimately running an image.

## 1. Creating a directory

```bash
mkdir hikey-flash
cd hikey-flash
```

## 2. Custom toolchains

The cross-toolchains GCC 4.9 for Aarch64 and
gnueabihf are required to flash the Hikey. If versions of GCC 5, or
higher, are installed the following steps must be taken as GCC5 is not
backwards compatible. Otherwise skip to the next Section.

The necessary files are:

- GCC 4.9 cross-toolchain for
      Aarch64 (gcc-linaro-4.9-2016.02-x86_64_aarch64-linux-gnu.tar.xz)
- GCC 4.9 cross-toolchain for
      gnueabihf (gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf.tar.xz)

The files are obtainable from the
following links:

- <http://releases.linaro.org/components/toolchain/binaries/4.9-2016.02/aarch64-linux-gnu/>
- <http://releases.linaro.org/components/toolchain/binaries/4.9-2016.02/arm-linux-gnueabihf/>

```bash
#Run the following commands to use GCC 4.9 only in this directory mkdir
arm-tc arm64-tc tar --strip-components=1 -C ${PWD}/arm-tc -xf ~/Downloads gcc-linaro-4.9-2016.02-x86_64_aarch64-linux-gnu.tar.xz
tar --strip-components=1 -C ${PWD}/arm64-tc -xf ~/Downloads/gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf.tar.xz
export PATH="${PWD}/arm-tc/bin:${PWD}/arm64-tc/bin:$PATH"

# To check that GCC 4.9 is used aarch64-linux-gnu-gcc --version
arm-linux-gnueabihf-gcc --version
```

## 3. Obtaining the source files

```bash
git clone -b hikey --depth 1 https://github.com/96boards/edk2.git linaro-edk2
git clone -b hikey --depth 1 https://github.com/96boards-hikey/arm-trusted-firmware.git
git clone -b hikey --depth 1 https://github.com/96boards/LinaroPkg.git
git clone --depth 1 https://github.com/96boards/l-loader.git
git clone git://git.linaro.org/uefi/uefi-tools.git
```

## 4. Changing console to UART0

```bash
gedit LinaroPkg/platforms.config

# Uncomment the following lines
BUILDFLAGS=-DSERIAL_BASE=0xF8015000
ATF_BUILDFLAGS=CONSOLE_BASE=PL011_UART0_BASE CRASH_CONSOLE_BASE=PL011_UART0_BASE
```

## 5. Patching the UEFI for the Hikey

Obtain the patch from [edk2.patch](edk2.patch) and follow the below steps.

```bash
cd linaro-edk2
patch -p1 < ~/Downloads/edk2.patch
# Then return to the main directory hikey-flash
```

## 6.Modifying the firmware

If settings are required
to be changed while in EL3 then the file in
arm-trusted-firmware/bl1/bl1_main.c can be modified. To disable the
prefetcher obtain the patch file from
[bl1_main.patch](bl1_main.patch) and follow the below steps.

```bash
cd arm-trusted-firmware/bl1
patch -p5 < ~/Downloads/bl1_main.patch
# Then return to the main directory hikey-flash
```

## 7. Modifying the UEFI

If settings are required to
be changed while in EL2 then the file in
linaro-edk2/MdeModulePkg/Application/noboot/efi-stub.S can be modified.
To disable the prefetcher obtain the patch file from
[efi-stub.patch](efi-stub.patch) follow the below steps.

```bash
 cd
linaro-edk2/MdeModulePkg/Application/noboot patch -p7 <
~/Downloads/efi-stub.patch # Then return to the main directory
hikey-flash
```

## 8. Building the UEFI for the Hikey

```bash
export AARCH64_TOOLCHAIN=GCC49
export EDK2_DIR=${PWD}/linaro-edk2
export UEFI_TOOLS_DIR=${PWD}/uefi-tools

cd ${EDK2_DIR}
${UEFI_TOOLS_DIR}/uefi-build.sh -c ../LinaroPkg/platforms.config -b RELEASE -a ../arm-trusted-firmware hikey

cd ../l-loader
ln -s ${EDK2_DIR}/Build/HiKey/RELEASE_GCC49/FV/bl1.bin
ln -s ${EDK2_DIR}/Build/HiKey/RELEASE_GCC49/FV/fip.bin

# If the DEBUG version of the build is require run the below commands instead
cd ${EDK2_DIR}
${UEFI_TOOLS_DIR}/uefi-build.sh -c ../LinaroPkg/platforms.config -b DEBUG -a ../arm-trusted-firmware hikey

cd ../l-loader
ln -s ${EDK2_DIR}/Build/HiKey/DEBUG_GCC49/FV/bl1.bin
ln -s ${EDK2_DIR}/Build/HiKey/DEBUG_GCC49/FV/fip.bin
# End

arm-linux-gnueabihf-gcc -c -o start.o start.S
arm-linux-gnueabihf-gcc -c -o debug.o debug.S
arm-linux-gnueabihf-ld -Bstatic -Tl-loader.lds -Ttext 0xf9800800 start.o debug.o -o loader
arm-linux-gnueabihf-objcopy -O binary loader temp
python gen_loader.py -o l-loader.bin --img_loader=temp --img_bl1=bl1.bin
sudo PTABLE=linux-4g bash -x generate_ptable.sh
python gen_loader.py -o ptable-linux.img --img_prm_ptable=prm_ptable.img
```

## 9. Boot Image

{% include note.html %}
96boards does no longer seem to provide the release binary below.
{% include endnote.html %}

Obtain the boot image from
`https://builds.96boards.org/releases/hikey/linaro/debian/latest/boot-fat.uefi.img.gz`
and follow the below commands.

```bash
gunzip *.img.gz

mkdir -p boot-fat
sudo mount -o loop,rw,sync boot-fat.uefi.img boot-fat

sudo rm boot-fat/EFI/BOOT/fastboot.efi
sudo cp ../linaro-edk2/Build/HiKey/RELEASE_GCC49/AARCH64/AndroidFastbootApp.efi boot-fat/EFI/BOOT/fastboot.efi
sudo cp ../linaro-edk2/Build/HiKey/RELEASE_GCC49/AARCH64/noboot.efi boot-fat/EFI/BOOT/

sudo umount boot-fat
```

## 10. Minicom

Install and configure minicom. Two terminals are required for the commands. If
minicom is already installed and configured skip the next Section.

```bash
# In the first terminal
cd /dev/
ls
# Note the ttyUSBX that is observed

# In the second terminal
sudo apt-get install minicom
sudo minicom -s
```

  1.  Use the arrow keys to scroll down to Serial port setup and press
      enter
  2.  Press 'a' to start editing the Serial Device
  3.  Rename the serial device to /dev/ttyUSBX where X is the observed
      number
  4.  Press 'esc' twice and select Save setup as dfl

## 11. Flash the firmware

  1.  Turn off the power to the board if it is on.
  2.  Connect UART0 to a USB port if it is not connected already.
  3.  Connect the Hikey board with a USB to micro USB cable.
  4.  Connect pins 1&2 (AUTO PWR) and 3&4 (BOOT SEL) on the
      J15 header. The pins are silk screened onto the PCB, otherwise
      see page the [Hikey user manual](https://www.96boards.org/documentation/consumer/hikey/hikey620/hardware-docs/hardware-user-manual.md.html#board-overview).
  5.  Obtain the Hikey flash recovery tool from
      <https://raw.githubusercontent.com/96boards/burn-boot/master/hisi-idt.py>
  6.  Turn the power on the to Hikey
  7.  Three terminals are then required for the following commands

```bash
# In the first terminal
ls
# Note the next ttyUSBY that is observed, in addition to the current ttyUSBX

# In the third terminal
sudo python ~/Downloads/hisi-idt.py --img1=l-loader.bin -d /dev/ttyUSBY
wget https://builds.96boards.org/releases/hikey/linaro/binaries/latest/nvme.img
sudo fastboot flash ptable ptable-linux.img
sudo fastboot flash fastboot fip.bin
sudo fastboot flash nvme nvme.img
sudo fastboot flash boot boot-fat.uefi.img
# The debug prints are displayed in the second terminal

# Then power off the Hikey
```

## 12. Build your first seL4 system

{% include sel4test.md %}

The Hikey also supports AArch32 mode. If you choose to build the AArch32 kernel,
please be sure to pass `-DAARCH32=1` instead of `-DAARCH64=1`.

## 13. Booting the Hikey


1.  Remove the connection for pins 3&4 on the J15 header and connect
    pins 5&6 instead.
2.  Power the Hikey
3.  Run the desired image. The command below is an example.

```bash
# In the third terminal
fastboot boot images/sel4test-driver-image-arm-hikey -c mode=32bit
```

## 14. Modifications to firmware or UEFI


- If the firmware is modified the whole process from and including
      Section 9 onward must be done.
- If the UEFI loader is modified then only Section 9 and from
      Section 11 onward need to be completed

Other instructions can be viewed here: <https://github.com/96boards/documentation/wiki/HiKeyUEFI#run-fastboot-from-uefi>
