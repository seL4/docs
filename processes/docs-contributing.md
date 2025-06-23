---
redirect_from:
  - /DocsContributing
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Contributing to the seL4 documentation

Thank you for considering helping improve the seL4 documentation.

This page is about contributing to the [documentation site][docsite].  For contributing to other parts of the seL4 ecosystem,
visit our main [contributing page][contribute].

[docsite]: ../
[contribute]: https://sel4.systems/Contribute/

We believe that documentation is important for any project and appreciate any contributions that improves it.
The sort of contributions that we are looking for are:
- Bug reporting
   - Stale or incorrect sections
   - Missing documentation
   - Ideas of how our documentation could be structured differently
- Improvements
   - Grammar and spell fixes (Nitpicks)
   - Missing documentation
   - Usage examples
   - Tutorials
   - Links to related external documentation

For reporting issues about a particular project, please use the relevant repository's issue tracker or post on the [Devel mailing list][mailing-list].

[mailing-list]: https://lists.sel4.systems/postorius/lists/devel.sel4.systems/

As a reminder, all contributors are expected to follow our [Code of Conduct][conduct].

[conduct]: https://sel4.systems/Contribute/conduct.html


## Your First Contribution

You have noticed something that is wrong with some documentation on the site.  GitHub makes it pretty easy to edit Markdown files without having to leave the browser. By clicking edit on the relevant file, making your change and then submitting a pull request someone can then review you change and merge it which will result in the update appearing on the website.

More detailed changes can be achieved by checking out the repository and editing locally, followed by committing and making a pull request manually.  The README.md describes how to host the site locally so that you can see how your changes are presented.

Contributions that are most helpful to us at the moment are:

- Identifying which pages contain stale documentation.  Filing an issue in the issue tracker will let us know that something is broken or old.
- Identifying areas where there is missing documentation or it is confusing
- Fixing any syntax errors left over from our migration from the old wiki site.


## Submitting a contribution

Contributions can be submitted by pull requests at <https://www.github.com/seL4/docs>.

Please follow the [git commit style guide](https://sel4.systems/Contribute/git-conventions.html).

### Style

This repo contains sources in various formats.  We will add style guides and tools for checking conformance to these style guides.
If there isn't a tool to check style conformance, then we won't be too pedantic about if the style is being followed correctly.  The general principle is to follow the same style used in the rest of the file or similar files.

See the README.md for instructions on running style checks.

Languages and styleguides that are used:
- Markdown: GitHub flavoured markdown, rendered by kramdown.  [Styleguide](https://github.com/slang800/markdown-styleguide).  We intend on eventually using [tidy-markdown](https://github.com/slang800/tidy-markdown) but the current codebase isn't compliant yet.
- HTML: Should be only used for presentation related content. Try and use markdown when possible. [Styleguide](https://google.github.io/styleguide/htmlcssguide.html).  We use [tidy](http://www.html-tidy.org/) for detecting errors in the generated site.
- SASS: Our styling should be kept into the `assets/css` folders.  We don't currently follow a style guide.
- Liquid templating language: We use [liquid-linter](https://www.npmjs.com/package/liquid-linter-cli) to check for liquid errors.
- python: use `pylint` if you want.
- Makefile: tabs not spaces.

### Code review process
Someone who is familiar with the source will review your changes.  They may request changes or have questions.
If no more feedback is required, we will likely approve and then merge the PR.


## Reporting an issue or feature enhancement

To report an issue, open an issue in the repository issue tracker.  Issues can be reporting problems, or ideas for improvement.

- What is the issue?
- Why is it a issue?

And if relevant
- What do you think a good fix or change may be?
- How the fix or change removes the issue?


## Community
Most community discussions about seL4 occur on our [Devel mailing
list][mailing-list].  There is also a [seL4
Mattermost](https://mattermost.trustworthy.systems/sel4-external/) chat
room.  (The sign-up link can be found on  [seL4 Discourse](https://sel4.discourse.group/t/sel4-mattermost-sign-up-link/125) with a valid account).

