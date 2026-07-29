# Skills Index
# Compound AI Operating Standards v3.0.10
# Authors: Cameron Sutcliff + Joshua Sutcliff
# Source: github.com/cameronpsutcliff/compound-ai | License: Apache 2.0

Load at session start. This is the human-readable capability registry. The
machine-readable routing surface is
`doctrine/conventions/trigger-registry.yaml`.

Total skills: derived by `check-counts.sh` (do not hand-edit this number).
Full repo after the skill-merge: 27 active SKILL.md files + 4 retired redirect
stubs (31 SKILL.md files total). The Individual derive omits `team/`, dropping
`team-router` to leave 26 active; the Team derive keeps all 27.

---

## Tier 1: Session Infrastructure (11)

These run the session. `request-router` consults the trigger registry.

| Skill | Trigger | Pointer |
|---|---|---|
| request-router | session start, routing | `doctrine/skills/request-router/SKILL.md` |
| goal-runner | "goal", "completion condition", "keep going until", "finish all", "/goal" | `doctrine/skills/goal-runner/SKILL.md` |
| memory | "remember this", "session log", "preserve this", "resume", "recall" | `doctrine/skills/memory/SKILL.md` |
| token-economist | "token audit", "optimize context", "reduce cost" | `doctrine/skills/token-economist/SKILL.md` |
| engagement-bootstrap | "new project", "bootstrap this", "set up the project" | `doctrine/skills/engagement-bootstrap/SKILL.md` |
| quality-gate | "quality check", "validate output", "is this ready", "rendered contract" | `doctrine/skills/quality-gate/SKILL.md` |
| delegation | "delegate", "which agent should", "spawn a worker", "cost tier" | `doctrine/skills/delegation/SKILL.md` |
| agent-panel-planning | "plan this with the panel", "split this work across agents" | `doctrine/skills/agent-panel-planning/SKILL.md` |
| agent-panel-review | "set up a panel", "multi-agent review", "phased review", "spec-drift review" | `doctrine/skills/agent-panel-review/SKILL.md` |
| release-captain | "ship gate", "release captain", "verify the release", "verify origin", "check provenance" | `doctrine/skills/release-captain/SKILL.md` |
| adoption-captain | "adopt this kit", "install into my current repo", "do not break my stack" | `doctrine/skills/adoption-captain/SKILL.md` |

## Tier 2: Cognitive Modes (7)

| Skill | Trigger | Pointer |
|---|---|---|
| parallel-lens-synthesis | "multiple perspectives", "steelman", "red-team" | `doctrine/skills/parallel-lens-synthesis/SKILL.md` |
| consequence-simulation | "what could go wrong", "premortem", "simulate" | `doctrine/skills/consequence-simulation/SKILL.md` |
| cross-domain-translation | "explain to", "translate for", "exec summary" | `doctrine/skills/cross-domain-translation/SKILL.md` |
| convergence-detection | "common thread", "root cause", "what connects these" | `doctrine/skills/convergence-detection/SKILL.md` |
| detached-judgment | "devil's advocate", "base rate", "calibrated" | `doctrine/skills/detached-judgment/SKILL.md` |
| simulation-to-action-bridge | "what should we do", "next steps", "turn into a plan" | `doctrine/skills/simulation-to-action-bridge/SKILL.md` |
| nod-protocol | "argue the opposite", "construct the opposite case", "NOD this" | `doctrine/skills/nod-protocol/SKILL.md` |

## Tier 2: Analytical Capabilities (5)

| Skill | Trigger | Pointer |
|---|---|---|
| ultra-think | "think deeply", "multi-angle", "ultra think" | `doctrine/skills/ultra-think/SKILL.md` |
| pressure-test | "pressure test", "critique this", "rip this apart" | `doctrine/skills/pressure-test/SKILL.md` |
| code-audit | "code audit", "dead code", "security review" | `doctrine/skills/code-audit/SKILL.md` |
| autoresearch | "research this", "find sources", "investigate" | `doctrine/skills/autoresearch/SKILL.md` |
| skill-creator | "build a skill", "create a skill", "extend the kit" | `doctrine/skills/skill-creator/SKILL.md` |

## Tier 2: Domain Capabilities (2)

| Skill | Trigger | Pointer |
|---|---|---|
| viz | "viz", "what chart", "dashboard design" | `doctrine/skills/viz/SKILL.md` |
| stakeholder-mapping | "stakeholder map", "influence interest" | `doctrine/skills/stakeholder-mapping/SKILL.md` |

## Tier 2: Orchestration Capabilities (1)

| Skill | Trigger | Pointer |
|---|---|---|
| loop-engineering | "build a loop", "recurring agent job", "loop spec" | `doctrine/skills/loop-engineering/SKILL.md` |

