= Toolchains on CentOS and Fedora =
These instructions are for information only — at NICTA we usually use Debian-derived build systems

Follow the instructions in All [[#allrpm|RPM-Based]] Variants then the ones for your system.

 * [[#fedora|Fedora]]
 * [[#centos|CentOS]]



== All RPM-Based Systems ==

<<Anchor(allrpm)>>


=== The Basics ===
To get a usable build system, install the Development Tools group, which, ncurses-devel and the python-tempita templating library. You can also install ccache to speed second and subsequent compialtions.

{{{
  sudo yum groupinstall 'Development Tools'
  sudo yum install which ncurses-devel python-tempita ccache
}}}

=== Extras for CAmkES ===
Projects using CAmkES (the seL4 component system) need Haskell and some extra python libraries in addition to the standard build tools.

You can get most of them from the repositories; some Haskell and python libraries have to be installed manually.

{{{
  sudo yum groupinstall haskell
  sudo yum install cabal-install
  cabal update
  cabal install data-ordlist missingh split
  sudo yum install python-pip
  sudo pip install --upgrade pip
  sudo pip install pyelftools jinja2 ply
}}}

== Fedora ==

<<Anchor(fedora)>>

To build for any of the ARM targets you need an arm cross compiler; to run on the simulator you need qemu

{{{
  yum install 'arm-none-*' qemu
}}}

== CentOS ==

<<Anchor(centos)>>

CentOS has no pre-built arm toolchain or qemu. You will have to get cross compilers from Mentor Graphics. Look for arm-none-eabi-gcc.

CentOS also does not prepackage qemu. You will have to build it from source.

{{{
  git clone git://git.qemu.org/qemu.git
  cd qemu
  ./configure --target-list=arm-softmmu
  make -j
}}}
The resulting qemu binary is in arm-softmmu/qemu-system-arm

Note that cabal installs per-user, not into system directories.
