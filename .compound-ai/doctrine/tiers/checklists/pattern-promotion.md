# Pattern Promotion Checklist
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Use this checklist when a reusable pattern emerges in a session log.
Promote on first reuse, not on first occurrence.

## Promotion gate (all three must be yes)
- [ ] Does this pattern apply to more than one project or session?
- [ ] Would a new session benefit from knowing this before starting?
- [ ] Is there a reference implementation that can be pointed to?

If any answer is no, leave it in the session log. Revisit if it appears again.

## Promotion format
Add to `_knowledge/patterns.md`:

```
## Pattern: [Name]

**Problem:** [What situation does this solve? One sentence.]
**Solution:** [The pattern in one paragraph. No intensifiers.]
**Reference implementation:** [Explicit path to where this is implemented]
**When NOT to use:** [The conditions where this pattern is wrong]
**First observed:** [Session ID or date]
```

## What NOT to promote
- One-off fixes that are project-specific
- Patterns that only work with a specific vendor or tool
  (unless the vendor-neutral form is also documented)
- Patterns that have not been validated in at least two contexts
- Patterns that are already in the Compound AI Operating Standards field guide
  (link to the chapter instead of duplicating)

## After promotion
- [ ] Add a one-line reference in the session log entry: "Promoted to _knowledge/patterns.md"
- [ ] Update `context/tier1-current.md` if the pattern changes how sessions should start
- [ ] Check if the pattern should also update `AGENT.md` (e.g., a new constraint or convention)
