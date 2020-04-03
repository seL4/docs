{% capture file %}
{% include_absolute {{include.file}} %}
{% endcapture %}
{% assign file = file | replace: site.static_url, '' %}

{% if include.indent_headings %}
{% assign file = file | replace: '# ', '## ' %}
{% endif %}
{{ file }}
