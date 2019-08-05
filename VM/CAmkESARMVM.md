# CAmkES ARM VMM
 This page describes the ARM virtual machine monitor. 'Out-of-the-box' it is set up for a Jetson TK1; there is also a configuration for an Odroid XU (note this is the ''original'' XU, not the current XU4)

## Getting and Building
```bash
repo init -u https://github.com/SEL4PROJ/camkes-arm-vm-manifest.git
repo sync
mkdir build
cd build
../init-build.sh -DAARCH32=TRUE -DCAMKES_VM_APP=tk1_vm
ninja
```

To build for the odroid-XU instead of the tk1, use `-DCAMKES_VM_APP=odroid_vm`.

An ELF file will be left in `images/capdl-loader-experimental-image-arm-tk1\` We normally boot using TFTP, by first copying `capdl-loader-experimental-image-arm-tk1` to a tftpserver then on the U-Boot serial console doing:
```bash
dhcp tftpboot $loadaddr
/capdl-loader-experimental-image-arm-tk1
bootelf
```

## Notes
 The default setup does not pass though many devices to the Linux kernel. If you `make menuconfig` you can set `insecure` mode in the `Applications` submenu; this is meant to pass through all devices, but not
everything has been tested and confirmed to work yet. In particular, the SMMU needs to have extra entries added for any DMA-capable devices such as SATA.

## Creating a guest Linux

Running Linux as a guest on seL4 requires constructing an image and initial file system for the specific platform you are targetting.

1. Download buildroot https://buildroot.org/
```
cd buildroot
```
2. If you are lucky there is an existing config for your platform. Type `make list-defconfigs` to see existing configs.
```
make list-defconfigs` # view all existing configs
```
For example, for the imx8mq-evk platform, we used the `freescale_imx8mqevk_defconfig`.
```bash
make freescale_imx8mqevk_defconfig # configure build root to create that config
```
Otherwise you need to manually create a config for your platform.
3. Build the buildroot
```make```
4. Wait for it to build (< 1h)
￼5. To be continued... 
￼
