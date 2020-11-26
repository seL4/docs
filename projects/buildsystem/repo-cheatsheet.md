---
toc: true
redirect_from:
  - /RepoCheatsheet
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Repo Cheatsheet

Repo is a tool developed by the Android Open Source Project.  We use repo for source dependency management.

This page describes how we typically structure our manifests and also explains some common repo commands that we use in our workflows.

Below is an example of a manifest for the sel4test project.  It is located in <https://github.com/seL4/sel4test-manifest>.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2017, Data61
     Commonwealth Scientific and Industrial Research Organisation (CSIRO)
     ABN 41 687 119 230.

     This software may be distributed and modified according to the terms of
     the BSD 2-Clause license. Note that NO WARRANTY is provided.
     See "LICENSE_BSD2.txt" for details.

     @TAG(DATA61_BSD)
-->
<manifest>

<remote name="seL4" fetch="."/>

<remote fetch="../sel4proj" name="sel4proj"/>

<default revision="master"
remote="seL4"
/>

<project name="seL4.git" path="kernel"/>
<project name="seL4_tools.git" path="tools">
    <linkfile src="cmake-tool/default-CMakeLists.txt" dest="CMakeLists.txt"/>
    <linkfile dest="init-build.sh" src="cmake-tool/init-build.sh"/>
</project>
<project name="musllibc.git" path="projects/musllibc" revision="sel4"/>
<project name="seL4_libs.git" path="projects/seL4_libs"/>
<project name="util_libs.git" path="projects/util_libs"/>
<project name="sel4test.git" path="projects/sel4test"/>
<project name="riscv-pk" remote="sel4proj" revision="fix-32bit" path="projects/riscv-pk"/>
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

```
<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2018, Data61
     Commonwealth Scientific and Industrial Research Organisation (CSIRO)
     ABN 41 687 119 230.
     This software may be distributed and modified according to the terms of
     the BSD 2-Clause license. Note that NO WARRANTY is provided.
     See "LICENSE_BSD2.txt" for details.
     @TAG(DATA61_BSD)
-->
<manifest>
  <remote fetch="." name="seL4"/>
  <remote fetch="../sel4proj" name="sel4proj"/>

  <default remote="seL4" revision="master"/>

  <project name="musllibc.git" path="projects/musllibc" revision="f58dacf44a679a2d7c10fbb8d8bc8f58e2123791" upstream="sel4"/>
  <project name="riscv-pk" path="projects/riscv-pk" remote="sel4proj" revision="db937e995b09d343fb7146c447b0780ab1dca66b" upstream="fix-32bit"/>
  <project name="seL4.git" path="kernel" revision="757c3ac98246afd0593367f1fa19054316a77495" upstream="master"/>
  <project name="seL4_libs.git" path="projects/seL4_libs" revision="1697cb16ecbc7820cbda78d7c7c1896e884195a1" upstream="master"/>
  <project name="seL4_tools.git" path="projects/tools" revision="930b6467eae8404e4a72555b693120ac0d64fc48" upstream="master">
    <linkfile dest="CMakeLists.txt" src="cmake-tool/default-CMakeLists.txt"/>
    <linkfile dest="init-build.sh" src="cmake-tool/init-build.sh"/>
  </project>
  <project name="sel4test.git" path="projects/sel4test" revision="dbd96aa862b8519165aaa8ae7bd5a1787048e34a" upstream="master"/>
  <project name="util_libs.git" path="projects/util_libs" revision="c575f7280ce6184dbb2876f83a6c591c91de219e" upstream="master"/>
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
