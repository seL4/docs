---
title: Project Status
project: camkes
permalink: projects/camkes/status.html
redirect_from:
  - status/camkes.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Camkes Project Status

This status page currently shows the status of CAmkES features and supplied components.
The feature list currently only tracks features of the CAmkES Architecture Description Language.
Other CAmkES features that are currently not tracked here include: Plugins, Templating engine,
CAmkES component runtime environments,  Procedure IDL interfaces, CDL refine verification, Tooling
and VisualCamkes.


## Features

### Camkes Architecture Description Language (ADL)

Features of the CAmkES ADL are listed below.  Features that are more experimental
may not be compatible with the CDL-refinement CAmkES tooling. The Status field for
each feature aims to indicate any known compatiblility issues related to a feature.

{% include component_list.md project='camkes' list='features' type='adl-feature' %}


## Components

### Example Applications

{% include component_list.md project='camkes' type='camkes-application' %}

### Reusable components

{% include component_list.md project='camkes' type='camkes-component' %}


### Camkes Connectors

{% include component_list.md project='camkes' type='camkes-connector' %}

## Project manifests

### Camkes project manifests
These manifests are available for checking out the example CAmkES applications.

{% include component_list.md project='camkes' type='repo-manifest' %}



## Configurations

### Camkes sample apps

The project containing all of the CAmkES example applications has a couple of configuration
options for selecting the example app and seL4 platform it runs on.

{% include component_list.md project='camkes' list='configurations' type='camkes-option' %}
