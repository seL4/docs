
{% capture path %}
{{page.tutorial}}/{{page.tutorial}}.md
{% endcapture %}

{% assign view_url = 'https://github.com/sel4/' | append: "sel4-tutorials" | append: '/blob/master/tutorials/' | append: path %}
{% assign edit_url = 'https://github.com/sel4/' | append: "sel4-tutorials" | append: '/edit/master/tutorials/' | append: path %}

*Tutorial included from [github repo]({{view_url}}) [edit]({{edit_url}})*

{% include_absolute _repos/tutes/{{page.tutorial}}.md %}
