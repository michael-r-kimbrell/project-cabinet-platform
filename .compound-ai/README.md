# Compound AI Operating Standards v3.0.10

[![CI](https://github.com/cameronpsutcliff/compound-ai/actions/workflows/enforce.yml/badge.svg)](https://github.com/cameronpsutcliff/compound-ai/actions/workflows/enforce.yml)
[![Release](https://img.shields.io/github/v/release/cameronpsutcliff/compound-ai)](https://github.com/cameronpsutcliff/compound-ai/releases)
[![License: Apache-2.0 and CC-BY-4.0](https://img.shields.io/badge/license-Apache--2.0%20and%20CC--BY--4.0-blue)](LICENSE)

**A co-owned operating kit that turns any capable AI coding agent into a
compounding work surface.**

By **Cameron Sutcliff** ([cameronpsutcliff](https://github.com/cameronpsutcliff))
and **Joshua Sutcliff** ([joshuadsutcliff](https://github.com/joshuadsutcliff)).

Most AI work resets every session: the operator re-explains the project, the
agent bulk-loads everything it might need, and the cost rises while the value
stays flat. This kit makes the work compound instead. It ships a portable
operating doctrine, a runtime-agnostic capability model that any agent can plug
into, and a real enforcement layer that hard-blocks violations on Claude Code
and is honored by prompt-prelude and wrapper on other runtimes. Enforcement is
graceful-degradation by design: hard where the runtime supports it, advisory
everywhere else, never silently absent.

**Canonical site:** [cameronsutcliff.com/compound-ai](https://cameronsutcliff.com/compound-ai)
**Source repo:** [github.com/cameronpsutcliff/compound-ai](https://github.com/cameronpsutcliff/compound-ai)

> Sponsoring an AI initiative, or evaluating this in 90 seconds? Read
> **[EXECUTIVE.md](EXECUTIVE.md)** first: the problem, the shift, and what is
> enforced versus advisory, in business terms.

---

## What is actually enforced

Stated up front, so the vocabulary never outruns the mechanism (full detail in
[docs/known-limits.md](docs/known-limits.md)):

| Discipline | How it is enforced |
|---|---|
| Costly subagent spawns and fan-out over the usage ceiling, on Claude Code | Hard block: a `PreToolUse` hook denies the call |
| Repo invariants (personal-data leaks, skill counts, tier-0 discipline, registry coherence, hand-typed benchmark figures) | Hard block: CI gates with a planted-fixture self-test |
| The same disciplines on Codex, Cursor, and other runtimes | Advisory: the agent is given the contract and honors it; nothing mechanically stops a violating call |
| Tiered context loading and main-loop model choice | Human-controlled convention, not a mechanical block |

## The six-layer architecture

The kit is organized as six layers. You may stop at any layer; every layer
below the one you stop at still applies and the Standard still holds.

| # | Layer | Path | What it gives you |
|---|---|---|---|
| 1 | **Doctrine** | `doctrine/` | Portable core any agent honors: tiered context, skills, goal and loop contracts, conventions. Plain Markdown and YAML, no tools. |
| 2 | **Capabilities** | `capabilities/` | The runtime-agnostic capability model. Four contracts (`adapter-contract`, `usage-discipline`, `session-routing`, `goal-loop`) that define what any adapter must guarantee. |
| 3 | **Runtime adapters** | `runtime/` | Per-runtime adapters: `claude-code` hard-enforces via hooks; `codex`, `cursor`, and `generic` honor the same contract (advisory, the graceful-degradation path for any agent). |
| 4 | **Enforcement** | `enforcement/` | CI gates, workflows, and a planted-fixture self-test that block real violations. Run `enforcement/bin/check-kit.sh`. |
| 5 | **Proof** | `proof/` | The session-start benchmark and other net-positive evidence. |
| 6 | **Reference and adoption** | `reference-impl/`, `adoption/` | Maintainer Python tooling and the drop-in adoption protocol. |

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full picture: how the
capability and adapter model lets any agent plug in, and how Claude Code hard
enforces via hooks while any other agent honors the same contract through the
generic adapter.

## Any agent honors the contract (Claude Code hard-enforces)

The capability layer is runtime-agnostic. A capability is defined once in
`capabilities/<name>.md` as a contract, an input and output shape, a reference
implementation, and a conformance test. Each runtime in `runtime/<agent>/`
implements the same `dispatch(task) -> result` contract with its own mechanism:

- **Claude Code** wires the capabilities to real `PreToolUse` and
  `UserPromptSubmit` hooks, so usage ceilings and tier routing are mechanical
  hard blocks. This is the richest adapter.
- **Codex** and **Cursor** apply the same checks through their directive files
  plus a dispatch wrapper.
- **Generic** injects the discipline as a prompt prelude with an optional shell
  wrapper, so a brand-new or GUI-only agent still honors the contract. This is
  graceful degradation: the kit works with one agent and scales to N with no
  structural change.

## Install

### Option A: adopt the doctrine into an existing project

```bash
git clone https://github.com/cameronpsutcliff/compound-ai.git .compound-ai
```

Hand the agent `adoption/ADOPT.md` and run the `adoption-captain` skill. The
doctrine and the capability contracts apply with no runtime dependency. See
`adoption/INSTALL.md` for the multi-agent walkthrough.

### Option B: add the enforced Claude Code runtime

The `runtime/claude-code/` module vendors the enforced-runtime hooks
(usage-guard, session-router) under Apache-2.0, adapted from Joshua Sutcliff's
public claude-config (github.com/joshuadsutcliff) and credited in
`runtime/claude-code/NOTICE`. Wire the runtime by following the adapter docs.

## The merge story

Version 3 is a true co-owned merge of two complementary systems. Cameron's
solo edition contributed the portable doctrine, the tiered context model, and
the skill library. Joshua's System B reference runtime
([github.com/joshuadsutcliff](https://github.com/joshuadsutcliff)),
hardened by a real multi-agent operating incident, contributed the hook-level
enforcement now living in `runtime/claude-code/`. The consolidation lifted the
shared behavior out of both into the runtime-agnostic `capabilities/` layer, so
the enforcement Joshua proved on Claude Code is now a contract any agent can
satisfy. Cross-repo skills were merged into unified named skills (`memory`,
`delegation`, `review`) with intelligent sub-routing. See
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Multi-agent orchestration

Multi-agent coordination ships as distilled guidance, not implementation. The
Field Guide (`docs/FIELD-GUIDE.md`) covers the patterns in its panel chapters:
the agent interface contract, multi-agent coordination, and the planning and
review panels. These read as operating guidance for running your own panels.
The kit does not ship any sealed-panel protocol mechanics or orchestration
secret sauce.

## The proof point: context that does not reload

A realistic un-tiered setup carries many times the context this kit loads at the
start of every session, and keeping the full reference resident costs an order of
magnitude beyond that. The kit routes to one short procedure on demand instead.
That is the cost you pay repeatedly, every session, for the life of the work.

The benchmark is pure shell, no metered API and no model call, reproducible on a
bare laptop with `bash proof/session-start-benchmark/measure.sh`. The token
counts are character estimates (bytes / 4), so the figure is order-of-magnitude,
and the ratio is estimator-independent because both sets use the same divisor.
The exact figures, both the realistic single-tier ratio and the full-resident
ceiling, are regenerated from the tree into
[proof/session-start-benchmark/results.md](proof/session-start-benchmark/results.md);
they are not hand-typed here, so they cannot drift. The benchmark measures
context-loading cost, not output quality.

## Honest posture

This is an early operating standard with a real enforced reference runtime, not
a battle-tested mass-adopted product. Public adoption is low; internal usage is
real. The enforcement story is incident-hardened on the runtime side. The kit
states what the hooks block, what stays advisory, and what the human still
controls, rather than overclaiming. See `docs/known-limits.md`.

The early v3.0.x releases are same-day pre-publication hardening passes from a
multi-model review, not instability between adopted versions. Pin v3.0.7 or
later.

## License

Co-owned by its two authors and dual licensed:

- **Documentation and data:** CC BY 4.0
- **Originally authored code:** Apache 2.0
- **Vendored enforced-runtime hooks** (usage-guard, session-router): Apache 2.0,
  adapted from Joshua Sutcliff's public claude-config
  (github.com/joshuadsutcliff), credited in `runtime/claude-code/NOTICE`.

Attribution:
`Compound AI Operating Standards by Cameron Sutcliff and Joshua Sutcliff`

See `LICENSE` and `NOTICE` for full terms.
