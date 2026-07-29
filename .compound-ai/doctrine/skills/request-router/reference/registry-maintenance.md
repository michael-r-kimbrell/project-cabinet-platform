# Registry Maintenance Reference
# Compound AI Operating Standards v3.0.10
# Source: github.com/cameronpsutcliff/compound-ai | License: Apache 2.0

The trigger registry is a repo invariant enforced by CI, not a tier-1 skill
invocation. Registry drift is a build failure. This reference covers how to
keep the registry sound and how the CI gate works.

## What the registry is

`doctrine/conventions/trigger-registry.yaml` is the router's canonical
trigger surface. `request-router` reads it at session start. `_skills-index.md`
is the human-readable summary; the YAML is the machine-readable authority.

## When the registry needs updating

- A new `SKILL.md` is added or an existing one is removed.
- A skill is renamed or relocated.
- Trigger phrases on an existing skill change.

These are code changes. Update the registry in the same commit as the skill
change. Do not defer; a merged skill change with a stale registry will fail
`check-registry-coherence.sh` on the next CI run.

## How to update the registry

1. Open `doctrine/conventions/trigger-registry.yaml`.
2. Add, edit, or remove the relevant entry. Schema and field definitions:
   `doctrine/skills/trigger-indexer/reference/registry-schema.md`.
3. Set `updated:` to today's date and increment `kit_version` if this is a
   release commit.
4. Verify locally before committing:

```
# Count SKILL.md files (active skills, excluding demoted/reference-only)
find . -name SKILL.md | grep -v reference-impl | grep -v course-shell | wc -l

# Count registry entries
grep -c '^\s*- skill:' doctrine/conventions/trigger-registry.yaml

# Confirm all pointer paths exist
while IFS= read -r pointer; do
  [[ -f "$pointer" ]] || echo "MISSING: $pointer"
done < <(grep 'pointer:' doctrine/conventions/trigger-registry.yaml | awk '{print $2}')
```

5. Confirm the SKILL.md count, registry entry count, and `_skills-index.md`
   total all agree. The canonical count is whatever `check-counts.sh` reports;
   do not hand-type it.

## CI gate: check-registry-coherence.sh

`enforcement/bin/check-registry-coherence.sh` runs on every push and PR. It:

- Asserts every registry `pointer:` resolves to a real file.
- Asserts no skill is registered twice.
- Asserts the registry entry count matches `_skills-index.md`'s declared total.

A coherence failure blocks merge. Fix the registry or the skill tree; do not
skip the gate.

## Trigger quality rules

- Prefer action phrases and intent phrases over single keywords.
- Do not add vague triggers that fire on normal conversation.
- Vendor-specific triggers are optional. Example: `/goal` maps to `goal-runner`
  but the portable trigger is "completion condition".
- No trigger phrase should be ambiguous between two active skills. If overlap
  exists, add a `notes:` disambiguation hint to both entries.

## Dangling trigger rule

When a skill is demoted or removed, all its trigger phrases must be removed
from the registry in the same change. A trigger phrase that points to a
non-existent or removed skill is a dangling trigger and will fail
`check-registry-coherence.sh`. There are no orphan triggers on a clean build.

## Registry modes

| Mode | Meaning |
|---|---|
| `auto` | Invoke when trigger clearly matches. |
| `offer` | Mention the skill and ask before invoking. |
| `manual` | Do not auto-invoke; only on explicit request. |
| `internal` | Used by another skill, not user-triggered directly. |

## Connection to session-router.sh (enforced runtime)

When the enforced runtime is active, `runtime/claude-code/hooks/session-router.sh`
reads the trigger registry as its data source. Its UserPromptSubmit classifier
uses the tier and trigger phrases to inject LIGHT/MEDIUM/HEAVY routing priors.
The hook is the delivery mechanism; `request-router` is the doctrine. Both read
the same YAML; keep them in sync.

## Origin note

Prior to v3.0.0 the registry was maintained by a standalone tier-1 skill
(`trigger-indexer`). That skill was demoted to CI in the v3.0.0 consolidation:
registry drift is a repo invariant the build gate catches automatically, not a
session-time skill invocation. The procedure above absorbs the trigger-indexer
procedure. The registry schema reference at
`doctrine/skills/trigger-indexer/reference/registry-schema.md`
remains as a field-level reference.
