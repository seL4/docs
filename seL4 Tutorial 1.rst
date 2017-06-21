##master-page:HelpTemplate
##master-date:Unknown-Date
#format wiki
#language en
= Summary: =
This tutorial is a fairly simple introduction to debugging, and doesn't really focus on seL4 itself, but rather on the idea and practice of tracing errors and debugging in a [[http://www.embedded.com/electronics-blogs/programming-pointers/4027541/Freestanding-vs-hosted-implementations|freestanding]] environment.

== Learning outcomes: ==

 * Reader should become accustomed to the idea of having to debug not only from the perspective of their own code, but also with an understanding that there are lower layers beneath them that have a say in whether or their abstractions will work as intended.
 * Reader should become accustomed to the idea that the compiler and language runtime are now part of their responsibility, and they should become at least trivially acquainted with the C runtime which they can usually ignore, and debug with it in mind.
 * Offhandedly hints to the reader that they should become acquainted with the Kconfig/Kbuild build utilities.

== Walkthrough ==

First try to build the code:

{{{
# select the config for the first tutorial 
make ia32_hello-1_defconfig
# build it
make -j8
}}}

This will fail to build with the following error:
{{{
/home/alyons/sel4-tutorials-source/stage/x86/pc99/lib/crt1.o: In function `_start_c':
/home/alyons/sel4-tutorials-source/libs/libmuslc/crt/crt1.c:17: undefined reference to `main'
collect2: error: ld returned 1 exit status
/home/alyons/sel4-tutorials-source/stage/x86/pc99/common/common.mk:301: recipe for target 'hello-1.elf' failed
make[1]: *** [hello-1.elf] Error 1
tools/common/project.mk:332: recipe for target 'hello-1' failed
make: *** [hello-1] Error 2
}}}

=== TASK 1: ===

Your task is to fix the above error. Look for `TASK` in `apps/hello1` to find the code to modify.

Regardless of the programming language used, every binary that is created must have an entry point, which is the first instruction in the program. In the C Runtime, this is usually `_start()`, which then calls some other compiler-specific and platform specific functions to initialize the program's environment, before calling the `main()` function. What you see here is the linker complaining that when `_start()` tried to call `main()`, it couldn't find a `main()` function, because one doesn't exist. Create a `main()` function, and proceed to the next step in the slides.

This next step is meant to show the user some basics for how to go about debugging in a freestanding environment. Most of the time you'll have to manually step through code, often without the help of a debugger, so this step forces a `Divide by zero` exception and tries to show you how debugging an exception looks. In the real world, in this kind of scenario, you'd usually want to know the instruction that triggered the exception, then find out what that instruction does that is wrong, and fix it.

Once you have fixed the problem, the build should succeed and you can run the example as follows:
{{{ 
$ make -j8
$ make simulate
}}}
If you've succeeded, qemu should output:
{{{
Starting node #0 with APIC ID 0
Booting all finished, dropped to user space
hello world
}}}
