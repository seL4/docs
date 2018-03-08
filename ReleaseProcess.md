# seL4 Release Process


## Version Policy


seL4 follows [semantic versioning](http://semver.org/). In
short:

"Given a version number MAJOR.MINOR.PATCH, increment the:

- MAJOR version when you make incompatible API changes,
- MINOR version when you add functionality in a backwards-compatible
      manner, and
- PATCH version when you make backwards-compatible bug fixes."

seL4 versions are tagged in git.

## Release Frequency


We aim to follow a monthly release cycle, with fresh code pushed to
github daily. This means that master is quite volatile, so unless you
want to live on the bleeding edge we suggest you should work on a
specific tag and choose when to upgrade.

## Library Compatibility


seL4 libraries have branches that track all MAJOR.MINOR versions, with
branch names in the format MAJOR.MINOR-compatible. A
MAJOR.MINOR-compatible branch will build with any MAJOR.MINOR.\* version
of the kernel, and all MAJOR.MINOR-compatible branches across our
libraries are compatible with each other.

To avoid too much dependency management we do not currently version our
libraries themselves.

## Project Compatibility


Each MAJOR.MINOR release we add updated project manifest to each of our
supported projects.

For example, for the 2.0.0 release a 2.0.x.xml was added to the seL4
test repository which tracks the 2.0.0 kernel and the 2.0-compatible
branches of each library. default.xml in each repository points to the
tip of each repository and may break when you pull in changes.

Supported projects are:

- [sel4test](https://github.com/seL4/sel4test-manifest)
- [verification](https://github.com/seL4/verification-manifest)

## Upgrading


We recommend you develop on a specific version of the kernel, rather
than the bleeding edge which is the tip of master. Each MAJOR.MINOR
release has release notes which describe changes and specific upgrade
notes, posted [here](/sel4_release).

## Legacy support


We only currently provide bug fixes and support for the latest version
of the kernel and latest version of libraries.
