---
layout: page
title: Style Guide
permalink: /styleguide/
---

A reference of custom CSS classes available for use in blog posts.

---

## Callout Classes

### `.box` - Hint/Callout Box

A red-bordered box for hints, tips, or important notes.

**Usage:**
```markdown
{:.box}
This is a hint or important note that deserves attention.
```

**Example:**

{:.box}
This is a hint or important note that deserves attention.

---

### `.rabbit-hole` - Expandable Tangent

A collapsible details element with a decorative bunny, for tangential content.

**Usage:**
```html
<details markdown="1" class="rabbit-hole">
<summary>Rabbit hole: A deeper dive into something</summary>

The expanded content goes here...

</details>
```

**Example:**

<details markdown="1" class="rabbit-hole">
<summary>Rabbit hole: A deeper dive into something</summary>

This is where you put content that's interesting but tangential to the main point. The reader can expand it if curious.

</details>

---

## Table Classes

### `.table-small` - Compact Table

Reduces cell padding for more compact tables.

**Usage:**
```markdown
{:.table-small}
| Col A | Col B | Col C |
|-------|-------|-------|
| 1     | 2     | 3     |
```

**Example:**

{:.table-small}
| Col A | Col B | Col C |
|-------|-------|-------|
| 1     | 2     | 3     |
| 4     | 5     | 6     |

---

### `.first-column` - Emphasize First Column

Bold first column with a right border, for key/label data.

**Usage:**
```markdown
{:.first-column}
| Key     | Value        |
|---------|--------------|
| Name    | Alice        |
| Role    | Engineer     |
```

**Example:**

{:.first-column}
| Key     | Value        |
|---------|--------------|
| Name    | Alice        |
| Role    | Engineer     |
| Level   | Senior       |

---

### `.last-column` - Emphasize Last Column

Bold, right-aligned last column with a left border, for totals/summary data.

**Usage:**
```markdown
{:.last-column}
| Item    | Qty | Total |
|---------|-----|-------|
| Apples  | 5   | $10   |
| Oranges | 3   | $6    |
```

**Example:**

{:.last-column}
| Item    | Qty | Total |
|---------|-----|-------|
| Apples  | 5   | $10   |
| Oranges | 3   | $6    |

---

### `.last-row` - Emphasize Last Row

Bold last row with a top border, for totals/summary rows.

**Usage:**
```markdown
{:.last-row}
| Item    | Amount |
|---------|--------|
| Revenue | $100   |
| Costs   | $40    |
| Profit  | $60    |
```

**Example:**

{:.last-row}
| Item    | Amount |
|---------|--------|
| Revenue | $100   |
| Costs   | $40    |
| Profit  | $60    |

---

### Combined Table Classes

You can combine table classes for more complex styling.

**Usage:**
```markdown
{:.table-small .first-column .last-row}
| Metric   | Q1  | Q2  | Q3  | Total |
|----------|-----|-----|-----|-------|
| Sales    | 10  | 15  | 20  | 45    |
| Returns  | 2   | 1   | 3   | 6     |
| Net      | 8   | 14  | 17  | 39    |
```

**Example:**

{:.table-small .first-column .last-row}
| Metric   | Q1  | Q2  | Q3  | Total |
|----------|-----|-----|-----|-------|
| Sales    | 10  | 15  | 20  | 45    |
| Returns  | 2   | 1   | 3   | 6     |
| Net      | 8   | 14  | 17  | 39    |

---

## Image Classes

### `.w-65` - 65% Width

Sets image to 65% width on desktop, 100% on mobile.

**Usage:**
{% raw %}
```liquid
{% include image.html src="/path/to/image.png" class="w-65" %}
```
{% endraw %}

---

### `.full-width` - Full Width

Sets image to 100% width.

**Usage:**
{% raw %}
```liquid
{% include image.html src="/path/to/image.png" class="full-width" %}
```
{% endraw %}

---

### `.yellow` - Yellow Border

Adds a thick yellow border around the image.

**Usage:**
{% raw %}
```liquid
{% include image.html src="/path/to/image.png" class="yellow" %}
```
{% endraw %}

---

## Email Component

A styled email visualization for illustrating email-related content.

**Usage:**
```html
<div class="email">
  <div class="email-header">
    <div class="email-meta">
      <div class="email-field">
        <span class="field-label">From:</span>
        <span class="field-value">alice@example.com</span>
      </div>
      <div class="email-field">
        <span class="field-label">To:</span>
        <span class="field-value">bob@example.com</span>
      </div>
      <div class="email-field">
        <span class="field-label">Subject:</span>
        <span class="field-value">Quick question</span>
      </div>
    </div>
  </div>
  <div class="email-body">
    <p>Hey Bob,</p>
    <p>Just wanted to check in about the project status.</p>
    <p>Thanks!</p>
  </div>
</div>
```

**Example:**

<div class="email">
  <div class="email-header">
    <div class="email-meta">
      <div class="email-field">
        <span class="field-label">From:</span>
        <span class="field-value">alice@example.com</span>
      </div>
      <div class="email-field">
        <span class="field-label">To:</span>
        <span class="field-value">bob@example.com</span>
      </div>
      <div class="email-field">
        <span class="field-label">Subject:</span>
        <span class="field-value">Quick question</span>
      </div>
    </div>
  </div>
  <div class="email-body">
    <p>Hey Bob,</p>
    <p>Just wanted to check in about the project status.</p>
    <p>Thanks!</p>
  </div>
</div>
