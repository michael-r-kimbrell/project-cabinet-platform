# Tier 0 Context
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

Always load this for non-trivial work.

1. Project: [name]
2. Phase: [Demo | Ramp-up | Durable]
3. Primary constraint: [constraint]
4. Source of current state: `STATE.md`
5. Source of recent changes: `session-log.md`

---

## Capabilities available in this kit (28 skills)

Load `_skills-index.md` for the full registry with triggers and pointers.
Load `doctrine/conventions/trigger-registry.yaml` when trigger behavior matters.

**Tier 1 - Session infrastructure (11):**
request-router (load at session start), goal-runner, memory, token-economist,
engagement-bootstrap, quality-gate, delegation, agent-panel-planning,
agent-panel-review, release-captain, adoption-captain

**Tier 2 - Cognitive modes (7):**
parallel-lens-synthesis, consequence-simulation, cross-domain-translation,
convergence-detection, detached-judgment, simulation-to-action-bridge,
nod-protocol

**Tier 2 - Analytical capabilities (5):**
ultra-think, pressure-test, code-audit, autoresearch, skill-creator

**Tier 2 - Domain capabilities (2):**
viz, stakeholder-mapping

**Tier 2 - Orchestration (1):**
loop-engineering

## Shells available (Tier 3)

For deliverables, pick one of the Tier 3 shells:
slide-shell, scroll-shell, mission-control, course-shell.
Each ships with the relevant interactivity already wired.

## To activate routing

Load `doctrine/skills/request-router/SKILL.md`.
The router auto-selects the right skill based on what the user is asking for.
