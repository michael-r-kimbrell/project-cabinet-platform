# Tier Model

Context-loading tiers describe how much kit material to load for a given task. They are unrelated to the six-layer directory layout.

```
doctrine/tiers/          <- always-load context (tier0) and working context (tier1)
  tier0.md               <- load every non-trivial session
  tier1-current.md       <- current engagement context
  checklists/            <- session-start, session-closeout, era transitions

doctrine/skills/         <- on-demand skills and deliverable shells
  (tier 1 infrastructure skills)
  (tier 2 capability skills)
  (tier 3 shells: slide-shell, scroll-shell, mission-control, course-shell)

doctrine/contracts/      <- goal-contract, loop-spec, verifiable finish-line primitives
doctrine/conventions/    <- trigger-registry, style, skill-author rules
```

## Inheritance rules

- **Tier 0/1 context is universal.** Conventions and core skills apply everywhere. Loaded at session start.
- **Tier 2 skills are on-demand.** Capability skills load when their triggers fire.
- **Tier 3 shells are per-deliverable.** Shells are starting points for specific output types.

## Six-layer kit layout

The repo is organized into six layers (see `STANDARD.md` and `_map.md`):

1. **Doctrine** (`doctrine/`) - portable Markdown/YAML any agent honors
2. **Capabilities** (`capabilities/`) - runtime-agnostic capability contracts
3. **Runtime** (`runtime/`) - per-agent adapters (none privileged)
4. **Enforcement** (`enforcement/`) - gates, CI, self-tests
5. **Proof** (`proof/`) + **reference-impl/** - evidence and maintainer tooling
6. **Adoption** (`adoption/`) - install and adopt entry points

## Authoring rules

- A file in tier 0/1 must be useful to every downstream consumer. If something is domain-specific, move it to skills.
- Skills should not duplicate conventions. Reference upstream, do not copy.
- Shells embed Abyssal design tokens in each shell's `index.html`.

## Naming note

Context tiers (tier0/tier1 = how much to load) differ from skill tiers (1/2/3 = inheritance hierarchy in the skill registry).
