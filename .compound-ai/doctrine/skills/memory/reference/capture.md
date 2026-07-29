# Mode: capture

Write durable facts and events as they happen, so nothing important lives only
in context. Two destinations: the daily note (raw timeline) and the knowledge
graph (curated facts).

## When to use

- The operator says "remember this", "note this", "write it down", "save this".
- You learn a durable fact, a preference, or a pattern mid-conversation.
- An event happens that a future session would need to know occurred.

## Route the capture

Ask: is this a one-off event, or a durable fact about a tracked entity?

| What it is | Destination |
|---|---|
| An event, a turn, a decision happening now | Daily note: `memory/YYYY-MM-DD.md` |
| A durable fact about a project, person, or company | Knowledge graph: that entity's `items.yaml` |
| A pattern about how the operator works | The tacit-knowledge core (`MEMORY.md`) |

If the entity does not exist yet and clears the create-an-entity bar (see
`memory-model.md`), create its folder with `summary.md` and `items.yaml`. If it
does not clear the bar, leave it as a line in the daily note.

## Atomic fact shape

One fact per entry. Keep it self-contained so a future session can act on it
without re-deriving it.

```yaml
- fact: "Short, specific, self-contained statement."
  date: YYYY-MM-DD
  source: where this came from (session, file, person)
  status: active        # or superseded
  # superseded_by: <id>  (only when status is superseded)
```

## Steps

1. Decide the destination from the table above.
2. Append the daily-note line, or add the atomic fact to `items.yaml`.
3. Never overwrite an existing fact. If this changes one, mark the old fact
   `status: superseded` and add the new one.
4. Confirm the file path you wrote to and the one-line content.

## Check

The fact is on disk with a date and a source. Re-reading it cold, a future
session could act on it without asking a clarifying question.
