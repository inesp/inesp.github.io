# Maintaining this site

Internal notes for future-me. Not published (this folder is in `_config.yml`'s `exclude` list), so it only ever lives in the repo.

Guides:
- [Add a blog post](add-a-post.md)
- [Add a series (collection of posts)](add-a-series.md)
- [Add a custom icon](add-a-custom-icon.md)
- [Front matter reference](front-matter-reference.md)
- Running the site locally, dependency upgrades, deployment, and the private drafts workflow: the root [README.md](../README.md) already covers all of that in detail, no need to duplicate it here.

## Where things are

| I want to... | Look at |
|---|---|
| Write a new post | `_posts/YYYY-MM-DD-slug.md` |
| Change a post's front matter options | [front-matter-reference.md](front-matter-reference.md) |
| Add/edit a series (a "collection" of posts) | `_data/topics.yml` |
| Add/edit a plain topic page (e.g. `/topic/celery/`) | `tags/*.md` |
| Change colors | `_sass/colors.scss` (never hardcode a color elsewhere) |
| Change page layout/structure | `_layouts/` (`default`, `home`, `post`, `page`, `topic`) |
| Change a reusable snippet (sidebar, head, biblio, images, icons...) | `_includes/` |
| Change CSS for a specific component | `_sass/*.scss`, imported from `assets/bs-override.scss` |
| Add/reuse a small inline icon | `_includes/career_icon.html`, see [add-a-custom-icon.md](add-a-custom-icon.md) |
| See every icon at a glance | `/styleguide/` on the running site, "Career Icons" section |
| See every custom CSS class available in post content | `/styleguide/` (the whole page) |
| Update the CV / career timeline | `cv.md` |
| Add/update a talk you've given or scheduled | `_data/talks.yml` |
| Add/update a talk pitch (not yet given, shown in the "Talk Catalogue") | `_data/talk_catalogue.yml` |
| Put images for a post somewhere | `assets/<topic-slug>/`, referenced via `_includes/image.html` |
| Change site-wide settings (title, permalink structure, plugins) | `_config.yml` (needs a server restart to take effect) |
| Run a local dev server, upgrade dependencies, deploy, work on drafts | root [README.md](../README.md) |

## Conventions worth remembering

- Colors only ever come from `_sass/colors.scss`. If you're about to write a hex code anywhere else (SCSS or an inline SVG icon), stop and either reuse one of the existing values or add it there first.
- Icons in `_includes/career_icon.html` are `viewBox="0 0 24 24"`, `stroke-width="2"`, `fill="none"`, rounded joins/caps. Copy an existing branch rather than starting from scratch.
- A post becomes part of a "series" via two things together: `series: "Series Name"` in its front matter, and a matching key in `_data/topics.yml`. The name must match exactly (it's a hash key, not a slug).
- A series only gets special "collection" treatment (the stack/custom icon, "part of a series" wording) if its name is also listed under `collection_tags` in `_data/topics.yml`. Without that, `series:` still groups the posts and shows the collection title, it just doesn't count as a "series" for icon/wording purposes.
