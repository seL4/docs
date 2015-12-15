= Toolchains on Debian and Ubuntu =

Unfortunately, Debian is in a state of flux between the old Emdebian approach and the new MultiArch approach to cross-compilation.

On Wheezy and before, you need to use the Emdebian toolchains. Library support is now available on Jessie and later, but not a full complement of cross compilers.


Ubuntu is relatively straightforward, as [[http://www.linaro.org/|Linaro]] maintain cross compilers for it — see https://wiki.ubuntu.com/ToolChain. You will however have to have enabled the Universe repository.

Follow the instructions in [[#all|All Debian and Ubuntu Variants]] then the ones for your system:

 * [[#wheezy|Debian Wheezy (stable)]]
 * [[#jessie|Debian Jessie or sid (testing or unstable)]]
 * [[#ubuntu|Ubuntu later than Precise Pangolin (tested on 14.04LTS — Trusty Tahr)]]

<<Anchor(all)>>
== All Debian And Ubuntu Variants ==

=== The basics ===
To get a usable build system, install build-essential, realpath, libxml2-utils and python-tempita. For cross compiling on a 64-bit host, you also need gcc-multilib; to run things on a simulator you need qemu; ccache speeds up builds after the first; and ncurses-dev is needed to run the configurator.
{{{
  sudo apt-get update
  sudo apt-get install build-essential realpath libxml2-utils python-tempita
  sudo apt-get install gcc-multilib ccache ncurses-dev
}}}
=== Extras for CAmkES ===
Projects using CAmkES (the seL4 component system) need Haskell and some extra python libraries in addition to the standard build tools.

You can get most of them from the repositories; some Haskell and python libraries have to be installed manually.
{{{
sudo apt-get install cabal-install ghc libghc-missingh-dev libghc-split-dev
cabal update
cabal install data-ordlist
sudo apt-get install python-pip python-jinja2 python-ply
sudo pip install --upgrade pip
sudo pip install pyelftools
}}}

<<Anchor(wheezy)>>
== Debian Wheezy ==
To build for any of the ARM targets you need an arm cross compiler. The simplest way to do this on Wheezy is to use the emdebian pre-built compilers.
{{{
  sudo /bin/sh -c 'echo "deb http://www.emdebian.org/debian/ squeeze main" > /etc/apt/sources.list.d/emdebian.list'
  sudo /bin/sh -c 'echo "deb http://ftp.us.debian.org/debian/ squeeze main" >> /etc/apt/sources.list.d/emdebian.list'
  sudo apt-get update
  sudo apt-get install gcc-4.4-arm-linux-gnueabi
}}}
The version of qemu in Debian Wheezy does not have KZM support. Either install it from Jessie or sid, or build it from the upstream source:
{{{
  git clone git://git.qemu.org/qemu.git
  sudo apt-get build-dep qemu
  cd qemu
  ./configure --target-list=arm-softmmu
  make -j
}}}
The resulting qemu binary is in arm-softmmu/qemu-system-arm

<<Anchor(jessie)>>
== Debian Jessie ==
Jessie has multiarch support. To cross-build for ARM, add armhf as an architecture, and install the cross compiler:
{{{
  sudo dpkg --add-architecture armhf
  sudo apt-get update
  sudo apt-get install gcc-arm-none-eabi qemu
}}}
The resulting cross compilers generate code that is incompatible with the prebuilt libraries in the libmuslc repository. You will need to disable use of the prebuilt libraries in configurations that use musl C, as well as change the compiler prefix in the configuration.

<<Anchor(ubuntu)>>
== Ubuntu ==
=== Trusty Tahr (14.04LTS) ===
Linaro maintains cross compilers that run on Ubuntu. With current releases, the method for adding a foreign architecture is slightly more complicated than for Debian. Please note — this works on Ubuntu 14 and later.
{{{
sudo apt-get install python-software-properties
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install gcc-arm-linux-gnueabi
sudo apt-get install qemu-system-arm qemu-system-x86
}}}

=== Precise Pangolin (12.10) ===
The compilers available in Precise do not compile seL4 correctly. Either upgrade to Trusty, or install compilers from [[https://www.mentor.com/embedded-software/codesourcery|CodeSourcery]].
