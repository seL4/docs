# Building and Running seL4test


First make sure you have
[set up your machine](https://wiki.sel4.systems/Getting%20started#Setting_up_your_machine).

<<TableOfContents()>>

## Get the code


If you don't have Repo, scroll up and read the earlier sections on Repo,
on this very page.

{{{ mkdir seL4test cd seL4test repo init -u
<https://github.com/seL4/sel4test-manifest.git> repo sync }}}

## Build it


We will now build seL4test for ia32, to run on the QEMU simulator.

` make ia32_simulation_release_xml_defconfig ` This copies
`configs/ia32_simulation_release_xml_defconfig` to
`./.config`, and sets up various header files.

You can look at the configuration options using

` make menuconfig ` Alternatively you can use any text editor to
change `./.config`; if you change anything you need to rebuild
header files with `make oldconfig`. It's advisable also to make
clean to clear out anything already built — the build system does not
track as many dependencies as it ought to.

For the ia32 target you should not have to change anything. For ARM
targets you may need to change the `cross-compiler prefix` in the
menuconfig under toolchain options

When you've configured the system, you can build by doing

` make ` Currently parallel builds do not work, so don't try to
speed things up by using -j. The build system does however support
ccache if you have it installed.

### Simulate it


The makefile provides a target to simulate ia32. Running the following
command will run qemu and point it towards the image we just built.

` make simulate-ia32 ` To exit qemu after the All is well in the
universe message that indicates the test suite has passed, type
`control-a x`.

### Useful configuration options
 For cross compilation (targeting
ARM), you can set the cross compiler triple. This will typically be
'''arm-linux-gnueabi-''' or '''arm-none-eabi-'''. Do {{{make
menuconfig}}} and look for '''toolchain-options'''

Some of the default configurations specify a particular x86 compiler. It
is usually safe to set the triple to the empty string when building for
x86, if you have a multilib gcc installed.

Fiddling with most of the other configuration options will lead to
systems that will either not compile, or not run.

### Caveats
 ==== kzm simulation hangs ==== qemu does not simulate
all the timers needed for a full sel4 test run. Use the
'''kzm_simulation_configurations''' to avoid tests that rely on
unimplemented timers.

#### arm-none-eabi
 If you use '''arm-none-eabi''' compilers, the
prebuilt libraries will fail to link, with a message something like

{{{ /usr/lib64/gcc/arm-none-eabi/4.8.1/../../../../arm-none-eabi/bin/ld:
warning: /usr/src/seL4test/stage/arm/imx31/lib/libmuslc.a(internal.o)
uses 32-bit enums yet the output is to use variable-size enums; use of
enum values across objects may fail }}} To fix, do `make menuconfig`
visit `seL4 Libraries→Build musl C Library` and untick {{{libmuslc
use precompiled archive}}} then do `make clean` and attempt to
rebuild.

### hard float compilers
 The default configuration on newer
compilers from Debian and Ubuntu use hardware floating point. Binaries
built with these compilers are incompatible with the prebuilt musl C
library. You can either tweak the flags (in
`tools/common/Makefile.flags}}}: add {{{-mfloat-abi=soft` to
'''NK_CFLAGS''') or disable the use of the prebuilt libraries as above.

## Run on Real Hardware


See the instructions per platform [here](Hardware)
