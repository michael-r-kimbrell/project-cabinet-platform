# Skill: agent-panel-planning
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Converges a panel of agents on a plan for a high-stakes deliverable, then splits the work based on demonstrated strength. Pairs with `agent-panel-review`: **planning** produces the plan and the role assignment; **review** runs sealed critique on the deliverable that emerges.

Tier 1 infrastructure skill. Use when the question is "what should we build and who is best at each piece," not "is what we built any good."

## When to convene

`reference/when-to-convene.md`. Short version: the plan itself needs to be right; multiple agents have genuinely different framings; work will be split and the operator needs strength-matched routing; operator wants to test their framing against independent reframings.

Do NOT convene when the plan is obvious (skip to `agent-panel-review`), when one agent already framed it well (use `pressure-test` or `nod-protocol`), or when time pressure exceeds convergence value.

## Triggers

"plan this with the panel", "set up a planning panel", "have agents propose plans", "converge on a plan", "split this work across agents", "who should own what", "compare independent plans"

## The protocol

Six stages. Full procedure in `reference/protocol.md`.

| Stage | What happens | Hard rule |
|---|---|---|
| 1. Frame | One prompt; each panelist frames the WHOLE problem. | One prompt, no variants. |
| 2. Independent plans (sealed) | Each agent produces a complete plan with no visibility into others. | Sealed. Restart if seal breaks. |
| 3. Cross-feedback | Structured per-plan critique + element-level votes on decision points. | Vote on specific elements, not whole plans. Reasoning required. |
| 4. Concession + private revise + cross-suggestions | Three outputs per agent: (a) explicit concessions, (b) revised own plan, (c) path-forward suggestions for each OTHER agent. Sealed. | The cross-suggestions move is the load-bearing one. |
| 5. Reconvene | Each agent reads the others' revised plans + cross-suggestions. No seal. | Adopt accepted suggestions; flag rejected ones. No relitigation. |
| 6. Voting + ratification + task split | Operator surfaces remaining contested decisions; agents vote with reasoning; operator locks plan and task assignment based on demonstrated strength. | Task assignment is empirical, not categorical. |

## Stage details

- **Cross-feedback format** (Stage 3): `reference/cross-feedback-template.md`
- **Concession discipline** (Stage 4): `reference/concession-discipline.md`
- **Voting format** (Stages 3 and 6): `reference/voting-format.md`
- **Strength-matched task split** (Stage 6): `reference/task-assignment.md`
- **Post-ratification execution + escalation**: `reference/escalation-discipline.md`

## Pair with

- `agent-panel-review` -- runs sealed critique on the deliverable the planning panel produced
- `nod-protocol` -- when a Stage 3 vote splits the panel; run NOD on the contested decision
- `pressure-test` -- on the ratified plan before execution begins
- `release-captain` -- ship gate after execution

## Worked example

`reference/worked-example.md`. Synthetic three-panelist run showing each stage's outputs. Method, not artifact.

## What this is NOT

Not a roundtable. Not a real-time debate. Not consensus-by-discussion. Each move is staged; the discipline is the staging. Skip a stage and the panel produces averaging, not convergence.
