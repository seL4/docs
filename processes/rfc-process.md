---
title: "The RFC Process"
redirect_from:
  - /RfcProcess
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

## Requests for Comments (RFCs)

The seL4 foundation uses the request for comments (RFC) process to

- allow the community to discuss design changes in seL4,
- gather valuable feedback from the community on changes the foundation is
  considering,
- allow members of the seL4 community to get support and approval to propose and
  implement their own changes to the seL4 ecosystem,
- ensure that all changes made to core components of the seL4 ecosystem or that
  have wide and varying impacts on users of seL4 undergo rigorous review, and
- ensure large changes are well advertised and can viewed publicly before
  contributors commit to implementing them.

This helps the seL4 community ensure that such changes are made with the goal of
the best outcome for the most users of seL4 without compromising seL4's
high-assurance properties of functional correctness, isolation, and security.

## The Process

See the [seL4 RFC repository] for how the process works, when to use it and when
not to use it.

When you are ready to propose a new RFC, please follow the [template
instructions] in the RFC repository.

## Approved and proposed RFCs

The approved RFCs are collected and rendered in the [seL4 RFC book].

You can also browse the currently [proposed RFCs] and their discussions.

[seL4 RFC repository]: https://github.com/seL4/rfcs/
[template instructions]: https://github.com/seL4/rfcs/blob/main/0000-template.md?plain=1
[seL4 RFC book]: https://sel4.github.io/rfcs/
[proposed RFCs]: https://github.com/seL4/rfcs/pulls?q=is%3Aopen+is%3Apr+-label%3Anot-rfc+
