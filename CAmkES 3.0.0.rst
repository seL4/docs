= CAmkES 3.0.0 Release Notes =

This adds all the features from our development branch "next". Changes include several syntactic and functional changes. The development of new features will now continue on the "master" branch, and the "next" branch will remain as is for compatibility reasons.

== Migrating ==

=== I was using the "master" branch, and don't want to migrate ===

That's fine! All the old versions of CAmkES will continue to be available. The latest release of this branch is [[https://github.com/seL4/camkes-tool/releases/tag/camkes-2.3.1|camkes-2.3.1]]. If you use repo, your manifest probably had a line resembling:
{{{
<project name="camkes-tool.git" path="tools/camkes">
}}}

Change it to:
{{{
<project name="camkes-tool.git" path="tools/camkes" revision="refs/tags/camkes-2.3.1">
}}}


== Syntax Changes ==

A detailed summary of visible changes can be found here: [[CAmkESDifferences]]

== New Dependencies ==

CAmkES dependencies have changed. For a definitive (maintained) list, see: [[CAmkES#Build_dependencies]]

== New Features ==

=== Cache Accelerator ===

CAmkES now comes with a small tool for caching compilation results based on source files. This should greatly reduce compilation times by not unnecessarily recompiling code. It is enabled by default. Control it with the `CONFIG_CAMKES_ACCELERATOR` config variable.

=== Python 3 Support ===

Previously, CAmkES only worked with python2. It's now compatible with python2 and python3.
