# Skill: goal-runner
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Turns substantial work into a durable goal loop: define the finish line, route
through the right skills, use the minimum context, validate the real contract,
continue while useful work remains, and write memory when done.

Use for work with a verifiable end state, multiple steps, a backlog, a queue,
or any request like "keep going until", "finish all", "optimize this from now
on", "make this ready", "drain this", or "do not stop until tests pass."

## Goal contract

Before acting, write the compact contract:

1. Objective: what changes in the world.
2. Completion condition: how a separate evaluator would know it is done.
3. Validation: commands, rendered checks, review gates, or evidence required.
4. Context budget: files to load now, files to leave behind pointers.
5. Stop conditions: unsafe action, missing authority, budget exhausted, or
   operator decision needed.
6. Memory update: state, backlog, session log, or instruction surface changes.

Template and examples: `reference/goal-contract.md`.

## Durable loop

1. Classify the request with `request-router` and `trigger-registry.yaml`.
2. Load only the context required for the current unit of work.
3. Work in lanes: clear fast safe items first; move blocked or repeatedly
   failing items to a slow lane with a reason and review path.
4. Keep selector and repair symmetry: if health/status counts an item as
   pending, the runner must be able to select and repair that exact item.
5. Validate the user-visible contract, not just file writes or timestamps.
6. If a quality rule finds bad historical output, apply it backward and forward.
7. Continue while in-scope work remains. Do not report the list instead of
   finishing the list.
8. Close out with validation results and memory updates.

Full loop rules: `reference/durable-loop.md`.

## Claude Code adapter

If the host is Claude Code v2.1.139+ and the operator wants autonomous
multi-turn continuation, translate the completion condition into `/goal`.
Do not make `/goal` a dependency. Other agents use the same goal contract
manually. Adapter details: `reference/claude-goal-adapter.md`.

## Output format

```
GOAL CONTRACT
Objective:
Completion condition:
Validation:
Context budget:
Stop conditions:
Memory update:

LOOP STATUS
Done:
Slow lane:
Validation:
Next action:
```

## Pair with

- `request-router` for skill selection.
- `token-economist` for context and model budget.
- `quality-gate` for validation.
- `memory` (preserve mode) for lessons worth preserving; (compress mode) for session closeout.
