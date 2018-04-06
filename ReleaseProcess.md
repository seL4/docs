---
toc: true
---

# Release Process

This page outlines how we make [seL4 and its associated ecosystem](/MaintainedRepositories) available to external developers.

## What we are trying to achieve

- Stop arbitrarily breaking things for our community (internal AND external developers)
- Provide a current up to date version of our libraries and applications
- Allow developers to decide when to upgrade between versions, i.e choose when breakage happens
- Provide libraries and apps compatible with each released version


## What are we not doing?
- guaranteeing maintenance of previous releases.
   - we'll do bugfixes on prior releases if someone pays us to
   - otherwise we only work on the current release and bleeding edge (ie: unreleased things on master)
- Assigning release numbers to individual libraries, projects and apps
   - this could be revised later but currently carries too much overhead
- We don't maintain all of the sources that we make available
   - A list of maintained projects, libraries and applications can be found [here](/MaintainedRepositories).

## Terminology

- Sources: Source code for everything
- Kernel: the seL4 microkernel source repository
- Libraries: user level libraries that run on seL4
- Applications: applications that run on seL4
- Projects: A collection of applications, libraries, kernel, denoted by a repo manifest
- CAmkES: The CAmkES tool repository
- Proofs: L4V proofs.

## Process

We have two release channels:
- [Bleeding edge](#bleeding-edge): These happen whenever any of our maintained project code is updated and the tests for it are passing
- [Versioned releases](#versioned-releases): Versioned releases of the kernel and the CAmkES tool.  These happen less frequently.

#### What version should you use?

New features and bug fixes will appear in bleeding edge updates much earlier than in a released version.  If you are
working on a long term project on seL4 or using a different userlevel than we provide then it is probably better to
pick a versioned release and manually upgrade when new features are required.  Additionally, we only guarantee working proofs for
released versions.
If you are trying out seL4 and experimenting with different features, rerunning benchmarks or doing the tutorials, using the
bleeding edge versions of the projects is probably fine.  They don't get updated unless they are passing our tests and any
issues should be repoted to the GitHub issue tracker or posted on our mailing list.

### Bleeding edge

These happen often. When ever any of the following sources tracked by the manifests in the following repositories are updated and the
regression tests pass, an updated version of the manifest will be committed to the repo and the new sources will be synced with GitHub.
{% for project in site.data.maintained.github %}
	{% for repo in project.repo_projects %}
- [{{repo}}](https://github.com/{{project.name}}/{{repo}})
	{% endfor %}
{% endfor %}

For all of the above repositories the repository contains a `default.xml` manifest.  This specifies the pinned revisions of the source dependencies that the project manifest corresponds to.  Updates to this file corresponds to new source that has been released.

Apart from verification-manifest, there is also a `master.xml` file which corresponds to the tip reference of the source repository.  These
aren't guaranteed to work.

Our `bleeding edge` release process involves:
1. checking out `master.xml`,
2. running the tests,
3. if the tests pass, saving the revisions to `default.xml`
4. then pushing everything out to GitHub.


### Versioned Releases

These happen less often but are more involved.  This process can be applied to seL4 or CAmkES-tool.

1. Create a commit increasing the version number in the VERSION file
2. Tag the commit of the kernel or camkes-tool that is being released with the release number
3. Generate a `default.xml` for all of the above projects that use the tagged release commit of seL4 and camkes-tool
4. Tag the `default.xml` with the released version.  (If it is a CAmkES project, use the CAmkES version, otherwise the seL4 version)
   For the verification-manifest, create a `${SEL4_VERSION}.xml` file corresponding to a version of the proofs that pass for the released version of the kernel.
5. Create branches for each of the source repositories that are [maintained](/MaintainedRepositories) following the pattern `X.Y-compatible`
6. Create a tagged release on GitHub
7. If seL4, upload a version of the Manual to <https://sel4.systems>
8. Publish release notes on devel mailing list and <https://docs.sel4.systems>.

The following subheadings go in to more detail about the above steps.

#### Version Policy


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

#### Library Compatibility


seL4 libraries have branches that track all MAJOR.MINOR versions, with
branch names in the format MAJOR.MINOR-compatible. A
MAJOR.MINOR-compatible branch will build with any MAJOR.MINOR.* version
of the kernel, and all MAJOR.MINOR-compatible branches across our
libraries are compatible with each other.

To avoid too much dependency management we do not currently version our
libraries themselves.

#### Upgrading


We recommend you develop on a specific version of the kernel, rather
than the bleeding edge which is the tip of master. Each MAJOR.MINOR
release has release notes which describe changes and specific upgrade
notes, posted [here](/sel4_release).

#### Legacy support


We only currently provide bug fixes and support for the latest version
of the kernel and latest version of libraries.
