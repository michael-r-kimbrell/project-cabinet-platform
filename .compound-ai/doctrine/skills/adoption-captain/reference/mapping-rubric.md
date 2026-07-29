# adoption-captain: Mapping Rubric (Stage 4)

Stage 4 classifies each kit skill for this specific project. The output is
the "Adoption mapping" table in the adoption plan. Every skill gets exactly
one classification and a one-line rationale.

This document defines the classification logic. The agent applies it; the
operator approves the resulting table in Stage 5 before any edits are made.

---

## The five classifications

| Class | Meaning |
|---|---|
| **adopt now** | Immediate value, no stack conflict, additive, activatable in Phase 1 |
| **adapt** | Useful, but needs project-specific shaping before it is ready (e.g. triggers must be reworded, outputs must match project conventions) |
| **defer** | Useful in principle, but not yet relevant or the project is not ready |
| **skip** | Not relevant for this project |
| **conflict** | Would directly override an existing project rule (these are already in the preserve map; classify skip unless the conflict was resolved in Stage 2) |

---

## Tier 1 infrastructure skills

These Tier-1 infrastructure skills form the kit's operating backbone. Most
projects should adopt at least 5 of them.

### adoption-captain

**Classification logic.**

This skill was just run. Do not list it as "adopt now" in the mapping table
as an ongoing trigger. Record it as "adopt: already active (this run)" and
note it in the adoption report. It is available for future re-runs (e.g.
upgrading the kit version or re-adopting after significant project changes).

---

### engagement-bootstrap

**Classification logic.**

| Condition | Classification |
|---|---|
| Project already exists (which it does, since adoption-captain is running) | skip |

Do not propose engagement-bootstrap for an existing project. It creates fresh
template files that overwrite real files. Record rationale: "skip: project is
existing; engagement-bootstrap is for new projects only."

---

### request-router

**Classification logic.**

| Condition | Classification |
|---|---|
| Project uses more than 2 kit skills | adopt now |
| Project uses 1-2 kit skills | adapt (lighter trigger list; full router is overhead for 2 skills) |
| Project uses no kit skills (edge case) | skip |

The request-router is the kit's dispatch layer. Its value scales with the
number of skills adopted. For projects adopting 3+ skills, the router reduces
per-session cognitive overhead significantly. For projects adopting 1-2 skills,
adding the router is more scaffolding than it is worth.

---

### goal-runner

**Classification logic.**

| Condition | Classification |
|---|---|
| Project has multi-step goals that must run to a completion condition | adopt now |
| Operator works in short, self-contained requests with no "keep going until done" need | defer |
| Project already has its own task-runner or checklist discipline | adapt (goal-runner reinforces the existing finish condition; does not replace it) |

Goal-runner holds a durable completion condition across a long task so work
does not stall half-finished. Its value scales with task length and the cost
of a dropped thread.

---

### memory

**Classification logic.**

| Condition | Classification |
|---|---|
| Project has state that varies across sessions, or an active session-log / development history | adopt now |
| Project is simple and stateless (e.g. a one-shot utility) | adapt (slim version: resume only, most fields empty) |
| Operator already has a session-start ritual or its own pattern-documentation system | adapt (point memory at the existing system; do not replace it) |

Memory is the kit's cross-session continuity skill. It covers two modes:
resume (rebuild working context at session start) and preserve (promote a
durable lesson or pattern so it survives into later sessions). If the project
already documents session state or patterns in CLAUDE.md or README.md,
classify as adapt and reinforce the existing system rather than overriding it.

---

### token-economist

**Classification logic.**

| Condition | Classification |
|---|---|
| Project involves LLM calls, large context operations, or agentic loops | adopt now |
| Project is a standard web app or library with no LLM-specific work | defer (relevant if LLM work is added later) |
| Operator has an existing cost-control rule already documented | preserve the existing rule; adapt token-economist to reinforce it |

---

### delegation

**Classification logic.**

