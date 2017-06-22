= Boot CentOS on the CAmkES VM =

Install CentOS for i386 on the main hard drive. Get an image here: http://mirror.centos.org/altarch/7/isos/i386/

You'll need to build a custom linux kernel to load when booting CentOS in the CAmkES VM. This is because the kernel that comes with CentOS expects PAE, which the CAmkES VM does not support. I got this working by building linux in the "CentOS way". You'll need a working installation of CentOS for this (though it doesn't have to be running on i386). Follow the instructions here: https://wiki.centos.org/HowTos/Custom_Kernel. Make sure to always choose the i386 option. Before building (step 5), modify the kernel's configuration to disable PAE. After building and installing the new kernel, you'll end up with a new /boot/vmlinuz* and /boot/initrd* file (you get a chance to choose the precise names during the configuration process). Use these files as the guest kernel and initrd as we do with the ubuntu kernel and initrd files in the [[CAmkESVM#Booting_from_hard_drive|ubuntu instructions]].

Use `configs/cma34cr_centos_defconfig` to build the CAmkES VM with a CentOS linux userland.
