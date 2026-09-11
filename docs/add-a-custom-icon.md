# Add a custom icon

{% raw %}
All small inline icons (CV timeline, sidebar, topic/series pages) live in one file: `_includes/career_icon.html`. It's a big `{% case %}` statement, one `{% when "name" %}` branch per icon.

1. Open `_includes/career_icon.html` and add a new branch just before the final `{%- endcase -%}`. Copy-paste template, then edit the shape and comment:

```liquid
{%- when "your-icon-name" -%}
{%- comment -%}Where this icon is used, e.g. "Series icon for X (_data/topics.yml `icon: \"your-icon-name\"`)".{%- endcomment -%}
<svg class="career-icon" viewBox="0 0 24 24" aria-hidden="true"><!-- shape goes here, stroke="#0288d1" stroke-width="2" fill="none" --></svg>
```

2. House style for the shape:
   - `viewBox="0 0 24 24"`
   - `stroke-width="2"`, `fill="none"` (unless it's a small filled dot/accent)
   - `stroke-linecap="round"` / `stroke-linejoin="round"` for anything that isn't a straight-edged shape
   - colors from `_sass/colors.scss` only — reuse a hex already used by another icon (open `_includes/career_icon.html` and grep for the color values already in there) rather than inventing a new one
3. Keep the comment up to date — it's the only documentation the icon set has.
4. List it in the style guide. Add a line to `styleguide.md`, in the `<ul class="icon-styleguide-list">` block near the bottom:

```html
<li>{% include career_icon.html name="your-icon-name" %} <code>your-icon-name</code></li>
```

5. Use it:
   - As a series icon: `icon: "your-icon-name"` in that series' entry in `_data/topics.yml` (see [add-a-series.md](add-a-series.md))
   - Anywhere else: `{% include career_icon.html name="your-icon-name" %}`
6. Verify: `make up`, then open `/styleguide/` and check the "Career Icons" section.
{% endraw %}

## Checking how it actually looks before committing

Eyeballing raw SVG path data is unreliable — render it instead. Copy-paste this into a scratch file (e.g. `/tmp/icon-check.html`), filling in your `<svg>` markup in both places:

```html
<!doctype html><html><body style="margin:0;background:#fff;padding:20px;">
<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 24 24">
  <!-- paste your icon's inner markup here, e.g. paths/rects/circles -->
</svg>
<br/>
<svg xmlns="http://www.w3.org/2000/svg" width="21" height="21" viewBox="0 0 24 24">
  <!-- same markup again, at the real inline render size -->
</svg>
</body></html>
```

Then render it to a PNG and look at it:

```bash
google-chrome --headless --disable-gpu --screenshot=/tmp/icon-check.png --window-size=300,300 "file:///tmp/icon-check.html"
```

Check both sizes: 240px shows detail, 21px is the real render size inline with text (see `.career-icon` in `_sass/career.scss`). Something that reads fine large (e.g. text inside a shape) can turn to mush that small — that's the point of checking both.
