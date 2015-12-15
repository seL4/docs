= CAmkES =
== Setting up your machine ==
Make sure that you already have the tools to build seL4 ([[Getting started#Setting_up_your_machine|seL4: Setting up your machine]])

== Build dependencies ==
Install GHC and packages MissingH, data-ordlist and split (installable from cabal):

{{{
test
}}}
Cabal packages get installed under the current user, so each user that wants to build the VM must run the cabal steps

Install python packages jinja2, ply, pyelftools (via pip):

{{{
}}}
If building on a 64bit system ensure 32bit compiler tools are installed, mainly:

{{{
}}}
And the correct version of multilib for your gcc, for example:

{{{
}}}
