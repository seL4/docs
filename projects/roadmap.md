---
toc: true
layout: api
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# seL4 Project Roadmap

The seL4 project roadmap lists larger planned contributions to the seL4
ecosystem, such as new architecture ports, new large formal verifications,
large or fundamental new features, user-level frameworks, or components with
general interest to the community.

The purpose is to provide a timeline to the community of when larger
contributions will become available with a reasonable level of commitment,
and for contributors to advertise to others which larger contributions they
are working on.

Features that are *in progress* are currently being worked on, features that
are *planned* have not yet had work started on them.

To put a feature on the roadmap, the respective contributor will have made a
commitment to delivering it, but these are not contracts &mdash; **any dates
are indicative and subject to change!**

Some features may become available in experimental preview *branches* before
they are merged into the *master* branch. The dates in the table are for the
completion of the feature in *master*. The preview branches may undergo
significant changes before they are merged and may also be abandoned. Some of
these branches may be long-lived, because features can only be merged into
*master* when they are either formally verified or do not affect the verified
configurations of the kernel. Typically, while a larger feature undergoes
formal verification, it will be available in a branch or a non-verified
configuration. Such features often undergo smaller API-level changes while
the verification progresses and either finds flaws or otherwise influences
the design.

In many cases, the roadmap could be accelerated with more funding for the
contributors who work on them, or, in some cases, by volunteering time. If
you are interested, talk to the [seL4 Foundation][] or directly to foundation
members, e.g. when it involves formal verification to [Proofcraft][] or for
major seL4 kernel features to the [Trustworthy Systems][] group.

[seL4 Foundation]: https://sel4.systems/Foundation/About "seL4 Foundation"
[Trustworthy Systems]: https://trustworthy.systems "Trustworthy Systems"
[Proofcraft]: https://proofcraft.systems "Proofcraft"

## seL4 Development

<!-- Draws content from the "roadmap" section in /_data/projects/<project>.yml -->
{% include component_list.md project='sel4' list='roadmap' type='in-progress' %}

## Verification

<!-- Draws content from the "roadmap: section in /_data/projects/<project>.yml -->
{% include component_list.md project='l4v' list='roadmap' type='in-progress' %}

## Adding to the Roadmap

The roadmap is not only for seL4 kernel development or verification itself.
If you are working on a larger feature or addition to the the wider seL4
ecosystem, and are confident enough to commit to a timeline, you can request
this plan to be added to the roadmap on this page.

If you are contracted to deliver a major user-level component, framework, or
feature in the seL4 ecosystem with a delivery date, and ideally an approved
[RFC](../processes/rfc-process) to go with it, your contribution would be
an ideal addition to the roadmap.

A new feature can become a part of the official seL4 roadmap by decision of
the [Technical Steering Committee][TSC] (TSC) of the seL4 Foundation. To
submit a request to the TSC for putting a planned feature on the roadmap,
send an email to any TSC member with a description of the contribution, the
planned timeline, and level of confidence for achieving it, e.g. by pointing
to any related RFC. The TSC will discuss the proposal and either request more
information or vote on it.

[TSC]: https://sel4.systems/Foundation/TSC/
