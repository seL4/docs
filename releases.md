---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 Proofcraft Pty Ltd
---

# Releases

## Latest Versions

The latest versioned software releases provided by the seL4 Foundation are

{% include releases.html %}

## Release Channels

There are two release channels:

- **Bleeding edge**: These happen whenever any of the maintained repository
  collections is updated and the tests for it are passing.
- **Versioned releases**: Versioned releases of the seL4 kernel, the seL4
  proofs, CAmkES, Microkit, capDL, and Rust support. These happen manually and
  less frequently. The latest versions of these are shown at the top of this
  page.

Bleeding edge releases happen every time the code is updated and passes the test
suites and proofs. Working on the bleeding edge means that API changes occur
often and code depending on that API may break without warning.

Currently, we do not guarantee maintenance of previous releases, or individually
versioned libraries, projects, and applications. If that becomes necessary for
you, please let us know via one of the [contact channels][contact].

### Which release should you use?

We recommend you develop on a specific official release version of the kernel,
rather than the bleeding edge. Each MAJOR.MINOR release has release notes which
describe changes and specific upgrade notes.

New board support, features, and bug fixes will appear in bleeding edge updates
earlier than in a released version.  If you are working on a long-term project
on seL4 or are using different user-level libraries than we provide then it is
usually better to pick a versioned release and manually upgrade when new
features are required. We only guarantee working proofs for released versions,
although we try to maintain working proofs for bleeding edge releases as well.
If you are trying out seL4 and experimenting with different features, rerunning
benchmarks or doing the tutorials, using the bleeding edge versions of the
projects is often fine. They will only get updated when they are passing our
tests. Please report any issues to the relevant GitHub issue tracker or post on
one of the [support channels](https://sel4.systems/support.html).

### Version Numbers

For versioned releases, seL4, Microkit, CAmkES, and capDL have different policies.

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

The libraries maintained by the seL4 Foundation have branches that track all
MAJOR.MINOR versions, with branch names in the format MAJOR.MINOR-compatible. A
MAJOR.MINOR-compatible branch will build with any MAJOR.MINOR.\* version of the
kernel, and all MAJOR.MINOR-compatible branches across our libraries are
compatible with each other.

### Legacy support

We only currently provide bug fixes and support for the latest version of the
kernel and latest version of libraries. Please do [contact us][contact] if
commercial support of specific older versions of the kernel is important to you.

## Manifests

Repository collections are tracked via manifests and the Google repo tool. Each
repository collection [below](#versioned-repository-collections) is tracked in a
separate manifest repository with at least the following manifest files:

- `default.xml` specifies pinned revisions of the source that are updated every
  time a new *bleeding edge* release is pushed. This happens every time there is
  a code change and the regression tests for the corresponding repository
  collection passes. This means, these manifests should always compile and pass
  tests provided the correct build configurations are used.
- `master.xml` specifies the tip of each repository in a project. These are used
  for development and *not* guaranteed to work. They may contain combinations of
  repositories that have not yet been tested together.

`default.xml` is tagged at each released version. To obtain the manifest for a
specific kernel version check out the corresponding X.Y.z tag.

### Proof manifests

The `verification-manifest` repository contains a `${SEL4_VERSION}.xml` manifest
for each release. It records the revisions of the proofs that match the
corresponding released version of the kernel and the version of the Isabelle/HOL
theorem prover that can be used to check the proofs.

### Versioned repository collections

The following manifests track maintained repository collections, meaning
both bleeding edge and versioned releases are available:

{% for project in site.data.maintained.github -%}
{% for repo in project.repo_projects -%}
- [{{repo}}](https://github.com/{{project.name}}/{{repo}})
{% endfor -%}
{% endfor %}

[contact]: https://sel4.systems/contact.html
