---
toc: true
redirect_from:
  - /GitConventions
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Git conventions

This page outlines the conventions we attempt to use for our git history. Note that this applies to
pull requests where the content is ready to merge to the master branch.
If you are raising a pull request for feedback, you do not
need to follow the history conventions, but please note this in the description of the pull request
to avoid confusion. 

We will review the history in pull requests that are in a *ready to merge* state. If you need help
with git, or advice on how to structure your history, please reach out.

Note that our work-flow is a [fork-rebase
workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow). 

## Commit messages

Please follow the git commit [style guide](https://chris.beams.io/posts/git-commit/). Briefly:

* Use a subject line to summarize the commit.
* Limit the subject line to roughly 50 characters.
* Capitalise the subject line.
* Avoid endpoint the subject line in a full stop.
* Use the imperative mood in the subject line.
* Follow this with a blank line, then a summary of why the changes are required, and if non-trivial,
  how they are required.
* Wrap the body at 72 chars.

## Whitespace and style

* Please keep whitespace and style changes in their own commits, not mixed with other changes.
* If making a trivial commit, please prefix with `trivial:`

## History

* Merge commits are prohibited.
* Revert commits which act on the contents of the PR are prohibited.
* Commits should make the changes easier to follow: if you move a function and change it, please do
  so in separate commits.
* Commits should be separated into functional, logical changes, unless those changes are dependant.
  if you find yourself writing a commit message which says 'Fix X and clean up Y', you should
      probably use two commits.

## Further resources

* [LearnGitBranching](http://pcottle.github.io/learnGitBranching/)
* Interactive [Git cheat sheet](http://ndpsoftware.com/git-cheatsheet.html#loc=stash)

