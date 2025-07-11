---
redirect_from:
  - /Developing/Building/
project: buildsystem
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# System configuration and building

seL4 and related projects use the [CMake](https://cmake.org/) family of tools to implement its build system.
The seL4 build system refers to a collection of CMake scripts that manage:
- system configuration: Configuration options such as platform flags and application settings.
- dependency structures: Tracking build order dependencies
- builds: Generating binary artifacts that can then be deployed on hardware.


The following documentation covers how to use the seL4 build system to:
- perform system configuration and builds
- incorporating the build system into a project
- Kernel stand-alone configuration and builds

## CMake basics

For a complete guide to CMake you can read the [extensive documentation](https://cmake.org/cmake/help/latest/),
but for the purposes here we will assume a particular workflow with CMake involving out of tree builds.

CMake is not itself a build tool, but rather is a build generator. This means that it generates build scripts,
typically Makefiles or Ninja scripts, which will be used either by a tool like GNU Make or Ninja to perform
the actual build.

### Pre-requisites

It is assumed that

 * CMake of an appropriate version is installed.
 * You are using the Ninja CMake generator.
 * You understand how to checkout projects using the repo tool as described on the
   [set up instructions](/projects/buildsystem/host-dependencies.html) page.
 * You have the [required dependencies](/projects/buildsystem/host-dependencies.html) installed to build your project.


{% comment %}
This liquid templating pulls an excerpt out of the child documentation pages to display under the links below to provide slightly more context about the contents.  Using excerpts from other pages prevents the descriptions from getting out of date.
{% endcomment %}

{% for page in site.pages %}
{% case page.path %}
  {% when "projects/buildsystem/standalone.md" %}
    {% assign seL4Standalone = page.content | split:'<!--excerpt-->' %}
  {% when "projects/buildsystem/using.md" %}
    {% assign using = page.content | split:'<!--excerpt-->' %}
  {% when "projects/buildsystem/incorporating.md" %}
    {% assign incorporating = page.content | split:'<!--excerpt-->' %}
  {% else %}
{% endcase %}
{% endfor %}

## [Configuring and building seL4 projects](/projects/buildsystem/using.html)

> {{ using[1] | strip }}

## [Incorporating the build system into a project](/projects/buildsystem/incorporating.html)

> {{ incorporating[1] | strip }}

## [Kernel standalone builds](/projects/buildsystem/standalone.html)

> {{ seL4Standalone[1] | strip}}


## Gotchas

List of gotchas and easy mistakes that can be made when using cmake

 * Configuration files passed to to cmake with `-C` *must* end in `.cmake`, otherwise CMake will silently throw
   away your file
