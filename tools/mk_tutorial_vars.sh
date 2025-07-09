#!/bin/sh
#
# Copyright 2025 Proofcraft Pty Ltd
# SPDX-License-Identifier: BSD-2-Clause

# Generate _data/microkit_tutorial.yml from microkit_tutorial repo
#
# Usage: ./mk_tutorial_vars.sh <build.sh in microkit tutorial repo> <output_file>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <build.sh in microkit tutorial repo> <output_file>"
    exit 1
fi

INPUT_FILE="$1"
DATA_FILE="$2"

if [ ! -r "$INPUT_FILE" ]; then
    echo "Error: $INPUT_FILE is not readable."
    exit 1
fi

# Conver export VAR="value" to VAR: value
cat $INPUT_FILE | \
    grep -E '^export ' | \
    sed -E 's/^export ([^=]+)=(.*)$/\1: \2/' > $DATA_FILE

echo "$INPUT_FILE  ==>  $DATA_FILE"
