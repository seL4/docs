<<TableOfContents()>>

= CAmkES =
CAmkES (component architecture for microkernel-based embedded systems) is a software development and runtime framework for quickly and reliably building microkernel-based multiserver (operating) systems. It follows a component-based software engineering approach to software design, resulting in a system that is modelled as a set of interacting software components. These software components have explicit interaction interfaces and a system design that explicitly details the connections between the components.

The development framework provides:

 * a language to describe component interfaces, components, and whole component-based systems
 * a tool that processes these descriptions to combine programmer-provided component code with generated scaffolding and glue code to build a complete, bootable, system image
 * full integration in the seL4 environment and build system

== Setting up your machine ==
 * Before you can use any of the SEL4 related repositories, you must [[http://source.android.com/source/downloading.html#installing-repo|get the "repo" tool by Google]]. SEL4 projects have multiple subproject dependencies, and repo will fetch all of them and place them in the correct subdirectories for you.
 * Make sure that you already have the tools to build seL4 ([[Getting started#Setting_up_your_machine|seL4: Setting up your machine]])

== Build dependencies ==
 * You must first install [[https://wiki.sel4.systems/Getting%20started#Build_Dependencies|the SEL4 dependencies]], and then you should move on to the instructions in this section.
 * Install [[https://haskellstack.org | haskell stack]] (haskell version and package manager)

{{{#!highlight bash numbers=off
curl -sSL https://get.haskellstack.org/ | sh
}}}
OR
{{{#!highlight bash numbers=off
sudo apt-get install haskell-stack
}}}

 * Install python packages jinja2, ply, pyelftools (via pip):

{{{#!highlight bash numbers=off
apt-get install python-pip
pip install --user pyelftools ply jinja2
}}}
OR
{{{#!highlight bash numbers=off
sudo apt-get install python-ply python-jinja2 python-pyelftools
}}}
 * If building on a 64-bit system ensure 32-bit compiler tools are installed, mainly:

{{{#!highlight bash numbers=off
apt-get install lib32gcc1
}}}

 * And the correct version of multilib for your gcc, for example:

{{{#!highlight bash numbers=off
apt-get install gcc-multilib
}}}

== Download CAmkES ==

Download CAmkES source code from github:

{{{#!highlight bash numbers=off
mkdir camkes-project
cd camkes-project
repo init -u https://github.com/seL4/camkes-manifest.git
repo sync
}}}

== Build and run simple application ==

The following will configure, build, and run a simple example CAmkES system:

{{{#!highlight bash numbers=off
make arm_simple_defconfig
make silentoldconfig
}}}

If you haven't done so already, change the toolchain to the one for your system. You can do this by running `make menuconfig`, then going to '''Toolchain Options -> Cross compiler prefix'''. You will most likely be compiling with '''arm-linux-gnueabi-'''.

{{{#!highlight bash numbers=off
make
qemu-system-arm -M kzm -nographic -kernel images/capdl-loader-experimental-image-arm-imx31
}}}

In order to clean up after building (for example because you’ve set up a new configuration and you want to make sure that everything gets rebuilt correctly) do:

{{{#!highlight bash numbers=off
make clean
}}}

== Read Tutorial ==

To learn about developing your own CAmkES application, read the [[https://sel4.systems/Info/CAmkES/Tutorial.pml|tutorial]].

== Camkes Terminology/Glossary ==

Can be found [[CAmkES/Terminology|here]].

== Camkes Next ==

Information about the active development branch of Camkes can be found [[CAmkESNext|here]].

== CAmkES VM ==

Information about the x86 camkes vm can be found [[CAmkESVM|here]].
