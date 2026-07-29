# Session Start Checklist
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Run at the start of every non-trivial AI session.

## Always load

- [ ] `AGENT.md`  -  root operating contract (constraints, tech stack, context map)
- [ ] `_tiers.md`  -  inheritance model (Tier 1 / 2 / 3)
- [ ] `doctrine/tiers/tier0.md`  -  the 5-bullet always-load context
- [ ] `_skills-index.md`  -  full capability registry (infrastructure + capability skills)
- [ ] `doctrine/conventions/trigger-registry.yaml`  -  machine-readable routing surface
- [ ] `doctrine/skills/request-router/SKILL.md`  -  activates skill routing for this session

## Load for most sessions

- [ ] `STATE.md`  -  current state: what is running, blocked, next
- [ ] `doctrine/tiers/tier1-current.md`  -  live working context

## Load on demand (subsystem work)

- [ ] `doctrine/tiers/tier1-subsystem/[relevant].md`  -  the specific subsystem slice

## Load on demand (deep work)

- [ ] Relevant section of spec or design doc (not the full file unless needed)

## Never load directly

- [ ] Full codebase (use search instead)
- [ ] Full session archive (use search or query instead)
- [ ] Large reference documents (use the Level 1 summary + path instead)

## State the task

- [ ] Task description is explicit and specific
- [ ] Expected output format is specified
- [ ] If ambiguous, query the knowledge index before loading broad context

## Cognitive mode check

Before responding to any complex request, check the trigger registry through request-router.
If a cognitive mode applies, load and follow that skill before producing output.

## Durable goal check

If work has a verifiable finish line, multiple steps, queue/backlog language,
or "keep going until" intent, load `goal-runner` and write a goal contract
before acting.

## Token budget check

| Session type | Expected context |
|---|---|
| Mechanical fix (one file) | tier0 only, 300–500 tokens |
| Subsystem work | tier0 + tier1 slice, 800–2,000 tokens |
| Cross-subsystem | tier0 + tier1-current + 2–3 slices, 3,000–6,000 tokens |
| Architecture decision | tier0 + relevant spec section, 5,000–10,000 tokens |
| New project bootstrap | full spec (one time only), 10,000–15,000 tokens |
