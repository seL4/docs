# Toolchains on CentOS and Fedora
 These instructions are for
information only — at NICTA we usually use Debian-derived build systems

Follow the instructions in [All RPM-Based](\#allrpm) Variants then
the ones for your system.

  -   [Fedora](\#fedora)
  -   [CentOS](\#centos)

<<Anchor(allrpm)>> == All RPM-Based Systems == === The
Basics === To get a usable build system, install the Development Tools
group, '''which, ncurses-devel''' and the '''python-tempita'''
templating library. You can also install '''ccache''' to speed second
and subsequent compilations.
```

:   sudo yum groupinstall 'Development Tools' sudo yum install which
    ncurses-devel python-tempita ccache
```

### Extras for CAmkES
 Projects using CAmkES (the seL4 component
system) need Haskell and some extra python libraries in addition to the
standard build tools.

You can get most of them from the repositories; some Haskell and python
libraries have to be installed manually. On CentOS you'll need to enable
the EPEL repository to be able to install Haskell.
```

:   sudo yum install epel-release sudo yum groupinstall haskell sudo yum
    install cabal-install cabal update cabal install --user data-ordlist
    missingH split sudo yum install python-pip sudo pip install
    --upgrade pip pip install --user pyelftools jinja2 ply
```

<<Anchor(fedora)>> == Fedora == To build for any of the ARM
targets you need an arm cross compiler; to run on the simulator you need
'''qemu'''
```

:   yum install 'arm-none-\*' qemu
```

<<Anchor(centos)>> == CentOS ==

Cross compilers are available from the EPEL repository. Do
``` sudo yum
install gcc-arm-linux-gnu
```

The resulting CROSS_COMPILE_PREFIX should be arm-linux-gnu in the
toolchain menus

CentOS 6 and earlier also do not prepackage qemu. You will have to build
it from source.
```

:   sudo yum install glib2-devel git clone <git://git.qemu.org/qemu.git>
    cd qemu ./configure --target-list=arm-softmmu make -j
```
The resulting qemu binary is in arm-softmmu/qemu-system-arm

Note that cabal installs per-user, not into system directories.
