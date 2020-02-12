---
order_priority: 3
---

## Building Proofs (l4v dependencies)

The proofs in the [L4.verified](https://github.com/seL4/l4v) repository use `Isabelle2017`. To best way to make sure you have all the dependencies on your host machine is to follow the instructions listed in sections [Base Build Dependencies](#base-build-dependencies). However you can get away with avoiding a full cross compiler setup. The dependencies for Isabelle you will need at least are listed below:

### Ubuntu

> *Tested on Ubuntu 18.04 LTS*

```
sudo apt-get install libwww-perl libxml2-dev libxslt-dev
sudo apt-get install mlton rsync
sudo apt-get install texlive-fonts-recommended texlive-latex-extra texlive-metapost texlive-bibtex-extra
```

###  Debian

#### For Debian Stretch or later

The dependencies listed in our docker files [repository](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles) will work for a Debian installation. You can refer to this repository for an up-to-date list of base build dependencies. Specifically refer to the dependencies listed in the:

* [l4v Dockerfile](https://github.com/SEL4PROJ/seL4-CAmkES-L4v-dockerfiles/blob/master/l4v.dockerfile)

### Haskell Dependencies

The Haskell tool-stack is required to build the Haskell kernel model. You can install [Haskell stack](https://haskellstack.org) on your distribution by running:

```
curl -sSL https://get.haskellstack.org/ | sh
```

If you prefer not to bypass your distribution's package manager, you can do
```
sudo apt-get install haskell-stack
```

### Setup Isabelle

To setup Isabelle, you will firstly need to pull the [L4.verified](https://github.com/seL4/l4v) project source using the Google repo tool (installing the Google repo tool is described in the [Get Google's Repo tool](#get-googles-repo-tool) section. The following steps to setup Isabelle:

```
# Create a directory to store the project source
mkdir lv4_repo
cd lv4_repo
# Initialise the project repo
repo init -u https://github.com/seL4/verification-manifest.git
repo sync
cd l4v
mkdir -p ~/.isabelle/etc
cp -i misc/etc/settings ~/.isabelle/etc/settings
./isabelle/bin/isabelle components -a
./isabelle/bin/isabelle jedit -bf
./isabelle/bin/isabelle build -bv HOL-Word
```
