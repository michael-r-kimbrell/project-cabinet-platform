# Architecture

# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0
# Authors: Cameron Sutcliff (cameronpsutcliff), Joshua Sutcliff (joshuadsutcliff)

This document is the architectural map. It explains the six layers, the
any-agent capability and adapter model, the merge that produced version 3, and
how Claude Code hard enforces the kit through hooks while any other agent honors
the same contract through the generic adapter.

If you read one diagram, read this one:

```
            the universal contract every agent reads first
                            AGENT.md
                               |
   +---------------------------+---------------------------+
   | PORTABLE (vendor-neutral, plain Markdown and YAML)    |
   |   Layer 1  doctrine/       tiers, skills, contracts   |
   |   Layer 2  capabilities/   adapter-contract + 3 caps  |
   +---------------------------+---------------------------+
                               |  dispatch(task) -> result
   +---------------------------+---------------------------+
   | MECHANISM (per-runtime and maintainer tooling)        |
   |   Layer 3  runtime/        claude-code | codex |      |
   |                            cursor | generic           |
   |   Layer 4  enforcement/    CI gates + self-test       |
   |   Layer 5  proof/          session benchmark + proof  |
   |   Layer 6  reference-impl/ + adoption/                |
   +-------------------------------------------------------+
```

The portable layers say what good operation is and what any adapter must
guarantee. The mechanism layers make it real for a specific runtime, prove it,
gate it, and help an operator adopt it. You may stop at any layer.

---

## The six layers

### Layer 1 - Doctrine (`doctrine/`)

The portable core. Plain Markdown and YAML, readable and applicable with no
tools. It holds the tiered context model (`tiers/`), the consolidated skill
library (`skills/`), the verifiable finish-line primitives (`contracts/`:
goal-contract and loop-spec), and the conventions (`conventions/`:
trigger-registry, file caps, the skill-author rule). This is what any agent
honors regardless of runtime.

The defining discipline is **tiered context loading**. Tier 0 is always loaded
and is tiny. Higher tiers load on demand through the router. This is what the
session-start benchmark measures: the kit reaches full capability by routing to one
short procedure instead of keeping the whole reference resident.

### Layer 2 - Capabilities (`capabilities/`)

The runtime-agnostic capability model: the part that makes "any agent" real.
Each capability is defined once, independent of any runtime, as four things:
the contract (what it guarantees), the input and output shape, a reference
implementation, and a numbered conformance test.

| File | Capability |
|---|---|
| `adapter-contract.md` | The shared `dispatch(task) -> result` interface and the order the capability hooks run in. Carries no runtime internals. |
| `usage-discipline.md` | A tunable, fail-open spend and work ceiling. A `block` decision is the one hard stop. |
| `session-routing.md` | LIGHT/MEDIUM/HEAVY tier classification, injected as a context directive before execution. |
| `goal-loop.md` | Verifiable finish-line contract, budget ceiling, and no-progress halt. |

### Layer 3 - Runtime adapters (`runtime/`)

Real per-runtime implementations of the Layer 2 contract. One subdirectory per
agent, none privileged. Covered in detail below.

### Layer 4 - Enforcement (`enforcement/`)

The CI gates (`bin/`, orchestrated by `check-kit.sh`), the workflows
(`.github/`), the planted-fixture self-test (`tests/`), and the git hooks
(`hooks/`). The self-test plants known violations and confirms the gates catch
them, so the enforcement story is itself tested. All thresholds live in
`enforcement-rules.yaml`, never duplicated in scripts.

### Layer 5 - Proof (`proof/`)

Net-positive evidence a reviewer can reproduce. The headline is the
session-start benchmark: a realistic un-tiered setup costs many times the
context the kit loads at session start, and keeping the full reference resident
costs more still (a labeled ceiling). The exact
file counts, token estimates, and ratio are generated from the tree into
`proof/session-start-benchmark/results.md` (never hand-typed here, so they
cannot drift). The token figures are character estimates (bytes / 4), not a
tokenizer read, so the point is order-of-magnitude, not a model-exact byte
count. Pure shell, no metered API, reproducible on a bare laptop with
`bash proof/session-start-benchmark/measure.sh`. Also includes delegation
economics and loop-adoption evidence.

