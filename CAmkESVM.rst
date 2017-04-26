= CAmkES x86 VM =

The CAmkES x86 VM uses CAmkES Next. Get the dependencies for building CAmkES next by following the instructions [[CAmkESNext|here]].

== Getting the Code ==

{{{
repo init -u https://github.com/seL4/camkes-vm-manifest.git
repo sync
}}}

== Starting Point ==

This repo contains many vm apps. We'll start from something basic, and add to it:
{{{
make cma34cr_minimal_defconfig
make
}}}

Running this should boot a single, very basic linux as a guest in the vm:
{{{
Welcome to Buildroot
buildroot login:
}}}

== Quick walk through the source code ==

The top level CAmkES spec is in apps/cma34cr_minimal/vm.camkes:
{{{
import <VM/vm.camkes>;
import "cma34cr.camkes";

assembly {
    composition {
        component VM vm;
    }
}
}}}

This is a very simple app, with a single vm, and nothing else. Each different vm app will have its own implementation of the `VM` component, where the guest environment is configured. For this app, the `VM` component is defined in apps/cma34cr_minimal/cma34cr.camkes:
{{{
#include <autoconf.h>
#include <configurations/vm.h>

component Init0 {
    VM_INIT_DEF()
}

component VM {

    composition {
        VM_COMPOSITION_DEF()
        VM_PER_VM_COMP_DEF(0)
    }

    configuration {
        VM_CONFIGURATION_DEF()
        VM_PER_VM_CONFIG_DEF(0, 2)

        vm0.simple_untyped24_pool = 12;
        vm0.heap_size = 0x10000;
        vm0.guest_ram_mb = 128;
        vm0.kernel_cmdline = VM_GUEST_CMDLINE;
        vm0.kernel_image = KERNEL_IMAGE;
        vm0.kernel_relocs = KERNEL_IMAGE;
        vm0.initrd_image = ROOTFS;
        vm0.iospace_domain = 0x0f;
    }
}
}}}

Most of the work here is done by five C preprocessor macros: VM_INIT_DEF, VM_COMPOSITION_DEF, VM_PER_VM_COMP_DEF, VM_CONFIGURATION_DEF, VM_PER_VM_CONFIG_DEF

These are all defined in projects/vm/components/VM/configurations/vm.h, and are concerned with specifying and configuring components that all VM(M)s need.

The `Init0` component corresponds to a single guest. Because of some rules in the cpp macros, the Ith guest in your system must be defined as a component named InitI. InitI components will be instantiated in the composition section by the VM_PER_VM_COMP_DEF macro with instance names vmI. The vm0 component instance being configured above is an instance of Init0. The C source code for InitI components is in projects/vm/components/Init/src. This source will be used for components named InitI for I in 0..VM_NUM_VM - 1, where VM_NUM_VM is defined in the app's Makefile (apps/cma34cr_minimal/Makefile).

The values of VM_GUEST_CMDLINE, KERNEL_IMAGE and ROOTFS are in apps/cma34cr_minimal/configurations/cma34cr_minimal.h. They are all strings, specifying the guest linux boot arguments, the name of the guest linux kernel image file, and the name of the guest linux initrd file (root filesystem to use during system initialization). KERNEL_IMAGE and ROOTFS refer to file names. These are the names of files in a CPIO archive that gets created by the build system, and linked into the VMM. The VMM uses the the KERNEL_IMAGE and ROOTFS names to find the appropriate files in this archive when preparing to boot the guest.

The local files used to construct the CPIO archive are specified in the app's Makefile, located at apps/cma34cr_minimal/Makefile:
{{{
...
KERNEL_FILENAME := bzimage
ROOTFS_FILENAME := rootfs.cpio
...
${STAGE_DIR}/${KERNEL_FILENAME}: $(SOURCE_DIR)/linux/${KERNEL_FILENAME}
...
${STAGE_DIR}/${ROOTFS_FILENAME}: ${SOURCE_DIR}/linux/${ROOTFS_FILENAME}
...
}}}

Both these rules refer to the "linux" directory, located at projects/vm/linux. It contains some tools for building new linux kernel and root filesystem images, as well as the images that these tools produce. A fresh checkout of this project will contain some pre-build images (bzimage and rootfs.cpio), to speed up build times. We'll get much more familiar with this directory later on.
