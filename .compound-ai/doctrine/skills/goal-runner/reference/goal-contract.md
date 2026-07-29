# goal-runner: Goal Contract

The goal contract is the portable version of Claude Code `/goal`. It works in
any agent because it describes the finish line in plain operating terms.

## Template

```markdown
GOAL CONTRACT
Objective: <what should be true when the work is done>
Completion condition: <observable condition a separate evaluator can check>
Validation: <commands, rendered checks, review gates, source evidence>
Context budget: <files to load now; files to keep as pointers>
Stop conditions: <unsafe, missing access, budget, conflict, approval needed>
Memory update: <state/log/backlog/instruction updates required>
```

## Writing a strong completion condition

Use conditions that can be checked. Prefer:

- All listed files have been updated and `npm run build` passes.
- Every queue item has status done, skipped with reason, or slow-lane.
- The rendered page contains the expected section and has no console errors.
- The release ZIP passes local integrity and public assets return 200.

Avoid:

- Make it better.
- Keep working for a while.
- Do everything.
- Use good judgment.

## Validation rules

Validation should inspect the contract the user experiences.

- Code: tests, lint, typecheck, build, smoke path.
- Website: rendered page, links, downloads, console errors.
- Deck: actual slides, not just generated source.
- Research: source coverage, claim grounding, date recency.
- Package: manifest, checksum, license, install path.

## Stop conditions

Stop only when one is true:

1. Completion condition is met and validation passed.
2. Continuing would be unsafe or destructive without approval.
3. The agent lacks required access.
4. A required decision is genuinely ambiguous and cannot be inferred.
5. The time or token budget is exhausted, and progress is recorded.

## Memory update

At closeout, record only useful state:

- What changed.
- What validation ran.
- What remains, if anything.
- Which triggers, rules, or patterns should affect future sessions.