---

## Team edition (org layer)

Team edition is the complete superset. The org layer lives under `team/`:

| Component | Pointer |
|---|---|
| team-router | `team/team-router/SKILL.md` |
| Command Center | `team/command-center/` |
| Installer | `team/install/install.py` |
| Capability profile | `team/capability-profile.md` |
| Routing contract | `capabilities/team-routing.md` |

Individual derive omits `team/`; Team derive includes it.

---

## v3.0.0 Changes

New co-owned repo (Option Z). Two authors: Cameron Sutcliff + Joshua Sutcliff.
v3.0.0 merges both contributors' skills into unified, intent-routed skills (the
viz-routing pattern: one trigger set, sub-components loaded on demand) and applies
the five-part standalone-skill rule to every component. All component decisions
are recorded in `docs/component-ledger.md`.

Merged into unified skills:

- **`memory` (new, Tier 1).** Folds Josh's session-lifecycle commands (compress,
  preserve, resume) with Cameron's file-based memory model (capture, recall) into
  one skill with five meta-modes. Sub-components in `reference/`.
  - `context-loader` retired into `memory` (resume mode).
  - `pattern-promoter` retired into `memory` (preserve mode). The ACE-scored
    promotion format (CAOS promotion format plus helpful=N / harmful=N scoring
    from the enforced runtime) is kept inside that mode; full Dataview surfacing
    remains a future milestone.

- **`delegation` (new, Tier 1).** Folds Josh's named workers (researcher,
  code-generator, tester) with Cameron's delegation doctrine, cost-tier routing,
  and the autonomy ladder into one generic, shippable skill. Supersedes the
  fleet-specific `delegation.md` (now a redirect stub, still derive-excluded).

- **`agent-panel-review` (extended).** Gains a `phased-review` mode (Josh's
  spec-drift harness, distilled) alongside the existing panel-review protocol.
  Lite only: no sealed-panel anonymity internals; the panel narrative points to
  Field Guide Chapters 31 to 32. Runnable workflow lives in
  `runtime/claude-code/workflows/phased-review.js`.

Consolidation cuts (five-part rule applied to all components):

- `trigger-indexer` demoted to CI. Registry drift is a repo invariant caught
  by `enforcement/bin/check-registry-coherence.sh`. The maintenance procedure lives in
  `doctrine/skills/request-router/reference/registry-maintenance.md`.
  All trigger-indexer trigger phrases removed from the registry.

- `provenance-check` merged into `release-captain`. Provenance verification
  is a release-time step (Step 3 of the ship gate), not an independent
  session-routable skill. Procedure is now at
  `doctrine/skills/release-captain/reference/provenance-verification.md`.
  "verify origin" and "check provenance" triggers now route to release-captain.

Kept separate (merge proposals withdrawn under cross-critique):

- `adoption-captain` and `engagement-bootstrap` remain separate. The split is
  a documented safety boundary: engagement-bootstrap must not run on an
  existing project.
- `agent-panel-planning` and `agent-panel-review` remain separate. Distinct
  lifecycle phases (pre-execution vs post-execution) and distinct artifacts
  (converged plan vs sealed critique).
- `goal-runner` and `loop-engineering` kept verbatim from v2.7.0.

Count. v3.0.0 leaves four retired redirect stubs on disk: `context-loader`,
`pattern-promoter`, `provenance-check`, `trigger-indexer`. The Individual derive
ships 26 active skills (11 Tier 1 + 15 Tier 2); the full repo (Team superset,
adding `team-router`) is 27 active. `check-counts.sh` derives these from the
filesystem; do not hand-type the number.

## v2.7.0 Changes

- Added `loop-engineering`: the Loop Spec contract, three hard stops,
  closed-loop default, maker/checker verification, memory on disk. No loop
  runs without a spec.
- Added `templates/loop-spec.md`: the fill-in per-loop contract.
- Total active skills: 28.

## v2.6.0 Changes

- Added `goal-runner`: durable goal contract, validation loop, slow lanes,
  selector/repair symmetry, rendered contract checks, and memory closeout.
- Added `trigger-indexer`: maintains the machine-readable trigger registry.
- Added `trigger-registry.yaml`: the router's canonical trigger surface.
- Updated `request-router` to use the registry instead of hardcoded prose.
- Updated `adoption-captain` memory commit to install a behavioral overlay.
- Corrected count drift from the v2.5.0 package: repo has 27 active skills.
- Standardized pointer budget language: under 100 lines, target 80.

Historical release notes live in `releases/`.

## Pointer Skill Rule

Every active `SKILL.md` stays under 100 lines, target 80. Deep references live
in `reference/` and load on demand. Skills are tools, not documentation.
