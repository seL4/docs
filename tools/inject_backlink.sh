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

LINK='<li style="margin-top: 3rem;" class="part-title"><a href="../">Back to seL4 docsite</a>'

for FILE in "$1"/*.html "$1"/root-task/*.html "$1"/microkit/*.html; do
  echo "injecting backlink: $FILE"
  sed -i .bak "s|</li></ol>|</li>${LINK}</ol>|" "$FILE"
done
