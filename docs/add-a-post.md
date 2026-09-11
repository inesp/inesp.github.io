# Add a blog post

1. Create the file: `_posts/YYYY-MM-DD-slug.md`. The date in the filename is what Jekyll uses as the post date, and it drives the URL (`_config.yml` sets the permalink to `:year/:month/:day/:title.html`).
2. A date in the future hides the post in production (`make up-prod`) but shows it locally (`make up`). Handy for drafting without publishing.
3. Add front matter. Minimum:
   ```yaml
   ---
   title: "Post Title"
   tags: ["Some Tag", "Another Tag"]
   ---
   ```
4. For everything else (series, chapter links, excerpt length, social image, full-width layout, sources), copy the full template from [front-matter-reference.md](front-matter-reference.md#posts-_postsmd) and delete what you don't need.
5. If the post belongs to a series, see [add-a-series.md](add-a-series.md) first, then set `series: "Series Name"` in the front matter (must match a key in `_data/topics.yml` exactly).
6. Images go in `assets/<topic-slug>/`, referenced with:
   {% raw %}
   ```liquid
   {% include image.html src="topic-slug/filename.png" alt="..." %}
   ```
   {% endraw %}
7. Preview locally: `make up`, then open the post's URL.
8. If the post chains to others via `prev_post`/`next_post`, run `make check-links` before pushing. It verifies every link points to a real post and that the link is reciprocal (A → next → B implies B → prev → A).
9. Push to `master` and it publishes automatically — see the root [README.md](../README.md) ("Deployment" section) for how that actually works, and for the draft-branch workflow if you're not ready to publish yet.
