# Skill: adoption-captain
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Adopts the Compound AI kit into an existing project safely. Pairs with `release-captain`: where release-captain governs what leaves the kit, **adoption-captain governs how the kit enters an existing project**.

Eight-stage protocol that (a) preserves the host stack, (b) maps kit skills to the project's actual needs, (c) applies changes additively under `.compound-ai/`, (d) validates non-breakage with the project's own tests, and (e) **commits a durable behavioral overlay** to the host agent's persistent instruction surfaces (CLAUDE.md, AGENT.md, AGENTS.md, .cursorrules, etc.) so future sessions route, budget, validate, and remember by default.

Required when adopting the kit into ANY existing project. Do NOT use `engagement-bootstrap` on an existing project; that skill copies fresh templates that overwrite real files.

## Triggers

"adopt this kit", "optimize this existing agent", "install this into my current repo", "use these techniques going forward", "reconfigure my agents", "take this tech stack and implement the kit", "do not break my stack", "migrate my agent instructions"

## The eight-stage protocol

| Stage | What happens | Pass criterion |
|---|---|---|
| 1. Discover host context | Read existing agent files, package files, build/test/lint commands, state/decision logs | Full inventory in `discovery-report.md` |
| 2. Preserve host rules | Build a Preserve / Add / Modify / Defer / Conflict map; existing rules win by default | `preserve-map.md` written |
| 3. Inventory kit surface | List skills, shells, scripts, hooks, references; do NOT load full Field Guide | Compact kit inventory ready |
| 4. Map kit to stack | Classify each skill: adopt now / adapt / defer / skip / conflict, with one-line rationale | `mapping-rubric.md` complete |
| 5. Propose phased plan | Phase 1 = additive scaffolding only; Phase 2+ = behavior changes (operator-gated) | Plan written; operator reviews before edits |
| 6. Apply additively | Default placement `.compound-ai/`. Never overwrite host files without explicit approval. On multi-agent machines, route shared skills from native runtime roots to a canonical skill directory. | All changes are additive; nothing destroyed |
| 7. Validate non-breakage | Run host project's own test, build, lint, typecheck, and shared-skill drift audit when skill routing changed. Report PASS / FAIL / NOT-FOUND honestly. | All discovered checks pass, or operator approves remediation |
| 8. Document + commit to memory | Write `.compound-ai/adoption-report.md`. **Update host agent's instruction surfaces** with bounded `## Compound AI Operating Standards` section listing adopted skills, trigger registry, goal contract behavior, preserve rules, validation commands, and shared-skill routing when present. Operator approves each surface. | Memory-commit complete; future sessions use the overlay |

Full procedure per stage in `reference/`:
- `reference/discovery-checklist.md` (Stage 1)
- `reference/preserve-map.md` (Stage 2)
- `reference/mapping-rubric.md` (Stage 4)
- `reference/adoption-plan-template.md` (Stage 5)
- `reference/non-breaking-rules.md` (Stage 6)
- `reference/validation-protocol.md` (Stage 7)
- `reference/adoption-report-template.md` (Stage 8a output)
- `reference/memory-commit-protocol.md` (Stage 8b -- the persistent instruction updates)
- `../../conventions/universal-skill-routing.md` (shared skill routing)

## Default placement

Kit goes in `.compound-ai/` at the host project root. Never the project root itself. Never overwriting an existing `.compound-ai/` directory without confirming it is a prior kit installation that should be upgraded.

## The memory-commit discipline (Stage 8b)

The skill ends not when files are dropped, but when the host agent's persistent operating memory has been updated to USE the kit in future sessions. Without this, every session starts adoption from zero. With it, routing, token discipline, goal loops, validation, and memory closeout become part of the agent's default operating context.

Concretely: a bounded `## Compound AI Operating Standards` section gets appended to the host agent's instruction file(s) -- CLAUDE.md, AGENT.md, AGENTS.md, .cursorrules, AGENTS.codex.md, etc. The section is operator-approved, marker-delimited, and lists exactly what the agent should do: check the trigger registry before complex replies, use `goal-runner` for verifiable multi-step work, preserve host rules, validate rendered contracts, and write useful memory.

Full procedure in `reference/memory-commit-protocol.md`.

## Pair with

- `engagement-bootstrap` -- use this for NEW projects (creates fresh files); adoption-captain is for EXISTING projects
- `release-captain` -- the outbound mirror; together they form the kit's full metabolism
- `memory` -- once adoption completes, its resume mode handles per-session loads

## What this skill is NOT

- **Not a migration tool.** It does not rewrite your existing code in kit patterns.
- **Not silent.** Every file modification needs operator approval.
- **Not destructive.** Default behavior is additive. Destructive operations require explicit confirmation per file.
- **Not optional for existing projects.** Skipping it means the agent improvises adoption, which is the failure mode Codex's v2.4.0 critique surfaced.
