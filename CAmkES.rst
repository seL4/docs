= CAmkES =
== Setting up your machine ==
Make sure that you already have the tools to build seL4 ([[Getting started#Setting_up_your_machine|seL4: Setting up your machine]])

== Build dependencies ==
Install GHC and packages MissingH, data-ordlist and split (installable from cabal):

{{{
apt-get install ghc
apt-get install cabal-install
cabal update
cabal install MissingH
cabal install data-ordlist
cabal install split
}}}
Cabal packages get installed under the current user, so each user that wants to build the VM must run the cabal steps

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
make
qemu-system-arm -M kzm -nographic -kernel images/capdl-loader-experimental-image-arm-imx31
}}}
In order to clean up after building (for example because you’ve set up a new configuration and you want to make sure that everything gets rebuilt correctly) do:
{{{
make clean
}}}
== Read Tutorial ==
To learn about developing your own CAmkES application, read the [[https://sel4.systems/Info/CAmkES/GettingStarted.pml|tutorial]].
