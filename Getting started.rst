= Getting started =
== Setting up your machine ==
These instructions are for Ubuntu. They assume you   already know the   basics of using the command line, compilers, and   GNU Make.

=== Toolchains and Prerequisites ===
Instructions should be similar for other distros, links to toolchains for other distros are provided.

[[SetupFedora|Instructions for Fedora and CentOS (RHEL should work as well)]]

[[SetupUbuntu|Instructions for Debian and Ubuntu]]Use Ubuntu's package manager to install the necessary packages. You will also need to add the universe repository (if you haven't already) to access the cross compiler.

{{{
sudo apt-get install python-software-properties
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install gcc-arm-linux-gnueabi
sudo apt-get install qemu-system-arm qemu-system-x86
}}}
=== Get Repo ===
Repo is a tool by google used for managing multiple git repositories. The latest repo is available from Google at https://storage.googleapis.com/git-repo-downloads/repo.   Download it, and put it somewhere in your PATH.

{{{
mkdir -p ~/bin
export PATH=~/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
}}}
=== Using repo ===
Choose a project to start with. As an example, we'll use   sel4test. First create a directory to work in, and initialise it   using repo:

{{{
mkdir seL4test
cd seL4test
repo init -u https://github.com/seL4/sel4test-manifest.git
}}}
This will download the latest version of repo from Google, and   the manifest for the seL4test project. To get the actual source,   you'll then need to use repo sync:

{{{
repo sync
}}}
repo will churn through for around ten minutes fetching all the   repositories needed.''''''

== Build and run seL4 test ==
TODO

== Try the seL4 tutorials ==
TODO
