# goal-runner: Durable Loop Rules

These rules are distilled from the Industry Intelligence Platform's durable
agentic patterns. They turn "keep going" into a safe operating loop.

## 1. Lane the work

Use lanes when a goal has multiple units.

| Lane | Use for | Behavior |
|---|---|---|
| Fast lane | Safe, high-confidence, low-dependency items | Process first |
| Slow lane | Repeated failures, weak evidence, blocked state | Quarantine with reason |
| Review lane | Needs operator judgment | Stop only for the decision |

Do not let one slow item block all useful work behind it.

## 2. Quarantine slow failures

If a safety gate rejects an item after repair, do not force it and do not keep
retrying forever. Record:

- Item identity.
- Failure reason.
- Evidence or validation gap.
- Cooldown or revisit condition.
- Human review note.

Then continue with unrelated work.

## 3. Keep selector and repair symmetry

For queue or backlog work, the same predicate should answer:

1. What status/health counts as pending.
2. What the runner can select next.
3. What the repair path can restore.

If health says an item is pending but the selector cannot pick it, the queue is
silently stuck. If the selector picks an item the writer cannot update, the loop
wastes effort.

## 4. Validate the rendered contract

Timestamps, file writes, and green intermediate tables are not enough. Validate
the surface the user or downstream consumer relies on.

- If a page changed, render or fetch the page.
- If a deck changed, inspect the deck output.
- If a package changed, clean-install or unzip it.
- If a feed changed, check the public feed, not only raw events.

## 5. Keep prompt and gate corpus symmetrical

Any factual field the agent used to produce output must also be available to
the validator. Dates, titles, source ids, summaries, and queued timestamps
should not disappear between prompt construction and validation.

## 6. Apply quality gates backward and forward

When a new gate catches a bad pattern, check whether old artifacts already have
the same problem. A forward-only filter stops tomorrow's leak but leaves
yesterday's leak live.

## 7. Finish the list

If the agent has identified in-scope remaining work, continue until the list is
done, slow-laned, or blocked by a real stop condition. Reporting a todo list is
not completion.

## 8. Respect budget

Use time and item caps:

- Per-item timeout.
- Total goal budget.
- Max retries before slow lane.
- Resume point after every completed unit.

Bounded work is safer than heroic loops that leave no recoverable state.