### Layer 6 - Reference implementation and adoption (`reference-impl/`, `adoption/`)

`reference-impl/` is the only place Python lives: provenance verification,
manifest build, derive tooling, and the skill-creator scaffold. It ships in both
editions (the verifiers are stdlib-only and adopters are told to run them); it
is not tier-0 loaded, so it does not affect the lean session-start cost. The
Individual zip stays lean by omitting the canonical working docs, the derive
tooling, and the Team org layer. `adoption/` holds the drop-in protocol:
`ADOPT.md`, the installer, and the multi-agent `INSTALL.md` walkthrough.

---

## The any-agent capability and adapter model

This is the architectural heart of version 3. The kit is designed so an
operator can plug **any** agent into it without privileging one runtime.

The mechanism is a clean split between policy and wiring:

- **Policy lives in `capabilities/`.** What the usage ceiling means, how a task
  is classified, when a goal loop halts. Defined once, runtime-free.
- **Wiring lives in `runtime/<agent>/`.** How a specific runtime calls those
  capabilities before and after it runs a task.

Every adapter satisfies the same interface from `capabilities/adapter-contract.md`:

```
dispatch(task) -> result

task   : { id, prompt, goal?, context[], budget? }
result : { id, status, output, usage?, halt_reason?, memory_update? }
status : done | halted | blocked | error
```

Around every dispatch, the adapter runs three capability hooks in a fixed
order: `session-routing` before execution to attach a context directive,
`usage-discipline` before execution to honor the spend ceiling, and `goal-loop`
after execution to decide whether the finish line is met or another iteration is
warranted. Every hook fails open with one deliberate exception: a
`usage-discipline` `block` is always a hard stop, because that is the entire
point of having a ceiling.

A runtime is **conformant** when the numbered conformance tests in each
capability file pass (CT-AC-*, CT-UD-*, CT-SR-*, CT-GL-*). Conformance, not the
mechanism, is what the kit demands. That is why no agent is privileged: any
runtime that passes the tests is a first-class citizen.

### How each runtime implements the contract

| Runtime | How it wires the capabilities | Enforcement strength |
|---|---|---|
| **claude-code** | `PreToolUse` and `UserPromptSubmit` hooks, plus agents and commands | Full hard block |
| **codex** | `AGENTS.md` directives plus a dispatch wrapper around the capability checks | Honor plus wrapper checks |
| **cursor** | rules file plus a dispatch wrapper | Honor plus wrapper checks |
| **generic** | a prompt prelude that injects the discipline, plus an optional shell wrapper | Honor (graceful degradation) |

### Hard enforcement versus honoring the contract

The difference between adapters is **how mechanically** the contract is
enforced, not **whether** it applies.

**Claude Code hard enforces.** Hooks run outside the model's control. The
`usage-guard` hook fires on `PreToolUse` and can deny a tool call when the
usage-cap proxy crosses the configured threshold; it can deny a
conductor-model subagent spawn. The `session-router` hook fires on
`UserPromptSubmit` and injects the routing prior into context. An agent cannot
talk its way past a hook. This is real, mechanical enforcement, and it is the
reason the Claude Code adapter is the richest in the kit. Thresholds are tunable
through a gitignored `settings.local.json`, and every hook fails open: a broken
probe, a stale cache, or a parse error yields no block.

**Any other agent honors the contract.** The generic adapter injects the same
discipline as a prompt prelude. A GUI-only or brand-new agent that can accept a
system prompt still gets session routing, the usage ceiling, and the goal loop,
enforced by honor rather than by a hard block. This is **graceful degradation**:
the kit loses mechanical guarantees on runtimes that cannot offer hooks, but it
never loses the behavior. The same contract, the same `dispatch(task) -> result`
shape, the same conformance tests. The kit works with one agent and scales to N
with no structural change.

