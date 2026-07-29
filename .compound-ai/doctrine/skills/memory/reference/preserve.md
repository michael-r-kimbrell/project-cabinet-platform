# Mode: preserve

Route durable knowledge to the right layer so the always-loaded core stays lean
and depth lives in separate notes. Covers two cases: a lasting decision or rule,
and a reusable pattern (the promotion path). Paths are illustrative; adapt.

## Routing decision

Ask: will this be needed every session, or only when working on a specific topic?

| Content | Route |
|---|---|
| A rule or convention that applies every session (a naming rule, a standing constraint, a permanent workflow step) | A - Core file |
| Detailed reference material (architecture decisions, tool mechanics, setup docs, how-to guides) | B - Depth note + a pointer in the core index |
| A decision that supersedes something already in the core | C - Update in place; archive the superseded content if load-bearing |

When in doubt, choose the depth note. The core is loaded every session.

## Route A - Core file

1. Read the core file fully before editing.
2. Find the right section. Add terse content (one bullet or short paragraph). If
   long, summarize here and route the detail to a depth note with a pointer.
3. If adding to a numbered convention list, assign the next number.
4. If the addition pushes the core past its size budget, trim an equal amount
   elsewhere (archive superseded content).
5. Never add the same information twice. If it updates an entry, edit in place.

## Route B - Depth note

1. Create or update a note in your depth-notes location with frontmatter
   (`type`, `date`, `status`, `tags`, `aliases`).
2. Write the full detail: examples, tables, edge cases, procedures.
3. Add a one-line pointer to the memory index: `- [Title](file) - one-line hook`.
4. Add a row to the lookup table in the core file pointing to the new note.

## Route C - Update / archive

1. Read the existing core entry. Edit it in place with the new decision.
2. If the old content was significant and not simply wrong, move it to an archive
   with a dated header: `## Superseded YYYY-MM-DD - {what it was}`.
3. Note the supersession in the update ("supersedes the YYYY-MM-DD decision to...").

## Promotion path (reusable patterns)

When preserving a pattern rather than a one-off decision, confirm all three
before promoting: it applies to more than one project or session; a new session
would benefit from knowing it up front; a reference implementation exists.

Record it with the ACE-scored format (CAOS promotion plus helpful / harmful
counts):

```markdown
## Pattern: [Name]
**Problem:** [What situation does this solve?]
**Solution:** [The pattern in one paragraph]
**Reference implementation:** [Explicit path]
**When NOT to use:** [Conditions where it is wrong]
**First observed:** [Session ID or date]
**Score:** helpful=N / harmful=N
```

Do not promote one-off project-specific fixes, single-vendor patterns without a
vendor-neutral form, or patterns unvalidated in at least two contexts.

## After routing

Report: which route, exactly what changed (file + section), the core file's net
line-count delta if touched, and whether an index pointer was added.
