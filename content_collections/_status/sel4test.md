---
project: sel4test
permalink: projects/sel4test/status.html
redirect_from:
  - status/sel4test.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# seL4test Project Status

This project status page lists the status for currently supported features, components
and configurations for seL4Test and who is responsible for maintaining them.

## Features

### Test runner

seL4test requires itself to be started directly by seL4 as the root-task in the system.
This is the `sel4test-driver` binary and it then also serves as the main test runner.
It runs the configured tests and sets up the required test environment for each test.
It prints out test results over a serial connection. `sel4test-driver` is maintained
by the seL4 Foundation and is currently the only test runner that is expected to run
tests defined for seL4test.

### Test environments

Each test runs in a test environment. This environment provides the test with an
expected set of system resources required for it to run. There are currently two test
environments, listed below. It is possible for more test environments to be defined
in the future. The usual motivation for different test environments is different
system dependencies of the tests.


{% include component_list.md project='sel4test' type='test-environment' %}


### Test declarations

Tests can be declared in any library that can be linked with sel4test applications.
A test is defined by using a preprocessor macro defined by its test environment. This
will place the test into a named linker section that the test runner will use to
launch the test at runtime inside it's requested environment.

## Project manifests

{% include component_list.md project='sel4test' type='repo-manifest' %}



## Configurations

The set of tests that get run will be different for different kernel configurations.
Each test is able to specify a config requirement that will prevent the test from
being run if a certain config option isn't set in a compatible way. This means that
changing the build configuration can change which tests will be run.  To make it easier
to configure a build of seL4test that enables the right coverage of tests there is
a selection of meta-configuration options that are specific to seL4test. These options
are listed below and will be interpreted by seL4test and used to set sensible default
configuration values.

{% include component_list.md project='sel4test' list='configurations' %}
