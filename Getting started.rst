= Getting started =
== Setting up your machine ==
These instructions are for Ubuntu. They assume you   already know the   basics of using the command line, compilers, and   GNU Make.

=== Toolchains and Prerequisites ===
Instructions should be similar for other distros, links to toolchains for other distros are provided.

[[SetupFedora|Instructions for Fedora and CentOS (RHEL should work as well)]]

[[SetupUbuntu|Instructions for Debian and Ubuntu]]

=== Get Repo ===
The latest repo is available from Google at https://storage.googleapis.com/git-repo-downloads/repo.   Download it, and put it somewhere in your PATH.

{{{
mkdir -p ~/bin
export PATH=~/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
}}}
== Build and run seL4 test ==
TODO

== Try the seL4 tutorials ==
TODO
