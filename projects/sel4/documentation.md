---
redirect_from:
  - /Documentation
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Documentation
## Kernel

- [Technical overview paper](https://trustworthy.systems/publications/nictaabstracts/Klein_AEMSKH_14.abstract)
- [L4 Microkernels: The Lessons from 20 Years of Research and Deployment](https://trustworthy.systems/publications/nictaabstracts/Heiser_Elphinstone_16.abstract),
  a retrospective explaining how we got to where we are;
- [Getting started](/GettingStarted)
- [Data61/CSIRO seL4
      research project pages](https://trustworthy.systems/projects/seL4/)
- [UNSW Advanced OS lecture slides](https://www.cse.unsw.edu.au/~cs9242/14/lectures/), especialy the Introduction and
      Microkernel Design lectures
- [Release download page](https://github.com/seL4/seL4/releases/latest) for the current release.
- [Manual](http://sel4.systems/Info/Docs/seL4-manual-latest.pdf)
      for the current release.
- [Explanation of how the API docs in the manual are generated](/seL4ManualAPIGeneration)

### Building the manual for a specific version


To get the latest version of the manual, checkout the seL4 source code
then:

` cd manual && make `

You need LaTeX and doxygen installed, and if all succeeds a fresh manual
will be produced in manual.pdf.

## Proofs


- [Formal specification](http://sel4.systems/Info/Docs/seL4-spec.pdf)
- [Git Repository and Build
      instructions](http://github.com/seL4/l4v/)
- [CSIRO's Data61 Trustworthy
      Systems research project pages](https://trustworthy.systems/projects.html)
- Isabelle Proof Assistant:

  -   [Concrete Semantics Isabelle textbook](http://concrete-semantics.org/)
  -   [Isabelle website](http://isabelle.in.tum.de/)
  -   [Isabelle on Stack Overflow](http://stackoverflow.com/questions/tagged/isabelle)


