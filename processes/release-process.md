---
redirect_from:
  - /ReleaseProcess
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Release Process

This page outlines how [seL4 and associated
repositories](/MaintainedRepositories) are released. The goals of this process
are as follows:

- provide a current up to date version of libraries and applications,
- allow developers to decide when to upgrade between versions, i.e choose when breakage happens,
- and provide libraries and apps compatible with each released version.

Currently, we do not guarantee maintenance of previous releases, or individually
version libraries, projects and applications.

## Terminology

- Kernel: the seL4 microkernel source repository
- Libraries: user level libraries that run on seL4
- Applications: applications that run on seL4
- Projects: a collection of applications, libraries, kernel, denoted by a repo manifest
- Proofs: the formal proofs about seL4 in the l4v repository.

## Releases

We have two release channels:

- **Bleeding edge**: These happen whenever any of our maintained project code is
  updated and the tests for it are passing
- **Versioned releases**: Versioned releases of the kernel, proofs, CAmkES,
  Microkit, capDL and Rust support. These happen less frequently.

Bleeding edge releases happen every time the code is updated and it passes the
test suites and proofs. Working on the bleeding edge means that API changes
occur often and user-level dependencies may break without warning. Whenever any
of the sources tracked by the manifests in the repositories below are
updated and the regression tests pass, an updated version of the corresponding
`default.xml` manifest will automatically be committed to the repo indicating
which version combination is confirmed to work.

### Which release should you use?

We recommend you develop on a specific version of the kernel, rather
than the bleeding edge which is the tip of master. Each MAJOR.MINOR
release has release notes which describe changes and specific upgrade
notes, posted [here](/sel4_release).

New features and bug fixes will appear in bleeding edge updates earlier than in
a released version.  If you are working on a long-term project on seL4 or are
using a different user level than we provide then it is probably better to pick
a versioned release and manually upgrade when new features are required.  We
only guarantee working proofs for released versions, although we try to maintain
working proofs for bleeding edge releases as well. If you are trying out seL4
and experimenting with different features, rerunning benchmarks or doing the
tutorials, using the bleeding edge versions of the projects is probably fine.
They don't get updated unless they are passing our tests and any issues should
be reported to the relevant GitHub issue tracker or posted on the
[mailing list][] or [discourse][].

[mailing list]: https://lists.sel4.systems/postorius/lists/devel.sel4.systems/
[discourse]: https://sel4.discourse.group

### Version Numbers

For versioned releases, seL4 and Microkit/CAmkES/capDL have different policies.

**seL4**, **Microkit**, and **rust-sel4** follow [semantic
versioning](http://semver.org/). In short:

Given a version number MAJOR.MINOR.PATCH, increment the:

- MAJOR version when you make incompatible API changes;
- MINOR version when you add functionality in a backwards-compatible manner;
- PATCH version when you make backwards-compatible bug fixes.

seL4 versions are tagged in git.

**CAmkES** and **capDL** versions follow the following policy:

MAJOR.MINOR.PATCH:

- MAJOR: A big rewrite
- MINOR: The actual release number, increased when seL4 is released or there are
         source/binary incompatible CAmkES updates
- PATCH: Small bug fixes that are backwards compatible.

### Library Compatibility

seL4 libraries have branches that track all MAJOR.MINOR versions, with
branch names in the format MAJOR.MINOR-compatible. A
MAJOR.MINOR-compatible branch will build with any MAJOR.MINOR.\* version
of the kernel, and all MAJOR.MINOR-compatible branches across our
libraries are compatible with each other.

### Legacy support

We only currently provide bug fixes and support for the latest version
of the kernel and latest version of libraries.

## Manifests

Each project repository above contains several manifest files:

- `default.xml` specifies pinned revisions of the source that are updated every
  time a new *bleeding edge* release is pushed. These manifests should always
  compile and pass tests if the correct build configurations are used.
- `master.xml` specifies the tip of each repository in a project. These aren't
  guaranteed to work, and may contain combinations of repositories that have not
  been tested together.

`default.xml` is tagged at each released version. To obtain the manifest for a
specific kernel version check out the corresponding X.Y.z tag. Our previous
process created an `X.Y.z.xml` manifest for each release, but this is no longer
the case.

### Proofs/Verification manifests

The verification-manifest project contains a `${SEL4_VERSION}.xml` containing
revisions which correspond to a version of the proofs that pass for the released
version of the kernel

### Versioned manifests

The following projects manifest repositories are maintained, meaning both
bleeding edge and versioned releases are available:

{% for project in site.data.maintained.github %}
	{% for repo in project.repo_projects %}
- [{{repo}}](https://github.com/{{project.name}}/{{repo}})
	{% endfor %}
{% endfor %}
