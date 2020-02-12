---
redirect_from:
  - /CodeReview
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
    - are any concurrent PRs (in other repositorites) dependant on this PR?
- State what testing has been performed:
    - Run sel4test and for which platforms.

### Reviewers

- The Trustworthy Systems team will delegate reviewers.
- If you want a particular person to review, please tag them.
- If there hasn't been any activity after a couple of days, feel free to bump the post.

### Commits

- Commit history is part of the review
    - A good commit history assists reviewers in understanding the change
    - Please see the [Git conventions](/GitConventions).
- Good reviews are small reviews. Large PRs should only be created if neccessary.

## During a PR

- Always abide by our [Code of Conduct](/Conduct).

### Reviewers

- Take into account the context stated by the author.
- Review commits as well as code
- Request that the above guide be followed if it is not.
- Provide constructive feedback.
  - see the resources below.
- Remember to comment on good things.

### Authors

- Apply changes due to feedback from reviewers as additional commits, and squash them once the PR is
  ready to merge.
- Please attempt to only push changes to the PR branch once it is ready for re-review.
- Please communicate any changes you make during the review process.
- Apart from editing history, or fixing trivial issues, do not push changes to a PR once it has been
  approved.

## Resources

- [The principle of charity](http://fishbowl.pastiche.org/2009/10/20/the_principle_of_charity_2/)
- Code review for humans [part 1](https://mtlynch.io/human-code-reviews-1/) and [part
  2](https://mtlynch.io/human-code-reviews-2/)

