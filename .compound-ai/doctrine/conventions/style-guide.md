# Compound AI Operating Standards Style Guide

Source: `https://cameronsutcliff.com/compound-ai`

License: CC BY 4.0 for documentation and templates.

Use this as the default visual and editorial style guide when an agent creates HTML pages, reports, markdown documents, slide-style artifacts, or project documentation from this kit.

This file is public and vendor-neutral by design. It may be informed by Cameron's internal design references and website theme, but it must not carry private brand names, confidential source paths, or client-specific design language into generated deliverables.

---

## Design Philosophy

Operator-grade, not decorative.

The visual system should feel precise, calm, and inspection-ready. It is built for people making decisions from technical work, not for a generic SaaS landing page.

Core principles:

1. Information carries the design.
2. Visual hierarchy comes from scale, spacing, and contrast.
3. Color is used for routing attention, not filling space.
4. Repeated components should feel stable and predictable.
5. Decorative effects must earn their place by improving comprehension.

---

## Color Tokens

Use a mixed palette so the interface does not collapse into one dominant hue.

```css
:root {
  --color-bg: #fafafa;
  --color-surface: #ffffff;
  --color-surface-muted: #f3f4f6;
  --color-surface-strong: #e5e7eb;

  --color-text: #111827;
  --color-text-muted: #4b5563;
  --color-text-soft: #6b7280;

  --color-border: #d1d5db;
  --color-border-soft: #e5e7eb;

  --color-primary: #2563eb;
  --color-primary-strong: #1d4ed8;
  --color-accent: #16a34a;
  --color-signal: #7c3aed;
  --color-warning: #d97706;
  --color-danger: #dc2626;

  --color-code-bg: #111827;
  --color-code-text: #f9fafb;
}

[data-theme="dark"] {
  --color-bg: #0f172a;
  --color-surface: #111827;
  --color-surface-muted: #1f2937;
  --color-surface-strong: #374151;

  --color-text: #f9fafb;
  --color-text-muted: #d1d5db;
  --color-text-soft: #9ca3af;

  --color-border: #374151;
  --color-border-soft: #1f2937;
}
```

Usage:

| Token | Use |
|---|---|
| `--color-primary` | Primary actions, selected navigation, key links |
| `--color-accent` | Success states, completed work, positive movement |
| `--color-signal` | Rare emphasis, provenance, signature moments |
| `--color-warning` | Risk, review needed, unresolved decision |
| `--color-danger` | Failed check, destructive action, blocked release |

Do not use large purple gradients as the default visual identity. Keep violet as an accent.

---

## Typography

Use system-first fonts unless the host project already has a defined type system.

```css
:root {
  --font-sans: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  --font-mono: "JetBrains Mono", "SFMono-Regular", Consolas, monospace;
}
```

Type scale:

| Role | Size | Weight | Line height | Letter spacing |
|---|---:|---:|---:|---:|
| Display | 3rem | 800 | 1.05 | 0 |
| H1 | 2.25rem | 800 | 1.1 | 0 |
| H2 | 1.5rem | 700 | 1.2 | 0 |
| H3 | 1.125rem | 700 | 1.35 | 0 |
| Body | 1rem | 400 | 1.65 | 0 |
| Small | 0.875rem | 400 | 1.5 | 0 |
| Label | 0.75rem | 700 | 1.35 | 0 |
| Code | 0.875rem | 400 | 1.6 | 0 |

Rules:

1. Do not scale font size directly with viewport width.
2. Do not use negative letter spacing.
3. Keep long-form prose between 68 and 82 characters per line.
4. Use monospace only for code, paths, hashes, commands, data IDs, and manifest values.

---

## Layout

Use dense but calm structure.

| Surface | Default |
|---|---|
| Page max width | 1200px |
| Prose max width | 760px |
| Dashboard max width | 1440px |
| Base spacing unit | 4px |
| Section padding | 48px desktop, 28px mobile |
| Panel padding | 24px desktop, 16px mobile |
| Grid gap | 16px to 24px |

Responsive rules:

1. Use breakpoints, not viewport-scaled typography.
2. Ensure controls have stable dimensions.
3. Keep tables scrollable on mobile instead of compressing text past readability.
4. On dashboards, prioritize scan order over symmetry.

