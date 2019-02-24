---
title: "The RFC Process"
author: 
  - "Curtis Millar <curtis.millar@data61.csiro.au>"
---

We have introduced
the request for comments (RFC) process
for the following reasons:

- to allow the us to discuss design changes
  in a manner transparent to the community,
- to gather valuable feedback from the community
  on changes we are considering,
- to allow members of the seL4 community
  to get support and approval
  to propose and implement their own changes
  to the seL4 ecosystem,
- to ensure that all changes
  made to core components of the seL4 ecosystem
  or that have wide and varying impacts on users of seL4
  undergo rigorous review, and
- to ensure large changes are well advertised
  and can viewed publicly
  before we commit to them.

This helps us to ensure that such changes are made
with the goal of the best outcome for the most users of seL4
whilst maintaining our guarantees of isolation and security.

To see all current RFCs, go check out the [RFC dashboard][].

You can also stay notified
of new RFCs and updates to RFCs
by joining the [RFC miling list][].
You can then use you [Atlassian Cloud][] account
to keep track of and contribute to discussion
on each of the RFCs.

[RFC dashboard]: https://sel4kernel.atlassian.net/secure/Dashboard.jspa?selectPageId=10100
[RFC mailing list]: https://sel4.systems/lists/listinfo/rfc


# When to follow the RFC process

All substantial changes to the seL4 ecosystem
must be made using the RFC process.
Substantial changes are those that that
impact a large number of users of seL4
in a way that may require them to change their own projects,
changes the operation of toolchain used to build projects on seL4,
changes the underlying model of one or more software components
within the ecosystem.

Examples of changes that must follow the RFC process include:

{% comment %}
Over time this list may change,
as we find certain kinds of changes
should be made via the RFC process
to benefit from the wider publicity
and the documentation artefact it generates.
{% endcomment %}

* removing support for a platform, and
* changing the versioning system used for libraries.

Changes such as bug-fixes, refactorings, optimistions,
or those that do not affect the functional requirements
of the kernel, supporting tooling, infrastructure,
or system components
can be made through the existing pull-request process
on the relevant repository.

Examples of changes that should not involve the RFC process include:

* Fixing a typo in existing code,
* Clarifying code or documentation,
* Adding a driver to an existing layer of the system.

If you try to make a substantial change
via the pull-request process,
or submit a pull-request that would result in such a change,
your request will be rejected
and you will be asked to use the RFC process
to propose your change.

If you are unsure whether a change requires an RFC,
ask on the [IRC channel][]
or post a question to the [mailing list][].

# The RFC Process


## Before creating a new RFC

Before proposing a new RFC
it is important to determine whether it will be supported
and what possible options exist
to solve the particular problem.

This should be done through discussion
one one of the many community forums
such as the [IRC channel][]
or the [mailing list][].

This part of the process should help you determine
whether your idea has already been proposed,
whether or not it fits with the near-term goals of the ecosystem,
and how to propose it with the best chances of acceptance.

You should make sure that during this discussion
you address each of the sections in the template below.
This will ensure that your proposal is well prepared
before it is formally presented as an RFC
and will speed up much of the RFC process.

Once you have the support of some existing seL4 developers
they can help you take your idea
through the rest of the RFC process.

[IRC channel]: ./IRCChannel.html "seL4 IRC channel"
[mailing list]: https://sel4.systems/lists/listinfo/ "seL4 mailing list"


## Proposing an new RFC

An RFC exists in the form of an RFC _issue_
on the [RFC project][] of the seL4 [Jira][] instance.
Anyone who has an [Atlassian Cloud][] account
is able to create an RFC.

You should check the postponed RFCs
to see if your idea has already been proposed
but was previously postponed.
You can adopt a postponed RFC
which will return it to the proposal stage
and you will become responsible for it.

Once you create an RFC,
you are the one responsible for maintaining it
throughout the approval process.
You will be able to modify it
in response to discussion and feedback
up until the point it is either approved or rejected.

Every RFC should use the template below,
omitting sections that are not relevant for the RFC.

[Jira]: https://sel4kernel.atlassian.net/ "seL4 Atlassian Cloud"
[RFC project]: https://sel4kernel.atlassian.net/browse/RFC "seL4 RFCs"
[Atlassian Cloud]: https://id.atlassian.com/ "Atlassian Cloud Login"


### The RFC template

You should consider each section of the RFC template in depth
before determining that it is not relevant.

You will probably want to work on this offline
during the initial discussion
so that you can paste the final document
into the issue description
when you create the RFC issue.

