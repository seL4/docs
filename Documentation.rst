= Documentation =
== Kernel ==

 * [[http://ssrg.nicta.com.au/publications/nictaabstracts/Klein_AEMSKH_14.abstract.pml||Technical overview paper]]
 * [[https://ts.data61.csiro.au/publications/nictaabstracts/Heiser_Elphinstone_16.abstract.pml|L4 Microkernels: The Lessons from 20 Years of Research and Deployment]], a retrospective explaining how we got to where we are;
 * [[Getting started]]
 * [[http://ssrg.nicta.com.au/projects/seL4/|NICTA seL4 research project pages]]
 * [[https://www.cse.unsw.edu.au/~cs9242/14/lectures/|UNSW Advanced OS lecture slides]], especialy the Introduction and Microkernel Design lectures
 * [[https://github.com/seL4/seL4/releases/latest|Release download page]] for the current release.
 * [[http://sel4.systems/Info/Docs/seL4-manual-latest.pdf|Manual]] for the current release.

=== Building the manual for a specific version ===

To get the latest version of the manual, checkout the seL4 source code then:

{{{
cd manual && make
}}}

You need LaTeX and doxygen installed, and if all succeeds a fresh manual will be produced in manual.pdf. 

== Proofs ==

 * [[http://sel4.systems/Info/Docs/seL4-spec.pdf|Formal specification]]
 * [[http://github.com/seL4/l4v/|Git Repository and Build instructions]]
 * [[http://ssrg.nicta.com.au/projects/TS/|NICTA Trustworthy Systems research project pages]]
 * Isabelle Proof Assistant:
  * [[http://concrete-semantics.org/|Concrete Semantics Isabelle textbook]]
  * [[http://isabelle.in.tum.de/website-Isabelle2013-2/dist/Isabelle2013-2/doc/tutorial.pdf| Isabelle 2013-2 tutorial]]
  * [[http://isabelle.in.tum.de/|Isabelle website]]
  * [[http://stackoverflow.com/questions/tagged/isabelle|Isabelle on Stack Overflow]]
