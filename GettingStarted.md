---
toc: true
---

# Getting Started
 In general, if you're just getting started, you want
to dive into the seL4 tutorials, then the CAmkES tutorials, then the
seL4 Test suite. There's a section on this page for each.

## Aims
 This page seeks to comprehensively assist new seL4 developers
or interested parties to easily obtain the correct tools to duplicate
the internal seL4 development environment, successfully build the seL4
tutorials, and successfully follow the seL4 tutorials.

It's introductory – after you've followed these steps, you'll be at the
crest point where you can confidently begin reading the seL4 API kernel
manual with a **functional** copy of the kernel on your own machine.
From that point, the guidance for what you should do with the functional
source copy that you have will come from your own intuition, interest
and hopefully, inspiration that seL4 gives you.

## Code
 All seL4 code and proofs are available on GitHub, at
<https://github.com/seL4>, under standard
[open-source licenses](http://sel4.systems/Info/GettingStarted/license.pml).

There are several repositories; the most interesting ones are the
project repositories (whose names end in -manifest) and these two:

- [l4v](https://github.com/seL4/l4v) the seL4 proofs
- [seL4](https://github.com/seL4/seL4) the seL4 kernel

## Projects


The seL4 kernel is usually built as part of project. Each project has a
README.md associated with it that gives more information. The
information on this page is common to all of them.

We modeled the seL4 development process on the
[Android development process](https://source.android.com/source/developing.html). Each project consist of an XML file that
describes which repositories to use, and how to lay them out to make a
buildable system.

The available projects so far are:

- [verification](https://github.com/seL4/verification-manifest),
      the seL4 proofs.
- [seL4test](https://github.com/seL4/sel4test-manifest), a
      test suite for seL4, including a Library OS layer.
- [CAmkES](https://github.com/seL4/camkes-manifest), a
      component architecture for embedded systems based on seL4. See the
      CAmkES pages for more documentation about CAmkES.
- [VMM](https://github.com/seL4/camkes-vm-manifest) a
      component-based virtual machine monitor for ia32 platforms using
      Intel VT-X and VT-D extensions.
- [RefOS](https://github.com/seL4/refos-manifest), a
      reference example of how one might build a multi-server operating
      system on top of seL4. It was built as a student project.

Other projects may be added later.

## Supported Target Platforms


Read the [Hardware](Hardware) pages to see a list of supported platforms,
and special instructions for particular hardware platforms.

## Setting up your machine


You can setup all the dependencies on your local OS, or you may choose
to use Docker.

### Using Docker
 You can also use Docker to isolate the dependencies
from your machine. Instructions for using Docker for building seL4,
CAmkES, and L4v can be found
[here](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles).

### Using your local OS
 These instructions are for Ubuntu. They
assume you already know the basics of using the command line, compilers
and GNU Make.

#### Get Google's "Repo" tool
 Repo is a tool by Google used for
managing multiple git repositories. All the seL4 related projects use
multiple subprojects, and Repo will fetch all of them and place them in
the correct subdirectories for you. To get repo,
[follow the instructions in the section "Installing Repo" here](http://source.android.com/source/downloading.html#installing-repo). (You don't
need to initialise a repo client yet.)

#### Using Repo to fetch an seL4 project and its subprojects
 Choose
a project to start with. As an example, we'll use sel4test.

- When fetching a project, look for the GIT repository from Github,
      whose title has "-manifest" appended to it. So instead of fetching
      the "sel4-tutorials" GIT repository on Github, we'll fetch the
      "sel4-tutorials-manifest" repository. The difference is that the
      "-manifest" repository is meant to tell Repo how to fetch the
      subprojects and set up the source tree.
- First create a directory for Repo to work in, then enter it and
      initialise it using Repo:

  ```bash
  mkdir seL4test 
  cd seL4test
  repo init -u https://github.com/seL4/sel4test-manifest.git
  ```

  To get the actual project and subproject source, you'll then need to use repo sync, which
  will then clone and checkout the project and all the required
  subprojects.

  ``` 
  repo sync
  ```

#### Getting cross compilers
 There are instructions on how to get
cross compilers for building ARM. We only have direct instructions for
Debian/Ubuntu/Fedora, but we imagine you should be able to substitute
where necessary for your distro. Instructions should be similar for
other distros, links to toolchains for other distros are provided.

  - [Cross compiler and general instructions for Fedora
     and CentOS (RHEL should work as well)](SetupFedora)
  - [Cross compilers for Debian and Ubuntu](SetupUbuntu)

## Start with the tutorials


The seL4 and CAmkES [Tutorials](Tutorials) are an excellent, holistic
introduction to the design of seL4, and also to preparing to develop for
SEL4, and they are also used internally to train new seL4 developers.
You are strongly encouraged to complete the tutorials if you are new to
SEL4: they will quickly bring you up to speed and ready to practically
contribute.

## Get acquainted with seL4Test


Any changes you make to seL4 should pass the tests in seL4 Test, and
pull requests to seL4 which are non-trivial or related only to
documentation, should come with a matching pull request and new test (if
applicable) to the seL4Test repository as well.

[seL4test](Testing) is a comprehensive unit and functional testing
suite for seL4 and can be useful when porting to new platforms or adding
new features.

## Project Layout


See [Build System Anatomy](BuildSystemAnatomy) for details of
project layouts and the seL4 build system.

Configuration files in the configs directory are named by target
machine, then something about what they do. Most have either release or
debug in their names. Debug kernels are built with debug symbols (so one
can use gdb), enable assertions, and provide the sel4debug interfaces to
allow debug printout on a serial port.

Some configurations are intended to run under qemu. Because qemu does
not produce a completely faithful emulation of the hardware, sometimes
features have to be disabled or worked around. These configurations have
‘simulation’ in their names.

## Running on real hardware


See [Hardware](/Hardware).

# Contributing


Gernot's presentation:
[seL4 is free: What does this mean for you? (2015)](https://www.youtube.com/watch?v=lRndE7rSXiI) outlines areas where the kernel could use some contributions – other than that,
gauging what you can do externally is for the time being, difficult. If you have
ideas, please feel free to visit the NICTA mailing lists and chime in:

- [seL4 Announce](https://sel4.systems/lists/listinfo/announce).
- [seL4 Devel](https://sel4.systems/lists/listinfo/devel).

# Learn more about seL4
 For someone just getting to know about seL4
and wanting to first at least understand how to build it, so that you
can get comfortable with editing the source code, the following pre-init
steps might help you get more context, before you try building, so you
have at least a conceptual understanding of exactly what sort of
creature you're about to step into the arena with. These are **not**
pre-requisites for building the kernel, but they will help you a lot in
understanding what you're dealing with.

## Publications


There are many publications available on the design of the seL4 kernel,
documenting every design decision and the justifications for each one.
Consider trying to read some of them, or at least scrolling through the
list, and picking out the most eye-catching titles and skimming them.
You can find a long list of seL4 publications here:

[The seL4 project page at Data61](http://ts.data61.csiro.au/projects/seL4/).

## Youtube


- Gernot Heiser outlines several areas where the kernel is looking
        for good Samaritans toward the end of this presentation,
        "[seL4 is
        free: What does this mean for you? (2015)](https://www.youtube.com/watch?v=lRndE7rSXiI)". If you were
        looking for externally available information on the status of
        seL4, you probably ran across that presentation yourself.
- In addition, this youtube video shows Gernot giving a
        presentation on seL4's context and position in the timeline of
        L4 microkernel research:
        "[From L3 to
        seL4: What have we learned in 20 years of L4
        microkernels? (2014)](https://www.youtube.com/watch?v=RdoaFc5-1Rk)".
