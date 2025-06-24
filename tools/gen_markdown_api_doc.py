#! /usr/bin/env python3

# Copyright 2020 Data61, CSIRO
# SPDX-License-Identifier: BSD-2-Clause

import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-f", "--file", dest="file", type=str,
                    help="Markdown location (within repository)")
parser.add_argument("-o", "--output", dest="output", type=str,
                    help="Output docsite file")
parser.add_argument("-p", "--parent", dest="parent", type=str,
                    help="Parent file on docsite")
args = parser.parse_args()

base = os.path.basename(args.file)
title = os.path.splitext(base)[0]
output = '''---
title: {0}
layout: "api"
toc: true
parent: "/projects/virtualization/docs/{1}"
---

{{% include_absolute {2} %}}
'''.format(title, args.parent, args.file)
with open(args.output, "w") as output_file:
    output_file.write(output)
