#! /usr/bin/env python3

# Copyright 2020 Data61, CSIRO
# SPDX-License-Identifier: BSD-2-Clause

import sys
from yaml import load, dump

# Try use libyaml C bindings first for parsing. Fall back to python implementations
# otherwise.
try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader

# Parse yaml file from stdin and output a newline separated list of repositories
data = load(sys.stdin, Loader=Loader)
try:
    if "repositories" in data:
        for repo in data["repositories"]:
            print(("%s/%s" % (repo["org"], repo["repo"])).lower())
except:
    pass
