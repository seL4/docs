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
  * {{{projects/sel4-tutorials/docs/seL4-APILib-details.pdf}}}: This is the actual tutorial.
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
