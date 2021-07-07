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

For versioned releases, seL4 and CAmkES/capDL have different policies.

**seL4** follows [semantic versioning](http://semver.org/). In
short:

"Given a version number MAJOR.MINOR.PATCH, increment the:

- MAJOR version when you make incompatible API changes,
- MINOR version when you add functionality in a backwards-compatible
      manner, and
- PATCH version when you make backwards-compatible bug fixes."

seL4 versions are tagged in git.

**CAmkES** and **capDL** versions follow the following policy:

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

## Release procedure

This section describes how a release is done. Most of the points below are
applicable to the wider public except for those where the actual release work
is carried out. Note that this procedure is based on the Trustworthy Systems
team-internal Bamboo continuous infrastructure and GitHub setup. This procedure
is likely to change in the coming future as the Trustworthy Systems team
migrates away from the Bamboo setup and perhaps experiments with a more
frequent release cycle.

### Release window and feeze

When a release is planned, decide on the timeframe of the release window in
which changes can still be made, and then make an announcement to the relevant
channels that a release is coming up and let people know of the release window
that you have decided. This is to give advance notice to contributors so that
they can prepare for the release and get features merged in before the release
is done. A decent timeframe for the release window is a month.

The relevant channels for the announcement are:
- [seL4 discourse](https://sel4.discourse.group/)
- seL4 announcement mailing list: announce@sel4.systems
- [seL4 Mattermost](https://mattermost.trustworthy.systems/sel4-external/)

Upon the end of the release window, announce the close of the window and the
start of the release freeze on the relevant channels. Pull requests should not
be merged during the release freeze except for those that fix issues and bugs
that occurred during the release window. Work towards getting the continuous
integration builds to be green while working on the next step.

### Preparing changelogs

Before preparing the changelogs for each project, review the changes of each
project since the last release and decide a new version number as according to
the [Version Numbers](#version-numbers) section.

Clone the `seL4_release` repository from the [seL4
organization](https://github.com/seL4) (this is currently private and you will
need to ask for permission).

Move to the directory of the repository that you cloned and execute the
following while replacing the fields:

```shell
./releaseit prerelease --config data/sel4_prerelease.yml --new-version=<new seL4 version>

./releaseit prerelease --config data/capdl_prerelease.yml --new-version=<new capDL version> --sel4-version=<new seL4 version>

./releaseit prerelease --config data/camkes_prerelease.yml --new-version=camkes-<new CAmkES version> --sel4-version=<new seL4 version>
```

These commands clone the projects in the `/tmp` directory of your machine and
apply two commits that add changes to the `CHANGES` and `VERSION` files. Note
that it also creates a `<project>_release.md` file in each project directory.
You now need to add any extra changes since the last release that were not
already included in the `CHANGES` file for each project. To do so, run `git log`
with the relevant arguments to get the commits since the last release or go to
each project's GitHub page and filter the pull requests that were merged since
the last release. Go through each of the commits/pull requests and summarise
them in the `CHANGES` files. You do not need to add changes that are trivial. The
best way to think about this is: "If i'm a user of (sel4, camkes, capdl) will
it affect me? Do I need to know about it? e.g has the API changed?  Are
variables renamed? New features? New licences? Removal of features?" etc. Make
sure to also update the `Upgrade Notes` section in each `CHANGES` file.

Meanwhile, you can also work on making the continuous integration builds green
while preparing the changelogs. Remember to also include any fixes and changes
to the changelogs.

Once the continuous integration builds are all green (make sure that the
verification builds are also green) and the changelogs are also done. Amend the
commits that the release tool made with the updated `CHANGES` file in each
project, sign the commits off and submit pull requests for each project.  Make
sure that the pull request **only** contains the two commits, one for updating
the `VERSION` and the `CHANGES` files to the latest version and one for
updating the `VERSION` file to add the `dev` suffix to the contents.

The next step is to copy the contents of each project's `CHANGES` file to the
`<project>_release.md` file in the same directory. Make sure that the top of
the `<project>_release.md` file contains a `project: sel4`, `project: camkes`,
or `project: capdl` tag. Take all of the `<project>_release.md` files and
rename them to the current release version and add them under the `_releases`
folder in the docsite's repository
[here](https://github.com/seL4/docs/tree/master/content_collections/_releases).
Submit a pull request for those changes as well.

Get all pull requests (should be four, one for each project, and one for the
docsite) merged and then wait for Bamboo to release the version tags for each
project. Once this is done, we can now carry out the
last remaining tasks and announce the release.

### Postrelease

Update the links on the docsite to point to the new releases by updating the
version numbers in this
[file](https://github.com/seL4/docs/blob/master/_config.yml).

Announce on the mailing list as well as the seL4 Discourse that the new release
is done. Update the line in this [file](_includes/custom-navbar.html) to point
to the seL4 Discourse announcement.

Build a new version of the seL4 kernel manual and add it
[here](https://github.com/seL4/website/tree/master/content/Info/Docs) and
update the symlink to point to it.

Finally, go to the release tool and run the following command while replacing
the fields:

```shell
./releaseit postrelease --sel4-new-version=<new seL4 version> --camkes-new-version=<new CAmkES version> --capdl-new-version=<new capDL version>
```

This command will add version tags to each sub-project repository for each of
the repositories that are under those projects. Running it without the
`--release` flag will perform a dryrun. If there are issues during the dryrun,
fix them up and when everything is all good, run it with the `--release` flag.

Now, the final task to do it to go to the GitHub pages for the seL4, CAmkES,
and capDL projects and draft new GitHub releases for each of the projects.

Once you're here, hurray the release is done!
