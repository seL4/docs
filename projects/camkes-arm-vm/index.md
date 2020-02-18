---
redirect_from:
  - /VM/CAmkESARMVM
layout: project
project: camkes-arm-vm
---

# CAmkES ARM VMM
 This page describes the ARM virtual machine monitor. By default it's configured for Jetson TX1, other supported platforms are Jetson TX2, Jetson TK1, Exynos5-based boards (Ordroid-XU, Odroid-XU3, Odroid-XU4) and Qemu.

## Getting and Building
```bash
repo init -u https://github.com/SEL4PROJ/camkes-arm-vm-manifest.git
repo sync
mkdir build
cd build
../init-build.sh -DAARCH32=TRUE -DCAMKES_VM_APP=vm_minimal -DPLATFORM=tk1
ninja
```

See `projects/vm/apps` for other supported virtual machine manager apps.

An EFI application file will be left in `images/capdl-loader-image-arm-tk1` We normally boot using TFTP, by first copying `capdl-loader-image-arm-tk1` to a tftpserver then on the U-Boot serial console doing:
```bash
dhcp tftpboot $loadaddr
/capdl-loader-image-arm-tk1
bootefi ${loadaddr}
```

## Notes
 The default setup does not pass though many devices to the Linux kernel. If you `make menuconfig` you can set `insecure` mode in the `Applications` submenu; this is meant to pass through all devices, but not
everything has been tested and confirmed to work yet. In particular, the SMMU needs to have extra entries added for any DMA-capable devices such as SATA.
