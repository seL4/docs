---
toc: true
redirect_from:
  - /ReleaseProcess
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Release Process

This page outlines how we make [seL4 and its associated ecosystem](/MaintainedRepositories) available to external developers. The goals of this process are as follows:

- provide a current up to date version of our libraries and applications,
- allow developers to decide when to upgrade between versions, i.e choose when breakage happens,
- and provide libraries and apps compatible with each released version.

Currently, we do not guarantee maintenance of previous releases, or individually version libraries,
projects and applications.

## Terminology

- Sources: Source code for everything
- Kernel: the seL4 microkernel source repository
- Libraries: user level libraries that run on seL4
- Applications: applications that run on seL4
- Projects: A collection of applications, libraries, kernel, denoted by a repo manifest
- CAmkES: The CAmkES tool repository
- Proofs: L4V proofs.

## Sources

We make a lot of source code available in the spirit of open source,
however we do not guarantee that all source provided is
maintained and tested.

A list of maintained projects, libraries and applications can be found [here](/MaintainedRepositories).


## Releases

We have two release channels:
- **Bleeding edge**: These happen whenever any of our maintained project code is updated and the tests for it are passing
- **Versioned releases**: Versioned releases of the kernel and the CAmkES tool.  These happen less frequently.

Bleeding edge releases happen every time we update our code and it passes our test suites and
proofs. Working on the bleeding edge means that API changes occur often, and you may get cut. Whenever any of the sources tracked by the manifests in the following repositories are updated and the
regression tests pass, an updated version of the manifest will be committed to the repo and the new sources will be synced with GitHub.

### Which release should you use?

We recommend you develop on a specific version of the kernel, rather
than the bleeding edge which is the tip of master. Each MAJOR.MINOR
release has release notes which describe changes and specific upgrade
notes, posted [here](/sel4_release).

New features and bug fixes will appear in bleeding edge updates much earlier than in a released version.  If you are
working on a long term project on seL4 or using a different userlevel than we provide then it is probably better to
pick a versioned release and manually upgrade when new features are required.  Additionally, we only guarantee working proofs for
released versions.
If you are trying out seL4 and experimenting with different features, rerunning benchmarks or doing the tutorials, using the
bleeding edge versions of the projects is probably fine.  They don't get updated unless they are passing our tests and any
issues should be repoted to the GitHub issue tracker or posted on our mailing list.

### Version Numbers

For versioned releases, seL4 and CAmkES have different policies.

**seL4** follows [semantic versioning](http://semver.org/). In
short:

"Given a version number MAJOR.MINOR.PATCH, increment the:

- MAJOR version when you make incompatible API changes,
- MINOR version when you add functionality in a backwards-compatible
      manner, and
- PATCH version when you make backwards-compatible bug fixes."

seL4 versions are tagged in git.

**CAmkES** versions follow the following policy:

MAJOR.MINOR.PATCH:
- MAJOR: A big rewrite
- MINOR: The actual release number, increased when seL4 is released or there are source/binary incompatible CAmkES updates
- PATCH: Small bugfixes that are backwards compatible.

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
- `default.xml` specifies pinned revisions of the source that are updated every time a new *bleeding
  edge* release is pushed. These manifests should always compile and pass tests if the correct build
  configurations are used.
  - `master.xml` specifies the tip of each repository in a project. These aren't guaranteed to work, and may contain combinations of repositories that have not been tested together.

`default.xml` is tagged at each released version. To obtain the manifest for a specific kernel
version checkout the corresponding X.Y.z tag. Our previous process created an `X.Y.z.xml` manifest
for each release, but this is no longer the case.

### Verified manifests

The verification-manifest project contains a `${SEL4_VERSION}.xml` containing revisions which correspond to a version of the proofs that pass for the released version of the kernel

### Versioned manifests

The following projects manifest repositories are maintained, meaning both bleeding edge and
versioned releases are available:

{% for project in site.data.maintained.github %}
	{% for repo in project.repo_projects %}
- [{{repo}}](https://github.com/{{project.name}}/{{repo}})
	{% endfor %}
{% endfor %}
