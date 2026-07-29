# Tiered context loading

The mistake this kit exists to prevent: an agent re-reads the whole project
every session because nobody drew a line between "always needed" and
"needed sometimes." That's the token cost that never goes away.

## Tier 0 — always loaded

`CLAUDE.md` only. Workspace boundary, the five core habits, and a pointer
map to everything else. If it doesn't belong in every single session,
it doesn't belong in Tier 0. Keep it under ~1 page.

## Tier 1 — loaded on demand

Everything under `doctrine/`, `capabilities/`, and skill files. Referenced
by name from `CLAUDE.md`, read only when the task actually touches that
area. A session that never touches supplier data never loads
`CONVENTIONS.md`'s supplier section.

## Tier 2 — loaded rarely

`enforcement/`, `proof/`, `adoption/`. Maintenance and onboarding material.
An agent doing normal feature work never opens these; a new project or a
kit-integrity check does.

## The rule

When you're about to add something to `CLAUDE.md`, ask: does *every*
session need this, or does *some* session need this? "Some" belongs one
tier down, referenced by a one-line pointer, not inlined.
