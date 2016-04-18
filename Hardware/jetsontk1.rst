The [[http://www.nvidia.com/object/jetson-tk1-embedded-dev-kit.html|Jetson TK1]] is a affordable embedded system developed by NVIDIA. It runs seL4. We will explain how to run seL4 on the Tegra.

= Pre-Requisites =
 * One Tegra Board. See [[http://www.nvidia.com/object/jetson-tk1-embedded-dev-kit.html|Jetson TK1]]
 * The development environment fully working. See [[Getting started]]

= Getting Started =
To get started, check out


= Build your first seL4 system =
First, check out the seL4 project.
{{{
$ mkdir tegra-test
$ repo init -u https://github.com/seL4/sel4test-manifest.git
$ repo sync
}}}

Then, use the default config for the tegra and build the system.
{{{
$ make tk1_debug_xml_defconfig
$ make
}}}
