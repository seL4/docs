= Contents =
<<TableOfContents()>>

= Getting Started =
In general, if you're just getting started, you want to dive into the SEL4 tutorials, then the CAmkES tutorials, then the SEL4 Test suite. There's a section on this page for each.

== Aims ==
This page seeks to comprehensively assist new SEL4 developers or interested parties to easily obtain the correct tools to duplicate the internal SEL4 development environment, successfully build the SEL4 tutorials, and successfully follow the SEL4 tutorials.

It's introductory – after you've followed these steps, you'll be at the crest point where you can confidently begin reading the SEL4 API kernel manual with a '''functional''' copy of the kernel on your own machine. From that point, the guidance for what you should do with the functional source copy that you have will come from your own intuition, interest and hopefully, inspiration that SEL4 gives you.

== Code ==
All seL4 code and proofs are available on github, at https://github.com/seL4, under standard [[http://sel4.systems/Info/GettingStarted/license.pml|open-source licenses]].

There are several repositories; the most interesting ones are the project repositories (whose names end in -manifest) and these two:

 * [[https://github.com/seL4/l4v|l4v]] the seL4 proofs

 * [[https://github.com/seL4/seL4|seL4]] the seL4 kernel

=== seL4 projects ===
The seL4 kernel is usually built as part of project. Each project has a wiki entry associated with it that gives more information. The information on this page is common to all of them.

We modelled the seL4 development process on the [[https://source.android.com/source/developing.html|Android development process]]. Each project consist of an XML file that describes which repositories to use, and how to lay them out to make a buildable system.

The available projects so far are:

 * [[https://github.com/seL4/verification-manifest|verification]], the seL4 proofs.

 * [[https://github.com/seL4/sel4test-manifest|seL4test]], a test suite for seL4, including a Library OS layer.

 * [[https://github.com/seL4/camkes-manifest|CAmkES]], a component architecture for embedded systems based on seL4. See the CAmkES pages for more documentation about CAmkES.

 * [[https://github.com/seL4/camkes-vm-manifest|VMM]] a componentised virtual machine monitor for ia32 platforms using Intel VT-X and VT-D extensions.

 * [[https://github.com/seL4/refos-manifest|RefOS]], a reference example of how one might build a multi-server operating system on top of seL4. It was built as a student project.

Other projects may be added later.

=== Supported Target Platforms ===

Read the [[Hardware]] pages to see a list of supported platforms, and special instructions for particular hardware platforms.

== Setting up your machine ==
These instructions are for Ubuntu. They assume you already know the basics of using the command line, compilers and GNU Make.

=== Getting the source code ===
==== Get Google's "Repo" tool ====
Repo is a tool by Google used for managing multiple git repositories. All the SEL4 related projects use multiple subprojects, and Repo will fetch all of them and place them in the correct subdirectories for you. [[http://source.android.com/source/downloading.html#installing-repo|Get repo here]].

==== Using Repo to fetch an SEL4 project and its subprojects ====
Choose a project to start with. As an example, we'll use sel4test.

 * When fetching a project, look for the GIT repository from Github, whose title has "-manifest" appended to it. So instead of fetching the "sel4-tutorials" GIT repository on Github, we'll fetch the "sel4-tutorials-manifest" repository. The difference is that the "-manifest" repository is meant to tell Repo how to fetch the subprojects and set up the source tree.
 * First create a directory for Repo to work in, then enter it and initialise it using Repo:

{{{
mkdir seL4test
cd seL4test
repo init -u https://github.com/seL4/sel4test-manifest.git
}}}
To get the actual project and subproject source, you'll then need to use repo sync, which will then clone and checkout the project and all the required subprojects.

{{{
repo sync
}}}
=== Getting cross compilers ===
There are instructions on how to get cross compilers for building ARM. We only have direct instructions for Debian/Ubuntu/Fedora, but we imagine you should be able to substitute where necessary for your distro. Instructions should be similar for other distros, links to toolchains for other distros are provided.

 * [[SetupFedora|Cross compiler and general instructions for Fedora and CentOS (RHEL should work as well)]]
 * [[SetupUbuntu|Cross compilers for Debian and Ubuntu]]

=== Build Dependencies ===
The build dependencies for SEL4 can be found in the {{{Prerequisites.md}}} ([[https://github.com/SEL4PROJ/sel4-tutorials/blob/master/Prerequisites.md|Click!]]) file in the root of the SEL4-tutorials GIT repository.

== Start with the SEL4 tutorials ==
The SEL4 tutorials are an excellent, holistic introduction to the design of SEL4, and also to preparing to develop for SEL4, and they are also used internally to train new SEL4 interns. You are strongly encouraged to complete the tutorials if you are new to SEL4: they will quickly bring you up to speed and ready to practically contribute.

=== Getting the SEL4 Tutorial source [Repo tool] ===
If you don't have Repo, scroll up and read the earlier sections on Repo, on this very page.

{{{
mkdir sel4-tutorials-manifest
cd sel4-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest -m sel4-tutorials.xml
repo sync
}}}
=== Using the SEL4 tutorial ===
The top of the source tree contains the kernel itself, and the actual tutorials are found in the subfolder: "{{{projects/sel4-tutorials}}}". The tutorial consists of some pre-written sample applications which have been deliberately half-written. You will be guided through filling in the missing portions, and thereby become acquainted with the SEL4 thought and design paradigm. For each of the sample applications however, there is a completed solution that shows all the correct answers, as a reference. In addition, for each of the "TODO" challenges in the tutorial, there is a Wiki page section that covers it (not this page: the pages are linked below).

 * The half-written sample applications are in the subfolder: {{{apps/}}}. Your job is to fill these out.
 * The completed sample applications showing the solutions to the tutorial challenges are in the subfolder: {{{projects/sel4-tutorials/solutions/}}}.
 * The slide presentations to guide you through the tutorials are in the following files:
  * {{{projects/sel4-tutorials/docs/seL4-Overview.pdf}}}: This is an overview of the design and thoughts behind SEL4, and we strongly recommend you read it before starting the tutorials.
  * {{{projects/sel4-tutorials/docs/seL4Tutorial.pdf}}}: This is the actual tutorial.
 * Detailed explanations of each "TODO" challenge:
  * [[seL4 Tutorial 1]] wiki page.
  * [[seL4 Tutorial 2]] wiki page.
  * [[seL4 Tutorial 3]] wiki page.
  * [[seL4 Tutorial 4]] wiki page.

== Move on to the CAmkES tutorial ==
=== Getting the CAmkES Tutorial source [Repo tool] ===
If you don't have Repo, scroll up and read the earlier sections on Repo, on this very page. Both the SEL4 tutorials and the CAmkES tutorials are synched from the same manifest repository, but they use different manifest .xml files and are separate projects.

{{{
mkdir camkes-tutorials-manifest
cd camkes-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest -m camkes-tutorials.xml
repo sync
}}}
=== Using the CAmkES tutorial ===
These tutorials work similarly to the SEL4 tutorials in that they are guided by a slide presentation. There are half-completed sample applications, with a set of slides giving instructions, with TODO challenges once again. There are also completed sample solutions.

There are however no detailed explanations of each TODO challenge for the CAmkES tutorials, as yet.

 * The half-written sample applications are in this folder: {{{apps/}}}.
 * The solutions can be found in this subfolder: {{{projects/sel4-tutorials/solutions/}}}.
 * The slide presentations to guide you through the tutorials are in this file: {{{projects/sel4-tutorials/docs/CAmkESTutorial.pdf}}}.

== Get acquainted with SEL4Test ==
Any changes you make to SEL4 should pass the tests in SEL4 Test, and pull requests to SEL4 which are non-trivial or related only to documentation, should come with a matching pull request and new test (if applicable) to the SEL4Test repository as well.

=== Getting the SEL4 Test source code ===
If you don't have Repo, scroll up and read the earlier sections on Repo, on this very page.

{{{
mkdir seL4test
cd seL4test
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
}}}
=== Build ia32 ===
We will now build seL4test for ia32, to run on the QEMU simulator.

{{{
make ia32_simulation_release_xml_defconfig
}}}
This copies {{{configs/ia32_simulation_release_xml_defconfig}}} to {{{./.config}}}, and sets up various header files.

You can look at the configuration options using

{{{
make menuconfig
}}}
Alternatively you can use any text editor to change   {{{./.config}}}; if you change anything you need to   rebuild header files with {{{make oldconfig}}}. It's   advisable also to make clean to clear out anything   already built — the build system does not track as many dependencies as it ought to.

For the ia32 target you should not have to change anything. For   ARM targets you may need to change the {{{cross-compiler prefix}}} in the menuconfig under toolchain options

When you've configured the system, you can build by doing

{{{
make
}}}
Currently parallel builds do not work, so don't try to speed   things up by using -j. The build system does however   support ccache if you have it installed.

=== Simulate ia32 ===
The makefile provides a target to simulate ia32. Running the following command will run qemu and point it towards the image we just built.

{{{
make simulate-ia32
}}}
To exit qemu after the All is well in the universe   message that indicates the test suite has passed, type {{{control-a x}}}.

=== Useful configuration options ===
For cross compilation (targeting ARM), you can set the cross compiler triple. This will typically be '''arm-linux-gnueabi-''' or '''arm-none-eabi-'''.   Do {{{make menuconfig}}} and look for '''toolchain-options'''

Some of the default configurations specify a particular x86 compiler. It is usually safe to set the triple to the empty string when building for x86, if you have a multilib gcc installed.

Fiddling with most of the other configuration options will lead to systems that will either not compile, or not run.

=== Caveats ===
==== kzm simulation hangs ====
qemu does not simulate all the timers needed for a full sel4 test run. Use the '''kzm_simulation_configurations''' to avoid tests that rely on unimplemented timers.

==== arm-none-eabi ====
If you use '''arm-none-eabi''' compilers, the prebuilt libraries will fail to link, with a message something like

{{{
/usr/lib64/gcc/arm-none-eabi/4.8.1/../../../../arm-none-eabi/bin/ld: warning: /usr/src/seL4test/stage/arm/imx31/lib/libmuslc.a(internal.o) uses 32-bit enums yet the output is to use variable-size enums; use of enum values across objects may fail
}}}
To fix, do {{{make menuconfig}}} visit {{{seL4 Libraries→Build musl C Library}}} and untick {{{libmuslc use precompiled archive}}} then do {{{make clean}}} and attempt to rebuild.

=== hard float compilers ===
The default configuration on newer compilers from Debian and Ubuntu use hardware floating point. Binaries built with these compilers are incompatible with the prebuilt musl C library. You can either tweak the flags (in {{{tools/common/Makefile.flags}}}: add {{{-mfloat-abi=soft}}} to '''NK_CFLAGS''') or disable the use of the prebuilt libraries as above.

== Project Layout ==

Each project has an associated wiki, accessible via github, that   has up-to-date dependencies and instructions. The general   instructions here apply to all projects.

See [[BuildSystemAnatomy|Build System Anatomy]] for details of project layouts and the seL4 build system.

Configuration files in the configs directory are named by target machine, then something about what they do. Most have either   `release` or `debug` in their names. Debug kernels are built with   debug symbols (so one can use gdb), enable   assertions, and provide the sel4debug interfaces to allow debug   printout on a serial port.

Some configurations are intended to run under qemu. Because qemu   does not produce a completely faithful emulation of the hardware,   sometimes features have to be disabled or worked around. These   configurations have ‘simulation’ in their names.

=== Build configuration ===
Prior to building a project you need to specify a configuration (settings, components, etc.) that you want to build. Kconfig is a tool for simplifying and automating this process. In a seL4 project you can enter make menuconfig in the top level directory to be presented with a terminal menu for choosing which components to build. Note that you will need the package libncurses5-dev installed to display terminal menus. It is possible to select a configuration without using the terminal menus, but techniques for doing this are not discussed on this page.

{{attachment:menuconfig.png|The menu config interface|width=600}}

Use arrow keys and Enter to navigate the menu, Space bar to select/deselect items and Esc-Esc to return to the parent level in the menu hierarchy. On exiting the menu system you will be asked whether you wish to save your configuration. If you choose to do so it will be written to the file .config in the top level directory.

Many projects will have a default list of configurations for building common scenarios. These are located in the configs/ directory. You can load one of these by running make config_file where config_file is the filename of the configuration you want to load. Whenever you load one of these pre-made configurations it is usually wise to run make silentoldconfig. This scans your project for configuration settings that have changed since the pre-made configuration was created and updates the configuration with the defaults of these changed settings. This is not always what you want, but it generally works.

Your current configuration is stored in the file .config. This file looks like a Makefile fragment and that is actually exactly how it is used by build system when it comes time to build your project. One gotcha to be aware of is that the comments in this file aren't completely comments, which you will find out if you try to edit them. Kconfig parses these comments and will throw all manner of strange errors if it thinks one is malformed.

Pre-made configurations are stored in configs/. To make a new configuration, pick the settings you want in the menus then copy your .config to configs/. Note that all the configurations in this directory must end in _defconfig for the build system to identify them correctly.

The other file(s) you will want to care about is Kconfig. These files tell Kconfig how to construct the menu hierarchy. A formal description of the Kconfig options and syntax can be found at http://kernel.org/doc/Documentation/kbuild/kconfig-language.txt. Symbols are defined by using the 'config' statement. These symbols are given the prefix 'CONFIG_' when the configuration is written to the .config file.

== Running on real hardware ==

See [[Hardware]].

= Contributing to SEL4 =

Gernot's presentation: "[[https://www.youtube.com/watch?v=lRndE7rSXiI|SEL4 is free: What does this mean for you? (2015)]]" outlines areas where the kernel could use some contributions – other than that, gauging what you can do externally is for the time being, difficult. If you have ideas, please feel free to visit the NICTA mailing lists and chime in:

 * [[https://sel4.systems/lists/listinfo/announce|SEL4 Announce]].
 * [[https://sel4.systems/lists/listinfo/devel|SEL4 Devel]].

= Learn more about SEL4 =
For someone just getting to know about SEL4 and wanting to first at least understand how to build it, so that you can get comfortable with editing the source code, the following pre-init steps might help you get more context, before you try building, so you have at least a conceptual understanding of exactly what sort of creature you're about to step into the arena with. These are '''not''' pre-requisites for building the kernel, but they will help you a lot in understanding what you're dealing with.

== SSRG/NICTA publications ==
The SSRG group at NICTA has published a long list of papers on the SEL4 kernel, documenting every design decision and the justifications for each one. Consider trying to read some of them, or at least scrolling through the list, and picking out the most eye-catching titles and skimming them. You can find a long list of SEL4 publications here:

[[http://ssrg.nicta.com.au/projects/seL4/|The SEL4 project page at NICTA]].

== Youtube videos ==
 * Gernot Heiser outlines several areas where the kernel is looking for good Samaritans toward the end of this presentation, "[[https://www.youtube.com/watch?v=lRndE7rSXiI|SEL4 is free: What does this mean for you? (2015)]]". If you were looking for externally available information on the status of SEL4, you probably ran across that presentation yourself.
 * In addition, this youtube video shows Gernot giving a presentation on SEL4's context and position in the timeline of L4 microkernel research: "[[https://www.youtube.com/watch?v=RdoaFc5-1Rk|From L3 to SEL4: What have we learned in 20 years of L4 microkernels? (2014)]]".
