# Email Components for Blog Posts

This project includes CSS-styled email components that allow you to visually represent email messages in your blog posts. These components provide a realistic email interface appearance while maintaining clean, readable content.

## Available Components

### 1. Full Email Component (`.email`)

Use this component for formal emails that need to display complete header information (From, To, Subject).

**Features:**
- Complete email header with From, To, and Subject fields
- Professional email client appearance
- Responsive design
- Clean typography optimized for readability

**HTML Structure:**
```html
<div class="email">
  <div class="email-header">
    <div class="email-meta">
      <div class="email-field">
        <span class="field-label">From:</span>
        <span class="field-value">sender@company.com</span>
      </div>
      <div class="email-field">
        <span class="field-label">To:</span>
        <span class="field-value">recipient@company.com</span>
      </div>
      <div class="email-field">
        <span class="field-label">Subject:</span>
        <span class="field-value">Your Subject Line</span>
      </div>
    </div>
  </div>
  <div class="email-body">
    <p>Your email content goes here...</p>
    
    <p>Best regards,<br>
    Your Name</p>
  </div>
</div>
```

### 2. Compact Email Component (`.email-compact`)

Use this component for shorter, more casual emails or when you want a simpler appearance.

**Features:**
- Minimal header (just "To:" field)
- Compact layout perfect for brief examples
- Clean, focused design
- Responsive and mobile-friendly

**HTML Structure:**
```html
<div class="email-compact">
  <div class="email-content">
    <div class="email-to">To: recipient@company.com</div>
    <div class="email-message">
      <p>Your message content here...</p>
    </div>
    <div class="email-closing">
      Best regards,<br>
      Your Name
    </div>
  </div>
</div>
```

## When to Use Each Component

### Use `.email` for:
- Formal business communications
- Complex email scenarios
- When you need to show complete email metadata
- Professional documentation examples
- When the sender/recipient context is important

### Use `.email-compact` for:
- Quick examples
- Casual communications
- When space is limited
- Simple message demonstrations
- Focus on content over metadata

## Styling Details

Both components:
- Use system fonts for optimal readability
- Include subtle shadows and borders for visual separation
- Responsive design that works on mobile devices
- Integrate seamlessly with existing blog styling
- Support standard HTML formatting within email content

## Implementation

The CSS for these components is located in `assets/bs-override.scss`. The styling is automatically included when you build your Jekyll site.

Simply copy the HTML structure and customize the content for your specific email examples.

## Examples in Use

You can see these components in action in the blog post "Why is sooooo.. much documentation a pain to read?" where they're used to demonstrate good vs. poor email communication practices.

For a live preview of both components, open `email-component-examples.html` in your browser.