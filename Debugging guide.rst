= Whole system debugging =

== Qemu ==

[[http://www.qemu.org/|Qemu]] is a simulator that provides software emulation of a hardware platform. It is useful for developing and debugging embedded software when you do not have access to the target platform. Even if you do have the target hardware, Qemu can shorten your edit-compile-debug cycle. Be aware that it is not cycle-accurate and cannot emulate every device, so sometimes you have no alternative than to debug on real hardware.

There are two main Qemu binaries that are relevant for seL4 development:

 * qemu-system-arm - qemu for ARM
 * qemu-system-i386 - qemu for x86

After compiling a seL4 project, you can use one of these to simulate execution of the resulting binaries. For example, after compiling sel4test for the KZM (IMX31) board:

{{{
$ qemu-system-arm -M kzm -nographic -kernel images/sel4test-driver-image-arm-imx31
}}}

On x86, kernel and userspace are provided as separate images:

{{{
$ qemu-system-i386 -m 512 -nographic -kernel images/kernel-ia32-pc99 -initrd images/sel4test-driver-image-ia32-pc99
}}}

Some seL4 projects will define Makefile targets as shorthand for these commands, so you can simply run:

{{{
$ make simulate-kzm   # Simulate KZM execution
$ make simulate-ia32  # Simulate x86 execution
}}}

When simulating a seL4 system in Qemu, you should see output that is directed to the (emulated) UART device on your terminal:

{{{
ELF-loader started on CPU: ARM Ltd. ARMv6 Part: 0xb36 r1p3
  paddr=[82000000..8225001f]
ELF-loading image 'kernel'
  paddr=[80000000..80033fff]
  vaddr=[f0000000..f0033fff]
  virt_entry=f0000000
ELF-loading image 'sel4test-driver'
  paddr=[80034000..8036efff]
  vaddr=[10000..34afff]
  virt_entry=1c880
Enabling MMU and paging
Jumping to kernel-image entry point...

Bootstrapping kernel
Switching to a safer, bigger stack...
seL4 Test
=========
...
}}}

To exit from Qemu, type the sequence Ctrl+"a", then "x". Note that you can exit at any point; you do not need to wait for the system to finish or reach some stable state. If you exit Qemu while a system is running, it will simply be terminated.

Qemu has some powerful debugging features built in. You can type Ctrl+"a", then "c" to switch to the Qemu monitor. From here you can inspect CPU or device state, read and write memory, and single-step execution. More information about this functionality is available in the [[http://qemu.weilnetz.de/qemu-doc.html#pcsys_005fmonitor|Qemu documentation]].

When debugging a seL4 project, the Qemu debugger is inherently limited. It has no understanding of your source code, so it is difficult to relate what you are seeing back to the C code you compiled. It is possible to get a richer debugging environment by connecting GDB to Qemu.

=== Using GDB with Qemu ===

[[https://www.gnu.org/s/gdb/|GDB]] is a debugger commonly used in C application development. Though not as seamless as debugging a native Linux application, it is possible to use GDB to debug within Qemu's emulated environment.

Start Qemu with the extra options "-S" (pause execution on start) and "-s" (start a GDB server on TCP port 1234):

{{{
$ qemu-system-arm -M kzm -nographic -kernel images/sel4test-driver-image-arm-imx31 -S -s
}}}

In a separate terminal window, start your target platform's version of GDB. You should either pass a binary of the seL4 kernel if you intend on debugging seL4 itself or the userspace application if you intend on debugging an application on seL4. Note that your binary needs to include debugging information ("-g" flag to GCC; "Toolchain Options" -> "Emit debugging information" in the seL4 build configuration) if you want GDB to show you C source code while debugging. In this example we're going to debug the seL4 kernel that has been built in debug mode:

{{{
$ arm-none-eabi-gdb build/kernel/kernel.elf
}}}

At the GDB prompt, enter "target remote :1234" to connect to the server Qemu is hosting:

{{{
Reading symbols from build/kernel/kernel.elf...done.
(gdb) target remote :1234
Remote debugging using :1234
0x82000000 in ?? ()
(gdb)
}}}

Suppose we want to halt when {{{kprintf}}} is called. Enter "break kprintf" at the GDB prompt:

{{{
(gdb) break kprintf
Breakpoint 1 at 0xf0011248: file kernel/src/machine/io.c, line 269.
}}}

We can now start Qemu running and wait until we hit the breakpoint. To do this, type "cont" at the GDB prompt:

{{{
(gdb) cont
Continuing.

Breakpoint 1, kprintf (format=0xf0428000 "") at kernel/src/machine/io.c:269
269     {
}}}

Note that some output has appeared in the other terminal window running Qemu as it has partially executed. It may be surprising to see that some printing somehow happened without our breakpoint triggering. The reason for this is that output we're seeing is from the ELF loader that runs prior to the kernel. GDB does not know the address of its print function (as we only gave GDB the kernel's symbol table) and it is not looking to break on its address. The breakpoint we have just hit is the first time the ''kernel'' tried to print. Similarly, the breakpoint we have configured will have no effect on userspace calls to {{{printf}}}.

Now that we are stopped at a breakpoint, all the standard GDB operations are possible (inspect registers or the stack, single-step, continue until function exit, ...). More information is available in the [[http://www.gnu.org/software/gdb/documentation/|GDB manual]].

Be warned that if you are debugging the kernel's early boot steps, something that may not be immediately obvious is that debugging across a context in which page mappings change (e.g. switching page directories or turning the MMU on/off) will confuse GDB and you may find breakpoints triggering unexpectedly or being missed.

The process we have described is similar for x86, though if you are on an x86 or x86_64 host you can simply use your platform's native GDB, {{{gdb}}}.

==== Userspace debugging ====

The steps for debugging a userspace application on seL4 are identical to the ones we have just seen, except that we pass GDB a symbol table for userspace rather than the kernel. For example, using the same sel4test environment we start Qemu in the same way but start GDB with sel4test's binary:

{{{
$ arm-none-eabi-gdb build/arm/imx31/sel4test-driver/sel4test-driver.bin
}}}

After connecting to Qemu, we can instruct GDB to break on the userspace {{{printf}}} function:

{{{
Reading symbols from build/arm/imx31/sel4test-driver/sel4test-driver.bin...done.
(gdb) target remote :1234
Remote debugging using :1234
0x82000000 in ?? ()
(gdb) break printf
Breakpoint 1 at 0x30870: file libs/libmuslc/src/stdio/printf.c, line 9.
(gdb)
}}}

Note that GDB has correctly identified the {{{printf}}} function in Musl C. We now continue as before:

{{{
(gdb) cont
Continuing.

Breakpoint 1, printf (fmt=0x363e8 "%s") at libs/libmuslc/src/stdio/printf.c:9
9               ret = vfprintf(stdout, fmt, ap);
(gdb)
}}}

If you examine the terminal window running Qemu at this point, you will note that we see an extra bit of output from the kernel. The kernel's print functionality is unaffected, but GDB has stopped execution the first time userspace called {{{printf}}}.

From here, the experience is essentially identical to debugging the kernel. One small complication to be aware of is that debugging across a context switch may be confusing. If you are single-stepping in GDB and find execution suddenly diverted to an address where code is unknown, check the address itself. It is usually easy to identify from the address alone when execution is in kernel code or the exception vector table. Unfortunately there is no easy way to continue until you're back in userspace, particularly if the kernel schedules a different thread than the one you were debugging. Depending on the scenario you are debugging, it may be simpler to modify your system setup to ensure only one thread is running.

== Objdump ==
Objdump can be used to disassemble an ELF file, be it a kernel or an application.

For ARM, supposing that '''arm-none-eabi-''' is used as the cross-compiler prefix.

{{{
  arm-none-eabi-objdump -D binary_file_name > dump.s
}}}
For x86

{{{
  objdump -D binary_file_name > dump.s
}}}
The file {{{dump.s}}} has the human-readable assembly instructions.

If you have symbols and want (C) source information in your disassembly (and who doesn't!) then use the -S flag.  for example:

{{{
  objdump -DS binary_file_name
}}}
=== Debugging seL4test ===
The sel4test project has make targets which perform call objdump with the correct arguments generated from the .config.

You can objdump the kernel:

{{{
make objdump-kernel | less
}}}
The test driver:

{{{
make objdump-driver | less
}}}
Or the tests themselves:

{{{
make objdump-tests | less
}}}
== GDB ==
= User level debugging =
== Fault handlers ==
TODO how to use sel4utils_start_fault_handler to find a threads registers when it crashes

= In kernel debugging =
TODO how to debug in the kernel

__builtin_ret_address__ printf

seL4 does not currently have a kernel debugger.
