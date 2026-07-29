# Skill: agent-panel-review
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Convenes a panel of agents to review a high-stakes deliverable using
**independent-first-pass, structured-critique, no-ego convergence**.
Agents do not see each other's drafts during the first pass.

Tier 1 infrastructure skill. Use on plans, documents, code, decisions, or releases. Triggers: "set up a panel", "convene a panel", "multi-agent review", "second opinion", "panel this", "phased review", "spec-drift review", "review against the spec".

## Two modes

| Mode | Use when | Load |
|---|---|---|
| panel-review | A high-stakes deliverable needs independent multi-perspective critique. | This file (the six-stage protocol below). |
| phased-review | A codebase or document set needs checking against a spec or PRD for drift, gaps, and correctness. | `reference/phased-review.md` |

panel-review is the human-orchestrated sealed protocol below. phased-review is an
automated, usage-gated, wave-capped review harness (contract to baseline to audit
to verify to synthesis). They share the no-ego, adversarial-verify discipline. The
implementation here is the lite, distilled version; the narrative is in Field
Guide Chapters 31 to 32. No sealed-panel anonymity internals ship in this kit.

## When to convene

`reference/when-to-convene.md`. Short version: high-stakes deliverables, multi-perspective work, irreversible decisions. NOT for daily code or single-answer questions.

## The protocol

Six stages. Full procedure in `reference/protocol.md`.

| Stage | What happens | Hard rule |
|---|---|---|
| 1. Frame | One prompt to every panelist. | One prompt, no variants. |
| 2. Independent first pass | Each agent produces a full first attempt with no visibility into others. | Sealed. No peeking. |
| 3. Cross-critique | Each agent reads the others' outputs and produces structured critique. | Critique the work, not the agent. |
| 4. Self-revise | Each agent revises its own output. | Adopt or one-line dissent. No relitigation. |
| 5. Converge | Operator picks the merge architecture. | Strongest layer from each, not average. |
| 6. Loop or ship | If gaps remain, loop 3-5. If clean, ship. | Loop-1 converge means you did not need a panel. |

## Critique formats (pick one per loop)

- **Four-cell template** (`reference/critique-format.md`): strongest claim / weakest claim / shared blind spot / one thing worth stealing. Fast qualitative signal.
- **Scorecard rubric** (`reference/scorecard-rubric.md`): ten dimensions, 0-100 score per dimension with evidence citation, composite + dual grade (strategy vs artifact production). Heavier quantitative evaluation.

Pick one per loop. Mixing within a single loop produces inconsistent signal.

## Role assignment

Roles are functions, not identities. `reference/roles.md` covers templates: voice/substance/architecture for documents, builder/critic/integrator for code, researcher/skeptic/synthesizer for analysis.

## Merge framework (Stage 5)

`reference/merge-framework.md`. Per-dimension scoring from the panel's outputs, plus an operator-bias check (two questions before locking each dimension) to prevent the operator's instinct from masquerading as panel signal.

## Loop-4 recovery

`reference/loop-4-recovery.md`. Five common causes of a panel that has not converged by Loop 4 (too-broad question, hidden assumption, wrong composition, scope creep, fatigue) with diagnostic signals and recovery moves per cause. The "ship the imperfect" rule protects against sunk-cost panic.

## Which agents excel at what

`reference/agent-strengths.md`. The skill works with any combination including three sessions of the same agent in three different roles. Same-model panels capture ~70% of cross-platform benefit.

## Worked example

`reference/worked-example.md`. Synthetic deliverable through all six stages. Field Guide Chapter 32 is the narrative version.

## phased-review mode

`reference/phased-review.md`. The automated spec-drift harness: distill the spec
into a checkable contract, baseline known issues, audit surfaces in waves,
adversarially verify each finding (keep-case), then rank delete over collapse over
rewrite. Usage-gated and wave-capped. The runnable workflow ships at
`runtime/claude-code/workflows/phased-review.js`; other runtimes follow the same
phases manually.

## Pair with

- `nod-protocol` -- when the panel disagrees and the disagreement needs gated opposite-construction
- `pressure-test` -- when one agent's critique role uses CEO/scope lenses
- `quality-gate` -- applied to the merged deliverable before ship
- `release-captain` -- ship gate after merge; especially if the deliverable is a release

## The discipline that makes this work

**Stage 2 must be sealed.** Once an agent has seen another agent's draft, its independent signal is destroyed for that loop. If the seal breaks, restart that panelist's pass. Lost time is cheaper than lost signal.
