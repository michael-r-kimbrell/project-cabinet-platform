# cabinet-ops

A compounding operating kit for Michael's AI-agent workflow, adapted from
Cameron Sutcliff and Joshua Sutcliff's [Compound AI](https://github.com/cameronpsutcliff/compound-ai)
operating standard (source read and summarized before anything here was
written — see the getting-started guide, step 3, for why that order
matters).

Same six-layer shape as the original, scaled and re-grounded in this
specific workspace and the cabinet-platform project rather than kept
generic:

| # | Layer | Path | What it gives you |
|---|---|---|---|
| 1 | Doctrine | `doctrine/` | Portable core: tiered context, skills convention, goal-loop, naming/data conventions specific to regions and suppliers |
| 2 | Capabilities | `capabilities/` | Runtime-agnostic contracts: adapter contract, usage discipline, session/model routing, goal-loop spec |
| 3 | Runtime adapters | `runtime/` | `claude-code/` hard-enforces via real `PreToolUse` hooks; `generic/` is the advisory fallback for Codex/Cursor/anything else |
| 4 | Enforcement | `enforcement/` | `bin/check-kit.sh` — a real, runnable self-test; `rules.yaml` as its declarative index |
| 5 | Proof | `proof/` | `session-start-benchmark/measure.sh` — reproducible token-cost comparison, tiered vs. full-resident |
| 6 | Adoption | `adoption/` | `ADOPT.md` for the agent to follow, `INSTALL.md` for the human, with a manual smoke test for the parts a script can't verify |

## What's actually enforced vs. advisory — stated up front, not overclaimed

| Discipline | How it's enforced |
|---|---|
| Workspace boundary, `.env` isolation | Hard block: `workspace-guard.sh` via Claude Code's `PreToolUse` hook |
| Subagent fan-out ceiling | Hard block: `usage-guard.sh`, same mechanism |
| The same disciplines on Codex, Cursor, other runtimes | Advisory only: `runtime/generic/PROMPT-PRELUDE.md` — nothing mechanically stops a violation there |
| Region/supplier-as-data convention | Advisory heuristic in `check-kit.sh`; worth a human look when it fires, not proof of correctness |
| Model tier routing | Human/agent judgment call, not mechanically enforced anywhere |

This kit is new and untested at scale — it was built for one project,
not proven across many. Treat it the way `INSTALL.md`'s smoke test treats
the hooks: verify it actually does what it claims before trusting it,
the same habit the kit itself is trying to teach.

## Quick start

See `adoption/INSTALL.md`.