### Goal parity

Native Claude Code `/goal` and the portable `goal-runner` are two surfaces of
one capability defined in `capabilities/goal-loop.md`. Whatever native `/goal`
does better, its continuation and automation affordances, the portable contract
documents and the generic adapter approximates. Whatever the portable runner
does better, the explicit budget ceiling wired to usage-discipline, the
no-progress halt, and a separate-evaluator completion check, native `/goal`
exposes through the Claude Code goal adapter. Native `/goal` is the Claude-side
surface of the shared capability, not a dumber shim.

---

## The merge story: Cameron plus Josh

Version 3 is a genuine co-owned merge of two complementary systems, not one
author absorbing the other.

**Cameron Sutcliff** brought the solo edition (CAOS): the portable doctrine, the
tiered context model, the skill library, the goal and loop contracts, and the
provenance and memory discipline. This was prose-and-convention enforcement:
strong on what good operation is, advisory on making it mechanical.

**Joshua Sutcliff** brought System B, the public reference runtime at
[github.com/joshuadsutcliff](https://github.com/joshuadsutcliff),
hardened by a real multi-agent operating incident. System B contributed
hook-level enforcement: the `usage-guard` and `session-router` hooks, the worker
agent definitions, and a capped fan-out workflow. This was the mechanical half:
strong on hard blocks, runtime-specific to Claude Code.

The consolidation did three things:

1. **Lifted the shared behavior into `capabilities/`.** The enforcement Joshua
   proved on Claude Code became a runtime-agnostic contract any agent can
   satisfy. The advisory conventions Cameron wrote became the policy those
   contracts encode. Neither system's enforcement is now trapped in one runtime.
2. **Merged cross-repo skills into unified named skills.** `memory` folds
   Josh's session lifecycle commands (compress, preserve, resume) with Cameron's
   memory skills under one trigger with intelligent sub-routing. `delegation`
   folds Josh's named workers (researcher, code-generator, tester) with
   Cameron's delegation doctrine and cost-tier routing into the shippable
   generic delegation doctrine. `review` extends with Josh's phased-review as a
   mode. One trigger set each, superseded entries retired as redirect stubs.
3. **Reconciled goals to parity.** The best of native `/goal` and the portable
   goal-runner, unified in `capabilities/goal-loop.md` as described above.

The result is co-ownership in the real sense: the architecture is structured so
that the portable doctrine and the proven enforcement are two faces of one
contract, and either author can edit the shared `enforcement-rules.yaml`.

---

## Multi-agent orchestration

Multi-agent coordination ships as distilled operating guidance, not as
implementation. The patterns live in the Field Guide (`docs/FIELD-GUIDE.md`)
panel chapters:

- **The Agent Interface Contract** and **Multi-Agent Coordination** (the
  coordination patterns chapters): how to give multiple agents a shared
  interface and coordinate their work.
- **The planning and review panel chapters**: when to convene a panel of
  independent agents to converge on a plan or to review drafts, and the
  `agent-panel-planning` and `agent-panel-review` skills that encode the lite
  pattern.

These read as guidance an operator can apply with their own agents. The kit
ships **no** sealed-panel protocol mechanics, no anonymity internals, no
orchestration CLI or kernel, and no secret sauce. The panel chapters are
distilled practice, deliberately not an implementation.

---

## How a reviewer reads the kit in five minutes

1. `ls` the root: the six layers are visible as directories.
2. Read this file and `STANDARD.md`: the architecture and the stop-at-any-layer
   rule.
3. Read `capabilities/`: see that any agent can plug in by satisfying one
   contract.
4. Run `enforcement/bin/check-kit.sh` and the self-test: watch the gates pass
   and block planted violations.
5. Read `proof/`: reproduce the ratio on a bare laptop.

Two credited authors. Leak-clean. No secret sauce. The Claude Code runtime
hooks (usage-guard, session-router) are vendored under Apache-2.0, adapted from
Joshua Sutcliff's public claude-config (github.com/joshuadsutcliff).
