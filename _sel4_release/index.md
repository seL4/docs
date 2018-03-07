---
layout: collection
title: seL4 releases
---

# seL4 releases

## Master (verified kernel)
{% assign coll = page.collection %}
{% for release in site[coll] reversed  %}
{% if release.path != page.path %}
    {% if release.variant != "mcs" %}

[{{ release.title }}]({{ release.url }})
([manual](http://sel4.systems/Info/Docs/seL4-manual-{{ release.version }}.pdf))

    {% endif %}

{% endif %}
{% endfor %}

## Experimental Branches


### Mixed Criticality Support (MCS) / Realtime
{% for release in site[coll] reversed  %}
    {% if release.path != page.path %}
        {% if release.variant == "mcs" %}
[{{ release.title }}]({{ release.url }})
([manual](http://sel4.systems/Info/Docs/seL4-manual-{{ release.version }}.pdf))
        {% endif %}

    {% endif %}
{% endfor %}
