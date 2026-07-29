# Map

Navigation map for Compound AI Operating Standards v3.0.10. Tier model lives in `_tiers.md`.

## Root files

| Path | Purpose |
|---|---|
| `README.md` | Public-facing intro |
| `AGENT.md` | Root operating contract |
| `STANDARD.md` | Six-layer operating model |
| `HANDOFF.md` | Drop-in prompt for handing the kit to a fresh agent |
| `adoption/ADOPT.md` | Existing-project adoption entry point |
| `adoption/INSTALL.md` | Multi-agent setup walkthrough |
| `CLAUDE.md` | 3-line pointer to AGENT.md (Claude Code convention) |
| `_tiers.md` | Context-loading tier model |
| `_skills-index.md` | Complete human skill registry |
| `_citations.md` | Attribution registry |
| `_map.md` | This file |
| `enforcement-rules.yaml` | Declarative CI gate and runtime policy contract |

## Layer 1: Doctrine (portable core)

| Path | Purpose |
|---|---|
| `doctrine/tiers/` | tier0/tier1 context, checklists, tier AGENT files |
| `doctrine/skills/` | All skills (tier 1 infrastructure, tier 2 capabilities, tier 3 shells) |
| `doctrine/contracts/` | goal-contract, loop-spec, and related templates |
| `doctrine/conventions/` | style-guide, token-efficiency, skill-author-guide, trigger-registry, session-log-format, quick-recap |

## Layer 2: Capabilities (runtime-agnostic)

| Path | Purpose |
|---|---|
| `capabilities/` | Universal capability contracts (CB-2) |

## Layer 3: Runtime adapters

| Path | Purpose |
|---|---|
| `runtime/claude-code/` | Full Claude Code hook enforcement |
| `runtime/codex/` | Codex adapter (CB-3) |
| `runtime/cursor/` | Cursor adapter (CB-3) |
| `runtime/generic/` | Graceful-degradation adapter (CB-3) |

## Layer 4: Enforcement

| Path | Purpose |
|---|---|
| `enforcement/bin/` | CI doctrine gates (`check-*.sh`, orchestrated by `check-kit.sh`) |
| `.github/workflows/` | CI workflows (repo root, so GitHub Actions triggers them) |
| `enforcement/tests/` | Planted-fixture self-test harness |
| `enforcement/hooks/` | Git hooks (pre-commit, post-session) |

## Layer 5: Proof

| Path | Purpose |
|---|---|
| `proof/` | session-start benchmark and net-positive evidence |

## Layer 6: Reference implementation and adoption

| Path | Purpose |
|---|---|
| `reference-impl/` | Maintainer Python tooling (provenance, build, derive) |
| `adoption/` | ADOPT.md, INSTALL.md, adoption protocol |

## Documentation

| Path | Purpose |
|---|---|
| `docs/ARCHITECTURE.md` | The six-layer architecture and the capability/adapter model |
| `docs/FIELD-GUIDE.md` | Field guide (lite panel chapters) |
| `docs/known-limits.md` | Known mechanical limits |

## Rule

Use this file for navigation. Do not overload `AGENT.md` with file listings.
