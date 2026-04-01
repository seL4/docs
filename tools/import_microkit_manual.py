#!/usr/bin/env python3

# Copyright 2026 seL4 International
# SPDX-License-Identifier: BSD-2-Clause

"""Import the Microkit manual from _repos/sel4/microkit

Usage:
    import_microkit_manual.py [<dir>]

Read the manual from the current checkout of the microkit repo in
_repos/sel4/microkit, and transform it into docsite format.

If a directory is provided, write the output to projects/microkit/manual/<dir>/,
and point projects/microkit/manual/latest/ at it.

If no directory is provided, write the output to projects/microkit/manual/dev/.

Writes the following files:
- projects/microkit/manual/<dir>/index.md
- projects/microkit/manual/<dir>/assets/microkit_flow.svg
- projects/microkit/manual/<dir>/microkit_user_manual.pdf
"""

# This script is very ad hoc and makes many hardcoded assumptions about the
# structure of manual.md. Will need updating if that structure changes.

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

DOCS_ROOT = Path(__file__).resolve().parent.parent
MICROKIT_REPO = DOCS_ROOT / '_repos' / 'sel4' / 'microkit'
MANUAL_DST_BASE = DOCS_ROOT / 'projects' / 'microkit' / 'manual'


def skip_blank(lines: list[str], i: int) -> int:
    """Return the index of the first non-blank line at or after i."""
    return next((j for j in range(i, len(lines)) if lines[j].strip()), len(lines))


def transform_manual(source: str, target: str, git_hash: str) -> str:
    """Transform microkit manual.md into a docsite-compatible index.md."""

    copyright_text = '2021, Breakaway Consulting Pty. Ltd.'

    lines = source.splitlines()
    i = 0

    # Skip initial HTML comment block
    if lines and lines[0].strip() == '<!--':
        i = next(j for j, line in enumerate(lines) if line.strip() == '-->') + 1
        i = skip_blank(lines, i)

    if not lines[i].strip() == '---':
        sys.exit('error: expected LaTeX YAML front matter after initial comment block')

    # Skip the LaTeX YAML front matter
    i += 1
    while lines[i].strip() != '---':
        i += 1
    i = skip_blank(lines, i + 1)

    # Skip LaTeX lines (beginning with '\')
    while lines[i].startswith('\\'):
        i += 1
    i = skip_blank(lines, i)

    remaining = lines[i:]

    # Remove all \clearpage lines + blank line after
    cleaned: list[str] = []
    j = 0
    while j < len(remaining):
        if remaining[j].strip() == r'\clearpage':
            j += 1
            # drop one following blank line if present
            if j < len(remaining) and not remaining[j].strip():
                j += 1
        else:
            cleaned.append(remaining[j])
            j += 1

    # increase every heading level by one
    headed = ['#' + line if line.startswith('#') else line for line in cleaned]

    # replace pdf image path by svg
    body = '\n'.join(headed)
    body = body.replace('microkit_flow.pdf', 'microkit_flow.svg')
    body = body.strip()

    # docsite front matter
    version = f'dev-{git_hash}' if target == 'dev' else f'v{target}'
    new_header = (
        '---\n'
        'parent: /projects/microkit/manual/latest/\n'
        'toc: true\n'
        f'SPDX-FileCopyrightText: {copyright_text}\n'
        # add random space in here so spdx checker does not barf
        'SPDX-' 'License-Identifier: CC-BY-SA-4.0\n'
        'mathjax: true\n'
        '---\n'
        '\n'
        f'# Microkit User Manual ({version})\n'
        '\n'
        'This is a web version of the manual, you can find a PDF '
        '[here](microkit_user_manual.pdf) as well as in the\n'
        'SDK at `doc/microkit_user_manual.pdf`.\n'
        '\n'
    )
    return new_header + body + '\n'


def update_latest_symlink(tag: str) -> None:
    """Point projects/microkit/manual/latest at the new tag directory."""
    latest = MANUAL_DST_BASE / 'latest'
    if latest.is_symlink():
        latest.unlink()
    else:
        sys.exit('error: expected `latest` to be a symlink')
    os.symlink(tag, latest)
    print(f'updated latest -> {tag}')


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('dir', nargs='?', default='dev',
                        help='Directory to write the manual to (default: dev)')
    args = parser.parse_args()

    if not MICROKIT_REPO.is_dir():
        sys.exit(f'error: microkit repo not found at {MICROKIT_REPO}\n'
                 f'Run "make repos" first.')

    target_dir = args.dir
    git_hash = subprocess.check_output(
        ['git', 'rev-parse', '--short=6', 'HEAD'],
        cwd=MICROKIT_REPO, text=True
    ).strip()

    dst = MANUAL_DST_BASE / target_dir
    assets_dst = dst / 'assets'

    # Create destination directories
    dst.mkdir(parents=True, exist_ok=True)
    assets_dst.mkdir(exist_ok=True)

    # Transform and write index.md
    input_path = MICROKIT_REPO / 'docs' / 'manual.md'
    output_path = dst / 'index.md'
    manual_src = input_path.read_text()
    index_md = transform_manual(manual_src, target_dir, git_hash)
    output_path.write_text(index_md)
    print(f'wrote {output_path.relative_to(DOCS_ROOT)}')

    # Copy the SVG flow diagram
    input_path = MICROKIT_REPO / 'docs' / 'assets' / 'microkit_flow.svg'
    output_path = assets_dst / 'microkit_flow.svg'
    shutil.copy(input_path, output_path)
    print(f'wrote {output_path.relative_to(DOCS_ROOT)}')

    # Build PDF in the microkit repo and copy to the target directory
    print(f'Building PDF from {(MICROKIT_REPO / 'docs' / 'manual.md').relative_to(DOCS_ROOT)}')
    input_path = MICROKIT_REPO / 'docs' / 'manual.pdf'
    output_path = dst / 'microkit_user_manual.pdf'
    subprocess.run(
        ['pandoc', 'manual.md', '-o', 'manual.pdf'],
        cwd=MICROKIT_REPO / 'docs',
        env={**os.environ, 'TEXINPUTS': 'style:'},
        check=True
    )
    shutil.copy(input_path, output_path)
    print(f'wrote {output_path.relative_to(DOCS_ROOT)}')

    # Update symlink if not dev
    if target_dir != 'dev':
        update_latest_symlink(target_dir)


if __name__ == '__main__':
    main()
