---
toc: true
---

# CAmkES x86 VM
 Get the dependencies for building CAmkES by following
the instructions [here](CAmkES#build-dependencies).

## Getting the Code
```bash
repo init -u https://github.com/seL4/camkes-vm-manifest.git
repo sync
```

## Starting Point
This repo contains many vm apps. We'll start from
something basic, and add to it:

```bash
make cma34cr_minimal_defconfig
make
```
Running this should boot a
single, very basic linux as a guest in the vm:

```
Welcome to Buildroot
buildroot login:
```
The linux running here was built using [buildroot](https://buildroot.org/). This tool
creates a compatible kernel and root filesystem with busybox and not
much else, and runs on a ramdisk (the actual hard drive isn't mounted).
Login with the username `root` and the password `root`.

## Quick walk through the source code
 The top level CAmkES spec is in
`apps/cma34cr_minimal/vm.camkes`:
```c
import <VM/vm.camkes>;
import "cma34cr.camkes";

assembly {
    composition {
        component VM vm;
    }
}
```

This is a very simple app, with a single vm, and nothing else. Each
different vm app will have its own implementation of the `VM` component,
where the guest environment is configured. For this app, the `VM`
component is defined in `apps/cma34cr_minimal/cma34cr.camkes`:
```c
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
      vm0.simple_untyped23_pool = 20;
      vm0.heap_size = 0x2000000;
      vm0.guest_ram_mb = 128;
      vm0.kernel_cmdline = VM_GUEST_CMDLINE;
      vm0.kernel_image = KERNEL_IMAGE;
      vm0.kernel_relocs = KERNEL_IMAGE;
      vm0.initrd_image = ROOTFS;
      vm0.iospace_domain = 0x0f;
  }

}
```

Most of the work here is done by five C preprocessor macros:
`VM_INIT_DEF`, `VM_COMPOSITION_DEF`, `VM_PER_VM_COMP_DEF`,
`VM_CONFIGURATION_DEF`, `VM_PER_VM_CONFIG_DEF`

These are all defined in `projects/vm/components/VM/configurations/vm.h`,
and are concerned with specifying and configuring components that all
VM(M)s need.

The `Init0` component corresponds to a single guest. Because of some rules
in the cpp macros, the *Ith* guest in your system must be defined as a
component named `InitI`. `InitI` components will be instantiated in the
composition section by the `VM_PER_VM_COMP_DEF` macro with instance
names `vmI`. The `vm0` component instance being configured above is an
instance of `Init0`. The C source code for`InitI` components is in
`projects/vm/components/Init/src`. This source will be used for components
named `InitI` for *I* in `0..VM_NUM_VM - 1`, where `VM_NUM_VM` is
defined in the app's Makefile (`apps/cma34cr_minimal/Makefile`).

The values of `VM_GUEST_CMDLINE`, `KERNEL_IMAGE` and `ROOTFS` are in
`apps/cma34cr_minimal/configurations/cma34cr_minimal.h`. They are all
strings, specifying the guest linux boot arguments, the name of the
guest linux kernel image file, and the name of the guest linux initrd
file (root filesystem to use during system initialization).
`KERNEL_IMAGE` and `ROOTFS` refer to file names. These are the names of
files in a CPIO archive that gets created by the build system, and
linked into the VMM. The VMM uses the `KERNEL_IMAGE` and `ROOTFS` names to
find the appropriate files in this archive when preparing to boot the
guest.

The local files used to construct the CPIO archive are specified in the
app's `Makefile`, located at `apps/cma34cr_minimal/Makefile`:
```make
# ...
KERNEL_FILENAME := bzimage
ROOTFS_FILENAME := rootfs.cpio
# ...
${STAGE_DIR}/${KERNEL_FILENAME}: $(SOURCE_DIR)/linux/${KERNEL_FILENAME}
# ...
${STAGE_DIR}/${ROOTFS_FILENAME}: ${SOURCE_DIR}/linux/${ROOTFS_FILENAME}
# ...
```

Both these rules refer to the "linux" directory, located at
`projects/vm/linux`. It contains some tools for building new linux kernel
and root filesystem images, as well as the images that these tools
produce. A fresh checkout of this project will contain some pre-build
images (`bzimage` and `rootfs.cpio`), to speed up build times.

## Adding to the guest
 In the simple buildroot guest image, the
initrd (rootfs.cpio) is also the filesystem you get access to after
logging in. To make new programs available to the guest, add them to the
rootfs.cpio archive. Similarly, to make new kernel modules available to
the guest, they must be added to the rootfs.cpio archive also. The
"linux" directory contains a tool called "build-rootfs", which is
unrelated to the unfortunately similarly-named buildroot, which
generates a new rootfs.cpio archive based on a starting point
(rootfs-bare.cpio), and a collection of programs and modules. It also
allows you to specify what happens when the system starts, and install
some camkes-specific initialization code.

Here's a summary of what the build-rootfs tool does:

  1.  Download the linux source (unless it's already been downloaded).
      This is required for compiling kernel modules. The version of
      linux must match the one used to build bzimage.
  2.  Copy some config files into the linux source so it builds the
      modules the way we like.
  3.  Prepare the linux source for building modules (make prepare;
      make modules_prepare).
  4.  Extract the starting-point root filesystem (rootfs-bare.cpio).
  5.  Build all kernel modules in the "modules" directory, placing the
      output in the extracted root filesystem.
  6.  Create an init script by instantiating the "init_template" file
      with information about the linux version we're using.
  7.  Add camkes-specific initialization from the "camkes_init" file to
      the init.d directory in the extracted root filesystem.
  8.  Build custom libraries that programs will use, located in the
      "lib_src" directory.
  9.  Build each program in the "pkg" directory, statically linked,
      placing the output in the extracted root filesystem.
  10. Copy all the files in the "text" directory to the "opt" directory
      in the extracted root filesystem.
  11. Create a CPIO archive from the extracted root filesystem, creating
      the rootfs.cpio file.

### Adding a program
 Let's add a simple program!

1.  Make a new directory:

    ```bash
    mkdir projects/vm/linux/pkg/hello 
    ```

2.  Make a simple C program in `projects/vm/linux/pkg/hello/hello.c`

    ```c
    #include <stdio.h>
    
    int main(int argc, char *argv[]) {
        printf("Hello, World!n");
        return 0;
    }
    ```

3.  Add a `Makefile` in `projects/vm/linux/pkg/hello/Makefile`:

    ```make
    TARGET = hello

    include ../../common.mk
    include ../../common_app.mk

    hello: hello.o
        $(CC) $(CFLAGS) $(LDFLAGS) $\^ -o $@
    ```

    Make sure there is a TAB character in the makefile, rather than spaces

4.  Run the "build-rootfs" script to update the rootfs.cpio file to
    include our new "hello" program.

    ```bash
    cd projects/vm/linux/
    ./build-rootfs
    cd ../../..
    ```

5.  Rebuild the app:

    ```
    make
    ```
6.  Run the app (use `root` as username and password):

    ```
    Welcome to Buildroot
    buildroot login: root
    Password:
    # hello
    Hello, World!
    ```

### Adding a kernel module
We're going to add a new kernel module that lets us poke the vmm.

1.  Make a new directory:

    ```
    mkdir projects/vm/linux/modules/poke
    ```

2.  Implement the module in `projects/vm/linux/modules/poke/poke.c`.

    Initially we'll just get the module building and running, and then take
    care of communicating between the module and the vmm. For simplicity,
    we'll make it so when a special file associated with this module is
    written to, the vmm gets poked.

    ```c
    #include <linux/module.h>
    #include <linux/kernel.h>
    #include <linux/init.h>
    #include <linux/fs.h>

    #include <asm/uaccess.h>
    #include <asm/kvm_para.h>
    #include <asm/io.h>

    #define DEVICE_NAME "poke"

    static int major_number;

    static ssize_t poke_write(struct file *f, const char \__user*b, size_t s, loff_t *o) {
        printk("hi\n"); // TODO replace with hypercall
        return s;
    }

    struct file_operations fops = {
        .write = poke_write,
    };

    static int __init poke_init(void) {
        major_number = register_chrdev(0, DEVICE_NAME, &fops);
        printk(KERN_INFO "%s initialized with major number %dn", DEVICE_NAME, major_number);
        return 0;
    }

    static void __exit poke_exit(void) {

        unregister_chrdev(major_number, DEVICE_NAME);
        printk(KERN_INFO"%s exitn", DEVICE_NAME);
    }

    module_init(poke_init);
    module_exit(poke_exit);
    ```

3.  And a makefile in `projects/vm/linux/modules/poke/Makefile`:

    ```
    obj-m += poke.o
    CFLAGS_poke.o = -I../../include -I../../../common/shared_include

    all:
        make -C $(KHEAD) M=$(PWD) modules

    clean:
        make -C $(KHEAD) M=$(PWD) clean
    ```

4.  Add the new module to so it is loaded during initialization, edit `projects/vm/linux/init_template`:

    ```c
    #...
    insmod /lib/modules/__LINUX_VERSION__/kernel/drivers/vmm/dataport.ko
    insmod /lib/modules/__LINUX_VERSION__/kernel/drivers/vmm/consumes_event.ko
    insmod /lib/modules/__LINUX_VERSION__/kernel/drivers/vmm/emits_event.ko
    insmod /lib/modules/__LINUX_VERSION__/kernel/drivers/vmm/poke.ko # <-- add this line
    #...
    ```

5.  Run the build-rootfs tool, then make

    ```
    cd projects/vm/linux/
    ./build-rootfs
    cd ../../..
    make
    ```

6.  Run the app:

    ```
    Welcome to Buildroot
    buildroot login: root
    Password:
    # grep poke /proc/devices        # figure out the major number of our driver
    244 poke
    # mknod /dev/poke c 244 0        # create the special file
    # echo > /dev/poke               # write to the file
    [ 57.389643] hi
    -sh: write error: Bad address    # the shell complains, but our module is being invoked!
    ```

    **Now let's make it talk to the vmm**.

7.  In projects/vm/linux/modules/poke/poke.c, replace `printk("hi\n");`
    with `kvm_hypercall1(4, 0);`
    The choice of 4 is because 0..3 are taken by other hypercalls.

8.  Now register a handler for this hypercall in
    `projects/vm/components/Init/src/main.c`:
    
    Add a new function at the top of the file:

    ```
    static int poke_handler(vmm_vcpu_t *vmm_vcpu) {
        printf("POKE!!!n");
        return 0;
    }
    ```

    In the function main_continued register \`poke_handler\`:

    ```
    reg_new_handler(&vmm, poke_handler, 4); // <--- added

    /* Now go run the event loop */
    vmm_run(&vmm);
    ```

9.  Finally re-run build-rootfs, make, and run:

    ```
    Welcome to Buildroot
    buildroot login: root
    Password:
    # mknod /dev/poke c 244 0
    # echo > /dev/poke
    POKE!!!
    ```

## Cross VM Connectors


It's possible to connect processes in the guest linux to regular CAmkES
components. This is done with the addition of 3 kernel modules to the
guest linux, that allow device files to be created that correspond to
CAmkES connections. Depending on the type of connection, there are some
file operations defined for these files that can be used to communicate
with the other end of the connection.

The kernel modules are included in the root filesystem by default:

- dataport: facilitates setting up shared memory between the guest
        and CAmkES components
- consumes_event: allows a process in the guest to wait or poll
        for an event sent by a CAmkES component
- emits_event: allows a process to emit an event to a CAmkES
        component

There is a library in `projects/vm/linux/lib_src/camkes` containing some
linux syscall wrappers, and some utility programs in
`projects/vm/linux/pkg/{dataport,consumes_event,emits_event}` which
initialize and interact with cross vm connections.

### Implementation Details


#### Dataports


In order for linux to use a dataport, it must first be initialized. To
initialize a dataport, a linux process makes a particular `ioctl` call on
the file associated with the dataport, specifying the page-aligned size
of the dataport. The dataport kernel module then allocates a
page-aligned buffer of the appropriate size, and makes a hypercall to
the VMM, passing it the guest physical address of this buffer, along
with the id of the dataport, determined by the file on which ioctl was
called. The VMM then modifies the guest's address space, updating the
mappings from the specified gpaddr to point to the physical memory
backing the dataport seen by the other end of the connection. This
results in a region of shared memory existing between a camkes component
and the guest. Linux processes can then map this memory into their own
address space by calling `mmap` on the file associated with the dataport.

#### Emitting Events


A guest process emits an event by making `ioctl` call on the file
associated with the event interface. This results in the emits_event
kernel module making a hypercall to the VMM, passing it the id of the
event interface determined by the file being ioctl'd. The VMM then emits
the real event (which doesn't block - events are notifications), and
then immediately resumes the guest running.

#### Consuming Events


Consuming events is complicated because we'd like for a process in the
guest to be able to block, waiting for an event, without blocking the
entire VM. A linux process can wait or poll for an event by calling poll
on the file associated with that event, using the timeout argument to
specify whether or not it should block. The event it polls for is
POLLIN. When the VMM receives an event destined for the guest, it places
the event id in some memory shared between the VMM and the
consumes_event kernel module, and then injects an interrupt into the
guest. The consumes_event kernel module is registered to handle this
interrupt, which reads the event id from shared memory, and wakes a
thread blocked on the corresponding event file. If no threads are
blocked on the file, some state is set in the module such that the next
time a process waits on that file, it returns immediately and clears the
state, mimicking the behaviour of notifications.

### Using Cross VM Connections


We'll create a program that runs in the guest, and prints a string by
sending it to a CAmkES component. The guest program will write a string
to a shared buffer between itself and a CAmkES component. When its ready
for the string to be printed, it will emit an event, received by the
CAmkES component. The CAmkES component will print the string, then send
an event to the guest process so the guest knows it's safe to send a new
string.

We'll start on the CAmkES side. Edit
`apps/cma34cr_minimal/cma34cr.camkes`, adding the following interfaces to
the Init0 component definition:
```c
component Init0 {
  VM_INIT_DEF()

  // Add the following four lines:
  dataport Buf(4096) data;
  emits DoPrint do_print;
  consumes DonePrinting done_printing;
  has mutex cross_vm_event_mutex;
}
```

These interfaces will eventually be made visible to processes running in
the guest linux. The mutex is used to protect access to shared state
between the VMM and guest.

Now, we'll define the print server component. Add the following to
`apps/cma34cr_minimal/cma34cr.camkes`:
```c
component PrintServer {
  control;
  dataport Buf(4096) data;
  consumes DoPrint do_print;
  emits DonePrinting done_printing;
}
```

We'll get around to actually implementing this soon. First, let's
instantiate the print server and connect it to the VMM. Add the
following to the composition section in
apps/cma34cr_minimal/cma34cr.camkes:
```c
component VM {

    composition {
        VM_COMPOSITION_DEF()
        VM_PER_VM_COMP_DEF(0)

        // Add the following component and connections:
        component PrintServer print_server;
        connection seL4Notification conn_do_print(from vm0.do_print,
                                                 to print_server.do_print);
        connection seL4Notification conn_done_printing(from print_server.done_printing,
                                                      to vm0.done_printing);

        connection seL4SharedDataWithCaps conn_data(from print_server.data,
                                                    to vm0.data);
    }
```

The only thing unusual about that was the [seL4SharedDataWithCaps](/seL4SharedDataWithCaps)
connector. This is a dataport connector much like seL4SharedData. The
only difference is that the "to" side of the connection gets access to
the caps to the frames backing the dataport. This is necessary from
cross vm dataports, as the VMM must be able to establish shared memory
at runtime, by inserting new mappings into the guest's address space,
which requires caps to the physical memory being mapped in.

Interfaces connected with [seL4SharedDataWithCaps](/seL4SharedDataWithCaps) must be
configured with an integer specifying the id of the dataport, and the
size of the dataport. Add the following to the configuration section in
apps/cma34cr_minimal/cma34cr.camkes:
```c
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

    // Add the following 2 lines:
    vm0.data_id = 1; // ids must be contiguous, starting from 1
    vm0.data_size = 4096;
}
```

Now let's implement our print server. Create a file
apps/cma34cr_minimal/print_server.c:
```c
#include <camkes.h>
#include <stdio.h>

int run(void) {

    while (1) {
        do_print_wait();

        printf("%s\n", (char*)data);

        done_printing_emit();
    }

    return 0;
}
```

This component loops forever, waiting for an event, printing a string
from shared memory, then emitting an event. It assumes that the shared
buffer will contain a valid, null-terminated c string. Obviously this is
risky, but will serve for our example here.

We need to create another c file that tells the VMM about our cross vm connections. This file must define 3 functions which initialize each type of cross vm interface:

- cross_vm_dataports_init
- cross_vm_emits_events_init
- cross_vm_consumes_events_init

Create a file `apps/cma34cr_minimal/cross_vm.c`:
```c
#include <sel4/sel4.h>
#include <camkes.h>
#include <camkes_mutex.h>
#include <camkes_consumes_event.h>
#include <camkes_emits_event.h>
#include <dataport_caps.h>
#include <cross_vm_consumes_event.h>
#include <cross_vm_emits_event.h>
#include <cross_vm_dataport.h>
#include <vmm/vmm.h>
#include <vspace/vspace.h>

// this is defined in the dataport's glue code
extern dataport_caps_handle_t data_handle;

// Array of dataport handles at positions corresponding to handle ids from spec
static dataport_caps_handle_t *dataports[] = {
    NULL, // entry 0 is NULL so ids correspond with indices
    &data_handle,
};
    
// Array of consumed event callbacks and ids
static camkes_consumes_event_t consumed_events[] = {
    { .id = 1, .reg_callback = done_printing_reg_callback },
};
    
// Array of emitted event emit functions
static camkes_emit_fn emitted_events[] = {
    NULL,   // entry 0 is NULL so ids correspond with indices
    do_print_emit,
};
    
// mutex to protect shared event context
static camkes_mutex_t cross_vm_event_mutex = (camkes_mutex_t) {
    .lock = cross_vm_event_mutex_lock,
    .unlock = cross_vm_event_mutex_unlock,
};  

int cross_vm_dataports_init(vmm_t *vmm) {
    return cross_vm_dataports_init_common(vmm, dataports, sizeof(dataports)/sizeof(dataports[0]));
}   
            
int cross_vm_emits_events_init(vmm_t *vmm) {
    return cross_vm_emits_events_init_common(vmm, emitted_events,
            sizeof(emitted_events)/sizeof(emitted_events[0]));
}   
            
int cross_vm_consumes_events_init(vmm_t *vmm, vspace_t *vspace, seL4_Word irq_badge) {
    return cross_vm_consumes_events_init_common(vmm, vspace, &cross_vm_event_mutex,
            consumed_events, sizeof(consumed_events)/sizeof(consumed_events[0]), irq_badge);
}
```

To make this build, we need to symlink the common source directory for
the camkes vm into the app's directory:
```
ln -s ../../common apps/cma34cr_minimal
```

And make the following change to `apps/cma34cr_minimal/Makefile`:
```
...
include PCIConfigIO/PCIConfigIO.mk
include FileServer/FileServer.mk
include Init/Init.mk

# Add the following:
Init0_CFILES += $(wildcard $(SOURCE_DIR)/cross_vm.c) \
                $(wildcard $(SOURCE_DIR)/common/src/*.c)
Init0_HFILES += $(wildcard $(SOURCE_DIR)/common/include/*.h) \
                $(wildcard $(SOURCE_DIR)/common/shared_include/cross_vm_shared/*.h)

PrintServer_CFILES += $(SOURCE_DIR)/print_server.c
...
```

The app should now build when you run `make`, but we're not done yet. Now
we'll make these interfaces available to the guest linux. Edit
`projects/vm/linux/camkes_init`. It's a shell script that is executed as
linux is initialized. Currently it should look like:
```bash
#!/bin/sh
# Initialises linux-side of cross vm connections.

# Dataport sizes must match those in the camkes spec.
# For each argument to dataport_init, the nth pair
# corresponds to the dataport with id n.
dataport_init /dev/camkes_reverse_src 8192 /dev/camkes_reverse_dest 8192

# The nth argument to event_init corresponds to the
# event with id n according to the camkes vmm.
consumes_event_init /dev/camkes_reverse_done
emits_event_init /dev/camkes_reverse_ready
```

This sets up some interfaces used for a simple demo. Delete all that,
and add the following:
```bash
#!/bin/sh
# Initialises linux-side of cross vm connections.

# Dataport sizes must match those in the camkes spec.
# For each argument to dataport_init, the nth pair
# corresponds to the dataport with id n.
dataport_init /dev/camkes_data 4096
                  
# The nth argument to event_init corresponds to the
# event with id n according to the camkes vmm.
consumes_event_init /dev/camkes_done_printing
emits_event_init /dev/camkes_do_print
```

Each of these commands creates device nodes associated with a particular
linux kernel module supporting cross vm communication. Each command
takes a list of device nodes to create, which must correpond to the ids
assigned to interfaces in the `cma34cr.camkes` and `cross_vm.c`. The
`dataport_init` command must also be passed the size of each dataport.

These changes will cause device nodes to be created which correspond to
the interfaces we added to the VMM component.

Now let's make an app that uses these nodes to communicate with the
print server. As before, create a new directory in pkg:
``` 
mkdir projects/vm/linux/pkg/print_client
```

Create `projects/vm/linux/pkg/print_client/print_client.c`:
```c
#include <string.h>
#include <assert.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>

#include "dataport.h"
#include "consumes_event.h"
#include "emits_event.h"

int main(int argc, char *argv[]) {

    int data_fd = open("/dev/camkes_data", O_RDWR);
    assert(data_fd >= 0); 

    int do_print_fd = open("/dev/camkes_do_print", O_RDWR);
    assert(do_print_fd >= 0); 

    int done_printing_fd = open("/dev/camkes_done_printing", O_RDWR);
    assert(done_printing_fd >= 0); 

    char *data = (char*)dataport_mmap(data_fd);
    assert(data != MAP_FAILED);

    ssize_t dataport_size = dataport_get_size(data_fd);
    assert(dataport_size > 0); 

    for (int i = 1; i < argc; i++) {
        strncpy(data, argv[i], dataport_size);
        emits_event_emit(do_print_fd);
        consumes_event_wait(done_printing_fd);
    }   

    close(data_fd);
    close(do_print_fd);
    close(done_printing_fd);

    return 0;
}
```

This program prints each of its arguments on a separate line, by sending
each argument to the print server one at a time.

Create `projects/vm/linux/pkg/print_client/Makefile`:
```
TARGET = print_client

include ../../common.mk
include ../../common_app.mk

print_client: print_client.o
    $(CC) $(CFLAGS) $(LDFLAGS) $^ -lcamkes -o $@
```

Now, run build-rootfs, and make, and run!
```
...
Creating dataport node /dev/camkes_data
Allocating 4096 bytes for /dev/camkes_data
Creating consuming event node /dev/camkes_done_printing
Creating emitting event node /dev/camkes_do_print

Welcome to Buildroot
buildroot login: root
Password:
# print_client hello world
[   12.730073] dataport received mmap for minor 1
hello
world
```

## Booting from hard drive


These instructions are for ubuntu. For CentOS instructions, see
[CAmkESVMCentOS](/CAmkESVMCentOS).

So far we've only run a tiny linux on a ram disk. What if we want to run
Ubuntu booting off a hard drive? This section will explain the changes
we need to make to our VM app to allow it to boot into a Ubuntu
environment installed on the hard drive. Thus far these examples should
have been compatible with most modern x86 machines. The rest of this
tutorial will focus on a particular machine:
[the cma34cr
single board computer](https://www.rtd.com/PC104/CM/CMA34CR/CMA34CR.htm)

The first step is to install ubuntu natively on the cma34cr. It's
currently required that guests of the camkes vm run in 32-bit mode, so
install 32-bit ubuntu. These examples will use ubuntu-16.04.

The plan will be to give the guest passthrough access to the hard drive,
and use a ubuntu initrd as our initial root filesystem, replacing the
buildroot one used thus far. We'll use the same kernel image as before,
as our vm requires that PAE be turned off, and it's on by default in the
ubuntu kernel.

### Getting the initrd image


We need to generate a root filesystem image suitable for ubuntu. Ubuntu
ships with a tool called mkinitramfs which generates root filesystem
images. Let's use it to generate a root filesystem image compatible with
the linux kernel we'll be using. Boot ubuntu natively on the cma34cr and
run the following command:
```
$ mkinitramfs -o rootfs.cpio 4.8.16
WARNING: missing /lib/modules/4.8.16
Ensure all necessary drivers are built into the linux image!
depmod: ERROR: could not open directory /lib/modules/4.8.16: No such file or directory
depmod: FATAL: could not search modules: No such file or directory
depmod: WARNING: could not open /var/tmp/mkinitramfs_H9SRHb/lib/modules/4.8.16/modules.order: No such file or directory
depmod: WARNING: could not open /var/tmp/mkinitramfs_H9SRHb/lib/modules/4.8.16/modules.builtin: No such file or directory
```

The kernel we'll be using has all the necessary drivers built in, so
feel free to ignore those warnings and errors. You should now have a
file called rootfs.cpio on the cma34cr. Transfer that file to your dev
machine, and put it in `apps/cma34cr_minimal`. Now we need to tell the
build system to take that rootfs image rather than the default buildroot
one. Edit apps/cma34cr_minimal/Makefile. Change this line:
```make
${STAGE_DIR}/${ROOTFS_FILENAME}: ${SOURCE_DIR}/linux/${ROOTFS_FILENAME}
```
to
```make
${STAGE_DIR}/${ROOTFS_FILENAME}: ${SOURCE_DIR}/${ROOTFS_FILENAME}
```

Since we'll be using a real hard drive, we need to change the boot
command line we give to the guest linux. Open
`apps/cma34cr_minimal/configurations/cma34cr_minimal.h`, and change the
definition of `VM_GUEST_CMDLINE` to:
```
#define VM_GUEST_CMDLINE "earlyprintk=ttyS0,115200 console=ttyS0,115200 i8042.nokbd=y i8042.nomux=y i8042.noaux=y io_delay=udelay noisapnp pci=nomsi debug root=/dev/sda1 rdinit=/init 2"
```

Try building and running after this change:
```
BusyBox v1.22.1 (Ubuntu 1:1.22.0-15ubuntu1) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs)
```

You should get dropped into a shell inside the root filesystem. You can
run commands from here:
``` 
(initramfs) pwd
/
(initramfs) ls
dev      run      init     scripts  var      usr      sys      tmp
root     sbin     etc      bin      lib      conf     proc
```

If you look inside `/dev`, you'll notice the lack of sda device. Linux
can't find the hard drive because we haven't passed it through yet.
Let's do that now!

We're going to give the guest passthrough access to the sata controller.
The sata controller will be in one of two modes: AHCI or IDE. The mode
can be set when configuring BIOS. By default it should be AHCI. The next
part has some minor differences depending on the mode. I'll show both.
Open `apps/cma34cr_minimal/cma34cr.camkes` and add the following to the
configuration section:

For AHCI:
```c
configuration {
    ...

    vm0_config.pci_devices_iospace = 1;


    vm0_config.ioports = [
        {"start":0x4088, "end":0x4090, "pci_device":0x1f, "name":"SATA"},
        {"start":0x4094, "end":0x4098, "pci_device":0x1f, "name":"SATA"},
        {"start":0x4080, "end":0x4088, "pci_device":0x1f, "name":"SATA"},
        {"start":0x4060, "end":0x4080, "pci_device":0x1f, "name":"SATA"},
    ];
    
    vm0_config.pci_devices = [ 
        {   
            "name":"SATA",
            "bus":0,
            "dev":0x1f,
            "fun":2,
            "irq":"SATA",
            "memory":[
                {"paddr":0xc0713000, "size":0x800, "page_bits":12},
            ],
        },  
    ];

    vm0_config.irqs = [ 
        {"name":"SATA", "source":19, "level_trig":1, "active_low":1, "dest":11},
    ];
}
```

For IDE:
```c
configuration {
    ...

    vm0_config.pci_devices_iospace = 1

    vm0_config.ioports = [ 
        {"start":0x4080, "end":0x4090, "pci_device":0x1f, "name":"SATA"},
        {"start":0x4090, "end":0x40a0, "pci_device":0x1f, "name":"SATA"},
        {"start":0x40b0, "end":0x40b8, "pci_device":0x1f, "name":"SATA"},
        {"start":0x40b8, "end":0x40c0, "pci_device":0x1f, "name":"SATA"},
        {"start":0x40c8, "end":0x40cc, "pci_device":0x1f, "name":"SATA"},
        {"start":0x40cc, "end":0x40d0, "pci_device":0x1f, "name":"SATA"},
    ];  

    vm0_config.pci_devices = [ 
        {   
            "name":"SATA",
            "bus":0,
            "dev":0x1f,
            "fun":2,
            "irq":"SATA",
            "memory":[],
        },  
    ];  

    vm0_config.irqs = [ 
        {"name":"SATA", "source":19, "level_trig":1, "active_low":1, "dest":11},
    ];
}
```

Now rebuild and run:
```
Ubuntu 16.04.1 LTS ertos-CMA34CR ttyS0

ertos-CMA34CR login: 
```

You should be able to log in and use the system largely as normal.

## Passthrough Ethernet


The ethernet device is not accessible to the guest:
```
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1
    link/sit 0.0.0.0 brd 0.0.0.0
```

An easy way to give the guest network access is to give it passthrough
access to the ethernet controller. This is done much in the same way as
enabling passthrough access to the sata controller. In the configuration
section in `apps/cma34cr_minimal/cma34cr.camkes`, add to the list of io
ports, pci devices and irqs to pass through:
```c
vm0_config.ioports = [
    {"start":0x4080, "end":0x4090, "pci_device":0x1f, "name":"SATA"},
    {"start":0x4090, "end":0x40a0, "pci_device":0x1f, "name":"SATA"},
    {"start":0x40b0, "end":0x40b8, "pci_device":0x1f, "name":"SATA"},
    {"start":0x40b8, "end":0x40c0, "pci_device":0x1f, "name":"SATA"},
    {"start":0x40c8, "end":0x40cc, "pci_device":0x1f, "name":"SATA"},
    {"start":0x40cc, "end":0x40d0, "pci_device":0x1f, "name":"SATA"},
    {"start":0x3000, "end":0x3020, "pci_device":0, "name":"Ethernet5"}, // <--- Add this entry
];

vm0_config.pci_devices = [
    {   
        "name":"SATA",
        "bus":0,
        "dev":0x1f,
        "fun":2,
        "irq":"SATA",
        "memory":[],
    },

    // Add this entry:
    {
        "name":"Ethernet5",
        "bus":5,
        "dev":0,
        "fun":0,
        "irq":"Ethernet5",
        "memory":[
            {"paddr":0xc0500000, "size":0x20000, "page_bits":12},
            {"paddr":0xc0520000, "size":0x4000, "page_bits":12},
        ],
    },
];

vm0_config.irqs = [
    {"name":"SATA", "source":19, "level_trig":1, "active_low":1, "dest":11},
    {"name":"Ethernet5", "source":0x11, "level_trig":1, "active_low":1, "dest":10}, // <--- Add this entry
];
```

You should have added a new entry to each of the three lists that
describe passthrough devices. Building and running:
```
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:d0:81:09:0c:7d brd ff:ff:ff:ff:ff:ff
    inet 10.13.1.87/23 brd 10.13.1.255 scope global dynamic enp0s2
       valid_lft 14378sec preferred_lft 14378sec
    inet6 2402:1800:4000:1:90b3:f9d:ae22:33b7/64 scope global temporary dynamic 
       valid_lft 86390sec preferred_lft 14390sec
    inet6 2402:1800:4000:1:aa67:5925:2cbc:928f/64 scope global mngtmpaddr noprefixroute dynamic 
       valid_lft 86390sec preferred_lft 14390sec
    inet6 fe80::cc47:129d:bdff:a2da/64 scope link 
       valid_lft forever preferred_lft forever
3: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1
    link/sit 0.0.0.0 brd 0.0.0.0
$ ping google.com
PING google.com (172.217.25.142) 56(84) bytes of data.
64 bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp_seq=1 ttl=51 time=2.17 ms
64 bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp_seq=2 ttl=51 time=1.95 ms
64 bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp_seq=3 ttl=51 time=1.99 ms
64 bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp_seq=4 ttl=51 time=2.20 ms
```

## Figuring out information about PCI devices


To add a new passthrough device, or access a pci device in general, we
need to know which io ports it uses, which interrupts it's associated
with, and the physical addresses of any memory-mapped io regions it
uses. The easiest way to find this information is to boot linux
natively, and run the command `lspci -vv`.
