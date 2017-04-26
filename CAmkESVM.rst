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
The linux running here was built using [[https://buildroot.org/|buildroot]]. This tool creates a compatible kernel and root filesystem with busybox and not much else, and runs on a ramdisk (the actual hard drive isn't mounted). Login with the username "root" and the password "root".

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
Both these rules refer to the "linux" directory, located at projects/vm/linux. It contains some tools for building new linux kernel and root filesystem images, as well as the images that these tools produce. A fresh checkout of this project will contain some pre-build images (bzimage and rootfs.cpio), to speed up build times.

== Adding to the guest ==
In the simple buildroot guest image, the initrd (rootfs.cpio) is also the filesystem you get access to after logging in. To make new programs available to the guest, add them to the rootfs.cpio archive. Similarly, to make new kernel modules available to the guest, they must be added to the rootfs.cpio archive also. The "linux" directory contains a tool called "build-rootfs", which is unrelated to the unfortunately similarly-named buildroot, which generates a new rootfs.cpio archive based on a starting point (rootfs-bare.cpio), and a collection of programs and modules. It also allows you to specify what happens when the system starts, and install some camkes-specific initialization code.

Here's a summary of what the build-rootfs tool does: 1. Download the linux source (unless it's already been downloaded). This is required for compiling kernel modules. The version of linux must match the one used to build bzimage. 2. Copy some config files into the linux source so it builds the modules the way we like. 3. Prepare the linux source for building modules (make prepare; make modules_prepare). 4. Extract the starting-point root filesystem (rootfs-bare.cpio). 5. Build all kernel modules in the "modules" directory, placing the output in the extracted root filesystem. 6. Create an init script by instantiating the "init_template" file with information about the linux version we're using. 7. Add camkes-specific initialization from the "camkes_init" file to the init.d directory in the extracted root filesystem. 8. Build custom libraries that programs will use, located in the "lib_src" directory. 9. Build each program in the "pkg" directory, statically linked, placing the output in the extracted root filesystem. 10. Copy all the files in the "text" directory to the "opt" directory in the extracted root filesystem. 11. Create a CPIO archive from the extracted root filesystem, creating the rootfs.cpio file.

=== Adding a program ===
Let's add a simple program!

Make a new directory at projects/vm/linux/pkg/hello.

{{{
mkdir projects/vm/linux/pkg/hello
}}}
Make a simple C program in projects/vm/linux/pkg/hello/hello.c

{{{
#include <stdio.h>

int main(int argc, char *argv[]) {
    printf("Hello, World!\n");
    return 0;
}
}}}
And a Makefile in projects/vm/linux/pkg/hello/Makefile:

{{{
TARGET = hello

include ../../common.mk
include ../../common_app.mk
}}}
Basic rules like turning .c files into .o files and statically linking all .o files into TARGET are stored in the common makefile stubs included by this file.

Run the "build-rootfs" script to update the rootfs.cpio file to include our new "hello" program.

Rebuild the app:

{{{
make
}}}
Running the app:

{{{
Welcome to Buildroot
buildroot login: root
Password:
# hello
Hello, World!
}}}
=== Adding a kernel module ===
We're going to add a new kernel module that lets us poke the vmm.

Make a new directory in projects/vm/linux/modules/poke:

{{{
mkdir projects/vm/linux/modules/poke
}}}
Implement the module in projects/vm/linux/modules/poke/poke.c. Initially we'll just get the module building and running, and then take care of communicating between the module and the vmm. For simplicity, we'll make it so when a special file associated with this module is written to, the vmm gets poked.

{{{
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>

#include <asm/uaccess.h>
#include <asm/kvm_para.h>
#include <asm/io.h>
#include <poke.h>

#define DEVICE_NAME "poke"

static int major_number;

static ssize_t poke_write(struct file *f, const char __user *b, size_t s, loff_t *o) {
    printk("hi\n");
    return s;
}     
          
struct file_operations fops = {
    .write = poke_write,
};

static int __init poke_init(void) {
    major_number = register_chrdev(0, DEVICE_NAME, &fops);
    printk(KERN_INFO "%s initialized with major number %d\n", DEVICE_NAME, major_number);
    return 0;
}

static void __exit poke_exit(void) {
    unregister_chrdev(major_number, DEVICE_NAME);
    printk(KERN_INFO "%s exit\n", DEVICE_NAME);
}

module_init(poke_init);
module_exit(poke_exit);
}}}
And a makefile in projects/vm/linux/modules/poke/Makefile:

{{{
obj-m += poke.o
CFLAGS_poke.o = -I../../include -I../../../common/shared_include

all:
    make -C $(KHEAD) M=$(PWD) modules

clean:
    make -C $(KHEAD) M=$(PWD) clean
}}}
And to make our module get loaded during initialization, edit projects/vm/linux/init_template:

{{{
...
insmod /lib/modules/__LINUX_VERSION__/kernel/drivers/vmm/dataport.ko
insmod /lib/modules/__LINUX_VERSION__/kernel/drivers/vmm/consumes_event.ko
insmod /lib/modules/__LINUX_VERSION__/kernel/drivers/vmm/emits_event.ko
insmod /lib/modules/__LINUX_VERSION__/kernel/drivers/vmm/poke.ko            # <-- add this line
...
}}}
Run the build-rootfs tool, then make and run the app:

{{{
Welcome to Buildroot
buildroot login: root
Password:
# grep poke /proc/devices         # figure out the major number of our driver
244 poke
# mknod /dev/poke c 244 0         # create the special file
# echo > /dev/poke                # write to the file
[   57.389643] hi
-sh: write error: Bad address     # the shell complains, but our module is being invoked!
}}}

Now let's make it talk to the vmm. In poke.c, replace
{{{
    printk("hi\n");
}}}
with
{{{
    kvm_hypercall1(4, 0);
}}}

The choice of 4 is because 0..3 are taken by other hypercalls.

Now we need to register a handler for this hypercall. Open the file projects/vm/components/Init/src/main.c:
Add a new function at the top of the file:
{{{
static int poke_handler(vmm_vcpu_t *vcpu) {
    printf("POKE!!!\n");
    return 0;
}
}}}

Now, in the function "main_continued", right before the call to "vmm_run", register the poke_handler:
{{{
    reg_new_handler(&vmm, poke_handler, 4); 

    /* Now go run the event loop */
    vmm_run(&vmm);
}}}

Now re-run build-rootfs, make, and run:
{{{
Welcome to Buildroot
buildroot login: root
Password:
# mknod /dev/poke c 244 0 
# echo > /dev/poke 
POKE!!!
}}}
