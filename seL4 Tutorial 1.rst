##master-page:HelpTemplate
##master-date:Unknown-Date
#format wiki
#language en
= Summary: =
This tutorial is a fairly simple introduction to debugging, and doesn't really focus on seL4 itself, but rather on the idea and practice of tracing errors and debugging in a [[http://www.embedded.com/electronics-blogs/programming-pointers/4027541/Freestanding-vs-hosted-implementations|freestanding]] environment.

= Table of Contents =
<<TableOfContents()>>

=== Learning outcomes: ===
 * Reader should become accustomed to the idea of having to debug not only from the perspective of his/her own code, but also with an understanding that there are lower layers beneath him that have a say in whether or not his/her abstractions will work as intended.
 * Reader should become accustomed to the idea that the compiler and language runtime are now part of his responsibility, and s/he should become at least trivially acquainted with the C runtime which he can usually ignore, and debug with it in mind.
 * Offhandedly hints to the reader that s/he should become acquainted with the Kconfig/Kbuild build utilities.

== Walkthrough of TODOs: ==
==== TODO 1: ====
''Corresponding line in tutorial:'' (https://github.com/SEL4PROJ/sel4-tutorials/blob/master/apps/hello-1/src/main.c#L18)

Regardless of the programming language used, every binary that is created must have an entry point, which is the first instruction in the program. In the C Runtime, this is usually "_start()", which then calls some other compiler-specific and platform specific functions to initialize the program's environment, before calling the "main()" function. What you see here is the linker complaining that when _start() tried to call main(), it couldn't find a main() function, because one doesn't exist. Create a main() function, and proceed to the next step in the slides.

This next step is meant to show the user some basics for how to go about debugging in a freestanding environment. Most of the time you'll have to manually step through code, often without the help of a debugger, so this step forces a "Divide by zero" exception and tries to show you how debugging an exception looks. In the real world, in this kind of scenario, you'd usually want to know the instruction that triggered the exception, then find out what that instruction does that is wrong, and fix it.
