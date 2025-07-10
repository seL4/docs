#!/bin/sh

# Copyright 2025 Proofcraft Pty Ltd
# SPDX-License-Identifier: BSD-2-Clause
#
# Insert a back link to the seL4 docsite into the Rust tutorial.

if [ $# -ne 1 ]; then
    echo "Usage: $0 <tutorial-dir>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "'$1' not a directory."
    exit 1
fi

TOC="$1/toc.js"

LINK='<li style="margin-top: 3rem;" class="part-title"><a href="../">Back to seL4 docsite</a>'

sed -i .bak "s|</li></ol>|</li>${LINK}</ol>|" "$TOC"
