{%- comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{%- endcomment %}
{%- assign list = include.list | default: 'components' %}
{%- assign status = include.status | default: "Status" %}
{%- include config_list.md
        project=include.project
        list=list
        type=include.type
        code=include.code
        status=status
        no_status=include.no_status
        filter=include.filter %}
