# Token Budget Worksheet
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Use this worksheet to plan context loading for a session or pipeline.

## Session type
[ ] Mechanical fix (one file)
[ ] Subsystem work
[ ] Cross-subsystem engineering
[ ] Architecture decision
[ ] New project bootstrap
[ ] Overnight autonomous run

## Context plan

| Layer | File | Estimated tokens | Load? |
|---|---|---|---|
| Tier 0 | `context/tier0.md` | [fill] | Always |
| Tier 1 current | `context/tier1-current.md` | [fill] | Most sessions |
| Tier 1 subsystem | `context/tier1-subsystem/[name].md` | [fill] | If subsystem-specific |
| Tier 2 spec section | `[path to spec section]` | [fill] | Deep work only |
| RAG results | Knowledge index query | [fill] | If ambiguous task |

**Total estimated context:** [sum] tokens

## Model routing plan

| Task in this session | Model tier | Rationale |
|---|---|---|
| [task 1] | [local / fast / mid / full] | [why] |
| [task 2] | [local / fast / mid / full] | [why] |

## Cache check
- [ ] Is this a repeated synthesis call? If yes, check cache before running.
- [ ] Are the upstream inputs unchanged since the last run? If yes, use input-fingerprint cache.
- [ ] Is the prompt normalizable? Strip incidental dates/timestamps before hashing.

## Budget targets by session type

| Session type | Tier 0 | Tier 1 | RAG | Total |
|---|---|---|---|---|
| Mechanical fix | Yes | No | No | 300-500 tokens |
| Subsystem work | Yes | Subsystem slice | Optional | 1,000-3,000 tokens |
| Cross-subsystem | Yes | 2-3 slices | Yes | 3,000-6,000 tokens |
| Architecture | Yes | Full design section | Yes | 5,000-10,000 tokens |
| Bootstrap | Yes | Full spec | No | 10,000-15,000 tokens |
| Overnight run | Yes | Current state only | No | 500-1,000 tokens |
