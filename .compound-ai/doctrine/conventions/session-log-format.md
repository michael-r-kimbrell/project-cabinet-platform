# Session Log Format

Purpose: make agent work resumable.

Use this format for `session-log.md` and any project-specific handoff log.

---

## Rules

1. Newest entries go at the top.
2. One entry per meaningful work session.
3. Do not rewrite another agent's entry except to fix an obvious merge conflict.
4. Put durable decisions in the operating contract or build plan.
5. Put tactical next actions in the backlog or work queue.

---

## Entry Template

```markdown
## YYYY-MM-DD HH:MM TZ | Agent | short-id

**Focus:** One sentence describing the work.

### What changed

1. Concrete change.
2. Concrete change.
3. Concrete change.

### What I observed

Short notes that help the next agent understand the system.

### Verification

- Check run
- Check run
- Anything not run

### Files touched

- `path/to/file`
- `path/to/file`

### Next actions

1. Next action.
2. Next action.

### Status, end of turn

One paragraph summary of the current state.

---
```

---

## What Belongs Here

Include:

1. Work completed.
2. Files touched.
3. Tests or checks run.
4. Decisions made.
5. Risks discovered.
6. Next actions for another agent.

Do not include:

1. Full file contents.
2. Long command output.
3. Private credentials.
4. Speculation that should be verified first.
5. Duplicate summaries already captured elsewhere.

---

## Closeout Habit

Before ending a session, make the next start cheap:

1. Update current state.
2. Add or update a log entry.
3. Mark queue items accurately.
4. Record verification.
5. Name the next highest-value action.

The log is not bureaucracy. It is the bridge between one agent session and the next.
