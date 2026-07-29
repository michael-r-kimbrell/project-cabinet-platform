# trigger-indexer: Registry Schema

The trigger registry is YAML so agents can read it cheaply without loading the
full router prose.

## File

`doctrine/conventions/trigger-registry.yaml`

## Schema

```yaml
version: 1
kit_version: 3.0.10
generated_by: trigger-indexer
entries:
  - skill: goal-runner
    tier: 1
    pointer: doctrine/skills/goal-runner/SKILL.md
    mode: auto
    triggers:
      - keep going until
      - completion condition
    notes: Durable goal loop for substantial work.
```

## Fields

| Field | Required | Meaning |
|---|---|---|
| `skill` | yes | Directory name / skill id |
| `tier` | yes | 1, 2, or 3 |
| `pointer` | yes | Path to `SKILL.md` |
| `mode` | yes | `auto`, `offer`, `manual`, or `internal` |
| `triggers` | yes | Phrases or intent patterns |
| `notes` | no | One-line routing guidance |

## Modes

- `auto`: invoke when trigger clearly matches.
- `offer`: mention the skill and ask before invoking.
- `manual`: do not auto-invoke unless explicitly requested.
- `internal`: used by another skill, not usually user-triggered.

## Validation

After editing:

1. Count `find . -name SKILL.md`.
2. Count registry entries.
3. Confirm all `pointer` paths exist.
4. Confirm no skill is registered twice.
5. Confirm `_skills-index.md` count matches the registry.
