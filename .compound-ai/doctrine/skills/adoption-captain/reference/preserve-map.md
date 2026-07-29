# adoption-captain: Preserve Map (Stage 2)

Stage 2 takes the rule inventory from `discovery-report.md` and classifies
each existing rule by its adoption implication. The output is a classification
table written to `preserve-map.md`. The table is the contract between the
existing project and the kit.

**Default: existing project rules win.** The kit adapts to the project, not
the other way around. Any deviation from this default requires explicit
operator confirmation.

---

## The five classifications

| Class | Meaning | Action |
|---|---|---|
| **PRESERVE** | Kit must not touch or override this rule | Record it in the memory-commit section; the adopted skills must defer to it |
| **ADD** | This area has no existing rule; kit can add one | Kit fills the gap additively |
| **MODIFY** | Project has a rule; kit has a better or different approach; operator must decide | Surface to operator with proposed change and rationale; wait for approval |
| **DEFER** | Kit has a relevant skill, but the project is not ready for it yet | Skip in Phase 1; revisit in Phase 2 or later |
| **CONFLICT** | Kit convention directly opposes an existing project rule | Surface with proposed resolution; never apply the kit default unilaterally |

---

## Building the table

For each rule found in Stage 1, create one row:

| Existing rule | Source (file:lines) | Kit default | Classification | Rationale |
|---|---|---|---|---|
| [rule text] | [path:L12-14] | [what kit would do] | [class] | [one sentence] |

The "Kit default" column states what the kit would do if it were being applied
to a new project. This makes conflicts visible without requiring the operator
to know the kit internals.

---

## Classification examples

### Example 1: Style convention (PRESERVE)

| Existing rule | Source | Kit default | Classification | Rationale |
|---|---|---|---|---|
| "Use em dashes for parenthetical asides in prose" | CLAUDE.md:23 | Prohibit em dashes; hook enforced | CONFLICT | Kit's no-em-dash rule cannot be applied; project explicitly uses em dashes. Hook must not be enabled. |

Operator surface: "Your CLAUDE.md permits em dashes in prose. The kit prohibits
them with a hook. Proposed resolution: skip the hook installation entirely for
this project. Accept?" If the operator says yes, record the skip in the adoption
plan. If the operator wants the hook, that is a MODIFY, and they are
knowingly overriding their own rule.

### Example 2: Test discipline (PRESERVE + ADD)

| Existing rule | Source | Kit default | Classification | Rationale |
|---|---|---|---|---|
| "All PRs must pass `npm run test` before merge" | CLAUDE.md:7 | Validate with detected test command | PRESERVE | Kit aligns with this rule; the validation step reinforces it. |
| (no rule about lint or typecheck) | -- | Suggest `npm run lint` and `tsc --noEmit` | ADD | Project has no existing lint gate; kit can surface one. |

### Example 3: Agent model restriction (PRESERVE)

| Existing rule | Source | Kit default | Classification | Rationale |
|---|---|---|---|---|
| "Use gpt-4o-mini for all summarization tasks; cost control" | AGENT.md:31 | No model prescription | PRESERVE | Kit does not override model choice. The preserve rule is noted in memory-commit. |

### Example 4: Commit message format (ADD)

| Existing rule | Source | Kit default | Classification | Rationale |
|---|---|---|---|---|
| "Commit messages use Present-tense imperative only: 'Add X', 'Fix Y'" | CONVENTIONS.md:8 | No commit format prescription | ADD | No conflict; kit has no commit message rule. Mark as ADD (kit can reinforce the existing rule). |

### Example 5: Kit-relevant gap (ADD)

| Existing rule | Source | Kit default | Classification | Rationale |
|---|---|---|---|---|
| (no provenance or attribution discipline) | -- | release-captain's provenance step catches unsourced claims | ADD | No existing rule; release-captain's provenance / verify-origin step can be adopted now. |

### Example 6: Pre-existing panel discipline (DEFER)

| Existing rule | Source | Kit default | Classification | Rationale |
|---|---|---|---|---|
| "This is a solo project; only one agent session at a time" | README.md:41 | agent-panel-planning for multi-agent work | DEFER | Panel skills are not relevant for a solo-agent project right now. |

