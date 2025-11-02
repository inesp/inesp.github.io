---
layout: page
title: Topics
permalink: /topics/
---

The posts here are grouped by topic, to make sense of a growing list of thoughts.

<div class="colorful"></div>

{% assign tags_list = site.tags | sort %}

{% comment %}
tag[0] → the tag name, tag[1] → the array of posts under that tag

“Code Patterns” handles concrete implementations.
“Software Design Principles” handles abstract principles like simplicity or modularity.
“Engineering Research” handles reasoned or research-backed insights.
{% endcomment %}

<ul class="categories-list separator-space">
    {% for tag in tags_list %}
        {% assign tag_slug = tag[0] | slugify %}
        <li class="category">
            {% if tag_slug == "building-blocks-collection" or tag_slug == "cognitive-biases-in-code" %}
              📦
            {% else %}
              ✨
            {% endif %}<a href="{{ '/topic/' | append: tag_slug | relative_url }}">{{ tag[0] }}</a>
            <span class="badge">({{ tag[1] | size }} posts)</span>
        </li>
    {% endfor %}
</ul>

