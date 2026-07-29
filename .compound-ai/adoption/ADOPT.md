# Adopt
# Compound AI Operating Standards v3.0.10
# Authors: Cameron Sutcliff, Joshua Sutcliff (joshuadsutcliff)
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

This file is the entry point for adopting the Compound AI kit into an
**existing** project. If you are starting a new project from scratch
with the kit, use `HANDOFF.md` and `engagement-bootstrap` instead.

## Three layers (read first)

| Layer | Path | Required? |
|---|---|---|
| A: Doctrine | Root + `tier-*/` | Yes. Portable Markdown and YAML. |
| B: Enforced Runtime | `runtime/claude-code/` | No. Claude Code hooks only. |
| C: Reference Tooling | `reference-impl/` | No. Python maintainer utilities. |

You may adopt Layer A alone. Layers B and C are optional profiles documented in
`STANDARD.md`.

The kit is not designed to flatten your project into its conventions.
It is designed to layer alongside your existing stack, propose only
safe changes, validate against your project's own tests, and update
your agent's instruction surfaces so future sessions inherit the kit's
durable behavioral overlay automatically.

---

## The fork: new project or existing?

```
If this is a new project    : use HANDOFF.md + engagement-bootstrap
If this is an existing project: use adoption/ADOPT.md + adoption-captain
```

If you are unsure, ask yourself: do I have files I am protective of in
this project that I do NOT want overwritten? If yes, you are adopting.

---

## Drop-in prompt for adopting agents

Copy everything between the rules and paste into a session of the agent
that operates inside your existing project (Claude Code in your repo,
Codex CLI, Cursor, etc.):

---

You are adopting Compound AI Operating Standards into an existing
project.

Do not replace this project's current tech stack, agent rules, build
system, deployment flow, or coding conventions. Existing project rules
win unless I explicitly approve a change.

**First read the kit files (in this exact order):**

1. `AGENT.md`: the kit's operating contract
2. `STANDARD.md`: the three-layer model (Doctrine vs runtime vs tooling)
3. `_tiers.md`: the kit's tier model
4. `_skills-index.md`: the kit's skill registry (do NOT load all skills; this is just the index)
5. `doctrine/tiers/checklists/session-start.md`: the bootstrap routine
6. `doctrine/conventions/trigger-registry.yaml`: machine-readable routing surface
7. `doctrine/skills/request-router/SKILL.md`: router procedure
8. `doctrine/skills/goal-runner/SKILL.md`: durable goal loop
9. `doctrine/skills/adoption-captain/SKILL.md`: the adoption protocol

Do NOT read the full field guide. It is the deep manual, not the
startup payload. Load specific chapters only when an adopted skill asks
for them.

**Then inventory the host project:**

1. Existing agent instruction files (CLAUDE.md, AGENT.md, AGENTS.md, .cursorrules, .aider.conf.yml, CONVENTIONS.md)
2. Package and build files (package.json, pyproject.toml, Cargo.toml, go.mod, etc.)
3. Test, lint, typecheck, and deploy commands
4. README and architecture docs
5. Current state, backlog, decision logs, session logs if present

**Then run the adoption protocol** (`adoption-captain` SKILL.md, eight
stages):

1. Discover host context
2. Preserve host rules (build the Preserve / Add / Modify / Defer / Conflict map)
3. Inventory kit surface (skills, shells, scripts)
4. Map kit to stack (classify each skill: adopt now / adapt / defer / skip / conflict)
5. Propose a phased plan (Phase 1 = additive scaffolding only)
6. Apply additively (default placement `.compound-ai/`; never overwrite without approval)
7. Validate non-breakage (run host project's own test, build, lint, typecheck)
8. Document and commit to memory:
   - Write `.compound-ai/adoption-report.md`
   - Update the host agent's instruction surfaces (CLAUDE.md, AGENT.md,
     etc.) with a bounded `## Compound AI Operating Standards` section so
     future sessions check triggers, use goal contracts, budget context,
     validate rendered contracts, and write useful memory. Operator-gated
     per surface.
   - If the machine has multiple agent runtimes, document native skill roots
     and shared-skill routing.

**Do not edit anything before producing the adoption plan and getting
my approval.**

---

## What you should see when the agent finishes

```
ADOPTION COMPLETE: Compound AI v3.0.1 -> [your project]
═══════════════════════════════════════════════════════

Discovery:
  Stack: [detected]
  Test command: [detected or NOT-FOUND]
  Build command: [detected or NOT-FOUND]
  Existing agent files: [list]

Adoption mapping:
  Adopt now: [skill list]
  Adopt with adaptation: [skill list]
  Defer: [skill list]
  Skip: [skill list]
  Conflict: [skill list, with proposed resolution]

Files added:
  .compound-ai/ (kit at this path)
  .compound-ai/adoption-report.md (full audit trail)

Memory commit:
  Updated: [list of host agent instruction files with bounded sections]
  Overlay: trigger registry + goal-runner + validation + memory closeout
  Global surfaces touched: [yes / no]

Validation:
  [host project test command]: PASS / FAIL / NOT-FOUND
  [host project build command]: PASS / FAIL / NOT-FOUND
  [host project lint command]: PASS / FAIL / NOT-FOUND

Routing active. Future substantial work will use the kit's behavioral overlay.
```

