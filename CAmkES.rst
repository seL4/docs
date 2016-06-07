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
 * Install GHC and packages MissingH, data-ordlist, split, mtl, and base-compat (installable from cabal):

{{{
sudo add-apt-repository -y ppa:hvr/ghc         
sudo apt-get update
sudo apt-get install -y ghc-7.8.4 cabal-install-1.22 

export PATH=/opt/ghc/7.8.4/bin:/opt/cabal/1.22/bin:$PATH

cabal update
cabal install MissingH
cabal install data-ordlist
cabal install split
cabal install mtl
cabal-install base-compat
}}}

Cabal packages get installed under the current user, so each user that wants to build CAmkES must run the cabal steps

Note also that this step adds the directories where ghc and cabal are installed to the PATH.  If ghc and/or cabal can't be found later on, it's probably because the PATH isn't set correctly.  Consider adding this to your startup files, e.g.:

{{{
echo export PATH=/opt/ghc/7.8.4/bin:/opt/cabal/1.22/bin:\$PATH >> ~/.bashrc
}}}


Install python packages jinja2, ply, pyelftools (via pip):

{{{
apt-get install python-pip
pip install pyelftools
pip install ply
pip install jinja2
}}}
If building on a 64bit system ensure 32bit compiler tools are installed, mainly:

{{{
apt-get install lib32gcc1
}}}
And the correct version of multilib for your gcc, for example:

{{{
apt-get install gcc-multilib
}}}
== Download CAmkES ==
Download CAmkES source code from github:

{{{
mkdir camkes-project
cd camkes-project
repo init -u https://github.com/seL4/camkes-manifest.git
repo sync
}}}
== Build and run simple application ==
The following will configure, build, and run a simple example CAmkES system:

{{{
make arm_simple_defconfig
make silentoldconfig
}}}
If you haven't done so already, change the toolchain to the one for your system. You can do this by running '''make menuconfig''', then going to '''Toolchain Options -> Cross compiler prefix'''. You will most likely be compiling with '''arm-linux-gnueabi-'''.

{{{
make
qemu-system-arm -M kzm -nographic -kernel images/capdl-loader-experimental-image-arm-imx31
}}}
In order to clean up after building (for example because you’ve set up a new configuration and you want to make sure that everything gets rebuilt correctly) do:

{{{
make clean
}}}
== Read Tutorial ==
To learn about developing your own CAmkES application, read the [[https://sel4.systems/Info/CAmkES/Tutorial.pml|tutorial]].

[[CAmkES Tutorial]]

== Camkes Terminology/Glossary ==
Can be found [[CAmkES/Terminology|here]].
