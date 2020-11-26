---
redirect_from:
  - /CodeReview
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Pull Request Conventions

This is a guide for conducting effective and efficient pull requests in our code projects and
applies to all github sources.

In general, a pull request (PR) should communicate what the change is, and why it's necessary.

## Creation

Pull requests should be created from personal forks. We follow a [fork-rebase
workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow).

### Title

- For a single commit, the title is the subject line of the commit message.
- Otherwise, the title should summarise the set of commits.

### Description

- Must state the *why* and the *how* for the change.
    - Usually this is the body of your commit message.
- Must explain the purpose of the PR, e.g.:
    - feedback for an initial implementation,
    - request for comment,
    - ready to merge.
- Explain any context:
    - is it part of a greater set of changes?
    - are any concurrent PRs (in other repositories) dependent on this PR?
- State what testing has been performed:
    - Run sel4test and for which platforms.

### Reviewers

- The [TSC][1] of the seL4 foundation will delegate reviewers to approve. Anyone can help to review a pull request.
- If you want a particular person to review, please tag them.
- If there hasn't been any activity after a couple of days, feel free to bump the post.
- Pull requests require at least one approving review for merge,
  and usually should aim for 2 reviews on each non-trivial pull request.

[1]: https://sel4.systems/Foundation/TSC

### Commits

- Commit history is part of the review
    - A good commit history assists reviewers in understanding the change
    - Please see the [Git conventions](/GitConventions).
- Good reviews are small reviews. Large PRs should only be created if necessary.

### Tests

- The foundation repositories require the following tests to pass
  before a pull request can be merged:
  - code style
    - these may vary per repository and language, but default should
      standardise on those in the repository
      [seL4/seL4_tools](https://github.com/seL4/seL4_tools/tree/master/misc)
  - developer certificate of origin ([DCO][dco])
  - checks for SPDX license tagging (using the [REUSE tool][reuse])
  - any applicable regression tests:
    - these vary per repository
    - for seL4 itself, they must include:
      - compile test
      - hardware and/or simulator runs
      - the proofs
    - for verification target repositories (currently mainly seL4):
      - a pull request can only be merged on the master branch if either
        the corresponding proof is updated or if there is no proof impact.
      - there is no proof impact if:
        - the preprocessed source for verified code has not changed
          (this is tested by the "preprocess" check on GitHub), or
        - the proof still works unchanged despite the code change
          (please ping the `@verification` team on the GitHub seL4 org when
          the "preprocess" check fails and you think the proof might still
          work).
      - for proof updates:
        - submit a pull request to the [`l4v`](https://github.com/seL4/l4v)
          repository together with the
          pull request for the [`seL4`](https://github.com/seL4/seL4)
          repository, or
        - ping the `@verification` team on the GitHub seL4 org for help in
          updating the proofs, or
        - talk to the [seL4 Foundation][foundation] about finding funding
          and/or volunteers for the proofs updates if it is a bigger project.

- Exceptions are possible by approval of someone in the [Committer][Committers] role

[Committers]: roles.html
[Reuse]: https://reuse.software
[DCO]: contributing.html
[foundation]: https://sel4.systems/Foundation/

## During a PR

- Always abide by the [seL4 Code of Conduct](/Conduct).

### For Reviewers

- Take into account the context stated by the author.
- Review commits and commit messages as well as code
- Request that the above guide be followed if it is not.
- Provide constructive feedback.
  - see the resources below.
- Remember to comment on good things.

### For Authors

- Apply changes due to feedback from reviewers as additional commits, and squash them once the PR is
  ready to merge.
- Please attempt to only push changes to the PR branch once it is ready for re-review.
- Please communicate any changes you make during the review process.
- Apart from editing history, or fixing trivial issues, do not push changes to a PR once it has been
  approved.

## Merging

- Anyone in the [Committer][Committers] role can merge pull requests after they
  satisfy the required tests and approvals.

- Currently, for many repositories in the seL4 GitHub org, the
  Trustworthy Systems (TS) group still provides continuous integration
  (CI) infrastructure on their internal servers. For these
  repositories, someone from TS will merge the pull request on that
  internal infrastructure, and it will be pushed out to GitHub
  automatically by the CI pipeline. Some of these tests, especially
  those involving proofs may run for multiple hours, some more than
  24h, so it might take some time for the merge to become visible.

  You can recognise these repositories by the fact that they require 6
  (instead of 1) approving reviews for pull requests -- this is merely a
  mechanism to prevent accidental merges.

  The seL4 foundation is working on making this CI infrastructure more
  accessible directly on GitHub to avoid this additional step, but it
  will require some time and resources to do so. If you're interested
  in helping with this, please email the [TSC chair][TSC].

- As long as the CI infrastructure is hosted by TS, some pull requests
  will continue to be handled directly internally on the TS group's
  infrastructure. The TS group must abide by the same rules for these
  as outlined above.

[TSC]: https://sel4.systems/Foundation/TSC/

## Resources

- [The principle of charity](http://fishbowl.pastiche.org/2009/10/20/the_principle_of_charity_2/)
- Code review for humans [part 1](https://mtlynch.io/human-code-reviews-1/) and [part
  2](https://mtlynch.io/human-code-reviews-2/)