If the output does not look like this, the adoption is incomplete.
Restart and check the file paths are correct relative to the agent's
working directory.

---

## Default placement: `.compound-ai/`

The kit goes into `.compound-ai/` at your project root by default. This
keeps the kit visibly separate from your existing files and trivially
removable if you decide adoption was the wrong call.

Your project's root stays yours. Your `AGENT.md`, `CLAUDE.md`,
`README.md`, `STATE.md`, and configuration files are NOT overwritten.
The agent adds a bounded `## Compound AI Operating Standards` section
to your existing agent instruction file(s) (with your approval). The
section lists the kit path, adopted skills, trigger registry, goal-runner
contract, preserve rules, validation commands, and closeout memory rules.
The rest of those files is left alone.

## Universal shared-skill routing

On a machine with multiple agents, Compound AI should centralize shared skills
without breaking native runtime expectations.

Use this pattern:

```text
~/.compound-ai/skills/[skill-name]   canonical shared skill
~/.claude/skills/[skill-name]        symlink to canonical copy
~/.agents/skills/[skill-name]        symlink to canonical copy
~/.codex/skills/[skill-name]         symlink only when Codex needs it
```

Rules:

1. Discover each runtime's native skill root.
2. Identify skills that are shared across runtimes.
3. Back up both copies before convergence.
4. Compare drift before selecting a canonical copy.
5. Preserve real machine paths and runtime-specific commands.
6. Replace shared runtime copies with symlinks to `~/.compound-ai/skills`.
7. Leave tool-specific skills in their native roots.
8. Add a drift-audit command to the memory-commit section.

Full convention:
`doctrine/conventions/universal-skill-routing.md`.

---

## Rollback

To remove the kit completely:

1. Delete the `.compound-ai/` directory
2. Open each instruction file the adoption report lists as updated
3. Find the `<!-- compound-ai:start -->` ... `<!-- compound-ai:end -->`
   markers and delete everything between (and including) them
4. Save

That is the full uninstall. The kit makes no other changes to your
project that are not contained within `.compound-ai/` or marker-
bounded sections.

---

## What the kit does NOT do during adoption

- Does NOT rewrite your existing code in kit patterns
- Does NOT migrate your existing prompts or conventions
- Does NOT modify your CI/CD pipelines
- Does NOT change your package manager or build system
- Does NOT replace your existing AGENT.md / CLAUDE.md / AGENTS.md
- Does NOT enable kit-specific git hooks unless you explicitly opt in
- Does NOT update global instruction files (~/.claude/CLAUDE.md, ~/.codex/AGENTS.md) without a separate explicit confirmation

Adoption is additive. The kit becomes an option for your agent, not a
replacement for what you already had.

---

## Tested with

This adoption flow has been validated against:

- **Claude Code**: reads `CLAUDE.md` first, then proceeds through the adoption-captain protocol; updates `<project>/CLAUDE.md` with the marker-bounded section
- **Codex CLI**: reads `AGENT.md` natively; updates `<project>/AGENT.md` or `<project>/AGENTS.md` with the marker-bounded section
- **Cursor**: reads `.cursorrules`; updates with a YAML or rules-block version of the kit section
- **Aider**: reads `CONVENTIONS.md`; updates with a markdown section

If your agent reads a different file convention, the adoption-captain
skill will discover it and ask you to confirm before updating.

---

## Custom adoption notes

If you have a specific reason a default doesn't fit (e.g. you want the
kit at `vendor/compound-ai/` instead of `.compound-ai/`, or you have
strong reasons to skip the memory-commit step), tell the agent at the
start of the adoption protocol. The default behaviors are sensible
starting points, not rigid mandates.

---

## Optional: enforced runtime (Layer B)

After Layer A adoption is stable, you may merge `runtime/claude-code/settings.fragment.json`
into your Claude Code settings for usage-guard and session-router hooks. This layer
is Claude Code-specific and must not be described as vendor-neutral. See
`runtime/claude-code/README.md` and `docs/known-limits.md`.

## Optional: reference tooling (Layer C)

Scripts live under `reference-impl/` and ship in both edition zips. To verify
what you downloaded, run `reference-impl/scripts/verify-integrity.py` and
`reference-impl/scripts/verify-origin.py` (stdlib-only, no install).
`build-manifest.py` and the `skill-creator/` scaffold are maintainer reference
material you can ignore. None of this is tier-0 loaded,
so it does not affect the lean session-start cost.

## Companion files

- `STANDARD.md`: the three-layer standard and CI gate summary
- `HANDOFF.md`: the entry point for FRESH agents on NEW projects
- `adoption/INSTALL.md`: the multi-agent setup question (do you have multiple agents available?)
- `AGENT.md`: the kit's root operating contract (loaded by both HANDOFF and ADOPT flows)
- `_skills-index.md`: the complete skill registry
- `doctrine/conventions/trigger-registry.yaml`: machine-readable triggers
- `doctrine/skills/goal-runner/SKILL.md`: durable goal loop
