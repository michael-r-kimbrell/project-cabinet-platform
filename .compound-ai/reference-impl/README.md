# Reference Implementation (Layer C)

Optional Python and maintainer tooling for authors. Not required to adopt or apply
the Compound AI Operating Standards Doctrine.

**Version:** v3.0.10  
**Authors:** Cameron Sutcliff, Joshua Sutcliff (joshuadsutcliff)

## Contents

| Path | Purpose |
|---|---|
| `code/` | Reference pipeline patterns (`cache_key.py`, `schema_validator.py`, `pipeline_runs.sql`, `phase_wrapper.sh`) |
| `scripts/` | Provenance utilities (`build-manifest.py`, `verify-integrity.py`, `verify-origin.py`, `new-project.sh`) |
| `skill-creator/` | Interactive skill scaffolding tool (relocated from `doctrine/skills/skill-creator/` in v3.0.0) |

## Usage

From the `operating-standards/` root:

```bash
python3 reference-impl/scripts/verify-integrity.py
python3 reference-impl/scripts/verify-origin.py --online
python3 reference-impl/scripts/build-manifest.py
bash reference-impl/scripts/new-project.sh /path/to/project
```

The `skill-creator` skill pointer lives at
`doctrine/skills/skill-creator/SKILL.md`. Run its scripts from
`reference-impl/skill-creator/`.

## Packaging

Both edition zips include this directory. The verifiers
(`verify-integrity.py`, `verify-origin.py`) are stdlib-only and the docs tell
adopters to run them, and the pattern code and skill-creator are reference
material. None of it is tier-0 loaded, so it does not affect the lean
session-start cost. The Individual zip stays lean by omitting the canonical
working docs, the derive tooling, and the Team org layer instead. See
`STANDARD.md` and `derive/transform-rules.md`.
