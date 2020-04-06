{%- assign project = site.data.projects[include.project] %}
{%- assign list = include.list | default: 'components' %}
{%- assign ignore_title_row = include.no_title | default: false %}
{%- for component in project[list] %}
    {%- if forloop.first == true and ignore_title_row == false %}
| {{list | capitalize}}   | Description | Status  | Maintained by |
|-|-|-|-|-|-|
    {%- endif %}
    {%- if include.type and include.type != component.component_type -%}
        {%- continue %}
    {%- endif %}
{%- capture link_text %}{{component.display_name_url}}{% endcapture %}
{%- capture display_text %}{{component.display_name}}{% endcapture %}
| {% include cond-wrap-link.md text=display_text link=link_text %} |{{component.description}}|{{component.status}}|{{component.maintainer}}|
{%- endfor -%}
