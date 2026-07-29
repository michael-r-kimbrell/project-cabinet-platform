# Skill: quality-gate
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Checks whether generated work meets the quality bar before it ships or a goal
is declared complete.

## Triggers
"quality check", "validate output", "ship check", "is this ready", "so what test", "rendered contract"

## What it checks
1. Schema: does the output conform to the declared output schema?
2. Richness: is narrative content above the richness floor?
3. Lineage: does the output point at source evidence?
4. So What: does it explain why it matters to a decision?
5. Grounding: are specific claims traceable to evidence?
6. Rendered contract: does the user-visible surface work?
7. Corpus symmetry: can validators see the facts the prompt used?

## Quality gate checklist
- [ ] Output passes schema validation (no missing required fields, correct types)
- [ ] Narrative sections are above richness floor (not below 50% of historical max)
- [ ] At least one lineage edge recorded (derived_from source evidence)
- [ ] "So What" is explicit: output explains why it matters, not just what happened
- [ ] No ungrounded specifics (every named entity, number, or claim has a source)
- [ ] Rendered artifact checked when output has a UI, deck, site, package, or public feed
- [ ] Prompt facts and validation facts use the same evidence corpus

## Failure actions
- Schema failure: retry once with error injected into prompt
- Richness failure: preserve prior version, log to quality ledger
- Lineage missing: log warning, do not block (lineage is best-effort)
- So What missing: flag for human review before surfacing to end consumer
- Grounding failure: reject output, do not surface
- Rendered contract failure: fix the visible surface, not just backing data
- Repeated gate failure: slow-lane the item with reason; continue unrelated work

## Backward and forward rule

When this gate learns a new bad pattern, check already-published or already-
generated artifacts for the same pattern. A forward-only gate leaves old bad
output live.

## Source references
- `code/schema_validator.py` -- schema validation implementation
- `code/pipeline_runs.sql` -- quality ledger table
- Field Guide Chapter 21: Schema Validation at LLM Boundaries
- Field Guide Chapter 24: The Quality Immune System
- Field Guide Chapter 25: The "So What" Test
- IIP Durable Patterns: rendered contract checks, quarantine lanes, prompt/gate corpus symmetry
