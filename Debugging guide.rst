== Qemu ==

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

The file {{{dump.s}}} has the human-readable assembly instructions