{% comment %}
This template has been taken from the Rust RFCs repository 
(https://github.com/rust-lang/rfcs) under the following MIT license:

Permission is hereby granted, free of charge, to any
person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the
Software without restriction, including without
limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice
shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF
ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT
SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
{% endcomment %}

```wiki
h1. Summary

One paragraph explanation of the change.

h1. Motivation

- Why are we doing this?
- What use cases does it support?
- What is the expected outcome?

h1. Guide-level explanation

Explain the change or feature as you would to another user of seL4.

This section should clearly outline new named concepts, provide some examples of how it will be used, and explain how users should *think* about it.

You should describe the change in a manner that is clear to both existing seL4 users and to new users of the ecosystem.

Any changes that existing users need to make either as a result of the RFC or such that the can use the feature should be clearly stated here.

h1. Reference-level explanation

Explain the change or feature as you would to the maintainers of the seL4 ecosystem.

This section should provide sufficent technical detail to guide any related implementation and ongoing maintenance.

This section should clearly describe how this change will interact with the existing ecosystem, describe particular complex examples that may complicate the implementation, and describe how the implementation should support the examples in the previous section.

h1. Drawbacks

Outline any arguments that have been made against this proposal and discuss why we may not want to accept it.  Also discuss any complications that may arise from the proposed change that may require specific consideration.

h1. Rationale and alternatives

- Why is this design the best in the space of possible designs?
- What other designs have been considered and what is the rationale for not choosing them?
- What is the impact of not doing this?

h1. Prior art

Discuss prior art, both the good and the bad, in relation to this proposal.  A few examples of what this can include are:

- For ecosystem proposals: Does this feature exist in similar systems and what experience have their community had?
- For community proposals: Is this done by some other community and what were their experiences with it?
- What lessons can we learn from what other communities have done here?
- Are there any published papers or great posts that discuss this?  If you have some relevant papers to refer to, this can serve as a more detailed theoretical background.

This section is intended to encourage you as an author to think about the lessons from other systems, provide readers of your RFC with a fuller picture.  If there is no prior art, that is fine - your ideas are interesting to us whether they are brand new or if it is an adaptation from other systems.

Note that while precedent set by other systems is some motivation, it does not on its own motivate an RFC.

h1. Unresolved questions

- What needs to be resolved in further discussion before the RFC is approved?
- What needs to resolved during the implementation of this RFC?
- What related questions are beyond the scope of this RFC that should be addressed beyond its implementation?
```


## Getting an RFC approved

After you propose an RFC,
it will undergo several rounds of changes
in response to the discussion on [Jira][].
The development team will hold offline meetings
to discuss the change as a group.
A summary of these meetings will be added
to the discussion of the RFC.

Once general consensus in the discussion on [Jira][] has been reached
and the seL4 development team agree on an outcome,
the RFC may either be approved or rejected.
When this occurs, a _disposition_ will be added to the RFC
outlining the reason for the particular ruling.
If the discussion of an RFC has been particularly long,
a summary comment will be made on the RFC
before the given ruling is made.

### Postponement of an RFC

When an RFC has a moderate amount of support
and is generally accepted as a good idea
but lacks someone to shepherd it
to the point where it can be accepted
it is _postponed_.

This indicates that the RFC may be revived in the future
when someone can be found to take it through
the remainder of the approval process.
Anyone may _adopt_ a postponed RFC
if they wish to see it approved
and want to rally support for it.


## Implementation of an approved RFC

Once seL4 development team aprroves an,
it becomes their responsibility
and is marked as _active_.
They may then assign it to a developer for implementation.
Issues for the implementation of all of the necessary components
will be created and linked to the RFC.

The implementation of an RFC
may lead to the resolution of many issues
that were present in the RFC
when it was approved.
As such, the RFC may be subject to further changes
throughout this part of the process.
These changes should not change
the overall goals or design of the RFC
but should merely resolve issues
or extend the design to cope
with unanticipated corner cases.


### Deferment of an approved RFC

There may not be sufficient resources
to implement an RFC when it is approved
or resources may be diverted
from the implementation of an RFC
when higher priority work arises.
In either case, the RFC will be _deferred_.
A _deferred_ RFC is lower priority than an _active_ one
and will generally see no progress on its implementation.

Anyone can request that a _deferred_ RFC be given priority
be demonstrating increased demand or urgency
for its implementation.
Generally, a _deferred_ RFC
will be given preference for implementation
in favour of approving a new RFC.
