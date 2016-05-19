= Whole system debugging =

== Qemu ==

TODO

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

__builtin_ret_address__
printf

seL4 does not currently have a kernel debugger.
