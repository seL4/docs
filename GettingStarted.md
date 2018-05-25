---
toc: true
---

# Getting Started

This page will lead you through the steps required to setup your development environment to be
able to work with seL4 and supported userlevel environments.


## Sources
 All seL4 code and proofs are available on GitHub, at
<https://github.com/seL4>, under standard
[open-source licenses](http://sel4.systems/Info/GettingStarted/license.pml).

There are [several repositories](/MaintainedRepositories).
The most interesting ones are the
project repositories (whose names end in -manifest) and these two:

- [l4v](https://github.com/seL4/l4v) the seL4 proofs
- [seL4](https://github.com/seL4/seL4) the seL4 kernel

The seL4 kernel is usually built as part of project. Each project has a
README.md associated with it that gives more information.

As projects are a collection of several git repositories, we use
[Android's Repo tool](http://source.android.com/source/downloading.html#installing-repo).
Each project consist of an XML file that describes which repositories
to use, and how to lay them out to make a buildable system.
See the [RepoCheatsheet](/RepoCheatsheet) page for a quick
explanation of how we use Repo and some common commands.

Some available projects so far are described below, but for a full list see a [list of released projects](https://docs.sel4.systems/ReleaseProcess#versioned-manifests):

- [verification](https://github.com/seL4/verification-manifest),
      the seL4 proofs.
- [seL4test](https://github.com/seL4/sel4test-manifest), a
      test suite for seL4, including a Library OS layer.
- [seL4bench](https://github.com/seL4/sel4bench-manifest), a
      microbenchmarking suite for seL4.
- [CAmkES](https://github.com/seL4/camkes-manifest), a
      component architecture for embedded systems based on seL4. See the
      CAmkES pages for more documentation about CAmkES.
- [x86 Camkes VMM](https://github.com/seL4/camkes-vm-examples-manifest) a
      component-based virtual machine monitor for ia32 platforms using
      Intel VT-X and VT-D extensions.

## Supported Target Platforms

Read the [Hardware](Hardware) pages to see a list of supported platforms,
and special instructions for particular hardware platforms.

## Setting up your machine

Read the [Host Dependencies](HostDependencies) page to find instructions on how to set up
your host machine to build seL4 and its various related projects.

## Build system

We use a collection of CMake scripts to handle system configuraiton and for building final binaries.
More information on the build system can be found [here](/Developing/Building). 

#### Fetching, Configuring and Building seL4test

To build a project, you need to:
- check out the sources using Repo
- configure a target build using CMake
- build the project using Ninja.

As an example, we'll use sel4test as it is a good way to verify your host setup.

We use repo to check sel4test out from GitHub. Its manifest is located in the `sel4test-manifest` repository.
```sh
mkdir seL4test 
cd seL4test
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
```

We will configure a x86_64 simulation target to be run by Qemu:
```sh
mkdir build-x86
cd build-x86
../init.sh -DPLATFORM=x86_64 -DSIMULATION=TRUE
ninja
```
The target configurations available for each project are potentially different depending on what the project supports.
[Building/Using](/Developing/Building/Using) describes how projects can generally be configured.

Now the images have been built they are available in `build-x86/images`.  There is also a `build-x86/simulation`
script that will run Qemu with the correct arguments to hopefully pass all the tests.
```sh
./simulate
```
If all the tests pass you should see:
```
Test VSPACE0002 passed

        </testcase>

        <testcase classname="sel4test" name="Test all tests ran">

        </testcase>
 
</testsuite>

All is well in the universe
```

For more information on seL4test see its [project page](/seL4Test).

## Project Layout

A project's layout refers to where apps, libraries, the kernel and required
tools can be found once the sources have been checked out and how they depend
on each other to build runnable images. 
- The Repo manifest specifies where sources are checked out to in the project directory
- CMakeLists.txt files specify dependencies. [Building/Incorporating](/Developing/Building/Using)
  describes how CMake projects can be structured.

## Running on real hardware

See [Hardware](/Hardware) for supported hardware and how to set it up.

## Learn more

### Start with the tutorials


The seL4 and CAmkES [Tutorials](Tutorials) are an
introduction to the design of seL4, and also to preparing to develop for
seL4, and they are also used internally to train new seL4 engineers.
You are strongly encouraged to complete the tutorials if you are new to
seL4: they will quickly bring you up to speed and ready to practically
contribute.

## Community

Gernot's presentation:
[seL4 is free: What does this mean for you? (2015)](https://www.youtube.com/watch?v=lRndE7rSXiI) outlines areas where the kernel could use some contributions – other than that,
gauging what you can do externally is for the time being, difficult. If you have
ideas, please feel free to visit the NICTA mailing lists and chime in:

### Mailing lists
- [seL4 Announce](https://sel4.systems/lists/listinfo/announce).
- [seL4 Devel](https://sel4.systems/lists/listinfo/devel).


## Learn more about seL4
 For someone just getting to know about seL4
and wanting to first at least understand how to build it, so that you
can get comfortable with editing the source code, the following pre-init
steps might help you get more context, before you try building, so you
have at least a conceptual understanding of exactly what sort of
creature you're about to step into the arena with. These are **not**
pre-requisites for building the kernel, but they will help you a lot in
understanding what you're dealing with.

### Publications


There are many publications available on the design of the seL4 kernel,
documenting every design decision and the justifications for each one.
Consider trying to read some of them, or at least scrolling through the
list, and picking out the most eye-catching titles and skimming them.
You can find a long list of seL4 publications here:

[The seL4 project page at Data61](http://ts.data61.csiro.au/projects/seL4/).

### Youtube


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
