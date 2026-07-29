# Quality Gates Template
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Define quality gates for each output type in your project.
Every pipeline that persists narrative content must declare its section floors.

## Output type: [fill in your output type]

### Schema gate
- Required fields: [list]
- Field types: [list]
- Validation: `code/schema_validator.py` or equivalent
- On failure: retry once with error injected, then raise

### Richness gate
- Minimum length (floor): [N] characters
- Historical max tracking: yes / no
- Preserve prior version if below floor: yes / no
- Reference: `code/pipeline_runs.sql` quality_ledger table

### Lineage gate
- Minimum edges required: [N] (recommend at least 1 "derived_from" edge)
- On failure: log warning, do not block (lineage is best-effort)

### "So What" gate
- Every output must be explainable in terms of why it matters to a decision
- If the "so what" cannot be stated in one sentence, the output is not ready
- On failure: flag for human review before surfacing

## Section floors by content type

| Section | Floor (chars) | Historical max tracking |
|---|---|---|
| [section name] | [N] | yes / no |
| [section name] | [N] | yes / no |

## Quality ledger

Every write decision should append one row to the quality ledger:
- action: written / preserved / aborted
- new_len: length of new content
- prior_len: length of prior content
- floor: the richness floor applied

Reference: `code/pipeline_runs.sql` (report_quality_ledger table)

## Scheduled quality sweep

Run daily. Scan for subjects below richness floor. Restore from history. Alert if healed.
Reference: Field Guide Chapter 24 (The Quality Immune System)
