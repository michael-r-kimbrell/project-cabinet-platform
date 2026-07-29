# Mode: compress

Synthesize the session into a structured, searchable session log. Follow every
step. Paths assume a notes-vault backend; adapt the folder names to your store.

## Step 1 - Determine metadata

- **Date + time:** today's date (YYYY-MM-DD) and the approximate start time
  (HH-MM, 24h). If the start time is unknown, use the current time.
- **Slug:** 2 to 5 hyphenated lowercase words naming the session's core topic
  (e.g. `delegation-setup`, `auth-refactor-part2`). No underscores.
- **Filename:** `YYYY-MM-DD-HH-MM-{slug}.md`. All hyphens, no spaces.
- **Project:** the `project:` frontmatter value. Use the exact project folder
  name when scoped to one project; use a sanctioned shared value (e.g.
  `vault-wide`) for cross-project or tooling work.
- **Topics:** 3 to 7 lowercase hyphenated tags for the main themes.

## Step 2 - Write the file

Create the file at your session-log location using this exact template:

```markdown
---
type: session
date: YYYY-MM-DD
project: {project}
topics: [{topic1}, {topic2}, ...]
status: completed
tags: [{domain-tag}]
---

# Session: YYYY-MM-DD HH:MM - {slug}

## Quick Reference
**Topics:** topic1, topic2, topic3
**Projects:** Project-Name (or vault-wide)
**Outcome:** One sentence on what was accomplished or decided.
**Ref:** path/to/related-note (if relevant; use your store's link syntax)

## Decisions Made
- Decision with rationale. Specific enough to act on without re-deriving it.

## Key Learnings
- Non-obvious things worth remembering. Skip obvious outcomes.

## Files Modified
- `path/to/file` - what changed and why

## Setup & Config
- Environment changes (settings, installs, credentials) that persist.

## Errors & Workarounds
- What failed and how it was resolved. Include surprising tool or permission denials.

## Pending Tasks
- [ ] Unfinished work carried forward
- [x] Completed items (mark [x] if carried from a prior session and finished here)

---

## Raw Session Log

[Archived for future searchability. Do not edit this section.]

{Summarize the session turn-by-turn, 1 to 3 sentences each. Focus on decisions,
discoveries, and pivots, not mechanical steps. Bold the turn labels. Compress
aggressively: 20 turns to roughly 15 lines.}
```

## Step 3 - Tags

Draw `tags:` from a closed, controlled vocabulary (keep a `tag-vocabulary`
reference; add new recurring tags there first). Shape: `[domain]` or
`[domain, project]`, 2 to 4 tags. Never use `session-log` as a tag; `type:
session` covers it.

## Step 4 - Verify

Confirm the file was written with valid YAML frontmatter. Report the filename and
a one-line outcome summary.

## Invariants

- **Session logs are append-only.** Never edit an existing log; create a new one.
- **Dates are always YYYY-MM-DD.** No other format.
- **`project:` must match exactly** (case-sensitive), or a sanctioned exception.
- **Do not add a hub link unless instructed.** A query-driven hub surfaces logs
  automatically via `project:` frontmatter.
