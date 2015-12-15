= Getting started =
== Setting up your machine ==
These instructions are for Ubuntu. They assume you   already know the   basics of using the command line, compilers, and   GNU Make.

=== Toolchains and Prerequisites ===
Instructions should be similar for other distros, links to toolchains for other distros are provided.

[[SetupFedora|Instructions for Fedora and CentOS (RHEL should work as well)]]

[[SetupUbuntu|Instructions for Debian and Ubuntu]]

Use Ubuntu's package manager to install the necessary packages. You will also need to add the universe repository (if you haven't already) to access the cross compiler.

{{{
sudo apt-get install python-software-properties
sudo apt-get install g++-multilib
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install gcc-arm-linux-gnueabi
sudo apt-get install qemu-system-arm qemu-system-x86
}}}
=== Get Repo ===
Repo is a tool by Google used for managing multiple git repositories.

The latest repo is available at https://storage.googleapis.com/git-repo-downloads/repo.   Download it, and put it somewhere in your PATH.

{{{
mkdir -p ~/bin
export PATH=~/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
}}}
=== Using repo ===
Choose a project to start with. As an example, we'll use   sel4test. First create a directory to work in, and initialise it   using repo:

{{{
mkdir seL4test
cd seL4test
repo init -u https://github.com/seL4/sel4test-manifest.git
}}}
To get the actual source,   you'll then need to use repo sync:

{{{
repo sync
}}}
repo will churn through for around ten minutes fetching all the   repositories needed.

== Build and run seL4 test ==
=== Project Layout ===
Each project has an associated wiki, accessible via github, that   has up-to-date dependencies and instructions. The general   instructions here apply to all projects.

The top level layout of all projects is similar. After a build it   looks something like this:

{{{
$ ls -F
Kbuild@   Makefile@  build/    images/   kernel/  projects/  tools/
Kconfig@  apps@      configs@  include/  libs/    stage/
}}}
 build   ::      contains built files.
 apps   ::      is a symlink to a subdirectory of projects     containing the source for applications.
 configs   ::      is a symlink to a subdirectory of projects     containing default configurations
 images   ::      contains the final linked ready-to-run artefacts after a build
 include   ::      is where header files from libraries and the kernel are staged
 kernel   ::      contains the seL4 kernel
 libs   ::      contains the source to libraries
 projects   ::      is a placeholder for project-specific parts
 stage   ::      is where built libraries are put
 tools   ::      contains parts of the build system, and other tools needed to     build a project

Configuration files in configs are named by target   machine, then something about what they do. Most have either   `release' or `debug' in their names. Debug kernels are built with   debug symbols (so one can use gdb), enable   assertions, and provide the sel4debug interfaces to allow debug   printout on a serial port.

Some configurations are intended to run under qemu. Because qemu   does not produce a completely faithful emulation of the hardware,   sometimes features have to be disabled or worked around. These   configurations have ‘simulation’ in their names.

=== Build ia32 ===
We will now build seL4test for ia32, to run on the QEMU simulator.

{{{
make ia32_simulation_release_xml_defconfig
}}}
This copies   configs/ia32_simulation_release_xml_defconfig to   ./.config, and sets up various header files.

You can look at the configuration options using

{{{
make menuconfig
}}}
Alternatively you can use any text editor to change   ./.config; if you change anything you need to   rebuild header files with make oldconfig. It's   advisable also to make clean to clear out anything   already built — the build system does not track as many   dependencies as it ought to.

For the ia32 target you should not have to change anything. For   ARM targets you may need to change the cross-compiler prefix in   the menuconfig under toolchain options

When you've configured the system, you can build by doing

{{{
make
}}}
Currently parallel builds do not work, so don't try to speed   things up by using -j. The build system does however   support ccache if you have it installed.

=== Simulate ia32 ===
The makefile provides a target to simulate ia32. Running the following command will run qemu and point it towards the image we just built.

{{{
make simulate-ia32
}}}
To exit qemu after the All is well in the universe   message that indicates the test suite has passed, type control-a   c q

=== Build ARM ===
== Try the seL4 tutorials ==
TODO
