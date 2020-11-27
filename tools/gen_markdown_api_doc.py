#! /usr/bin/env python3

# Copyright 2020 Data61, CSIRO
# SPDX-License-Identifier: BSD-2-Clause

import sys
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-f", "--file", dest="file", type=str,
                    help="Markdown location (within repository)")
parser.add_argument("-o", "--output", dest="output", type=str,
                    help="Output docsite file")
args = parser.parse_args()

base = os.path.basename(args.file)
title = os.path.splitext(base)[0]
output = '''---
title: {0}
---

{{% include_absolute {1} %}}
'''.format(title, args.file)
with open(args.output, "w") as output_file:
    output_file.write(output)
