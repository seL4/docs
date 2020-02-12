---
toc: true
redirect_from:
  - /HostDependencies
---

# Host Dependencies

This page describes how to set up your host machine to build and run seL4 and its supported projects. To compile and use seL4 you can either:

* *Recommended:* Use Docker to isolate the dependencies from your machine. Detailed instructions for using Docker for building seL4, Camkes, and L4v can be found [here](Docker).
* Install the following dependencies on your local OS

The following instructions describe how to set up the required dependencies on your local OS. This page assumes you are building in a Linux OS. We however encourage site [contributions](https://docs.sel4.systems/DocsContributing) for building in alternative OSes (e.g. macOS).

## Get Google's Repo tool

The primary way of obtaining and managing seL4 project source is through the use of Google's repo tool. To get repo, follow the instructions described in the section “Installing Repo” [here](http://source.android.com/source/downloading.html#installing-repo).

See the [RepoCheatsheet](/RepoCheatsheet) page for a quick explanation of how we use Repo.

{% assign items = site.dependencies | sort: 'order_priority' %}
{% for project in items %}

{{ project.content }}

{% endfor %}
