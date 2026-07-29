# Skill Author Guide

Version: v3.0.10
Authors: Cameron Sutcliff, Joshua Sutcliff (joshuadsutcliff)

Use this file when adding, revising, or evaluating a skill under `skills/` or
`doctrine/skills/`. Every component in the kit is judged by the
standalone-skill rule before it earns its own SKILL.md.

---

## The Standalone-Skill Rule (five-part test)

A capability earns a standalone SKILL.md if and only if it satisfies all five:

1. **Distinct trigger.** It has a routable trigger that would not fire on any
   other active skill. Two skills must not share a trigger signature.

2. **Distinct procedure.** The procedure is non-obvious enough that a capable
   agent gets it wrong without it. If it is just "do the obvious thing," it
   is a checklist item or a section in a parent skill, not a standalone skill.

3. **Cross-project reuse.** It applies independently across more than one
   project type. A project-specific procedure belongs in that project's docs,
   not in the shared skill surface.

4. **Pointer-cap compliance.** The SKILL.md is under 100 lines (target 80).
   Long content goes in a `reference/` file linked from the pointer. A skill
   that cannot be described under the cap does not earn standalone status.

5. **Proof note or scheduled measurement.** The skill carries evidence it is
   used (a proof note, a trigger-registry entry with known firing history, or
   a scheduled `check-counts.sh` measurement). Fail this twice and the skill
   is cut. Fail criterion 3 and it becomes a section in a parent skill.

**Consequence of failing the five-part test:**
- Fail 5 twice: cut from the skill surface.
- Fail 3 only: demote to a section in the nearest parent skill.
- Fail any other single criterion: revision required before merge.

---

## Required SKILL.md Sections

1. **Trigger:** exact phrases or conditions that route to this skill.
2. **Goal:** what the skill helps accomplish.
3. **Inputs:** files, data, or context needed.
4. **Procedure:** the smallest useful workflow (numbered steps).
5. **Outputs:** expected artifact or answer.
6. **Checks:** how to verify the result (cite files and lines).
7. **References:** deeper files to load on demand.

---

## Size Rule

Under 100 lines, target 80. If the skill needs more detail, move it to
`reference/` and link to it. The pointer file routes; it does not contain the
whole framework.

---

## Authoring Rules

- Never duplicate content from a parent tier. Reference it.
- Name specific files and commands. Vague instructions are not verifiable.
- Give the skill a clear finish condition. "Be thoughtful" is not one.
- Add a verification step. A skill with no check cannot prove it worked.
- Add an entry to `trigger-registry.yaml` when the skill ships. The registry
  is `check-registry-coherence.sh`'s data source; a missing entry fails CI.

---

## Naming

Short kebab-case. Name the job, not the tool:

- `request-router` (not `claude-router`)
- `token-economist` (not `usage-optimizer`)
- `quality-gate` (not `pre-ship-checker`)

---

## What Goes Where

| Content type | Location |
|---|---|
| Pointer file | `skills/{name}/SKILL.md` or `doctrine/skills/{name}/SKILL.md` |
| Deep reference | `skills/{name}/reference/` or `docs/` |
| Templates | `templates/` or `skills/{name}/templates/` |
| Examples / fixtures | `examples/` or `tests/fixtures/` |
| Enforced runtime scripts | `runtime/claude-code/` only (Layer B) |

No `.py`, `.sh`, or `.js` inside a SKILL.md directory. Scripts belong in
`runtime/claude-code/`, `hooks/`, or `reference-impl/`. The portability gate
(`check-portability.sh`) fails on violations.

---

## Component Ledger

Every new skill is entered in `docs/component-ledger.md` before it ships.
Record: name, five-part test result, proof note or measurement date, and
keep/merge/cut decision. This prevents count drift and phantom entries.
