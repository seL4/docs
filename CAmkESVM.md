# CAmkES x86 VM
 Get the dependencies for building CAmkES by following
the instructions \[\[CAmkES\#Build\_dependencies|here\]\].

&lt;&lt;TableOfContents&gt;&gt;

## Getting the Code
 {{{ repo init -u
<https://github.com/seL4/camkes-vm-manifest.git> repo sync }}} ==
Starting Point == This repo contains many vm apps. We'll start from
something basic, and add to it:

{{{ make cma34cr\_minimal\_defconfig make }}} Running this should boot a
single, very basic linux as a guest in the vm:

{{{ Welcome to Buildroot buildroot login: }}} The linux running here was
built using \[\[<https://buildroot.org/%7Cbuildroot>\]\]. This tool
creates a compatible kernel and root filesystem with busybox and not
much else, and runs on a ramdisk (the actual hard drive isn't mounted).
Login with the username "root" and the password "root".

## Quick walk through the source code
 The top level CAmkES spec is in
apps/cma34cr\_minimal/vm.camkes:

{{{ import &lt;VM/vm.camkes&gt;; import "cma34cr.camkes";

assembly {

:   

    composition {

    :   component VM vm;

    }

}
=

This is a very simple app, with a single vm, and nothing else. Each
different vm app will have its own implementation of the VM component,
where the guest environment is configured. For this app, the VM
component is defined in apps/cma34cr\_minimal/cma34cr.camkes:

{{{ \#include &lt;autoconf.h&gt; \#include &lt;configurations/vm.h&gt;

component Init0 {

:   VM\_INIT\_DEF()

}

component VM {

> composition {
>
> :   VM\_COMPOSITION\_DEF() VM\_PER\_VM\_COMP\_DEF(0)
>
> }
>
> configuration {
>
> :   VM\_CONFIGURATION\_DEF() VM\_PER\_VM\_CONFIG\_DEF(0, 2)
>
>     vm0.simple\_untyped23\_pool = 20; vm0.heap\_size = 0x2000000;
>     vm0.guest\_ram\_mb = 128; vm0.kernel\_cmdline =
>     VM\_GUEST\_CMDLINE; vm0.kernel\_image = KERNEL\_IMAGE;
>     vm0.kernel\_relocs = KERNEL\_IMAGE; vm0.initrd\_image = ROOTFS;
>     vm0.iospace\_domain = 0x0f;
>
> }

}
=

Most of the work here is done by five C preprocessor macros:
VM\_INIT\_DEF, VM\_COMPOSITION\_DEF, VM\_PER\_VM\_COMP\_DEF,
VM\_CONFIGURATION\_DEF, VM\_PER\_VM\_CONFIG\_DEF

These are all defined in projects/vm/components/VM/configurations/vm.h,
and are concerned with specifying and configuring components that all
VM(M)s need.

The Init0 component corresponds to a single guest. Because of some rules
in the cpp macros, the ''Ith'' guest in your system must be defined as a
component named InitI. InitI components will be instantiated in the
composition section by the VM\_PER\_VM\_COMP\_DEF macro with instance
names vmI. The vm0 component instance being configured above is an
instance of Init0. The C source code for InitI components is in
projects/vm/components/Init/src. This source will be used for components
named InitI for ''I'' in 0..VM\_NUM\_VM - 1, where VM\_NUM\_VM is
defined in the app's Makefile (apps/cma34cr\_minimal/Makefile).

The values of VM\_GUEST\_CMDLINE, KERNEL\_IMAGE and ROOTFS are in
apps/cma34cr\_minimal/configurations/cma34cr\_minimal.h. They are all
strings, specifying the guest linux boot arguments, the name of the
guest linux kernel image file, and the name of the guest linux initrd
file (root filesystem to use during system initialization).
KERNEL\_IMAGE and ROOTFS refer to file names. These are the names of
files in a CPIO archive that gets created by the build system, and
linked into the VMM. The VMM uses the KERNEL\_IMAGE and ROOTFS names to
find the appropriate files in this archive when preparing to boot the
guest.

The local files used to construct the CPIO archive are specified in the
app's Makefile, located at \`apps/cma34cr\_minimal/Makefile\`:

{{{
---

KERNEL\_FILENAME := bzimage ROOTFS\_FILENAME := rootfs.cpio ...
\${STAGE\_DIR}/\${KERNEL\_FILENAME}:
\$(SOURCE\_DIR)/linux/\${KERNEL\_FILENAME} ...
\${STAGE\_DIR}/\${ROOTFS\_FILENAME}:
\${SOURCE\_DIR}/linux/\${ROOTFS\_FILENAME} ... }}}

Both these rules refer to the "linux" directory, located at
projects/vm/linux. It contains some tools for building new linux kernel
and root filesystem images, as well as the images that these tools
produce. A fresh checkout of this project will contain some pre-build
images (bzimage and rootfs.cpio), to speed up build times.

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

> 1.  Download the linux source (unless it's already been downloaded).
>     This is required for compiling kernel modules. The version of
>     linux must match the one used to build bzimage.
> 2.  Copy some config files into the linux source so it builds the
>     modules the way we like.
> 3.  Prepare the linux source for building modules (make prepare;
>     make modules\_prepare).
> 4.  Extract the starting-point root filesystem (rootfs-bare.cpio).
> 5.  Build all kernel modules in the "modules" directory, placing the
>     output in the extracted root filesystem.
> 6.  Create an init script by instantiating the "init\_template" file
>     with information about the linux version we're using.
> 7.  Add camkes-specific initialization from the "camkes\_init" file to
>     the init.d directory in the extracted root filesystem.
> 8.  Build custom libraries that programs will use, located in the
>     "lib\_src" directory.
> 9.  Build each program in the "pkg" directory, statically linked,
>     placing the output in the extracted root filesystem.
> 10. Copy all the files in the "text" directory to the "opt" directory
>     in the extracted root filesystem.
> 11. Create a CPIO archive from the extracted root filesystem, creating
>     the rootfs.cpio file.

### Adding a program
 Let's add a simple program!

1.  Make a new directory:

{{{ mkdir projects/vm/linux/pkg/hello }}}

2.  Make a simple C program in projects/vm/linux/pkg/hello/hello.c

{{{ \#include &lt;stdio.h&gt;

int main(int argc, char \*argv\[\]) {

:   printf("Hello, World!n"); return 0;

}
=

3.  Add a Makefile in \`projects/vm/linux/pkg/hello/Makefile\`:

{{{ TARGET = hello

include ../../common.mk include ../../common\_app.mk

hello: hello.o

:   \$(CC) \$(CFLAGS) \$(LDFLAGS) \$\^ -o \$@

}}}

Make sure there is a TAB character in the makefile, rather than spaces

4.  Run the "build-rootfs" script to update the rootfs.cpio file to
    include our new "hello" program.

{{{ cd projects/vm/linux/ ./build-rootfs cd ../../.. }}}

5.  Rebuild the app:

{{{ make }}} 6. Run the app (use root as username and password):

{{{ Welcome to Buildroot buildroot login: root Password: \# hello Hello,
World! }}} === Adding a kernel module === We're going to add a new
kernel module that lets us poke the vmm.

1.  Make a new directory:

{{{ mkdir projects/vm/linux/modules/poke }}}

2.  Implement the module in projects/vm/linux/modules/poke/poke.c.

Initially we'll just get the module building and running, and then take
care of communicating between the module and the vmm. For simplicity,
we'll make it so when a special file associated with this module is
written to, the vmm gets poked.

{{{ \#include &lt;linux/module.h&gt; \#include &lt;linux/kernel.h&gt;
\#include &lt;linux/init.h&gt; \#include &lt;linux/fs.h&gt;

\#include &lt;asm/uaccess.h&gt; \#include &lt;asm/kvm\_para.h&gt;
\#include &lt;asm/io.h&gt;

\#define DEVICE\_NAME "poke"

static int major\_number;

static ssize\_t poke\_write(struct file *f, const char \_\_user*b, size\_t s, loff\_t \*o) {

:   printk("hin"); // TODO replace with hypercall return s;

}

struct file\_operations fops = {

:   .write = poke\_write,

};

static int \_\_init poke\_init(void) {

:   major\_number = register\_chrdev(0, DEVICE\_NAME, &fops);
    printk(KERN\_INFO "%s initialized with major number %dn",
    DEVICE\_NAME, major\_number); return 0;

}

static void \_\_exit poke\_exit(void) {

:   unregister\_chrdev(major\_number, DEVICE\_NAME); printk(KERN\_INFO
    "%s exitn", DEVICE\_NAME);

}

module\_init(poke\_init); module\_exit(poke\_exit); }}}

3.  And a makefile in \`projects/vm/linux/modules/poke/Makefile\`:

{{{ obj-m += poke.o CFLAGS\_poke.o = -I../../include
-I../../../common/shared\_include

all:

:   make -C \$(KHEAD) M=\$(PWD) modules

clean:

:   make -C \$(KHEAD) M=\$(PWD) clean

}}}

4.  Add the new module to so it is loaded during initialization, edit
    projects/vm/linux/init\_template:

{{{
---

insmod
/lib/modules/\_\_LINUX\_VERSION\_\_/kernel/drivers/vmm/dataport.ko
insmod
/lib/modules/\_\_LINUX\_VERSION\_\_/kernel/drivers/vmm/consumes\_event.ko
insmod
/lib/modules/\_\_LINUX\_VERSION\_\_/kernel/drivers/vmm/emits\_event.ko
insmod /lib/modules/\_\_LINUX\_VERSION\_\_/kernel/drivers/vmm/poke.ko \#
&lt;-- add this line ... }}}

5.  Run the build-rootfs tool, then make

{{{ cd projects/vm/linux/ ./build-rootfs cd ../../.. make }}}

6.  Run the app:

{{{ Welcome to Buildroot buildroot login: root Password: \# grep poke
/proc/devices \# figure out the major number of our driver 244 poke \#
mknod /dev/poke c 244 0 \# create the special file \# echo &gt;
/dev/poke \# write to the file \[ 57.389643\] hi -sh: write error: Bad
address \# the shell complains, but our module is being invoked! }}}

'''Now let's make it talk to the vmm'''.

7.  In projects/vm/linux/modules/poke/poke.c, replace ' printk("hin");'
    with 'kvm\_hypercall1(4, 0);'

The choice of 4 is because 0..3 are taken by other hypercalls.

8.  Now register a handler for this hypercall in
    \`projects/vm/components/Init/src/main.c\`:

Add a new function at the top of the file:

{{{ static int poke\_handler(vmm\_vcpu\_t \*vmm\_vcpu) {
printf("POKE!!!n"); return 0; } }}}

In the function main\_continued register \`poke\_handler\`:

{{{

:   reg\_new\_handler(&vmm, poke\_handler, 4); // &lt;--- added

    /\* Now go run the event loop \*/ vmm\_run(&vmm);

}}}

9.  Finally re-run build-rootfs, make, and run:

{{{ Welcome to Buildroot buildroot login: root Password: \# mknod
/dev/poke c 244 0 \# echo &gt; /dev/poke POKE!!! }}}

## Cross VM Connectors


It's possible to connect processes in the guest linux to regular CAmkES
components. This is done with the addition of 3 kernel modules to the
guest linux, that allow device files to be created that correspond to
CAmkES connections. Depending on the type of connection, there are some
file operations defined for these files that can be used to communicate
with the other end of the connection.

The kernel modules are included in the root filesystem by default:

:   -   dataport: facilitates setting up shared memory between the guest
        and CAmkES components
    -   consumes\_event: allows a process in the guest to wait or poll
        for an event sent by a CAmkES component
    -   emits\_event: allows a process to emit an event to a CAmkES
        component

There is a library in projects/vm/linux/lib\_src/camkes containing some
linux syscall wrappers, and some utility programs in
projects/vm/linux/pkg/{dataport,consumes\_event,emits\_event} which
initialize and interact with cross vm connections.

### Implementation Details


#### Dataports


In order for linux to use a dataport, it must first be initialized. To
initialize a dataport, a linux process makes a particular ioctl call on
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
address space by calling mmap on the file associated with the dataport.

#### Emitting Events


A guest process emits an event by making ioctl call on the file
associated with the event interface. This results in the emits\_event
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
consumes\_event kernel module, and then injects an interrupt into the
guest. The consumes\_event kernel module is registered to handle this
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
apps/cma34cr\_minimal/cma34cr.camkes, adding the following interfaces to
the Init0 component definition: {{{ component Init0 { VM\_INIT\_DEF()

> // Add the following four lines: dataport Buf(4096) data; emits
> DoPrint do\_print; consumes DonePrinting done\_printing; has mutex
> cross\_vm\_event\_mutex;

}
=

These interfaces will eventually be made visible to processes running in
the guest linux. The mutex is used to protect access to shared state
between the VMM and guest.

Now, we'll define the print server component. Add the following to
apps/cma34cr\_minimal/cma34cr.camkes: {{{ component PrintServer {
control; dataport Buf(4096) data; consumes DoPrint do\_print; emits
DonePrinting done\_printing; } }}}

We'll get around to actually implementing this soon. First, let's
instantiate the print server and connect it to the VMM. Add the
following to the composition section in
apps/cma34cr\_minimal/cma34cr.camkes: {{{ component VM {

> composition {
>
> :   VM\_COMPOSITION\_DEF() VM\_PER\_VM\_COMP\_DEF(0)
>
>     // Add the following component and connections: component
>     PrintServer print\_server; connection seL4Notification
>     conn\_do\_print(from vm0.do\_print, to print\_server.do\_print);
>     connection seL4Notification conn\_done\_printing(from
>     print\_server.done\_printing, to vm0.done\_printing);
>
>     connection seL4SharedDataWithCaps conn\_data(from print\_server.data,
>
>     :   to vm0.data);
>
> }

...
===

The only thing unusual about that was the \[\[seL4SharedDataWithCaps\]\]
connector. This is a dataport connector much like seL4SharedData. The
only difference is that the "to" side of the connection gets access to
the caps to the frames backing the dataport. This is necessary from
cross vm dataports, as the VMM must be able to establish shared memory
at runtime, by inserting new mappings into the guest's address space,
which requires caps to the physical memory being mapped in.

Interfaces connected with \[\[seL4SharedDataWithCaps\]\] must be
configured with an integer specifying the id of the dataport, and the
size of the dataport. Add the following to the configuration section in
apps/cma34cr\_minimal/cma34cr.camkes: {{{ configuration {
VM\_CONFIGURATION\_DEF() VM\_PER\_VM\_CONFIG\_DEF(0, 2)

> vm0.simple\_untyped24\_pool = 12; vm0.heap\_size = 0x10000;
> vm0.guest\_ram\_mb = 128; vm0.kernel\_cmdline = VM\_GUEST\_CMDLINE;
> vm0.kernel\_image = KERNEL\_IMAGE; vm0.kernel\_relocs = KERNEL\_IMAGE;
> vm0.initrd\_image = ROOTFS; vm0.iospace\_domain = 0x0f;
>
> // Add the following 2 lines: vm0.data\_id = 1; // ids must be
> contiguous, starting from 1 vm0.data\_size = 4096;

> }

}}}

Now let's implement our print server. Create a file
apps/cma34cr\_minimal/print\_server.c: {{{ \#include &lt;camkes.h&gt;
\#include &lt;stdio.h&gt;

int run(void) {

> while (1) {
>
> :   do\_print\_wait();
>
>     printf("%sn", (char\*)data);
>
>     done\_printing\_emit();
>
> }
>
> return 0;

}
=

This component loops forever, waiting for an event, printing a string
from shared memory, then emitting an event. It assumes that the shared
buffer will contain a valid, null-terminated c string. Obviously this is
risky, but will serve for our example here.

We need to create another c file that tells the VMM about our cross vm connections. This file must define 3 functions which initialize each type of cross vm interface:

:   -   cross\_vm\_dataports\_init
    -   cross\_vm\_emits\_events\_init
    -   cross\_vm\_consumes\_events\_init

Create a file apps/cma34cr\_minimal/cross\_vm.c: {{{ \#include
&lt;sel4/sel4.h&gt; \#include &lt;camkes.h&gt; \#include
&lt;camkes\_mutex.h&gt; \#include &lt;camkes\_consumes\_event.h&gt;
\#include &lt;camkes\_emits\_event.h&gt; \#include
&lt;dataport\_caps.h&gt; \#include &lt;cross\_vm\_consumes\_event.h&gt;
\#include &lt;cross\_vm\_emits\_event.h&gt; \#include
&lt;cross\_vm\_dataport.h&gt; \#include &lt;vmm/vmm.h&gt; \#include
&lt;vspace/vspace.h&gt;

// this is defined in the dataport's glue code extern
dataport\_caps\_handle\_t data\_handle;

// Array of dataport handles at positions corresponding to handle ids
from spec static dataport\_caps\_handle\_t \*dataports\[\] = { NULL, //
entry 0 is NULL so ids correspond with indices &data\_handle, };

// Array of consumed event callbacks and ids static
camkes\_consumes\_event\_t consumed\_events\[\] = { { .id = 1,
.reg\_callback = done\_printing\_reg\_callback }, };

// Array of emitted event emit functions static camkes\_emit\_fn
emitted\_events\[\] = { NULL, // entry 0 is NULL so ids correspond with
indices do\_print\_emit, };

// mutex to protect shared event context static camkes\_mutex\_t
cross\_vm\_event\_mutex = (camkes\_mutex\_t) { .lock =
cross\_vm\_event\_mutex\_lock, .unlock =
cross\_vm\_event\_mutex\_unlock, };

int cross\_vm\_dataports\_init(vmm\_t \*vmm) {

:   return cross\_vm\_dataports\_init\_common(vmm, dataports,
    sizeof(dataports)/sizeof(dataports\[0\]));

}

int cross\_vm\_emits\_events\_init(vmm\_t \*vmm) {

:   

    return cross\_vm\_emits\_events\_init\_common(vmm, emitted\_events,

    :   sizeof(emitted\_events)/sizeof(emitted\_events\[0\]));

}

int cross\_vm\_consumes\_events\_init(vmm\_t *vmm, vspace\_t*vspace, seL4\_Word irq\_badge) {

:   

    return cross\_vm\_consumes\_events\_init\_common(vmm, vspace, &cross\_vm\_event\_mutex,

    :   consumed\_events,
        sizeof(consumed\_events)/sizeof(consumed\_events\[0\]),
        irq\_badge);

}
=

To make this build, we need to symlink the common source directory for
the camkes vm into the app's directory: {{{ ln -s ../../common
apps/cma34cr\_minimal }}}

And make the following change to apps/cma34cr\_minimal/Makefile: {{{ ...
include PCIConfigIO/PCIConfigIO.mk include FileServer/FileServer.mk
include Init/Init.mk

\# Add the following: Init0\_CFILES += \$(wildcard
\$(SOURCE\_DIR)/cross\_vm.c)
 \$(wildcard \$(SOURCE\_DIR)/common/src/*.c) Init0\_HFILES +=
\$(wildcard \$(SOURCE\_DIR)/common/include/*.h)
 \$(wildcard
\$(SOURCE\_DIR)/common/shared\_include/cross\_vm\_shared/\*.h)

PrintServer\_CFILES += \$(SOURCE\_DIR)/print\_server.c ... }}}

The app should now build when you run "make", but we're not done yet. No
we'll make these interfaces available to the guest linux. Edit
projects/vm/linux/camkes\_init. It's a shell script that is executed as
linux is initialized. Currently it should look like: {{{ \#!/bin/sh \#
Initialises linux-side of cross vm connections.

\# Dataport sizes must match those in the camkes spec. \# For each
argument to dataport\_init, the nth pair \# corresponds to the dataport
with id n. dataport\_init /dev/camkes\_reverse\_src 8192
/dev/camkes\_reverse\_dest 8192

\# The nth argument to event\_init corresponds to the \# event with id n
according to the camkes vmm. consumes\_event\_init
/dev/camkes\_reverse\_done emits\_event\_init
/dev/camkes\_reverse\_ready }}}

This sets up some interfaces used for a simple demo. Delete all that,
and add the following: {{{ \#!/bin/sh \# Initialises linux-side of cross
vm connections.

\# Dataport sizes must match those in the camkes spec. \# For each
argument to dataport\_init, the nth pair \# corresponds to the dataport
with id n. dataport\_init /dev/camkes\_data 4096

\# The nth argument to event\_init corresponds to the \# event with id n
according to the camkes vmm. consumes\_event\_init
/dev/camkes\_done\_printing emits\_event\_init /dev/camkes\_do\_print
}}}

Each of these commands creates device nodes associated with a particular
linux kernel module supporting cross vm communication. Each command
takes a list of device nodes to create, which must correpond to the ids
assigned to interfaces in the cma34cr.camkes and cross\_vm.c. The
dataport\_init command must also be passed the size of each dataport.

These changes will cause device nodes to be created which correspond to
the interfaces we added to the VMM component.

Now let's make an app that uses these nodes to communicate with the
print server. As before, create a new directory in pkg: {{{ mkdir
projects/vm/linux/pkg/print\_client }}}

Create projects/vm/linux/pkg/print\_client/print\_client.c: {{{
\#include &lt;string.h&gt; \#include &lt;assert.h&gt;

\#include &lt;sys/types.h&gt; \#include &lt;sys/stat.h&gt; \#include
&lt;sys/mman.h&gt; \#include &lt;fcntl.h&gt;

\#include "dataport.h" \#include "consumes\_event.h" \#include
"emits\_event.h"

int main(int argc, char \*argv\[\]) {

> int data\_fd = open("/dev/camkes\_data", O\_RDWR); assert(data\_fd
> &gt;= 0);
>
> int do\_print\_fd = open("/dev/camkes\_do\_print", O\_RDWR);
> assert(do\_print\_fd &gt;= 0);
>
> int done\_printing\_fd = open("/dev/camkes\_done\_printing", O\_RDWR);
> assert(done\_printing\_fd &gt;= 0);
>
> char *data = (char*)dataport\_mmap(data\_fd); assert(data !=
> MAP\_FAILED);
>
> ssize\_t dataport\_size = dataport\_get\_size(data\_fd);
> assert(dataport\_size &gt; 0);
>
> for (int i = 1; i &lt; argc; i++) {
>
> :   strncpy(data, argv\[i\], dataport\_size);
>     emits\_event\_emit(do\_print\_fd);
>     consumes\_event\_wait(done\_printing\_fd);
>
> }
>
> close(data\_fd); close(do\_print\_fd); close(done\_printing\_fd);
>
> return 0;

}
=

This program prints each of its arguments on a separate line, by sending
each argument to the print server one at a time.

Create projects/vm/linux/pkg/print\_client/Makefile: {{{ TARGET =
print\_client

include ../../common.mk include ../../common\_app.mk

print\_client: print\_client.o

:   \$(CC) \$(CFLAGS) \$(LDFLAGS) \$\^ -lcamkes -o \$@

}}}

Now, run build-rootfs, and make, and run! {{{ ... Creating dataport node
/dev/camkes\_data Allocating 4096 bytes for /dev/camkes\_data Creating
consuming event node /dev/camkes\_done\_printing Creating emitting event
node /dev/camkes\_do\_print

Welcome to Buildroot buildroot login: root Password: \# print\_client
hello world \[ 12.730073\] dataport received mmap for minor 1 hello
world }}}

## Booting from hard drive


These instructions are for ubuntu. For CentOS instructions, see
\[\[CAmkESVMCentOS\]\].

So far we've only run a tiny linux on a ram disk. What if we want to run
Ubuntu booting off a hard drive? This section will explain the changes
we need to make to our VM app to allow it to boot into a Ubuntu
environment installed on the hard drive. Thus far these examples should
have been compatible with most modern x86 machines. The rest of this
tutorial will focus on a particular machine:
\[\[<https://www.rtd.com/PC104/CM/CMA34CR/CMA34CR.htm%7Cthe> cma34cr
single board computer\]\]

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
run the following command: {{{ \$ mkinitramfs -o rootfs.cpio 4.8.16
WARNING: missing /lib/modules/4.8.16 Ensure all necessary drivers are
built into the linux image! depmod: ERROR: could not open directory
/lib/modules/4.8.16: No such file or directory depmod: FATAL: could not
search modules: No such file or directory depmod: WARNING: could not
open /var/tmp/mkinitramfs\_H9SRHb/lib/modules/4.8.16/modules.order: No
such file or directory depmod: WARNING: could not open
/var/tmp/mkinitramfs\_H9SRHb/lib/modules/4.8.16/modules.builtin: No such
file or directory }}}

The kernel we'll be using has all the necessary drivers built in, so
feel free to ignore those warnings and errors. You should now have a
file called rootfs.cpio on the cma34cr. Transfer that file to your dev
machine, and put it in apps/cma34cr\_minimal. Now we need to tell the
build system to take that rootfs image rather than the default buildroot
one. Edit apps/cma34cr\_minimal/Makefile. Change this line: {{{
\${STAGE\_DIR}/\${ROOTFS\_FILENAME}:
\${SOURCE\_DIR}/linux/\${ROOTFS\_FILENAME} }}} to {{{
\${STAGE\_DIR}/\${ROOTFS\_FILENAME}:
\${SOURCE\_DIR}/\${ROOTFS\_FILENAME} }}}

Since we'll be using a real hard drive, we need to change the boot
command line we give to the guest linux. Open
apps/cma34cr\_minimal/configurations/cma34cr\_minimal.h, and change the
definition of VM\_GUEST\_CMDLINE to: {{{ \#define VM\_GUEST\_CMDLINE
"earlyprintk=ttyS0,115200 console=ttyS0,115200 i8042.nokbd=y
i8042.nomux=y i8042.noaux=y io\_delay=udelay noisapnp pci=nomsi debug
root=/dev/sda1 rdinit=/init 2" }}}

Try building and running after this change: {{{ BusyBox v1.22.1 (Ubuntu
1:1.22.0-15ubuntu1) built-in shell (ash) Enter 'help' for a list of
built-in commands.

(initramfs) }}}

You should get dropped into a shell inside the root filesystem. You can
run commands from here: {{{ (initramfs) pwd / (initramfs) ls dev run
init scripts var usr sys tmp root sbin etc bin lib conf proc }}}

If you look inside /dev, you'll notice the lack of sda device. Linux
can't find the hard drive because we haven't passed it through yet.
Let's do that now!

We're going to give the guest passthrough access to the sata controller.
The sata controller will be in one of two modes: AHCI or IDE. The mode
can be set when configuring BIOS. By default it should be AHCI. The next
part has some minor differences depending on the mode. I'll show both.
Open apps/cma34cr\_minimal/cma34cr.camkes and add the following to the
configuration section:

For AHCI:

{{{

:   

    configuration {

    :   ...

        vm0\_config.pci\_devices\_iospace = 1;

        vm0\_config.ioports = \[

        :   {"start":0x4088, "end":0x4090, "pci\_device":0x1f,
            "name":"SATA"}, {"start":0x4094, "end":0x4098,
            "pci\_device":0x1f, "name":"SATA"}, {"start":0x4080,
            "end":0x4088, "pci\_device":0x1f, "name":"SATA"},
            {"start":0x4060, "end":0x4080, "pci\_device":0x1f,
            "name":"SATA"},

        \];

        vm0\_config.pci\_devices = \[

        :   

            {

            :   "name":"SATA", "bus":0, "dev":0x1f, "fun":2,
                "irq":"SATA", "memory":\[ {"paddr":0xc0713000,
                "size":0x800, "page\_bits":12}, \],

            },

        \];

        vm0\_config.irqs = \[

        :   {"name":"SATA", "source":19, "level\_trig":1,
            "active\_low":1, "dest":11},

        \];

    }

}}}

For IDE:

{{{

:   

    configuration {

    :   ...

        vm0\_config.pci\_devices\_iospace = 1

        vm0\_config.ioports = \[

        :   {"start":0x4080, "end":0x4090, "pci\_device":0x1f,
            "name":"SATA"}, {"start":0x4090, "end":0x40a0,
            "pci\_device":0x1f, "name":"SATA"}, {"start":0x40b0,
            "end":0x40b8, "pci\_device":0x1f, "name":"SATA"},
            {"start":0x40b8, "end":0x40c0, "pci\_device":0x1f,
            "name":"SATA"}, {"start":0x40c8, "end":0x40cc,
            "pci\_device":0x1f, "name":"SATA"}, {"start":0x40cc,
            "end":0x40d0, "pci\_device":0x1f, "name":"SATA"},

        \];

        vm0\_config.pci\_devices = \[

        :   

            {

            :   "name":"SATA", "bus":0, "dev":0x1f, "fun":2,
                "irq":"SATA", "memory":\[\],

            },

        \];

        vm0\_config.irqs = \[

        :   {"name":"SATA", "source":19, "level\_trig":1,
            "active\_low":1, "dest":11},

        \];

    }

}}}

Now rebuild and run: {{{ Ubuntu 16.04.1 LTS ertos-CMA34CR ttyS0

ertos-CMA34CR login: }}}

You should be able to log in and use the system largely as normal.

## Passthrough Ethernet


The ethernet device is not accessible to the guest: {{{ \$ ip addr 1:
lo: &lt;LOOPBACK,UP,LOWER\_UP&gt; mtu 65536 qdisc noqueue state UNKNOWN
group default qlen 1 link/loopback 00:00:00:00:00:00 brd
00:00:00:00:00:00 inet 127.0.0.1/8 scope host lo valid\_lft forever
preferred\_lft forever inet6 ::1/128 scope host valid\_lft forever
preferred\_lft forever 2: <sit0@NONE>: &lt;NOARP&gt; mtu 1480 qdisc noop
state DOWN group default qlen 1 link/sit 0.0.0.0 brd 0.0.0.0 }}}

An easy way to give the guest network access is to give it passthrough
access to the ethernet controller. This is done much in the same way as
enabling passthrough access to the sata controller. In the configuration
section in apps/cma34cr\_minimal/cma34cr.camkes, add to the list of io
ports, pci devices and irqs to pass through: {{{ vm0\_config.ioports =
\[ {"start":0x4080, "end":0x4090, "pci\_device":0x1f, "name":"SATA"},
{"start":0x4090, "end":0x40a0, "pci\_device":0x1f, "name":"SATA"},
{"start":0x40b0, "end":0x40b8, "pci\_device":0x1f, "name":"SATA"},
{"start":0x40b8, "end":0x40c0, "pci\_device":0x1f, "name":"SATA"},
{"start":0x40c8, "end":0x40cc, "pci\_device":0x1f, "name":"SATA"},
{"start":0x40cc, "end":0x40d0, "pci\_device":0x1f, "name":"SATA"},
{"start":0x3000, "end":0x3020, "pci\_device":0, "name":"Ethernet5"}, //
&lt;--- Add this entry \];

> vm0\_config.pci\_devices = \[
>
> :   
>
>     {
>
>     :   "name":"SATA", "bus":0, "dev":0x1f, "fun":2, "irq":"SATA",
>         "memory":\[\],
>
>     },
>
>     // Add this entry: { "name":"Ethernet5", "bus":5, "dev":0,
>     "fun":0, "irq":"Ethernet5", "memory":\[ {"paddr":0xc0500000,
>     "size":0x20000, "page\_bits":12}, {"paddr":0xc0520000,
>     "size":0x4000, "page\_bits":12}, \], },
>
> \];
>
> vm0\_config.irqs = \[
>
> :   {"name":"SATA", "source":19, "level\_trig":1, "active\_low":1,
>     "dest":11}, {"name":"Ethernet5", "source":0x11, "level\_trig":1,
>     "active\_low":1, "dest":10}, // &lt;--- Add this entry
>
> \];

}}}

You should have added a new entry to each of the three lists that
describe passthrough devices. Building and running: {{{ \$ ip addr 1:
lo: &lt;LOOPBACK,UP,LOWER\_UP&gt; mtu 65536 qdisc noqueue state UNKNOWN
group default qlen 1 link/loopback 00:00:00:00:00:00 brd
00:00:00:00:00:00 inet 127.0.0.1/8 scope host lo valid\_lft forever
preferred\_lft forever inet6 ::1/128 scope host valid\_lft forever
preferred\_lft forever 2: enp0s2:
&lt;BROADCAST,MULTICAST,UP,LOWER\_UP&gt; mtu 1500 qdisc pfifo\_fast
state UP group default qlen 1000 link/ether 00:d0:81:09:0c:7d brd
ff:ff:ff:ff:ff:ff inet 10.13.1.87/23 brd 10.13.1.255 scope global
dynamic enp0s2 valid\_lft 14378sec preferred\_lft 14378sec inet6
2402:1800:4000:1:90b3:f9d:ae22:33b7/64 scope global temporary dynamic
valid\_lft 86390sec preferred\_lft 14390sec inet6
2402:1800:4000:1:aa67:5925:2cbc:928f/64 scope global mngtmpaddr
noprefixroute dynamic valid\_lft 86390sec preferred\_lft 14390sec inet6
fe80::cc47:129d:bdff:a2da/64 scope link valid\_lft forever
preferred\_lft forever 3: <sit0@NONE>: &lt;NOARP&gt; mtu 1480 qdisc noop
state DOWN group default qlen 1 link/sit 0.0.0.0 brd 0.0.0.0 \$ ping
google.com PING google.com (172.217.25.142) 56(84) bytes of data. 64
bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp\_seq=1
ttl=51 time=2.17 ms 64 bytes from syd15s03-in-f14.1e100.net
(172.217.25.142): icmp\_seq=2 ttl=51 time=1.95 ms 64 bytes from
syd15s03-in-f14.1e100.net (172.217.25.142): icmp\_seq=3 ttl=51 time=1.99
ms 64 bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp\_seq=4
ttl=51 time=2.20 ms }}}

## Figuring out information about PCI devices


To add a new passthrough device, or access a pci device in general, we
need to know which io ports it uses, which interrupts it's associated
with, and the physical addresses of any memory-mapped io regions it
uses. The easiest way to find this information is to boot linux
natively, and run the command lspci -vv.
