# Contributing to upstream seL4 projects


## Contributor license agreement:


We welcome contributions to the seL4 project. However, the copyright
holders require us to have on file a signed Contributor Licence
Agreement for all contributions.

The Licence agreement certifies:

:   -   That you have the rights to give us the contribution, and
    -   That you give us the rights to use your contribution.

Please sign the
\[\[<https://sel4.systems/Community/Contributing/seL4-CLA.pdf%7CContributor>
License Agreement\]\], scan it and send it to us at ''licensing AT
sel4.systems.''

{{ <http://i.imgur.com/kuAok5A.png> }} ==== Figure 1 ====

We have two main groups of publicly hosted projects: the first group is
the set of repositories found at <https://github.com/sel4>. The second
group is that found at <https://github.com/sel4proj>.

All submissions to repositories under <https://github.com/sel4> require
a CLA. All submissions to repositories under
<https://github.com/sel4proj> do not require a CLA.

## General:


Please see figure 1: the “master” branch of all of our repositories
points to the bleeding edge of the source code. Internally, we have
continuous integration which tests the master branch and some other
internal branches before pushing them out to Github. But not all
combinations of various repositories and libraries are guaranteed to be
in sync at the tip of “master”. If you want to use a known, stable build
of a project, then you might want to consider checking out a named
version tag of that repository’s manifest. For example, in the
“[camkes-manifest](https://github.com/seL4/camkes-manifest)”
repository, there are several versioned manifests such as
“default-2.0.x.xml”, “default2.1.x.xml” and so on.

You want to pass the name of the manifest to your “repo init” command,
similar to:

''“repo init -u &lt;MANIFEST\_REPO\_CLONE\_URL&gt; -m
&lt;VERSIONED\_MANIFEST\_FILENAME&gt;”''

Code being on the master branch '''does not imply''' that it has been
formally verified. The verified build of the kernel is currently I.MX7
Sabre platform on ARM. To see which code is verified, please have a look
at \[\[<https://wiki.sel4.systems/Hardware%7Cour> verified
platforms\]\].

## User-level code:


The story is different for most user-level code. While we are working on
verifying some of this, and are likely to adopt a similar model as for
the kernel for such components, most user-level code is '''not likely to
be verified in the foreseeable future'''. Many of the user-level
components are suitable for a truly open development model, and we will
be happy to hand control to a suitable external maintainer for many of
those. Our priority is on building an ecosystem and easing deployment of
and with the system.

See [Suggested Projects](https://sel4.systems/Info/Projects/)
for suggestions on where to contribute.