| Condition | Classification |
|---|---|
| Project routinely hands work to other agents or model tiers | adopt now |
| Project is single-agent with no delegation surface | defer (relevant if the project grows multi-agent) |
| Operator already has a cost-tier or routing convention documented | adapt (delegation reinforces the existing routing rule) |

Delegation decides which agent and which cost tier handles a unit of work.
It earns its place once a project spans more than one agent or model.

---

### quality-gate

**Classification logic.**

| Condition | Classification |
|---|---|
| Project ships deliverables to external consumers (APIs, reports, published packages, public-facing content) | adopt now |
| Project is internal tooling or scripts with no external consumers | defer |
| Project has its own quality checklist already | adapt (gate reinforces the existing checklist; does not replace it) |

---

### release-captain

**Classification logic.**

| Condition | Classification |
|---|---|
| Project has versioned releases (npm package, GitHub release, deployed app) | adopt now |
| Project ships frequently but has no release formalization (e.g. continuous deploy) | adapt (ship gate for the human-decision checkpoints, not the CI gate) |
| Project generates content with factual claims and needs a provenance / verify-origin check before publishing | adopt now (release-captain runs the provenance step at its ship gate) |
| Project is a research codebase, internal script, or single-file tool with no release concept | skip |

Release-captain runs the pre-ship gate, including the provenance and
verify-origin step that confirms published claims trace to a source. A project
with no versioned release but with factual prose still benefits from that step.

---

### agent-panel-planning

**Classification logic.**

| Condition | Classification |
|---|---|
| Project involves multiple agents or multi-session deliberation | adopt now |
| Project uses a single agent with no panel workflow | defer (panel planning becomes relevant if the project grows multi-agent) |
| Project has a small team that already reviews outputs collaboratively | adapt (reframe panel as human-agent hybrid review) |

Heuristic: if the project has only one agent and no existing panel discipline,
defer. Adopting panel-planning to a solo-agent project adds terminology and
overhead without benefit.

---

### agent-panel-review

**Classification logic.**

| Condition | Classification |
|---|---|
| Project produces high-stakes deliverables (strategy docs, architecture decisions, published reports) | adopt now |
| Project uses agent-panel-planning | adopt now (pair skill) |
| Project is a solo-dev utility or internal script | defer |
| Project has an existing PR review culture that already catches quality gaps | adapt (agent-panel-review as a pre-PR step, not a replacement) |

---

### team-router

**Classification logic.**

| Condition | Classification |
|---|---|
| Team edition installed and the operator runs a multi-agent command center (inbox, ledger, routing) | adopt now |
| Individual edition (team-router is not present in this edition) | skip |
| Solo operator with no team ledger or command-center surface | skip |

team-router is the one Tier-1 skill whose presence is edition-conditional: it
ships only in the Team edition. For Individual-edition installs there is nothing
to adopt, so record "skip: Team edition only."

---

## Tier 2 cognitive mode skills

These skills are most valuable for high-stakes analytical and deliberative
work. They add overhead; adopt only where the work warrants it.

### ultra-think

**Classification logic.**

| Condition | Classification |
|---|---|
| Project involves complex architectural decisions, strategy problems, or high-stakes tradeoffs | adopt now |
| Project is primarily implementation work with clear requirements | defer (invoke ad hoc when decisions arise; not a standing adopted skill) |
| Operator already uses a structured thinking protocol | adapt (ultra-think as a supplementary check, not a replacement) |

---

### detached-judgment

**Classification logic.**

| Condition | Classification |
|---|---|
| Project operator has noted a tendency to confirm rather than critique | adopt now |
| Project involves work where the agent's conclusions should be stress-tested | adopt now |
| Project is primarily mechanical (code formatting, data transforms) | skip |

---

### nod-protocol

**Classification logic.**

| Condition | Classification |
|---|---|
| Project involves high-stakes decisions where sycophancy is a known risk | adopt now |
| Operator explicitly wants more pushback from the agent | adopt now |
| Project is primarily creative work where agreement is appropriate | skip |
| Project already has a structured dissent or review process | adapt (nod-protocol as a named trigger, not a standing rule) |

---

### pressure-test

**Classification logic.**

