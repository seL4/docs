= seL4 and CAmkES tutorials =

First make sure you have [[https://wiki.sel4.systems/Getting%20started#Setting_up_your_machine|set up your machine]].

<<TableOfContents()>>

== Prerequisites ==

The build dependencies for seL4 can be found in the {{{Prerequisites.md}}} ([[https://github.com/SEL4PROJ/sel4-tutorials/blob/master/Prerequisites.md|Click!]]) file in the root of the SEL4-tutorials GIT repository.

== seL4 tutorials ==

These tutorials get you started with writing dynamic systems and interacting directly with seL4 and our libraries. 

=== Get the code ===

{{{
mkdir sel4-tutorials-manifest
cd sel4-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest -m sel4-tutorials.xml
repo sync
}}}

=== Do the tutorials ===

The top of the source tree contains the kernel itself, and the actual tutorials are found in the subfolder: "{{{projects/sel4-tutorials}}}". The tutorial consists of some pre-written sample applications which have been deliberately half-written. You will be guided through filling in the missing portions, and thereby become acquainted with seL4. For each of the sample applications however, there is a completed solution that shows all the correct answers, as a reference. In addition, for each of the `TASK` challenges in the tutorial, there is a Wiki page section that covers it, listed below.
 * The half-written sample applications are in the subfolder: {{{exercises/}}}. Your job is to fill these out.
 * The completed sample applications showing the solutions to the tutorial challenges are in the subfolder: {{{projects/sel4-tutorials/solutions/}}}.
 * The slide presentations to guide you through the tutorials are in the following files:
  * {{{projects/sel4-tutorials/docs/seL4-Overview.pdf}}}: This is an overview of the design and thoughts behind seL4, and we strongly recommend you read it before starting the tutorials.
  * {{{projects/sel4-tutorials/docs/seL4-APILib-details.pdf}}}: This is the actual tutorial.
 * Detailed explanations of each tutorial challenge:
  * [[seL4 Tutorial 1]] 
  * [[seL4 Tutorial 2]]
  * [[seL4 Tutorial 3]] 
  * [[seL4 Tutorial 4]] 
  * [[seL4 Timer tutorial]]
  * [[seL4 RT tutorial|seL4 MCS tutorial]]  

== CAmkES tutorials ==

These tutorials get you started with our component system CAmkES, which is allows you to configure static systems through components. CAmkES generates the glue code for interacting with seL4. 

=== Get the code ===

{{{
mkdir camkes-tutorials-manifest
cd camkes-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest -m camkes-tutorials.xml
repo sync
}}}

=== Do the tutorials ===

These tutorials work similarly to the SEL4 tutorials in that they are guided by a slide presentation. There are half-completed sample applications, with a set of slides giving instructions, with TASK challenges once again. There are also completed sample solutions.

There are however no detailed explanations of each TASK challenge for the CAmkES tutorials, as yet.

 * The half-written sample applications are in this folder: {{{apps/}}}.
 * The solutions can be found in this subfolder: {{{projects/sel4-tutorials/solutions/}}}.
 * The slide presentations to guide you through the tutorials are in this file: {{{projects/sel4-tutorials/docs/CAmkESTutorial.pdf}}}.

== What next? ==

You can try building and running [[Testing|seL4test]]
