# Suggested Projects


After trying the existing projects (especially [[Getting started|seL4
test suite]]) a good way to learn the intricacies of programming on
top of seL4 is to do the exercise in the
[UNSW Advanced
Operating Systems course](http://www.cse.unsw.edu.au/~cs9242/current/).

# Possible Projects


Below is a set of suggested projects of varying degree of
sophistication. If you're interested in providing generally-useful
infrastructure, you're probably best off basing this on the CAmkES
environment.

If you are planning to produce a significant and long-lived part of the
seL4 open-source ecosystem (as opposed to just having fun for yourself)
you should talk to us first. We run frequent student and occasionally
larger development projects, and may already have something that can
serve as a starting point. We will in the future try to be more
pro-active in seeding projects with incomplete internal work.

## Ports to other platforms


seL4 currently runs on only a small set of platforms. Porting seL4
itself is usually pretty easy; porting the platform support library and
its drivers is trickier.

Some interesting platforms that could support seL4 include:

- Any of the Tegra S\`\`oCs from NVIDIA.
- The RK3188, maybe using the [Radxa Rock Pro](http://radxa.com/Home) development board
- Any of the Arm V8 64-bit processors that are beginning to
      become available.

## Qubes


[Qubes](https://qubes-os.org/) is an open source operating
system designed to provide strong security for desktop computing using
virtualisation to provide isolation. Qubes is based on Xen. seL4 is a
much better fit for Qubes. The project is to port Qubes to seL4 (or
develop an alternative Qubes-like system for seL4).

## Bug fixes and enhancements


The build system needs work. A typical project comprises the kernel,
libraries and apps; dependencies between these are not properly tracked,
which means things are rebuilt even if up-to-date; also sometimes things
are not rebuilt when they should be.

There are other problems with the system as a whole that need
addressing. In particular the drivers in libsel4platsupport need
extension and improvement.

## Useful Components


Drivers, file systems, useful libraries... Especially a POSIX
environment would be useful.

## Port Doom


Port the PC game
[Doom](https://en.wikipedia.org/wiki/Doom_(1993_video_game)) to
run on seL4.

## Minix 3 on seL4


Minix is the original multi-server OS by Tannenbaum.
[Minix 3](http://www.minix3.org/) is the latest shiny version
of it, and is based on a more limited microkernel than seL4. So far x86
is supported.

The project is to port Minix 3 to run on seL4.

## Language Support


Userspace currently needs to be written in C (or assembler). An
interesting challenge is to provide run-time support for higher level
languages, such as C++, Java, Go, Haskell, Python. Some of that exists
internally:

- reasonably mature support for a subset of C++ (no template
      library), we'll probably release that soon for others to build on
- we have Haskell sort-of running on seL4 (thanks or friends from
      [Galois](https://galois.com/) for their help), should be
      released in the near future
- there is a student-level port of Go, which is bitrotted but could
      be made available if someone wants to revive it
- limited support of Rust applications

## Stuff we're working on


Kernel development will continue to happen primarily at NICTA for the
foreseeable future, as this not only requires a good understanding of
the kernel design and implementation, but also a good understanding of
what is feasible to verify. Several of these internal projects are
reasonably mature and will be pushed into the public tree soon, see our
[Roadmap](http://sel4.systems/Info/Roadmap/)
