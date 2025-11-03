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

{% assign collection_tags = "building-blocks-collection,cognitive-biases-in-code,self-documenting-code" | split: "," %}

{% comment %}
I loop over the lists 2x to first print out all the collections and after to print the other tags.
{% endcomment %}

<ul class="categories-list separator-space">
    {% for tag in tags_list %}
        {% assign tag_slug = tag[0] | slugify %}
        {% assign tag_title = tag[0] %}
        {% assign num_of_posts = tag[1] | size %}
        {% if collection_tags contains tag_slug %}
            {% include post_in_topic.html emoji="📦" tag_title=tag_title tag_slug=tag_slug num_of_posts=num_of_posts %}
        {% endif %}
    {% endfor %}
    {% for tag in tags_list %}
        {% assign tag_slug = tag[0] | slugify %}
        {% assign tag_title = tag[0] %}
        {% assign num_of_posts = tag[1] | size %}
        {% if collection_tags contains tag_slug %}
        {% else %}
            {% include post_in_topic.html emoji="✨" tag_title=tag_title tag_slug=tag_slug num_of_posts=num_of_posts %}
        {% endif %}
    {% endfor %}
</ul>

