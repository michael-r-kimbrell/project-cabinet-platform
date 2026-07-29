# Project Operating Contract
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0 (code) / CC BY 4.0 (docs)

Canonical URL: `https://cameronsutcliff.com/compound-ai`

This is the universal contract: the first file any agent reads. It is
runtime-agnostic. Whatever agent you are, you honor this contract; your runtime
adapter in `runtime/` decides how mechanically it is enforced.

## What this kit is

A vendor-neutral operating layer that turns any capable agent into a
compounding work surface: routing, token discipline, durable goals, validation,
provenance, and memory.

## What this kit is not

1. Not a prompt library.
2. Not vendor-specific. `AGENT.md` is canonical; `CLAUDE.md` points here.
3. Not a replacement for host project rules. Existing project rules win.

## Hard constraints

1. Keep `AGENT.md` and every `SKILL.md` under 100 lines (target 80).
2. Put long content in `reference/` and load it only when needed.
3. Never duplicate Tier 1 content in Tier 2 or 3. Reference upstream.
4. Credit external canon in skill source references.

## The six layers

| # | Layer | Path |
|---|---|---|
| 1 | Doctrine (portable core) | `doctrine/` |
| 2 | Capabilities (runtime-agnostic) | `capabilities/` |
| 3 | Runtime adapters | `runtime/` |
| 4 | Enforcement (CI gates, self-test) | `enforcement/` |
| 5 | Proof | `proof/` |
| 6 | Reference and adoption | `reference-impl/`, `adoption/` |

See `STANDARD.md` for the layer rules and `docs/ARCHITECTURE.md` for the model.

## Capabilities and adapters

Three behaviors are defined runtime-agnostically in `capabilities/`:
usage-discipline, session-routing, goal-loop. Every adapter satisfies the
shared `dispatch(task) -> result` contract in `capabilities/adapter-contract.md`
and applies these before and after execution. Claude Code enforces them with
hooks; the generic adapter honors them through a prompt prelude. No runtime is
privileged.

## Context map

| Question | Load |
|---|---|
| Current project state | `STATE.md` in your project, if present |
| Recent changes | `session-log.md` in your project, if present |
| Open items | `BACKLOG.md` in your project, if present |
| Tier model | `_tiers.md` |
| File map | `_map.md` |
| Human skill registry | `_skills-index.md` |
| Trigger registry | `doctrine/conventions/trigger-registry.yaml` |
| Universal shared-skill routing | `doctrine/conventions/universal-skill-routing.md` |
| Always-load context | `doctrine/tiers/tier0.md` |

## Context tiers

- Tier 0: always load. Short operating contract + task.
- Tier 1: current state + relevant subsystem slice.
- Tier 2: full specs, long logs, detailed design docs.
- Tier 3: do not load directly. Search or query exact files.

## Durable behavioral overlay

For non-trivial work:

1. Check `trigger-registry.yaml` before answering.
2. Route through the smallest useful skill chain.
3. Use `goal-runner` when work has a verifiable finish line.
4. Load minimum viable context.
5. Validate the rendered or user-visible contract before declaring done.
6. Write useful memory at closeout.

Claude Code `/goal` is optional. When available it automates continuation; the
portable contract is still `goal-contract` plus `goal-runner`, and native
`/goal` is the Claude-side surface of the shared `capabilities/goal-loop.md`,
not a dumber shim.

## Session lifecycle

Start: read this file, read `_skills-index.md`, load `request-router` and
`trigger-registry.yaml`, read `STATE.md` if present.

End: record validation performed; update state/log/backlog if work changed;
promote reusable patterns via the `memory` skill (preserve mode).

## Governance

Confirm before destructive data operations, force pushes, billing, publishing,
auth, or permission changes.
