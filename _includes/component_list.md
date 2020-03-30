{% assign project = site.data.projects[include.project] %}

{% for component in project.components %}
    {%- if forloop.first == true %}
| Component  | Type | Description | Status  | Maintained by | Licensing |
|-|-|-|-|-|-|-|
    {%- endif %}
| {{component.display_name}}| {{component.component_type}} |{{component.description}}|{{component.status}}|{{component.maintainer}}|{{component.licensing}}|
{%- endfor %}
