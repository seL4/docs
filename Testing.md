---
toc: true
---
# seL4Test

[sel4test](https://github.com/seL4/sel4test-manifest) is a test suite for seL4.

First make sure you have
[set up your machine](/GettingStarted#setting-up-your-machine).

## Getting the Code 

~~~bash
mkdir sel4test
cd sel4test
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
ls 
# kernel/ libs/ projects/ tools/ apps configs Kbuild Kconfig Makefile
~~~

This clones the seL4 kernel, the test suite, some libraries used by the
tests, and some tools used in the build process. By default, the current
master branch of the kernel is cloned. To clone a specific version of
the kernel and compatible libraries and tools, replace the
```
repo init
```
line above with:
```
repo init -u https://github.com/seL4/sel4test-manifest.git -b refs/tags/{{site.sel4_master}}
```

In this example we clone version 2.0.x of the kernel, where "x" is the
highest available minor version number. For more information on version
numbers, see ReleaseProcess. 
## Build it
### Configurations

Default make configurations are provided for a number of platforms:
```
$ ls configs 
arndale_debug_xml_defconfig              inforce_release_xml_defconfig
arndale_release_xml_defconfig            kzm_debug_xml_clang_defconfig
bbone_debug_xml_defconfig                kzm_debug_xml_defconfig
bbone_release_xml_defconfig              kzm_debug_xml_goanna_defconfig
beagle_debug_xml_defconfig               kzm_release_xml_clang_defconfig
beagle_release_xml_defconfig             kzm_release_xml_defconfig
beagle_simulation_debug_xml_defconfig    kzm_release_xml_goanna_defconfig
beagle_simulation_release_xml_defconfig  kzm_simulation_debug_xml_defconfig
goanna-arm-gcc.profile                   kzm_simulation_release_xml_defconfig
...
```

To use a specific config:

```
make ia32_simulation_release_xml_defconfig
```

This copies `configs/ia32_simulation_release_xml_defconfig` to
`./.config`, and sets up various header files.

You can look at the configuration options using

```
make menuconfig
```

Alternatively you can use any text editor to change `./.config`; if
you change anything you need to rebuild header files with
`make oldconfig`
. It's advisable also to make clean to clear out anything
already built — the build system does not track as many dependencies as
it ought to. 

### Useful configuration options
For cross compilation (targeting ARM), you can set the cross compiler triple. This will
typically be **arm-linux-gnueabi-** or **arm-none-eabi-**. Do
`make menuconfig` and look for **toolchain-options**

Some of the default configurations specify a particular x86 compiler. It
is usually safe to set the triple to the empty string when building for
x86, if you have a multilib gcc installed.

Fiddling with most of the other configuration options will lead to
systems that will either not compile, or not run.
## Building
When you've configured the system, you can build by doing

~~~
make -j libmuslc && make
~~~

Currently parallel builds do not work for the whole build, but it is
worth using for the C library. The build system does however support
ccache if you have it installed.

A more comprehensive overview of the build system is available at
[BuildSystemAnatomy](/BuildSystemAnatomy/)

## Running it


### IA32
 We will now build seL4test for ia32, to run on the QEMU
simulator.

The makefile provides a target to simulate ia32. Running the following
command will run qemu and point it towards the image we just built.
~~~bash
make ia32_simulation_release_xml_defconfig
make -j libmuslc && make
make simulate-ia32
~~~

To exit qemu after the All is well in the universe message that
indicates the test suite has passed, type `control-a x`.

### ARM - kzm11


Let's build the test suite for kzm_simulation_debug_xml_defconfig:
~~~bash
make kzm_simulation_debug_xml_defconfig
make
ls images
# sel4test-driver-image-arm-imx31
~~~

Run it in qemu:
~~~
qemu-system-arm -nographic -M kzm -kernel images/sel4test-driver-image-arm-imx31
ELF-loader started on CPU: ARM Ltd. ARMv6 Part: 0xb36 r1p3
  paddr=[82000000..8223001f]
ELF-loading image 'kernel'
  paddr=[80000000..80035fff]
  vaddr=[f0000000..f0035fff]
  virt_entry=f0000000
ELF-loading image 'sel4test-driver'
...
<testsuite>
        <testcase classname="sel4test" name="TEST_BIND0001">
Running test BIND0001 (Test that a bound tcb waiting on a sync endpoint receives normal sync ipc and notification notifications.)
Test BIND0001 passed
                <system-out> TEST_BIND0001
</system-out>
        </testcase>
...
~~~

The test suite prints out
JUnit-style XML which can be parsed by various tools.

## Testing a Customised Kernel

Suppose you've got seL4 checked out in `\~/projects/seL4`, and sel4test in
`\~/tests/sel4test`, and you have been making changes on a feature branch of seL4 named
`awesome-new-feature`. You want to test if your modified kernel
still passes all the tests in sel4test.

~~~bash
cd ~/tests/sel4tests/kernel
git remote add feature ~/projects/seL4
git fetch feature
git checkout feature/awesome-new-feature
cd ..
~~~

Now the kernel in sel4test has been changed to your custom kernel.
Now just build and run the test suite as above.

## Running a subset of the tests
You can use a regular expression to select a subset of
tests. This can be set using Kconfig, or the build shortcut
`make select-test TEST=SCHED.*`. By default the test suite runs all tests.