| Condition | Classification |
|---|---|
| Project produces strategies, proposals, or recommendations that will be acted on | adopt now |
| Project is exploratory/research with no actionable outputs | defer |
| Project already runs its outputs through a structured critique step | adapt |

---

### convergence-detection

**Classification logic.**

| Condition | Classification |
|---|---|
| Project uses iterative LLM loops where outputs could plateau | adopt now |
| Project has no agentic loops (one-shot tasks only) | skip |

---

## Tier 2 analytical skills

### autoresearch

**Classification logic.**

| Condition | Classification |
|---|---|
| Project requires iterative investigation with changing evidence | adopt now |
| Project does single-pass research (not iterative) | skip |
| Project uses a specific research methodology that autoresearch would disrupt | conflict -- surface to operator |

---

### code-audit

**Classification logic.**

| Condition | Classification |
|---|---|
| Project is a code repository with active development | adopt now |
| Project is a documentation or content repository with no significant code | skip |
| Project already runs automated linting/scanning in CI | adapt (code-audit as a periodic deep review, not a per-commit replacement for CI) |

---

### consequence-simulation

**Classification logic.**

| Condition | Classification |
|---|---|
| Project makes decisions with significant downstream effects (financial, architectural, user-facing) | adopt now |
| Project is exploratory prototyping where consequences are intended to be discovered | defer |

---

### parallel-lens-synthesis

**Classification logic.**

| Condition | Classification |
|---|---|
| Project consistently involves trade-off decisions between multiple valid approaches | adopt now |
| Project has a clear single-track implementation path | defer |

---

### cross-domain-translation

**Classification logic.**

| Condition | Classification |
|---|---|
| Project communicates across technical and non-technical audiences | adopt now |
| Project is fully within a single domain (e.g. internal dev tooling for engineers only) | skip |

---

### simulation-to-action-bridge

**Classification logic.**

| Condition | Classification |
|---|---|
| Project runs consequence-simulation or pressure-test and needs to close the loop to action | adopt now (if consequence-simulation is adopted) |
| Project does not use simulation skills | skip |

---

### stakeholder-mapping

**Classification logic.**

| Condition | Classification |
|---|---|
| Project involves multiple stakeholders with different interests | adopt now |
| Project is a solo developer tool with no stakeholder layer | skip |

---

### skill-creator

**Classification logic.**

| Condition | Classification |
|---|---|
| Project develops or extends agent capabilities over time | adopt now |
| Project is a fixed-scope implementation with no new skill creation planned | defer |

---

### viz

**Classification logic.**

| Condition | Classification |
|---|---|
| Project produces data visualizations, dashboards, or analytical charts | adopt now |
| Project is a non-visual tool (CLI, API, library) | skip |
| Project uses a specific visualization framework the kit's viz skill does not address | adapt |

---

## Summary heuristics (quick reference)

| Heuristic | Implication |
|---|---|
| Single agent, no panel workflow | Defer agent-panel-planning and agent-panel-review |
| No external deliverables or consumers | Defer release-captain and quality-gate |
| No LLM calls in the project | Defer token-economist |
| No prose or factual claims | release-captain provenance step adds little value |
| Pure implementation, no strategy decisions | Defer ultra-think, defer pressure-test |
| No data visualization work | Skip viz |
| Project uses existing pattern documentation | Adapt memory (preserve mode), do not replace |
| Project already has a release gate | Adapt release-captain, do not duplicate |
| Single-pass tasks, no iterative loops | Skip convergence-detection |

---

## Output format for Stage 5

The mapping table in the adoption plan uses this format:

```
| Skill | Tier | Classification | Rationale |
|---|---|---|---|
| request-router | T1 | adopt now | 4+ skills adopted; router reduces dispatch overhead |
| memory | T1 | adopt now | Active development state varies per session |
| agent-panel-planning | T1 | defer | Solo-agent project; no multi-agent workflow |
| viz | T2 | skip | CLI tool; no visualization work |
| ... | | | |
```

One row per skill. No missing rows. Every classification has a one-line
rationale specific to this project, not a restatement of the rubric.
