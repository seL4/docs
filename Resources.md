---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Resources

This page provides an overview of working with seL4 and its ecosystem.

## Background and terminology

### Sources

Code and proofs are available on [GitHub](https://github.com/seL4), under standard
[open-source licenses](https://sel4.systems/Legal/license.html).

There are [many repositories](/MaintainedRepositories).
Of the most significant are:

- [l4v](https://github.com/seL4/l4v) the seL4 proofs
- [seL4](https://github.com/seL4/seL4) the seL4 kernel

### Projects

The seL4 kernel is built as part of project. Each project has a
README.md associated with it which provides further information.

While the kernel is normally built as part of a project it is also
possible create a [standalone build](/Developing/Building/seL4Standalone).

Projects are a collection of git repositories, with versions managed by
[Android's Repo tool](http://source.android.com/source/downloading.html#installing-repo).
Each project consists of an XML manifest file which specifies the source dependencies,
and directory structure of a project.
See the [RepoCheatsheet](/RepoCheatsheet) page for a quick
explanation of how we use Repo and some common commands.

A subset of available projects are described below, for a full list see the [list of released projects](/processes/release-process#versioned-manifests):

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

### Hardware and Target Platforms

Read the [Hardware](Hardware) pages to see a list of supported platforms,
and special instructions for particular hardware platforms.

### Verification Targets and Claims

The seL4 kernel has a number of verified properties on a selection of
configured hardware platforms. These configurations are also referred to
as *verification platforms* (e.g. ARM\_HYP). Read
[Verified Configurations](VerifiedConfigurations) to see which proofs are
available for which platform and how to make use of these
configurations.

**Note:** verification claims are limited to specific properties of seL4
on specifically configured platforms. These claims do not automatically
transfer to other platforms, other seL4 configurations, or custom seL4
versions. Please consult [Frequently Asked
Questions](FrequentlyAskedQuestions), as well as the [proof and
assumptions page](http://sel4.systems/Info/FAQ/proof.html) for a better
understanding of the intersection of verification and seL4.

### Setting up your machine

Read the [Host Dependencies](HostDependencies) page to find instructions on how to set up
your host machine.

### Build system

We use a [CMake-based build system](/Developing/Building) to manage dependencies.

## Running seL4

This section presents a case study, by the end of which you can run seL4test on a simulator.

### Fetching, Configuring and Building seL4test

To build a project, you need to:
- check out the sources using Repo,
- configure a target build using CMake,
- build the project using Ninja.

1. Use repo to check sel4test out from GitHub. Its manifest is located in the `sel4test-manifest` repository.

```sh
mkdir seL4test
cd seL4test
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
```

2. Configure an x86\_64 build directory, with a simulation target to be run by
[Qemu](http://www.qemu.org/). QEMU is a generic and open source
 machine emulator and virtualizer, and can emulate different
 architectures on different systems.

```sh
mkdir build-x86
cd build-x86
../init-build.sh -DPLATFORM=x86_64 -DSIMULATION=TRUE
ninja
```

The target configurations available for each project are potentially different depending on what the project supports.
[Building/Using](/Developing/Building/Using) describes how projects can generally be configured.
3. The build images are available in `build-x86/images`, and a script `build-x86/simulation`
that will run Qemu with the correct arguments to run seL4test.

```sh
./simulate
```

4. On success, you should see:

   ```
   Test VSPACE0002 passed

           </testcase>

           <testcase classname="sel4test" name="Test all tests ran">

           </testcase>

   </testsuite>

   All is well in the universe
   ```

For more information on seL4test see its [project page](/seL4Test).

## Using real hardware

See [Hardware](/Hardware) for supported hardware and how to set it up.

## Learn more

### seL4 Tutorials

The seL4 and CAmkES [Tutorials](Tutorials) are an
introduction to the design of seL4, and also to preparing to develop for
seL4, and they are also used internally to train new seL4 engineers.
You are strongly encouraged to complete the tutorials if you are new to
seL4: they will quickly bring you up to speed and ready to practically
contribute.

### Publications

You can find a long list of seL4 publications here:

[The seL4 project page at Trustworthy Systems](https://trustworthy.systems/projects/seL4/).

### Youtube

- [seL4 is free: What does this mean for you? (2015)](https://www.youtube.com/watch?v=lRndE7rSXiI).
- [From L3 to seL4: What have we learned in 20 years of L4 microkernels? (2014)](https://www.youtube.com/watch?v=RdoaFc5-1Rk).

## Contact

### Forums

- [Discourse forum](https://sel4.discourse.group/)
- [Mattermost channel](https://mattermost.trustworthy.systems/sel4-external/)

### Mailing lists

If you have ideas or questions, please use the developer mailing list:
- [seL4 Devel](https://lists.sel4.systems/postorius/lists/devel.sel4.systems/).

There is also a low-bandwidth list for general announcements:
- [seL4 Announce](https://lists.sel4.systems/postorius/lists/announce.sel4.systems/).
