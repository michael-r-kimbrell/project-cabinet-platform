# Skill: request-router
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Routes incoming requests to the right skill using the canonical trigger
registry. Load at session start. Before answering a non-trivial request, scan
the registry and invoke, offer, or skip skills according to match strength.

Canonical registry:
`doctrine/conventions/trigger-registry.yaml`

## Routing modes

| Mode | Behavior |
|---|---|
| `auto` | Invoke when the request clearly matches a trigger. |
| `offer` | Mention the skill and ask before invoking. |
| `manual` | Use only when explicitly requested. |
| `internal` | Used by another skill or at session start. |

## Procedure

1. Read the current request.
2. Check `trigger-registry.yaml` for exact, phrase, and intent matches.
3. If one `auto` match is clear, state `Applying [skill-name]` and load it.
4. If several skills match, choose the smallest useful chain and state the
   order.
5. If an `offer` match fires, answer briefly and offer the panel or workflow.
6. If no match fires, answer directly.
7. If routing feels stale, refresh the trigger registry per `reference/registry-maintenance.md` (registry coherence is a CI invariant, not a session-time skill).

## Durable goal fast path

If the request has a verifiable finish line, multiple steps, queue/backlog
language, or asks the agent to continue until something is true, route to
`goal-runner` before any domain skill. Claude Code `/goal` is only an adapter;
the portable behavior is the `goal-runner` contract.

## Bootstrap distinction

Before applying bootstrap-style skills:

- New project with no existing protected files: `engagement-bootstrap`
- Existing project or existing agent instructions: `adoption-captain`

Never use `engagement-bootstrap` on an existing project.

## Panel offer judgment

Offer a panel when at least one is true:

1. User explicitly asks for another model or agent view.
2. User is stuck between alternatives.
3. The decision is high-stakes and should not be decided alone.
4. User uses panel, council, multi-agent, or second-opinion language.
5. A complete draft needs alternative framings or critique.

Expanded thresholds live in `reference/panel-offer-threshold.md`.

## Compound requests

Some requests need a skill chain. Examples:

- Goal + implementation: `goal-runner` -> relevant capability -> `quality-gate`
- Release: `release-captain` -> `quality-gate` (release-captain runs the provenance check at its Step 3)
- Existing adoption: `adoption-captain` -> `goal-runner`

More recipes: `reference/compound-requests.md`.

## Passthrough

Most requests are ordinary. If the registry does not match, or the cost of
routing exceeds the task, respond directly.
