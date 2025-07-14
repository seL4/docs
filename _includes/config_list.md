{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}
{%- assign project = site.data.projects[include.project] %}
{%- assign list = include.list | default: 'configurations' %}
{%- assign status = include.status | default: "Value" %}
{%- if include.code == false %}
{%-   assign code = "" %}
{%-   assign endcode = "" %}
{%- else %}
{%-   assign code = '<pre class="not-prose text-xs sm:text-tiny lg:text-xs"><code class="code-span">' %}
{%-   assign endcode = "</code></pre>" %}
{%- endif %}
<table class="hidden sm:block">
    <thead>
        <tr>
            <th>{{list | capitalize}}</th>
            <th>Description</th>
            {%- unless include.no_status %}
            <th>{{status}}</th>
            {%- endunless %}
        </tr>
    </thead>
    <tbody>
{%- for component in project[list] %}
{%-   if include.type and include.type != component.component_type -%}
{%-     continue %}
{%-   endif %}
{%-   if include.filter and component.status != include.filter %}
{%-     continue %}
{%-   endif %}
{%- capture link_text %}{{component.display_name_url}}{% endcapture %}
{%- capture display_text %}{{code}}{{component.display_name}}{{endcode}}{% endcapture %}
        <tr>
            <td>{% include cond-wrap-link.md text=display_text link=link_text %}</td>
            <td class="prose-p:m-0 prose-p:p-0">
              {{component.description | markdownify}}
            </td>
            {%- unless include.no_status %}
            <td>{{component.status}}</td>
            {%- endunless %}
        </tr>
{%- endfor -%}
    </tbody>
</table>

<div class="text-sm sm:hidden">
{%- for component in project[list] %}
{%-   if include.type and include.type != component.component_type -%}
{%-     continue %}
{%-   endif %}
{%-   if include.filter and component.status != include.filter %}
{%-     continue %}
{%-   endif %}
  <div class="mt-8 pb-2 mb-2 border-b-1 border-gray-200 dark:border-gray-700">
{%- capture link_text %}{{component.display_name_url}}{% endcapture %}
{%- capture display_text %}{{code}}{{component.display_name}}{{endcode}}{% endcapture %}
    <span class="font-semibold">{% include cond-wrap-link.md text=display_text link=link_text %}</span>
  </div>
  <div class="prose-p:m-0 prose-p:p-0">
    {{component.description | markdownify}}
  </div>
  {%- unless include.no_status %}
  <div class="mt-2 text-lighter">
      {{component.status}}
  </div>
  {%- endunless %}
{%- endfor -%}
</div>
