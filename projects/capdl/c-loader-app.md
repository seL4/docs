---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
repo_link: https://github.com/seL4/capdl/blob/master/capdl-loader-app/
---

# capDL Loader


This repository contains the capDL initialiser for seL4.

The capDL initialiser is the root task for a seL4 system that takes a
description of the state to be initialised using [capDL][Kuz_KLW_10],
and starts the system in conformance with the specification.

The code is an implementation of the formal algorithm specified
in Isabelle/HOL.

  [Kuz_KLW_10]: https://trustworthy.systems/publications/nicta_full_text/3679.pdf "capDL: A language for describing capability-based systems"

## Repository overview

  * [`src/main.c`]({{page.repo_link}}/src/main.c): The implementation of the initialiser
  * [`include/capdl.h`]({{page.repo_link}}/include/capdl.h): The data structure for capDL.

## Dependencies

The capDL loader uses `capDL-tool` to generate a data structure
containing the capDL specification to be initialised.

## Related papers

The formal model for the capDL initialiser is documented in a
[ICFEM '13 paper][Boyton_13] and Andrew Boyton's [PhD thesis][Boyton_14].

  [Boyton_13]: https://trustworthy.systems/publications/nicta_full_text/7047.pdf "Formally Verified System Initialisation"
  [Boyton_14]: https://trustworthy.systems/publications/nicta_full_text/9141.pdf "Secure architectures on a verified microkernel"

