# Lineage Record Template
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Use this template to document the lineage of a synthesized artifact.
For automated lineage, use the `intelligence_lineage` table pattern
from `code/pipeline_runs.sql`.

## Artifact

- **Subject type:** [daily_brief_item / report_section / vacuum / insight / other]
- **Subject ID:** [unique identifier for this artifact]
- **Generated at:** [ISO 8601 timestamp]
- **Model used:** [model tier or name]
- **Pipeline:** [which pipeline produced this]

## Source evidence

| Source type | Source ID | Relation | Notes |
|---|---|---|---|
| [news_article / filing / report / event] | [ID] | derived_from | [brief note] |
| [news_article / filing / report / event] | [ID] | confirmed_by | [brief note] |
| [news_article / filing / report / event] | [ID] | contradicted_by | [brief note] |

## Relation types

- `derived_from`: this artifact was synthesized from this source
- `confirmed_by`: this source corroborates a claim in the artifact
- `contradicted_by`: this source conflicts with a claim in the artifact
- `superseded_by`: a newer version of this artifact exists

## Minimum viable lineage

Even one "derived_from" edge is worth recording. Start simple.
The schema can evolve as the system matures.

## SQL insert pattern

```sql
INSERT OR IGNORE INTO intelligence_lineage
    (subject_type, subject_id, source_type, source_id, relation, created_at)
VALUES
    ('[subject_type]', '[subject_id]', '[source_type]', '[source_id]', 'derived_from',
     datetime('now'));
```

The `INSERT OR IGNORE` pattern enforces idempotency via the UNIQUE constraint.
Lineage writes are best-effort: a write failure logs a warning and does not block the pipeline.
