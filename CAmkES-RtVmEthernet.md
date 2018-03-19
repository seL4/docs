# Case Study: Building an app with a vm, a native ethernet driver, on the RT kernel, with CAmkES


This is a log of what I had to do to implement a CAmkES application with
a vm and a native ethernet driver on the RT kernel. It should serve as a
guide to others on how to approach the task of making a new CAmkES app,
and how to debug and resolve problems that come up when working with
CAmkES. This isn't a tutorial. Things will break and I'll show how I fix
them, but as I'm working off the tip of repos, some of which are
internal forks that aren't publicly accessible, readers probably won't
be able to reproduce what I show here. That said, it should serve to
demonstrate a realistic workflow of building an app on seL4.

## Starting Out


When possible, I don't start apps from scratch. The most similar project
to what I want to make is the CAmkES x86 VM, so let's start with that:
```
repo init -u ssh://bitbucket.keg.ertos.in.nicta.com.au:7999/seL4/camkes-vm-manifest && repo sync -j8
```

The camkes vm actually contains several apps and build configs. The
simplest one is x64_optiplex9020_onevm_defconfig. Since we just
grabbed the tip of the master branches of all the projects that make up
camkes, there's a chance that something is currently broken. Let's make
sure it all works before changing anything.
```
make x64_optiplex9020_onevm_defconfig
make
mq-run
...
Welcome to Buildroot
buildroot login:
```

Note that despite the config's name, it actually starts 2 vms.

Also note the mq-run script. It's a wrapper around the machine queue
script that automates common cases. Everyone should use it! Get it here:
http://bitbucket.keg.ertos.in.nicta.com.au/users/adanis/repos/mq-run/browse

Ok we have a working system, so now let's make some changes!

## Real-Time Kernel


So far we've been using the master branch of the kernel. The most
daunting part of making this app will be switching to the RT kernel,
which has a different api from the master kernel, and hoping the world
doesn't break.

Oh, and we won't be using the **actual** rt branch, but a bleeding
edge variant of Anna's fork of seL4.
```
cd kernel
git remote add alyons
ssh://git@bitbucket.keg.ertos.in.nicta.com.au:7999/~alyons/seL4.git
git fetch alyons
git checkout phd
cd ..
```

We also need to update seL4_libs.
```
cd projects/seL4_libs
git remote add alyons ssh://git@bitbucket.keg.ertos.in.nicta.com.au:7999/~alyons/seL4_libs.git
git fetch alyons
git checkout phd
cd ../..
```

That changed lots of stuff, so let's remove everything we've built so
far: 
```
make mrproper
make x64_optiplex9020_onevm_defconfig
```

And try building...
```
$ make                                                                                                                                               12:12:45
[KERNEL]
 [BF_GEN] arch/object/structures_gen.h
 [BF_GEN] plat/64/plat_mode/machine/hardware_gen.h
 [BF_GEN] 64/mode/api/shared_types_gen.h
 [CPP] src/arch/x86/64/machine_asm.s_pp
 [AS] src/arch/x86/64/machine_asm.o
 [CPP] src/arch/x86/64/traps.s_pp
 [AS] src/arch/x86/64/traps.o
 [CPP] src/arch/x86/64/head.s_pp
 [AS] src/arch/x86/64/head.o
 [CPP] src/arch/x86/multiboot.s_pp
 [AS] src/arch/x86/multiboot.o
 [CPP_GEN] kernel_all.c
 [CPP] kernel_all.c_pp
 [Circular includes] kernel_all.c_pp
 [CP] kernel_final.c
 [CC] kernel_final.s
/home/ssteve/src/camkes-rt-vm-ethernet/kernel/src/object/notification.c: In function ‘sendSignal’:
/home/ssteve/src/camkes-rt-vm-ethernet/kernel/src/object/notification.c:94:45: error: ‘thread’ undeclared (first use in this function)
                     maybeDonateSchedContext(thread, ntfnPtr);
```

Easy fix. The "thread" variable was renamed to "tcb" and this instance
wasn't updated.

Try building again...
```
make
...
[apps/capdl-loader-experimental] building...
 [HEADERS]
 [STAGE] debug.h
 [STAGE] capdl_spec.h
 [STAGE] capdl.h
 [STAGE] autoconf.h
 [GEN] capdl_spec.c
 [CPIO] archive.o
  [CPIO] vm.fserv_group_bin
  [CPIO] vm_group_bin
  [CPIO] vm.rtc_group_bin
  [CPIO] vm.vm0_group_bin
  [CPIO] vm.vm1_group_bin
  [CPIO] vm.time_server_group_bin
  [CPIO] vm.serial_group_bin
  [CPIO] vm.string_reverse_group_bin
  [CPIO] vm.pci_config_group_bin
 [CC] src/main.o
/home/ssteve/src/camkes-rt-vm-ethernet/apps/capdl-loader-experimental/src/main.c: In function ‘init_sc’:
/home/ssteve/src/camkes-rt-vm-ethernet/apps/capdl-loader-experimental/src/main.c:1002:17: error: too few arguments to function ‘seL4_SchedControl_Configure’
     int error = seL4_SchedControl_Configure(bi->schedcontrol.start + bi->nodeID,
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/sel4/sel4.h:22:0,
                 from /home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/vka/vka.h:16,
                 from /home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/vka/object.h:15,
                 from /home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/vspace/vspace.h:16,
                 from /home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/sel4platsupport/platsupport.h:14,
                 from /home/ssteve/src/camkes-rt-vm-ethernet/apps/capdl-loader-experimental/src/main.c:21:
/home/ssteve/src/camkes-rt-vm-ethernet/stage/x86/pc99/include/interfaces/sel4_client.h:3527:1: note: declared here
 seL4_SchedControl_Configure(seL4_SchedControl _service, seL4_SchedContext schedcontext, seL4_Time budget, seL4_Time period, seL4_Word max_refills, seL4_Word badge)
 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
... # more lines of errors
```

Lots of errors. What went wrong?

CAmkES uses a program called the capdl-loader as its root task, and that
failed to compile. Fortunately, this is the final step of building, so
the rest of the system build fine. The specific error suggests the
kernel api is different from what the capdl loader suggests, so let's
fix the capdl loader.

## Fixing the Capdl Loader

