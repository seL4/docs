{% capture file %}
{% include_absolute {{include.file}} %}
{% endcapture %}

{% if include.indent_headings %}
{% assign file = file | replace: '# ', '## ' %}
{% endif %}
{{ file }}
