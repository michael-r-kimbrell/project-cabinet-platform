# Token Efficiency Convention

Purpose: keep AI work cheap enough to repeat.

Use this file when adding context, designing a workflow, or deciding whether a model call should happen at all.

---

## Default Rule

Load the smallest context that can answer the task safely.

Do not load files because they might be useful. Load them because the current task requires them.

---

## Context Tiers

| Tier | Load When | Typical Content |
|---|---|---|
| Tier 0 | Every session | Project identity, hard constraints, current state pointers |
| Tier 1 | Most sessions | Current goals, active files, recent decisions |
| Tier 2 | Specific subsystem work | Architecture notes, data contracts, implementation details |
| Tier 3 | Rare deep work | Full specs, long histories, raw transcripts, archives |

If a file is needed often, summarize it into a lower tier. If it is needed rarely, keep it behind a pointer.

---

## Before Loading a File

Ask:

1. Does this task need the full file, or only a summary?
2. Is there a current-state file that already contains the answer?
3. Can a targeted search answer the question?
4. Will loading this file change the decision?

If the answer to question 4 is no, do not load it.

---

## Before Running a Model Call

Ask:

1. Are the inputs materially different from the last run?
2. Is this deterministic enough to cache?
3. Can a cheaper model do it?
4. Is the output observable or synthetic?
5. Does the output need a schema?

Routine parsing, formatting, classification, and extraction should not use the deepest model tier by default.

---

## Promotion Rule

When the same context is loaded three times for the same reason, promote it into a reusable summary, checklist, or skill pointer.

When the same model call repeats with the same inputs, cache it.

When the same prompt keeps growing, split it into an operating contract plus references.

When work has a verifiable finish line, use `goal-runner` so the agent
validates completion instead of asking for the next step repeatedly.

---

## Anti-Patterns

Avoid:

1. Pasting a full spec into every session.
2. Loading archives before checking current state.
3. Using a synthesis model for mechanical edits.
4. Running scheduled synthesis when upstream inputs did not change.
5. Treating cache hits as success without attribution.

---

## Session Closeout

At the end of meaningful work, write down:

1. What changed.
2. What context was actually needed.
3. What should be promoted for next time.
4. Which files or calls were unnecessary.

Token efficiency compounds only when the system learns from its own waste.
