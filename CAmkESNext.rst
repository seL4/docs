<<TableOfContents()>>

= CAmkES Next =

CAmkES Next refers to the "next" branch of camkes-tools. It is the active development branch of camkes.

Github: https://github.com/seL4/camkes-tool/tree/next

Main CAmkES page: https://wiki.sel4.systems/CAmkES

== Setting up your machine ==

The following commands were tested on a fresh installation of Ubuntu 16.04. This will install the tools and libraries required to build seL4 and CAmkES Next. Note that the dependencies are different from those of the "master" branch of CAmkES.
{{{#!highlight bash numbers=off
apt-get install git repo libncurses-dev python-pip libxml2-utils cmake ninja-build clang libssl-dev libsqlite3-dev libcunit1-dev gcc-multilib expect qemu-system-x86 qemu-system-arm gcc-arm-none-eabi binutils-arm-none-eabi
pip install six tempita plyplus pyelftools orderedset jinja2
curl -sSL https://get.haskellstack.org/ | sh
}}}

== Download and build example CAmkES app ==

Create and enter an empty working directory before running the commands below.
{{{#!highlight bash numbers=off
# Download CAmkES, seL4, user libraries and example apps
repo init -u https://github.com/seL4/camkes-manifest.git -m next.xml
repo sync

# Select an app to build (build configs can be found in the "configs" directory)
make arm_simple_defconfig

# Compile it
make

# Run the app in qemu
qemu-system-arm -M kzm -nographic -kernel images/capdl-loader-experimental-image-arm-imx31

}}}