---

## Surfacing conflicts to the operator

When a CONFLICT row is found, the agent presents it before proceeding to
Stage 3. Format:

```
CONFLICT detected: [rule text]
Source: [file:lines]
Kit behavior: [what the kit would do]
Proposed resolution: [one of: skip the kit convention / override the existing rule (operator must confirm) / adapt the kit convention to fit]
Accept resolution? (yes/no)
```

The operator's response is recorded in `preserve-map.md`. A conflict without
a recorded resolution blocks Stage 5 (the adoption plan cannot be written
with unresolved conflicts).

Resolution options:

1. **Skip the kit convention** -- the kit feature is not adopted for this
   project. Record as SKIP in the mapping rubric.
2. **Override the existing rule** -- the operator knowingly replaces their
   own rule with the kit's. Requires explicit "yes, override [rule]" confirmation.
   Record the override in both `preserve-map.md` and the adoption report.
3. **Adapt the kit convention** -- the kit's approach is modified to be
   compatible with the existing rule. The adaptation is described in the
   mapping rubric under "adopt with adaptation."

---

## Preserve-map output format

Write `preserve-map.md` to the project root (temporary; moved to
`.compound-ai/` in Stage 5).

```markdown
# Preserve Map
Date: YYYY-MM-DD
Host project: <path>
Generated by: adoption-captain v2.6.0

## Classification summary

| Class | Count |
|---|---|
| PRESERVE | N |
| ADD | N |
| MODIFY | N |
| DEFER | N |
| CONFLICT | N |

## Full table

| # | Existing rule | Source | Kit default | Class | Rationale |
|---|---|---|---|---|---|
| 1 | ... | ... | ... | PRESERVE | ... |
| 2 | ... | ... | ... | ADD | ... |

## Conflict resolutions

| # | Conflict | Proposed resolution | Operator decision | Date |
|---|---|---|---|---|
| 1 | [rule] | Skip hook | Accepted | YYYY-MM-DD |

## PRESERVE rules for memory-commit

The following rules MUST appear in the Compound AI section of the host
agent's instruction file(s) so future sessions honor them:

- [rule 1]
- [rule 2]
```

---

## What carries forward from Stage 2

- The PRESERVE rules list carries into Stage 8b (memory-commit): these rules
  appear verbatim in the `## Compound AI Operating Standards` section under
  "Preserve rules."
- The CONFLICT resolutions carry into the adoption plan: each resolved
  conflict appears in the "Conflicts" section of the plan.
- ADD and MODIFY entries carry into the mapping rubric as candidate
  adoption areas.
- DEFER entries carry into the adoption plan's "Deferred skills" section.

---

## Anti-patterns

### Anti-pattern: classifying everything as ADD

**Symptom.** Agent reads CLAUDE.md, finds 12 rules, and classifies all of
them as ADD because "the kit doesn't have a conflicting rule for any of them."

**Fix.** PRESERVE is the correct classification for any existing rule that
the kit's behavior could plausibly touch, even indirectly. If the kit adds
a hook, a validation step, a new file, or a new agent instruction section,
any existing rule in those areas is PRESERVE until proven otherwise.

### Anti-pattern: skipping the conflict presentation step

**Symptom.** Agent classifies a row as CONFLICT, notes it in the table, and
proceeds to Stage 3 without surfacing it to the operator.

**Fix.** Every CONFLICT row pauses the protocol. The agent cannot proceed
to the next stage with unresolved conflicts. The operator must record a
decision before Stage 3 begins.

### Anti-pattern: letting kit conventions override PRESERVE rules in memory-commit

**Symptom.** The agent writes the memory-commit section (Stage 8b) with kit
defaults that contradict a PRESERVE rule from Stage 2 -- for example,
adding a "no em dashes" instruction to a project where em dashes were
classified PRESERVE.

**Fix.** The preserve map is input to the memory-commit template. Every
PRESERVE rule is copied into the memory-commit section verbatim. The agent
reviews the draft memory-commit against the preserve map before presenting
it to the operator.
