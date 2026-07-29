# Era 02 to Era 03 Checklist: Ramp-up to Durable
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Era 02 (Ramp-up): Can this run unattended?
Era 03 (Durable): Can others rely on it?

Complete this checklist to graduate from Era 02 to Era 03.

## Required for Era 03

### Schema and validation
- [ ] Schema validation at every LLM boundary (no raw json.loads without schema check)
- [ ] Schema constants defined at module level, not inline
- [ ] Auto-retry on schema validation failure (one retry with error injected)

### Lineage and observability
- [ ] Lineage on every synthesized artifact (at least "derived_from source" edges)
- [ ] `pipeline_runs` table with phase health queryable
- [ ] Phase wrapper records start, end, status for every scheduled phase
- [ ] Phase failures do not abort the entire pipeline

### Token efficiency
- [ ] Cache hit rate measured per role (not just "cache exists")
- [ ] Tiered context loading in place (not full spec on every session)
- [ ] Model routing table defined and applied consistently

### Quality
- [ ] Quality immune system for narrative content (merge-preserve + quality ledger)
- [ ] Richness floors defined for each narrative section type
- [ ] Scheduled quality sweep exists (even if not yet automated)

### Operational discipline
- [ ] Session end protocol followed every session (STATE.md + session log updated)
- [ ] Patterns promoted from session logs to shared reference
- [ ] URL enumeration defense on any gated public resources (opaque slugs)

## Signals you are in Era 02 (not yet Era 03)
- You notice silent drift in the weekly review, not in the moment
- A downstream consumer has complained about stale or wrong output
- You have had to manually restore a degraded artifact
- Cache hit rate is "probably fine" (not measured)
- A new operator cannot pick up the work without an oral history

## Signals you are in Era 03
- Schema validation catches drift at the boundary, not downstream
- Lineage answers "why does this say X?" without manual investigation
- Pipeline health is visible in the morning brief
- Token efficiency is measured, not assumed
- A bad output cannot quietly overwrite a good one
- A new operator can read AGENT.md + STATE.md and start contributing
