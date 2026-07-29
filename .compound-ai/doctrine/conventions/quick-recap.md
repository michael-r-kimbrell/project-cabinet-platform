# Quick Recap

Purpose: hand off session state in a few lines any agent can act on.

A quick recap is a terse, structured snapshot written at the end of a work
session (or before a context handoff). It answers four questions and points at
the artifacts. It is runtime-agnostic: any agent on any platform honors it, and
it carries no Claude-specific assumptions.

A quick recap is not a session log. The session log
(`doctrine/conventions/session-log-format.md`) is the durable, append-only
timeline. The quick recap is the disposable top-of-mind state for the next
agent, optimized for a fast resume. Write the recap to resume fast; promote
anything durable into the session log or the operating contract.

---

## When to use

- End of a work session, before you stop.
- Before handing the work to a different agent or a fresh context.
- When the operator asks for a "quick recap" or a "handoff."

## The four fields

Keep each field to one or two lines. Terse is the point.

1. **Changed.** What you actually did this session. Concrete, past tense.
2. **In-flight.** What is started but not finished, and its current state.
3. **Next.** The single most useful next action, plus runners-up if any.
4. **Artifacts.** Where the work lives: file paths, branch, PR, or doc links.

## Template

```markdown
## Quick recap [YYYY-MM-DD]

- Changed: <what got done>
- In-flight: <what is partway, and where it stands>
- Next: <the next action to take>
- Artifacts: <paths / branch / PR / links>
```

## Rules

1. Four fields, in order, every time. Skip none; write "none" if a field is empty.
2. Paths over prose. Point at the artifact; do not re-describe it.
3. No status theater. State blockers and failures plainly, including tests that
   did not pass.
4. The recap is disposable. Durable decisions belong in the operating contract
   or the session log, not here. Link there with `[[ ]]` or a path if relevant.
5. Runtime-agnostic. No tool names, model names, or platform-specific steps in
   the recap body.
