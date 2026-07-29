# Enforced Runtime (Layer B)

Optional Claude Code enforcement profile. Separable from the portable Doctrine
(Layer A). Vendor-neutral adoption does not require this module.

**Version:** v3.0.10  
**Authors:** Cameron Sutcliff, Joshua Sutcliff (joshuadsutcliff)  
**Origin:** System B reference runtime (`github.com/joshuadsutcliff`)

## What ships here

The enforced-runtime hooks (usage-guard, session-router) are vendored under
Apache-2.0, adapted from Joshua Sutcliff's public claude-config
(github.com/joshuadsutcliff) and credited in `NOTICE`. This directory carries
the hooks and wiring:

| Path | Role |
|---|---|
| `hooks/usage-guard.sh` | PreToolUse usage-cap proxy block, cheap-worker policy |
| `hooks/session-router.sh` | UserPromptSubmit LIGHT/MEDIUM/HEAVY tier injection |
| `workflows/phased-review.js` | Capped-fan-out reference workflow |
| `agents/` | Pinned cheap worker definitions |
| `settings.fragment.json` | Hook event declarations for merge into Claude Code settings |
| `PATCHES.md` | Install adapter and override documentation |
| `CONFORMANCE.md` | Capability-contract mapping for this runtime |
| `goal-adapter.md` | Claude-side surface of the goal-loop capability: maps native `/goal` to the contract and wires in budget ceiling, no-progress halt, separate-evaluator check |

The hooks under `hooks/` are vendored and wired. See `NOTICE`.

## Configuration

Thresholds are tunable via gitignored `settings.local.json` (documented in
`PATCHES.md` when wired). Hooks fail open: a broken probe never blocks
legitimate work. See `docs/known-limits.md` and `enforcement-rules.yaml`.

## Install

The hooks are vendored under Apache-2.0 (see `NOTICE`). Use the install adapter
documented in `PATCHES.md` to merge the settings fragment into your Claude Code
settings.