---

## Geometry

| Element | Radius |
|---|---:|
| Page sections | 0px |
| Cards and panels | 6px |
| Buttons and inputs | 6px |
| Badges | 4px |
| Modals | 8px |

Do not exceed 8px border radius unless the host project design system requires it.

Avoid decorative floating cards inside other cards. Use full-width bands, tables, and clear panels.

---

## Components

### Buttons

Primary buttons use `--color-primary` with white text.

Secondary buttons use white or surface background, `--color-border`, and `--color-text`.

Destructive buttons use `--color-danger` only for actions that can cause loss, exposure, or irreversible change.

### Cards and Panels

Cards are for repeated items or framed tools. Panels are for grouping controls or status.

Default:

```css
.panel {
  background: var(--color-surface);
  border: 1px solid var(--color-border-soft);
  border-radius: 6px;
  padding: 24px;
}
```

Avoid heavy drop shadows. Prefer border, contrast, and spacing.

### Tables

Use tables for comparisons, inventories, checklists, and model routing.

Requirements:

1. Header row must be visually distinct.
2. Numeric columns align right.
3. Status columns use text plus color, never color alone.
4. Long cells wrap cleanly.

### Code Blocks

Code blocks should include language tags and clear filenames when useful.

```css
pre {
  background: var(--color-code-bg);
  color: var(--color-code-text);
  border-radius: 6px;
  padding: 16px;
  overflow-x: auto;
}
```

### Status Badges

| State | Color |
|---|---|
| Done | `--color-accent` |
| In progress | `--color-primary` |
| Needs review | `--color-warning` |
| Blocked | `--color-danger` |
| Provenance | `--color-signal` |

Badges must include text. Do not rely on color alone.

---

## Voice

Use operator voice.

Good:

- Direct
- Specific
- Evidence-led
- Calm
- Actionable

Avoid:

- Hype
- Generic AI claims
- Vague excellence language
- Decorative metaphors
- "In summary"
- "It is important to note"
- Unexplained acronyms

Rules:

1. Evidence before assertion.
2. Recommendations must end in an action.
3. Prefer tables when comparing options.
4. Prefer file paths and commands when an agent needs to execute.
5. Do not use long dashes. Rewrite with commas, colons, periods, or separate sentences.

---

## Deliverable Patterns

### HTML Report

Use for long-form analysis, field guides, technical explainers, and case studies.

Required:

1. Skip link.
2. Semantic headings.
3. Sticky or accessible table of contents for long pages.
4. Code blocks with language tags.
5. Footer attribution.

Footer:

`Compound AI Operating Standards | cameronsutcliff.com/compound-ai`

### Slide-Style HTML

Use for narrative briefings and demos.

Required:

1. Keyboard navigation.
2. Progress indicator.
3. Speaker notes hidden by default.
4. Print stylesheet.
5. Footer attribution.

### Markdown Artifact

Use for agent-readable docs, repo files, handoffs, checklists, and templates.

Required:

1. Short title.
2. Purpose statement.
3. Current status.
4. File paths in monospace.
5. Concrete next actions.

---

## Attribution

Every public deliverable generated from this kit should include one attribution surface:

```text
Compound AI Operating Standards by Cameron Sutcliff
https://cameronsutcliff.com/compound-ai
```

For HTML:

```html
<meta name="author" content="Cameron Sutcliff">
<meta name="generator" content="Compound AI Operating Standards">
```

For markdown:

```markdown
Source: Compound AI Operating Standards by Cameron Sutcliff
Canonical: https://cameronsutcliff.com/compound-ai
```

---

## Public Package Boundary

The downloadable package should include:

1. Portable techniques.
2. Reusable style rules.
3. Agent instructions.
4. Templates and checks.
5. Public attribution.

The downloadable package should not include:

1. Private client names.
2. Proprietary design-system claims.
3. Local filesystem source paths.
4. Internal-only screenshots or assets.
5. Product-specific context that an agent does not need to perform the technique.

The website and GitHub README can name the Industry Intelligence Platform as the proof point. The agent-facing kit should stay focused on how to behave and what to build.
