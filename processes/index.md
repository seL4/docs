---
layout: api
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Processes

Documentation relating to development processes and how to get help or get involved in seL4
can be found on this page. Note that these are generalisations and may be different for a
particular project/repository.

The processes described here are managed by the [seL4 Foundation](https://sel4.systems/Foundation/).

## Development processes

Developing trustworthy systems requires identifying critical, trusted, system components and ensuring that they:

- are isolated from non-critical, untrusted, components
- have assurance of their trustworthiness

Determining appropriate system designs that clearly separate trusted from untrusted components and using this separation to achieve security and safety properties is beyond the scope of this section.
However,  given such a design, the seL4 ecosystem tries to provide components, infrastructure, and tools to implement it in a trustworthy way.

### What we work on

As a microkernel, seL4 intends to provide the smallest amount of mechanisms required to enable
securely multiplexing hardware. A full system requires many more components than only the microkernel.
We typically try and reuse existing components when possible, but below is a list of projects that
are currently maintained to support the seL4 ecosystem:

- [seL4](/projects/sel4): {{site.data.projects["sel4"].description}}.

- [seL4 verification](https://github.com/sel4/l4v): formal specifications and proofs for the seL4 microkernel.

- [Build system](/projects/buildsystem) and [tooling](/projects/sel4_tools): Tooling, system configuration and building used to build seL4 projects using mostly CMake.

- [Elfloader](/projects/elfloader): {{site.data.projects["elfloader"].description}}.

- [seL4 Run-time](/projects/sel4runtime): {{site.data.projects["sel4runtime"].description}}.

- [User environment libraries](/projects/user_libs): {{site.data.projects["user_libs"].description}}.

- [seL4 testing framework](/projects/sel4test): {{site.data.projects["sel4test"].description}}.

- [seL4 benchmarking framework](/projects/sel4bench): {{site.data.projects["sel4bench"].description}}.

- [CAmkES framework](/projects/camkes): {{site.data.projects["camkes"].description}}.

- [CapDL](/projects/capdl): {{site.data.projects["capdl"].description}}.

- Virtualization with [camkes-vm](/projects/camkes-vm): x86 and Arm Virtual Machines built as a CAmkES component.

- [sel4-tutorials](/projects/sel4-tutorials): {{site.data.projects["sel4-tutorials"].description}}.

- [Dockerfiles](/projects/dockerfiles): {{site.data.projects["dockerfiles"].description}}.

- [seL4 webserver reference application](/projects/sel4webserver): {{site.data.projects["sel4webserver"].description}}.

- [Hardware components](/projects/hardware_hacks): {{site.data.projects["hardware_hacks"].description}}.

#### Supported platforms

This all needs to be deployed on hardware components. The [Supported Platforms](/Hardware) page has a list of currently supported platforms.


### How we choose what we work on

Primarily, what we work on gets prioritised by externally funded projects and what is long-term strategic.
The strategic roadmap can be found on the [seL4 development and verification roadmap](https://sel4.systems/roadmap.html) page.

Some priority is also given to the maintained projects and repositories which involves responding to
breakages and reported issues as they arise.  Raising a GitHub issue on a relevant repository is the best way to get an issue
acknowledged. Alternatively, the *devel* mailing list or the seL4 Mattermost can be used to ask about potential issues.

Additionally, the [RFC process](https://sel4.systems/Contribute/rfc-process.html) is intended as a way to provide input on
longer-term priorities as well as a way to promote a collaborative design process on new kernel features
before larger effort is invested into their development. More information is provided on the RFC page above.


### Where we work on things

The code documented on this site is available from two GitHub organisations:

- <https://github.com/sel4/>: the seL4 kernel itself and the core
  repositories around it, managed by the [seL4
  Foundation](https://sel4.systems/Foundation/About).

- <https://github.com/sel4proj/>: additional tools, libraries, and projects around seL4, managed by the
  by the [Trustworthy Systems](https://trustworthy.systems) group at UNSW.

Each project has a list of which repositories it contributes to on its
documentation home page. Alternatively, the README.md of each repository
should indicate what its purpose is.

Communication about what is being developed can occur on any of the channels listed [below](#contact).
In particular:

- The *devel* mailing list, seL4 Mattermost and seL4 Discourse are for general development discussions.
- Discussions about proposed changes can reach a point where an
  [RFC](https://sel4.systems/Contribute/rfc-process.html) is created. Further discussion then happens on
  the RFC pull requests in the
  [RFC repository](https://github.com/seL4/rfcs/pulls?q=is%3Aopen+is%3Apr+-label%3Anot-rfc+).
- GitHub issue and Pull-request comment sections can also be used.

The [seL4 development and verification
roadmap](https://sel4.systems/roadmap.html) page lists major features and
projects that someone has committed to deliver.


## Contact

We use the following communication mechanisms:

- [Mailing lists](emails): For email-based discussions, for asking for help, reporting issues or general seL4 communication.
- [seL4 Discourse forum](https://sel4.discourse.group/): Forum for seL4. Attempting to build up useful knowledge-base.
- [seL4 Mattermost](https://mattermost.trustworthy.systems/sel4-external/). seL4 chat platform (Sign-up link can be found on [seL4 Discourse](https://sel4.discourse.group/t/sel4-mattermost-sign-up-link/125) with a valid account).
- GitHub issues: Reporting issues or creating pull requests on repositories
  located in the [seL4 GitHub org](https://github.com/seL4).
- [RFCs](https://github.com/seL4/rfcs): for reading and creating new seL4 features or larger ecosystem changes.
- [Websites](websites): Websites containing information about seL4.
- [seL4 Jira](https://sel4.atlassian.net): archive for old issue tracking on
  seL4, CAmkES, and formal verification before GitHub development.


## Contributing

We welcome your contributions to code, documentation and this website.
To ensure a collaborative environment, we expect all contributions and interactions to fall within our [Code of Conduct](https://sel4.systems/Contribute/conduct.html).

In addition to following the development process that is outset below, most of the software projects generally follow the following conventions:
- [Coding Conventions](https://sel4.systems/Contribute/style.html)
- [Git Conventions](https://sel4.systems/Contribute/git-conventions.html)
- [Pull Requests](https://sel4.systems/Contribute/pull-requests.html)

Additionally, each project may have a slightly augmented processes for contributing:
- [docs.sel4.systems](docs-contributing)
