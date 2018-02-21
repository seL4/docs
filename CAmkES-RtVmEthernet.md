= Case Study: Building an app with a vm, a native ethernet driver, on
the RT kernel, with CAmkES =

This is a log of what I had to do to implement a CAmkES application with
a vm and a native ethernet driver on the RT kernel. It should serve as a
guide to others on how to approach the task of making a new CAmkES app,
and how to debug and resolve problems that come up when working with
CAmkES. This isn't a tutorial. Things will break and I'll show how I fix
them, but as I'm working off the tip of repos, some of which are
internal forks that aren't publicly accessible, readers probably won't
be able to reproduce what I show here. That said, it should serve to
demonstrate a realistic workflow of building an app on seL4.

== Starting Out ==

When possible, I don't start apps from scratch. The most similar project
to what I want to make is the CAmkES x86 VM, so let's start with that:

{{{ repo init -u
<ssh://bitbucket.keg.ertos.in.nicta.com.au:7999/seL4/camkes-vm-manifest>
&& repo sync -j8 }}}

The camkes vm actually contains several apps and build configs. The
simplest one is x64\_optiplex9020\_onevm\_defconfig. Since we just
grabbed the tip of the master branches of all the projects that make up
camkes, there's a chance that something is currently broken. Let's make
sure it all works before changing anything. {{{ make
x64\_optiplex9020\_onevm\_defconfig make mq-run ... Welcome to Buildroot
buildroot login: }}}

Note that despite the config's name, it actually starts 2 vms.

Also note the mq-run script. It's a wrapper around the machine queue
script that automates common cases. Everyone should use it! Get it here:
<http://bitbucket.keg.ertos.in.nicta.com.au/users/adanis/repos/mq-run/browse>

Ok we have a working system, so now let's make some changes!

== Real-Time Kernel ==

So far we've been using the master branch of the kernel. The most
daunting part of making this app will be switching to the RT kernel,
which has a different api from the master kernel, and hoping the world
doesn't break.

Oh, and we won't be using the '''actual''' rt branch, but a bleeding
edge variant of Anna's fork of seL4.

{{{ cd kernel git remote add alyons
<ssh://git@bitbucket.keg.ertos.in.nicta.com.au:7999/~alyons/seL4.git>
git fetch alyons git checkout phd cd .. }}}

We also need to update seL4\_libs.

{{{ cd projects/seL4\_libs git remote add alyons
<ssh://git@bitbucket.keg.ertos.in.nicta.com.au:7999/~alyons/seL4_libs.git>
git fetch alyons git checkout phd cd ../.. }}}

That changed lots of stuff, so let's remove everything we've built so
far: {{{ make mrproper make x64\_optiplex9020\_onevm\_defconfig }}}

And try building... {{{ \$ make 12:12:45 \[KERNEL\] \[BF\_GEN\]
arch/object/structures\_gen.h \[BF\_GEN\]
plat/64/plat\_mode/machine/hardware\_gen.h \[BF\_GEN\]
64/mode/api/shared\_types\_gen.h \[CPP\]
src/arch/x86/64/machine\_asm.s\_pp \[AS\] src/arch/x86/64/machine\_asm.o
\[CPP\] src/arch/x86/64/traps.s\_pp \[AS\] src/arch/x86/64/traps.o
\[CPP\] src/arch/x86/64/head.s\_pp \[AS\] src/arch/x86/64/head.o \[CPP\]
src/arch/x86/multiboot.s\_pp \[AS\] src/arch/x86/multiboot.o
\[CPP\_GEN\] kernel\_all.c \[CPP\] kernel\_all.c\_pp \[Circular
includes\] kernel\_all.c\_pp \[CP\] kernel\_final.c \[CC\]
kernel\_final.s
/home/ssteve/src/camkes-rt-vm-ethernet/kernel/src/object/notification.c:
In function ‘sendSignal’:
/home/ssteve/src/camkes-rt-vm-ethernet/kernel/src/object/notification.c:94:45:
error: ‘thread’ undeclared (first use in this function)
maybeDonateSchedContext(thread, ntfnPtr); }}}

Easy fix. The "thread" variable was renamed to "tcb" and this instance
wasn't updated.

Try building again... {{{ make ... \[apps/capdl-loader-experimental\]
building... \[HEADERS\] \[STAGE\] debug.h \[STAGE\] capdl\_spec.h
\[STAGE\] capdl.h \[STAGE\] autoconf.h \[GEN\] capdl\_spec.c \[CPIO\]
archive.o \[CPIO\] vm.fserv\_group\_bin \[CPIO\] vm\_group\_bin \[CPIO\]
vm.rtc\_group\_bin \[CPIO\] vm.vm0\_group\_bin \[CPIO\]
vm.vm1\_group\_bin \[CPIO\] vm.time\_server\_group\_bin \[CPIO\]
vm.serial\_group\_bin \[CPIO\] vm.string\_reverse\_group\_bin \[CPIO\]
vm.pci\_config\_group\_bin \[CC\] src/main.o
/home/ssteve/src/camkes-rt-vm-ethernet/apps/capdl-loader-experimental/src/main.c:
In function ‘init\_sc’:
/home/ssteve/src/camkes-rt-vm-ethernet/apps/capdl-loader-experimental/src/main.c:1002:17:
error: too few arguments to function ‘seL4\_SchedControl\_Configure’ int
error = seL4\_SchedControl\_Configure(bi-&gt;schedcontrol.start +
bi-&gt;nodeID, \^\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~ In
file included from
/home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/sel4/sel4.h:22:0,
from
/home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/vka/vka.h:16,
from
/home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/vka/object.h:15,
from
/home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/vspace/vspace.h:16,
from
/home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/sel4platsupport/platsupport.h:14,
from
/home/ssteve/src/camkes-rt-vm-ethernet/apps/capdl-loader-experimental/src/main.c:21:
/home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/interfaces/sel4\_client.h:3527:1:
note: declared here seL4\_SchedControl\_Configure(seL4\_SchedControl
\_service, seL4\_SchedContext schedcontext, seL4\_Time budget,
seL4\_Time period, seL4\_Word max\_refills, seL4\_Word badge)
\^\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~\~ ... \# more lines
of errors }}}

Lots of errors. What went wrong?

CAmkES uses a program called the capdl-loader as its root task, and that
failed to compile. Fortunately, this is the final step of building, so
the rest of the system build fine. The specific error suggests the
kernel api is different from what the capdl loader suggests, so let's
fix the capdl loader.

== Fixing the Capdl Loader ==
