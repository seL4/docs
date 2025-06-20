---
redirect_from:
  - /RepoCheatsheet
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Repo Cheatsheet

Repo is a tool developed by the Android Open Source Project.  We use repo for source dependency management.

This page describes how we typically structure our manifests and also explains some common repo commands that we use in our workflows.

Below is a set of example manifests for the sel4test project. They are located at <https://github.com/seL4/sel4test-manifest/>.

- `common.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2018, Data61, CSIRO
     SPDX-License-Identifier: BSD-2-Clause
-->
<manifest>
<remote name="seL4" fetch="." />
<remote fetch="../sel4proj" name="sel4proj"/>
<remote fetch="https://github.com/nanopb" name="nanopb" />
<remote fetch="https://github.com/riscv" name="opensbi"/>

<default revision="master" remote="seL4" />

<project name="seL4_tools.git" path="tools/seL4">
    <linkfile src="cmake-tool/init-build.sh" dest="init-build.sh"/>
    <linkfile src="cmake-tool/griddle" dest="griddle"/>
</project>
<project name="sel4runtime.git" path="projects/sel4runtime"/>
<project name="musllibc.git" path="projects/musllibc" revision="sel4"/>
<project name="seL4_libs.git" path="projects/seL4_libs"/>
<project name="util_libs.git" path="projects/util_libs"/>
<project name="sel4test.git" path="projects/sel4test">
    <linkfile src="easy-settings.cmake" dest="easy-settings.cmake"/>
</project>
<project name="sel4_projects_libs" path="projects/sel4_projects_libs" />
<project name="opensbi" remote="opensbi" revision="refs/tags/v0.8" path="tools/opensbi"/>
<project name="nanopb" path="tools/nanopb" revision="refs/tags/0.4.3" upstream="master" remote="nanopb"/>
</manifest>
```

- `master.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2018, Data61, CSIRO
     SPDX-License-Identifier: BSD-2-Clause
-->
<manifest>
<!-- include all the common repositories, we just want to define the kernel -->
<include name="common.xml"/>
<project name="seL4.git" path="kernel"/>
</manifest>
```


## Manifest layout

