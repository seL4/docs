---
title: The Proofs
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# The seL4 Proofs

The formal proofs for seL4 are hosted at <https://github.com/seL4/l4v>.

They are written in the [Isabelle/HOL][1] theorem prover, and some
familiarity with this tool is required to understand them. There are many
learning resources available for Isabelle -- see the Isabelle website for
tutorials and reference manuals, and [this blog][2] post for a list of what
you'd need to really get deep into the proofs.

There are also many publications about these proofs, some of which are fairly
complex. A comprehensive technical overview is available in the [2014 TOCS
paper][4]. It's been a few years since then, but the technical concepts are
still current.

The repository [README file][3] shows which proofs are where, and how to set
up your machine to run them. You can run and check that the proofs work for a
specific version of seL4 without a deep understanding of their content --
that is one of the advantages of machine-checked proofs.

We're planning to add more pointers to this page on how to get started on
smaller contributions. Stay tuned for updates and feel free to raise pull
requests to add more information yourself!

[1]: http://isabelle.in.tum.de
[2]: http://proofcraft.org/blog/proof-engineer-reading.html
[3]: https://github.com/seL4/l4v/blob/master/README.md
[4]: https://trustworthy.systems/publications/nictaabstracts/Klein_AEMSKH_14.abstract
