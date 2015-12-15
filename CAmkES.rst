= CAmkES =
== Setting up your machine ==
Make sure that you already have the tools to build seL4 ([[Getting started#Setting_up_your_machine|seL4: Setting up your machine]])

== Build dependencies ==
Install GHC and packages MissingH, data-ordlist and split (installable from cabal):

{{{
apt-get install ghc
apt-get install cabal-install
cabal update
cabal install MissingH
cabal install data-ordlist
cabal install split
}}}
Cabal packages get installed under the current user, so each user that wants to build the VM must run the cabal steps

Install python packages jinja2, ply, pyelftools (via pip):

{{{
apt-get install python-pip
pip install pyelftools
pip install ply
pip install jinja2
}}}
If building on a 64bit system ensure 32bit compiler tools are installed, mainly:

{{{
}}}
And the correct version of multilib for your gcc, for example:

{{{
}}}
