#! /usr/bin/env python3

# Copyright 2025 Proofcraft Pty Ltd
# SPDX-License-Identifier: BSD-2-Clause

# Process mdbook .md files to
#  - execute `{{#include "path/to/file.md"}}` directives
#  - convert tab directives Jekyll includes used in the docsite

import os
import re
import argparse

def inclusion_content(input_path, match):
    include_path = match.group(1)
    start_line = match.group(2)
    end_line = match.group(3)

    full_path = os.path.join(input_path, include_path)
    if os.path.exists(full_path):
        with open(full_path, 'r', encoding='utf-8') as inc_file:
            lines = inc_file.read().splitlines()
            if start_line is None:
                start_line = 1
            if end_line is None:
                end_line = len(lines)
            else:
                end_line = int(end_line)
            # Return the specified lines as a string
            return '\n'.join(lines[int(start_line)-1:end_line])
    else:
        print(f'Include file {include_path} not found in {input_path}')
        return f'<!-- Include file {include_path} not found -->'

def process_mdbook(input_file, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Read entire input file
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Process include directives with line numbers
    include_pattern = re.compile(r'{{#include[ ]*([^ :]+)(?::(\d+):(\d+))?[ ]*}}')
    input_path = os.path.dirname(input_file)
    content = re.sub(include_pattern, lambda match: inclusion_content(input_path, match), content)

    # Convert tab directives to Jekyll includes
    # {{#tabs }}, {{#endtabs }}, {{#endtab }}
    pat = re.compile(r'{{#([a-z]*tabs?)[ ]*}}')
    content = re.sub(pat, r'{% include \1.html %}', content)

    # "{{#tab name="Linux" }}"
    pat = re.compile(r'{{#tab name="([^"]+)"[ ]*}}')
    content = re.sub(pat, r'{% include tab.html title="\1" %}', content)

    # Write processed content
    output_file = os.path.join(output_dir, os.path.basename(input_file))
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process mdbook .md files for includes and tabs.')
    parser.add_argument('input_file', help='Path to the input .md file')
    parser.add_argument('output_dir', help='Directory to save the processed output')

    args = parser.parse_args()
    process_mdbook(args.input_file, args.output_dir)
