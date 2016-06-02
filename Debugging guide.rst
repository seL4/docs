= Whole system debugging =
== Qemu ==
Qemu is a simulator that we use to simulate lots of different hardware platforms. This page lists a bunch of common tips and tricks, as well as how to generally use it.

=== Versions ===

 * qemu-arm - qemu for ARM
 * qemu-system-i386 - qemu for IA32

=== Sample Makefile targets ===
==== KZM ====
||`QEMU = qemu-arm`<<BR>>`QEMU_OPTS = -M kzm`||

emulate:    

||`${QEMU} ${QEMU_OPTS} -nographic -kernel /path/to/elfloader/generated/image`||


==== x86 ====
||`QEMU = qemu-system-i386`<<BR>>`QEMU_OPTS = -m 512`<<BR>>emulate:<<BR>>`${QEMU} ${QEMU_OPTS} -nographic -kernel /path/to/kernel/images -initrd /path/to/userlevel/image`||


=== To Exit ===
||`Ctrl+a, x`||


=== To get a register dump ===
||`Ctrl+a, c`<<BR>>`info registers`||


=== Using GDB with Qemu ===
Qemu has internal hooks to allow you to connect to it with the GNU Debugger. Start Qemu with extra options -s -S. Beware that -S (pause execution and wait for GDB to connect) is broken in some versions of Qemu. If your image immediately starts executing with this option, upgrade your version of Qemu. Once Qemu has started, run

||`gdb image`||


where image is the path to the image you are running. Enter

||`target remote :1234`||


at the GDB prompt to connect to Qemu. Note that you will need a version of GDB that matches the architecture of the image you are running.

==== Kernel debugging ====
As an example, let's look at debugging seL4 while running the hello example.

<TODO FIX REPO PATH>
||`make kzm_hello_defconfig`<<BR>>`make`||


Now run the example with extra options to Qemu to instruct it to not begin executing:

||`qemu-arm -M kzm -nographic -S -s -kernel images/hello-image-arm-imx31`||


Open another terminal and connect to Qemu using GDB. Note that we pass GDB the kernel image so it has access to the kernel's symbol table.

||`arm-none-eabi-gdb build/kernel/kernel.elf# At the GDB prompt enter "target remote :1234"`||


Suppose we want to halt when printf is called. Enter "break printf", then "cont" to begin execution. Execution will halt and you will get a GDB prompt whenever the kernel calls printf. At this point you can inspect registers, single step code or do whatever you would normally do in GDB. Note that this '''does not''' affect when the userspace application calls printf.

One thing that may not be immediately obvious is that debugging across a context in which page mappings change (e.g. switching page directories or turning the MMU on/off) will confuse GDB and you may find breakpoints triggering unexpectedly or being missed.

==== Userspace debugging ====
Clone and compile the hello example and execute Qemu as above. Start GDB in the same way, but pass the userspace image build/arm/imx31/hello/hello.bin. Enter "break printf" to set a breakpoint on printf as above. Note that this breakpoint is on '''userspace''' printf (in libc), not the kernel's printf. Enter "cont" to start executing and execution will halt whenever hello calls printf.



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