We provide a brief overview of manifests as used in our projects in this section, please find more details in the full description of the manifest layout which can be found [here](https://gerrit.googlesource.com/git-repo/+/master/docs/manifest-format.md).

> `<remote name="seL4" fetch="." />`

The `remote` element specifies a remote where git repositories can be found.

> `<project name="musllibc.git" remote="seL4" path="projects/musllibc" revision="sel4"/>`

The `project` element declares a repository.
- `name` is the repository name at the `remote`
- `path` is the repository checkout location relative to the directory the project was initialised in.
- `revision` specifies what version of the repository to use. Branches and revision hashes are supported.  Tags are supported but the attribute value must be structured as `refs/tags/tagname`.
- `linkfile` element specifies a symlink from the repository to somewhere else in the project layout.
  - `src` is a path relative to the repository checkout.
  - `dest` is a path relative to the project directory.

> `<default revision="master" remote="seL4"/>`

The `default` element specifies attribute defaults that may be ommitted from `project` elements.
If attributes are ommitted, the values from the default element will be used instead.

### Pinned manifests

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
   Copyright 2021 seL4 Project a Series of LF Projects, LLC
   SPDX-License-Identifier: BSD-2-Clause
-->
<manifest>
  <remote name="nanopb" fetch="https://github.com/nanopb"/>
  <remote name="opensbi" fetch="https://github.com/riscv"/>
  <remote name="seL4" fetch="."/>
  <remote name="sel4proj" fetch="../sel4proj"/>

  <default remote="seL4" revision="master"/>

  <project name="musllibc.git" path="projects/musllibc" revision="aa82031dd861f7ade4c3738b417de34120b01f15" upstream="sel4" dest-branch="sel4"/>
  <project name="nanopb" path="tools/nanopb" remote="nanopb" revision="1466e6f953835b191a7f5acf0c06c941d4cd33d9" upstream="master" dest-branch="refs/tags/0.4.3"/>
  <project name="opensbi" path="tools/opensbi" remote="opensbi" revision="a98258d0b537a295f517bbc8d813007336731fa9" upstream="refs/tags/v0.8" dest-branch="refs/tags/v0.8"/>
  <project name="seL4.git" path="kernel" revision="a6c29549fce33df65b9018f420d330bca9086712" upstream="master" dest-branch="master"/>
  <project name="seL4_libs.git" path="projects/seL4_libs" revision="14d3c94f5164c993033a35a5d9e23ba6dcf12f5f" upstream="master" dest-branch="master"/>
  <project name="seL4_tools.git" path="tools/seL4" revision="553086aab4c9fb9c4869060fe51a3e95c20ce454" upstream="master" dest-branch="master">
    <linkfile src="cmake-tool/init-build.sh" dest="init-build.sh"/>
    <linkfile src="cmake-tool/griddle" dest="griddle"/>
  </project>
  <project name="sel4_projects_libs" path="projects/sel4_projects_libs" revision="a6fbc13c792ef518e5bcf1da69c8d27b6cd19814" upstream="master" dest-branch="master"/>
  <project name="sel4runtime.git" path="projects/sel4runtime" revision="c27050513503f615137950cb3918f6f040f34407" upstream="master" dest-branch="master"/>
  <project name="sel4test.git" path="projects/sel4test" revision="110ad99b32cb94f0604ce9fef796164b595fe6aa" upstream="master" dest-branch="master">
    <linkfile src="easy-settings.cmake" dest="easy-settings.cmake"/>
  </project>
  <project name="util_libs.git" path="projects/util_libs" revision="280f7bb58290ea3d719d86894655a03f36d347e2" upstream="master" dest-branch="master"/>
</manifest>
```

A pinned manifest uses pinned git revisions for all of its repositories. It is good practice to create a pinned manifest that refers to a working version of a project. For projects that we maintain, we provide at least two manifests: default.xml and master.xml (See [ReleaseProcess](/ReleaseProcess) for more information about what manifests we make available).

## Commands

### `init` and `sync`

`repo init` and `repo sync` are the most commonly used commands. Their purpose is for selecting a manifest and downloading all of the repositories and setting up a project directory structure.  Often project READMEs will provide the following instructions:
```
mkdir source_dir
cd source_dir
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
```

This will initialise a new directory with the git repos checked out in the locations described by the manifest file.

init is for selecting a manifest to use, and sync is for checking out that manifest.

`init`
- `-u` git url. Note: GitHub `ssh` urls do not work using the generated URL they provide: `git@github.com:seL4/sel4test-manifest.git` has to be changed to `ssh://git@github.com/seL4/sel4test-manifest.git`
- `-m` manifest name, default is default.xml.
- `-b` branch or revision, or tag if using format `refs/tags/tagname`. Default is default.xml

`sync`

This command synchronises your project directory with what the manifest describes.  If you have made commits in your branches, this may result in them getting _lost_ as repo switches the HEAD back to what the manifest describes. If this happens, use `git reflog` to find the untracked commit, or use branches to keep track of commits as branches will remain in your local checkouts.

`sync` has several flags for specifying how to checkout from remotes such as `-j` for parallel checkouts.  Use `repo sync --help` for a list and description.

### `diff` and `status`

These two commands are similar to running git diff or git status in every git repository.


### `diffmanifests`

This command allows you to list the commit differences between two manifests of the same project.

```
changed projects :

        kernel changed from master to 757c3ac98246afd0593367f1fa19054316a77495
                [-] 62445b35 x86: Correct labels for port out operations
                [-] d9780ec7 manual: label object groups in parse_doxygen_xml.py
                [-] 63c5ac6d manual: use level 3 for syscalls
                [-] deba85b2 manual: promote sel4_arch API docs level
                [-] b5ee12f0 manual: group generated API methods by object type
                [-] da1e73fe manual: use int level in parse_doxygen_xml.py
                [-] c2212688 x86: IOPort invocation has proper structure
                [-] 7b8f6106 x86: Consistently compare against PPTR_USER_TOP
                [-] 1b0a7181 manual: s/Polling Send/Non-Blocking Send
                [-] 84b065b0 manual: use fontenc package

        projects/tools changed from master to 930b6467eae8404e4a72555b693120ac0d64fc48
                [-] 121782a CMake add error condition

```
<!--
## Repo mirroring

TODO: Add details about repo mirroring
 -->
## FAQ

### How do I check out a released version of a project such as seL4test?

>
```
repo init -u https://github.com/seL4/sel4test-manifest.git -b refs/tags/{{site.sel4_master}}
repo sync
```

### How do I change manifests of an already checked out project?

>
```
repo init -m master.xml
repo sync
```

This will change from the current manifest to `master.xml` in the manifest repository

### How do I create a pinned manifest?

>
```
repo manifest -r -o pinned.xml
```

### Is there a faster way to checkout and sync a project?
>
```
repo init -u https://github.com/seL4/sel4test-manifest.git --no-clone-bundle --depth=1
repo sync --jobs=8 --fetch-submodules --current-branch --no-clone-bundle
```
