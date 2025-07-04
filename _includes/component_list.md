{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}
{%- assign project = site.data.projects[include.project] %}
{%- assign list = include.list | default: 'components' %}
{%- assign ignore_title_row = include.no_title | default: false %}
{%- assign end_table = include.continue_table | default: false %}
{%- assign status = include.status | default: "Status" %}
{%- if include.code %}
{%-   assign code = "<code>" %}
{%-   assign endcode = "</code>" %}
{%- else %}
{%-   assign code = "" %}
{%-   assign endcode = "" %}
{%- endif %}
{%- for component in project[list] %}
  {%- if list != 'roadmap' %}
    {%- if forloop.first == true and ignore_title_row == false %}
<table>
    <thead>
        <tr>
            <th>{{list | capitalize}}</th>
            <th>Description</th>
            <th>{{status}}</th>
        </tr>
    </thead>
    <tbody>
    {%- endif %}
    {%- if include.type and include.type != component.component_type -%}
        {%- continue %}
    {%- endif %}
{%- capture link_text %}{{component.display_name_url}}{% endcapture %}
{%- capture display_text %}{{code}}{{component.display_name}}{{endcode}}{% endcapture %}
        <tr>
            <td>{% include cond-wrap-link.md text=display_text link=link_text %}</td>
            <td class="prose-p:m-0 prose-p:p-0">
              {{component.description | markdownify}}
            </td>
            <td>{{component.status}}</td>
        </tr>
  {%- else %}
    {%- if forloop.first == true and ignore_title_row == false %}
<table class="table">
    <thead>
        <tr>
            <th>Feature</th>
            <th>Description</th>
            <th>Assigned</th>
            <th>{{status}}</th>
        </tr>
    </thead>
    <tbody>
    {%- endif %}
    {%- if include.type and include.type != component.roadmap_type -%}
        {%- continue %}
    {%- endif %}
{%- capture link_text %}{{component.display_name_url}}{% endcapture %}
{%- capture display_text %}{{code}}{{component.display_name}}{{endcode}}{% endcapture %}
        <tr class="{{component.presentation_style}}">
            <td>{% include cond-wrap-link.md text=display_text link=link_text %}</td>
            <td>{{component.description}}</td>
            <td>{{component.assigned}}</td>
            <td>{{component.status}}</td>
        </tr>
  {%- endif -%}
{%- endfor -%}
{%- if end_table == false %}
    </tbody>
</table>
{%- endif -%}
