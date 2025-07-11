---
redirect_from:
  - /DocsContributing
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Contributing to the seL4 documentation

Thank you for considering helping improve the seL4 documentation.

This page is about contributing to the [documentation site][docsite].  For
contributing to other parts of the seL4 ecosystem, visit our main [contributing
page][contribute].

We believe that documentation is important for any project and appreciate any
contributions that improves it. The sort of contributions that we are looking
for are:

- Bug reporting
  - Stale or incorrect sections
  - Missing documentation
  - Ideas of how our documentation could be structured better
- Improvements
  - Grammar, consistency, and spelling fixes
  - Missing documentation
  - Usage examples
  - Tutorials
  - Links to related external documentation

For reporting issues about a particular project, please use the relevant
repository's issue tracker or if that doesn't work post on any of the [community
channels][support].

## Your first contribution

You have noticed something that is wrong with some documentation on the site.
GitHub makes it pretty easy to edit Markdown files without having to leave the
browser. By clicking "Edit" on the relevant file, making your change and then
submitting a pull request, someone can then review you change and merge it which
will result in the update appearing on the website.

More detailed changes can be achieved by checking out the repository and editing
locally, followed by committing and making a pull request manually.  The
`README.md` files describes how to host the site locally so that you can see how
your changes are presented.

Contributions that are most helpful to us at the moment are:

- Identifying which pages contain stale documentation.  Filing an issue in the
  issue tracker will let us know that something is broken or old.
- Identifying areas where there is missing documentation or it is confusing.

## Submitting a contribution

Contributions can be submitted by pull requests at <https://www.github.com/seL4/docs>.

Please follow the [git commit style guide](https://sel4.systems/Contribute/git-conventions.html).

### Style

This repository contains sources in various formats. The general principle is to
follow the same style used in the rest of the file or similar files.

Languages and style guides that the docsite uses:

- Markdown: GitHub flavoured markdown, rendered by kramdown.
  [Styleguide](https://github.com/slang800/markdown-styleguide). Please wrap
  lines at 80 characters.
- HTML: Should be only used for presentation related content.
  Use markdown when possible. [Styleguide](https://google.github.io/styleguide/htmlcssguide.html).
- Liquid templating language: We use
  [liquid-linter](https://www.npmjs.com/package/liquid-linter-cli) to check for
  liquid errors.

### Code review process

Someone who is familiar with the source will review your changes.  They may
request changes or have questions, or merge the pull request if everything looks
good.

## Reporting an issue or feature enhancement

To report an issue, open an issue in the [repository issue tracker][issues].
Issues can be reporting problems, or ideas for improvement.

- What is the issue?
- Why is it a issue?

And if relevant

- What do you think a good fix or change may be?
- How the fix or change removes the issue?

[support]: https://sel4.systems/support.html
[contribute]: https://sel4.systems/Contribute/
[docsite]: ../
[issues]: https://github.com/seL4/docs/issues
