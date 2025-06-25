---
layout: tutorial
description: guide to machine set-up for tutorials
next: get-the-tutorials.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Setting up your machine

## Google's Repo tool

The primary way of obtaining and managing seL4 project sources is through the use of Google's Repo tool.

To install run:
```sh
  sudo apt-get update
  sudo apt-get install repo
```

<details markdown='1'>
<summary>More on Repo</summary>
<br>
[More details about on installing Repo](https://source.android.com/setup/develop#installing-repo).

[seL4 Repo cheatsheet](../projects/buildsystem/repo-cheatsheet)
</details>

## Docker
To compile and use seL4, it is recommended that you use Docker to isolate the dependencies from your machine.

These instructions assume you are using Debian (or a derivative, such as Ubuntu), and are using Bash for your shell. However, it should be informative enough for users of other distros/shells to adapt.

These instructions are intended for Ubuntu LTS versions 20.04 and 22.04.

To begin, you will need at least these two programs:

 * make (`sudo apt install make`)
 * docker (See [here](https://get.docker.com) or [here](https://docs.docker.com/engine/installation) for installation instructions)

For convenience, add your account to the docker group:

```bash
sudo usermod -aG docker $(whoami)
```

<details markdown='1'>
  <summary>More on Docker</summary>
  <br>

  **Available images**

  All the prebuilt docker images are available on [DockerHub here](https://hub.docker.com/u/trustworthysystems)

  These images are used by the Trustworthy Systems Continuous Integration (CI) software, and so represent a standard software setup we use.
  The CI software always uses the `latest` docker image, but images are also tagged with the date they were built.

  **More information**

  You can find the dockerfiles and supporting Makefile [here](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles)

</details>


### Getting a build environment
To get a running build environment for seL4 and CAmkES, run:

```bash
git clone https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles.git
cd seL4-CAmkES-L4v-dockerfiles
make user
```

This will give you a terminal inside a container that has all the relevant tools to build, simulate, and test seL4 & Camkes programs.

The first time you run this, docker will fetch the relevant images, which may take a while.

The last line will say something like:

```
Hello, welcome to the seL4/CAmkES/L4v docker build environment
```

### Mapping a container
To run the container from other directories (e.g. starting a container for the [Hello World](hello-world.md) tutorial, which we'll do next), you can setup a bash alias such as this:

```bash
echo $'alias container=\'make -C /<path>/<to>/seL4-CAmkES-L4v-dockerfiles user HOST_DIR=$(pwd)\'' >> ~/.bashrc
# now open a new terminal, or run `source ~/.bashrc`
```

Replace `/<path>/<to>/` to match where you cloned the git repo of the docker files.

*Reminder:* Include the absolute path to your `seL4-CAmkES-L4v-dockerfiles` folder, e.g.

```bash
echo $'alias container=\'make -C /~/seL4-CAmkES-L4v-dockerfiles user HOST_DIR=$(pwd)\'' >> ~/.bashrc
# now open a new terminal, or run `source ~/.bashrc`

```

This then allows you to run `container` from any directory.

*Reminder:* start a new terminal for the changes in `.bashrc` to take effect or run `source ~/.bashrc`.


## An example workflow

A good workflow is to run two terminals:

 - Terminal A is just a normal terminal, and is used for git operations, editing (e.g., vim, emacs, vscode), and other non-build operations.
 - Terminal B is running in a container, and is only used for compilation.

This gives you the flexibility to use all the normal tools you are used to, while having the seL4 dependencies separated from your machine.

### Compiling seL4 test

Start two terminals (terminal A and terminal B).

In terminal A, run these commands:

```bash
jblogs@host:~$ mkdir ~/seL4test
jblogs@host:~$ cd ~/seL4test
jblogs@host:~/seL4test$ repo init -u https://github.com/seL4/seL4test-manifest.git
jblogs@host:~/seL4test$ repo sync
```

In terminal B, run these commands:

```bash
jblogs@host:~$ cd ~/seL4test
jblogs@host:~/seL4test$ container  # using the bash alias defined above
jblogs@in-container:/host$ mkdir build-x86
jblogs@in-container:/host$ cd build-x86
jblogs@in-container:/host/build-x86$ ../init-build.sh -DPLATFORM=x86_64 -DSIMULATION=TRUE
jblogs@in-container:/host/build-x86$ ninja
jblogs@in-container:/host/build-x86$ ./simulate
```

If you need to make any code modifications or commit things to git, use terminal A. If you need to recompile or simulate an image, use terminal B.

`./simulate` is run using [QEMU](https://www.qemu.org/), and will take a few minutes to run. If QEMU works, you'll see something like

```
Test suite passed. 121 tests passed. 57 tests disabled.
All is well in the universe
```

Note, if QEMU fails when trying to simulate the image, try configuring your Docker host to give the container more memory using [Docker Desktop](https://docs.docker.com/desktop/use-desktop/).

That's it! seL4 is running.

To quit QEMU: `Ctrl+a, x`
