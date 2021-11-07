---
redirect_from:
  - /Docker
layout: project
project: dockerfiles
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Using Docker for seL4, Camkes, and L4v dependency management

This page provides instructions on how to quickly set up your machine for building the seL4 kernel and related projects.

## Requirements:

These instructions assume you are using Debian (or a derivative, such as Ubuntu), and are using Bash for your shell. However, it should be informative enough for users of other distros/shells to adapt.

To begin, you will need at least these two programs:

 * make (`sudo apt install make`)
 * docker (See [here](https://get.docker.com) or [here](https://docs.docker.com/engine/installation) for installation instructions)

For convenience, add your account to the docker group:

```bash
sudo usermod -aG docker $(whoami)
```

## Getting a build environment

To get a running build environment for seL4 and Camkes, run:

```bash
git clone https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles.git
cd seL4-CAmkES-L4v-dockerfiles
make user
```

This will give you a terminal inside a container that has all the relevant tools to build, simulate, and test seL4 & Camkes programs. 

The first time you run this, docker will fetch the relevant images, which may take a while.

To map a particular directory into the container:

```bash
make user HOST_DIR=/scratch/seL4_stuff  # as an example
# Now /host in the container maps to /scratch/seL4_stuff
```

To make this easier to type, you can setup a bash alias such as this:

```bash
echo $'alias container=\'make -C /<path>/<to>/seL4-CAmkES-L4v-dockerfiles user HOST_DIR=$(pwd)\'' >> ~/.bashrc
# now open a new terminal, or run `source ~/.bashrc`
```

Replace `/<path>/<to>/` to match where you cloned the git repo of the docker files. This then allows you to run:

```bash
container
```

to start the container in the current directory you are in.

## An example workflow:
A good workflow is to run two terminals: 

 - terminal A is just a normal terminal, and is used for git operations, editing (e.g., vim, emacs), and other normal operations.
 - terminal B is running in a container, and is only used for compilation.

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
```

If you need to make any code modifications or commit things to git, use terminal A. If you need to recompile or simulate an image, use terminal B.

## Adding dependencies
To add more software inside the container, modify the `extras.dockerfile`. It contains an `apt-get` command which can be added to. After the first modification, docker will rebuild the extras image, and cache it after that.


## Available images

All the prebuilt docker images are available on [DockerHub here](https://hub.docker.com/u/trustworthysystems)
These images are used by the Trustworthy Systems Continuous Integration (CI) software, and so represent a standard software setup we use.

The CI software always uses the `latest` docker image, but images are also tagged with the date they were built.

## More information

You can find the dockerfiles and supporting Makefile [here](https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles)

Pull-requests and issues are [welcome](https://docs.sel4.systems/Contributing).
    
