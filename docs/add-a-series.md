# Add a series (a collection of related posts)

A "series" is just a group of posts that share a `series:` value in their front matter, plus an entry in `_data/topics.yml` that gives that value a display title (and optionally an icon).

1. Add an entry to `_data/topics.yml`, keyed by the exact series name you'll use in post front matter:
   ```yaml
   My New Series:
     display_title: "My New Series"
   ```
2. To make it show up as a "series" (stack/custom icon, "part of a series" wording, its own topic page treatment) rather than a plain topic, add its name to the `collection_tags` list at the bottom of the same file:
   ```yaml
   collection_tags:
     - My New Series
   ```
   Skipping this step still groups the posts and shows the title, it just won't get the series-specific icon/wording.
3. Optionally give it a custom icon instead of the default "stack": see [add-a-custom-icon.md](add-a-custom-icon.md), then add `icon: "your-icon-name"` under the series' entry in `_data/topics.yml`.
4. In each post that belongs to the series, set the front matter:
   ```yaml
   series: "My New Series"
   tags: ["My New Series", "..."]
   ```
   The name has to match the `_data/topics.yml` key exactly (it's a hash lookup, not a slug match).
5. To chain posts in reading order, add `prev_post`/`next_post` to each post's front matter (the value is the filename without the date-prefixed path or extension, e.g. `2026-02-24-api-resilience-resumable-pagination`). Run `make check-links` to verify the chain is correct and reciprocal.
6. Check it on `/topic/<slugified-series-name>/` and on the homepage's "Selected writing" section (if you add it to the list in `_includes/selected_writing.html`).

## Worked example, start to finish

Adding a series called "My New Series" with a custom icon, and one post in it.

`_data/topics.yml` — add the entry anywhere in the file, and the name to `collection_tags` at the bottom:

```yaml
My New Series:
  display_title: "My New Series"
  icon: "your-icon-name"

collection_tags:
  - My New Series
```

`_posts/2026-09-11-my-new-series-intro.md` — front matter for the first post:

```yaml
---
title: "My New Series, Part 1"
series: "My New Series"
tags: ["My New Series", "Some Other Tag"]
next_post: 2026-10-01-my-new-series-part-2
---
```

`_posts/2026-10-01-my-new-series-part-2.md` — the second post, pointing back:

```yaml
---
title: "My New Series, Part 2"
series: "My New Series"
tags: ["My New Series"]
prev_post: 2026-09-11-my-new-series-intro
---
```

Then `make check-links` to confirm the `prev_post`/`next_post` pair is reciprocal, and `make up` to look at `/topic/my-new-series/`.
