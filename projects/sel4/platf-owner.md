---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Becoming a platform owner

Below are the guidelines defined by the [Technical Steering Committee
(TSC)](https://sel4.systems/Foundation/TSC/) to become a *platform owner*.

This assumes that:
* the platform that you are after is not listed on the [Supported Platforms
  page](/Hardware/);
* from your available [options](/Hardware/index.html#not-in-the-lists-below),
  you choose to contribute the port or feature yourself;
* you are following the [guidelines for kernel
  contributions](/projects/sel4/kernel-contribution.html#) and the specific
  [Platform Porting guide](/projects/sel4/porting).





> A platform owner:
> * is the maintainer of platform specific kernel and library code for that
>   platform
> * is the “driver” for that platform (setting the direction where things are
>   going for the platform)
> * is usually one of the main code contributors for that platform
> * has the following responsibilities:
>   * keep the platform working, make sure sel4test and sel4bench are passing on
>     the master branch for all supported configurations (esp MCS, but also
>     multicore, and IOMMU/VCPU where relevant/appropriate) write and maintain
>     documentation for the platform,
> * help to keep the verification passing for verified configurations (only
>   relevant for a few platforms, but might increase in the future)
> * handle bug reports for that platform on github and devel mailing list (has
>   access to github issues and/or the new sel4 Jira at sel4.atlassian.net for
>   this if desired)
> * handle support requests/questions for that platform (if low-key, ideally
>   publicly on the mailing list, but also paid support etc for bigger things)
> * review and help merge PRs for that platform (relevant PRs should have one
>   approving review from the platform owner if possible)
> * providing binaries for bootloader and load instructions would be desirable
> * if other development on the master branch has platform impact (from
>   contributions or D61), it should preferably include relevant platform code
>   updates already, but might need consultation with the platform owner to get
>   done, i.e. the basic expectation would be “you break it, you fix it”, but
>   people sometimes might need help.
> * the foundation advertises platform owners on the website, and platform owners
>   would link back to the foundation.
