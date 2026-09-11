# Front matter reference

The full list of front matter fields the templates actually read. If you add or stop using a field, update this file (and `.claude/CLAUDE.md`'s shorter copy, if that's still in sync with this one).

## Posts (`_posts/*.md`)

Copy-paste template, every field included. Delete whatever you don't need — only `title` and `tags` are required.

```yaml
---
title: "Post Title"
tags: ["Some Tag", "Another Tag"]

# Series (optional) — see add-a-series.md. Must match a key in _data/topics.yml exactly.
series: "Series Name"

# Chapter links within a series (optional). Value is the filename, no date-prefixed
# path and no extension. Verify with `make check-links`.
prev_post: 2026-02-24-some-earlier-post-slug
next_post: 2026-09-09-some-later-post-slug

# Excerpt length override for post listings (optional, default is 15-30 depending on context).
intro_truncatewords: 30

# Social/OG preview image, site-root-relative path (optional, read by jekyll-seo-tag).
image: /assets/topic-slug/social-preview.png

# Extra CSS class(es) on the post body wrapper (optional, rarely needed for posts).
css: ""

# Full-width layout instead of the centered reading column (optional, default false).
fluid: false

# External sources / further reading (optional).
biblio:
  - title: "Source Title"
    link: https://example.com/source
---
```

Field-by-field:
- `title`: Post title.
- `tags`: Array of tag names (e.g. `["API Resilience Patterns", "Code Patterns"]`); each tag becomes a `/topic/<slug>/` page.
- `series`: Optional series/collection name; must match a key in `_data/topics.yml` exactly. Adds a collection link above the title and groups the post under a shared topic page. See [add-a-series.md](add-a-series.md).
- `biblio`: Optional array of `{title, link}` objects, rendered as an "External sources" section.
- `prev_post` / `next_post`: Optional post slugs linking chapters within a series. Verify with `make check-links`.
- `intro_truncatewords`: Optional override for how many words of the excerpt to show in post listings.
- `image`: Optional path to a social/OG preview image, picked up by the jekyll-seo-tag plugin.
- `css`: Optional extra CSS class(es) applied to the post body wrapper.
- `fluid`: Optional boolean; when true, renders the page in the full-width layout instead of the centered reading column.
- `author`: Defaults to "Ines Panker" via `_config.yml`; can be overridden per post (rare, no example above since it's basically never needed).

## Topic pages (`tags/*.md`)

Pages with `layout: topic` support three fields. Copy-paste template for a brand new plain topic:

```yaml
---
layout: topic
title: My Topic Name
permalink: /topic/my-topic-name/
tags: My Topic Name
---

One or two sentences describing what this topic covers.
```

- `title`: Page title.
- `permalink`: URL for the topic page, e.g. `/topic/algorithms/`.
- `tags`: The single tag name this page filters posts by (a plain string here, not an array — this is the one place it isn't a list).

## Series data (`_data/topics.yml`)

Copy-paste template for a new entry, plus the `collection_tags` line that makes it a "series" instead of a plain topic (see [add-a-series.md](add-a-series.md) for the full walkthrough):

```yaml
My New Series:
  display_title: "My New Series"
  icon: "your-icon-name"   # optional — see add-a-custom-icon.md; omit to use the default "stack" icon
  home_intro: ""           # optional, currently unused, reserved for future use

collection_tags:
  - My New Series
```

- `display_title`: Shown instead of the raw key wherever the series is referenced.
- `icon`: Optional icon name from `_includes/career_icon.html`, used instead of the default "stack" icon on the topic page and homepage cards. See [add-a-custom-icon.md](add-a-custom-icon.md).
- `home_intro`: Short blurb field (currently unused, reserved for future use).

The `collection_tags` key lists which tag names count as a "series" (collection icon, "part of a series" framing) rather than a plain topic.
