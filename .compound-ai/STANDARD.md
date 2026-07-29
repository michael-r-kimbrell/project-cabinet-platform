# Compound AI Operating Standards
## The Six-Layer Standard

Version: v3.0.10
Authors: Cameron Sutcliff (cameronpsutcliff), Joshua Sutcliff (joshuadsutcliff)

---

Every capability in this kit lives in exactly one of six layers. A forker on a
bare laptop needs to understand only one rule: you may stop at any layer. The
layers below it still apply and the Standard still holds.

The first two layers are vendor-neutral and portable. The remaining layers add
mechanism: real adapters, real enforcement, proof, and tooling. The dependency
fence is enforced by `enforcement/bin/check-portability.sh`: no Python outside
`reference-impl/` and `team/`, no scripts in the portable `doctrine/` layer, and
no personal-data leak anywhere in the shipped surface of either edition.

---

## Layer 1 - Doctrine (portable, vendor-neutral)

**What:** Everything under `doctrine/`. Plain Markdown and YAML.

**Dependencies:** None. No Python, no Node, no Claude Code, no npm.

Includes:
- Tiered context model (`tiers/`: tier0 through tier3 discipline)
- The consolidated skills (`skills/`, merged Cameron + Josh, by tier)
- Verifiable finish-line primitives (`contracts/`: goal-contract, loop-spec)
- Conventions (`conventions/`: trigger-registry, file caps, skill-author rule)

This layer is advisory on its own: it describes what good operation is. Layers 2
and 3 turn the advice into a contract and then into mechanism.

---

## Layer 2 - Capabilities (runtime-agnostic)

**What:** Everything under `capabilities/`. Plain Markdown. The universal
capability model that lets any agent plug in.

**Dependencies:** None.

Each capability is defined once as a contract, an input and output shape, a
reference implementation, and a conformance test:
- `adapter-contract.md`: the shared `dispatch(task) -> result` interface and the
  capability hook order. Start here. Carries no runtime internals.
- `usage-discipline.md`: a tunable, fail-open spend and work ceiling.
- `session-routing.md`: LIGHT/MEDIUM/HEAVY tier classification.
- `goal-loop.md`: verifiable finish-line + budget ceiling + no-progress halt.

A runtime is conformant when the numbered tests (CT-AC-*, CT-UD-*, CT-SR-*,
CT-GL-*) pass. This is the only layer besides Doctrine that may be called
vendor-neutral.

---

## Layer 3 - Runtime adapters (real per-runtime mechanism)

**What:** Everything under `runtime/`. One subdirectory per agent runtime. None
privileged; every runtime gets a real adapter.

| Adapter | Mechanism | Enforcement |
|---|---|---|
| `claude-code/` | `PreToolUse` + `UserPromptSubmit` hooks, agents, commands | Full hard block |
| `codex/` | `AGENTS.md` directives + dispatch wrapper | Honor + wrapper checks |
| `cursor/` | rules file + dispatch wrapper | Honor + wrapper checks |
| `generic/` | prompt prelude + optional shell wrapper | Honor (graceful degradation) |

The Claude Code adapter is the richest because hooks let it hard-block: the
usage ceiling and tier router are mechanical, not promises. The generic adapter
is the fallback so a brand-new or GUI-only agent still gets the capabilities by
honor. The kit works with one agent and scales to N with no structural change.

Status: the enforced-runtime hooks (usage-guard, session-router) are vendored
under Apache-2.0, adapted from Joshua Sutcliff's public claude-config
(github.com/joshuadsutcliff), and credited in `runtime/claude-code/NOTICE`.

---

## Layer 4 - Enforcement (CI gates and self-test)

**What:** Everything under `enforcement/`. Small portable scripts: bash plus
python3.

Includes:
- `bin/`: the doctrine gates, orchestrated by `check-kit.sh`.
- `.github/workflows/`: CI.
- `tests/`: the planted-fixture self-test that proves the gates block real
  violations.
- `hooks/`: git hooks (pre-commit, post-session).

All gate thresholds live in `enforcement-rules.yaml` (single source of truth;
never duplicated in scripts).

---

## Layer 5 - Proof

**What:** Everything under `proof/`. Net-positive evidence.

Includes the session-start benchmark (a character-estimate ratio, a realistic single-tier
comparison plus a full-resident ceiling, pure shell, no metered API), delegation economics, and
loop-adoption evidence. The token counts are heuristic estimates (bytes / 4), so
the result is order-of-magnitude, not a model-exact byte count. The exact
current numbers are regenerated from the tree into
`proof/session-start-benchmark/results.md` (never hand-typed, so they cannot
drift); a reviewer can re-run `measure.sh` on a bare laptop and reproduce them.

---

## Layer 6 - Reference implementation and adoption

**What:** `reference-impl/` (maintainer Python tooling) and `adoption/` (the
drop-in adoption protocol).

`reference-impl/` is the only place Python lives: provenance verification,
manifest build, derive, and the skill-creator scaffold. It ships in both
editions: the verifiers (`verify-integrity.py`, `verify-origin.py`) are
stdlib-only and the docs tell adopters to run them, and the pattern code and
skill-creator are reference material. None of it is tier-0 loaded, so it does
not affect the lean session-start cost. The Individual zip stays lean by
omitting the canonical working docs, the derive tooling, and the Team org layer
(`team/`), not the reference tooling. `adoption/` carries `ADOPT.md`, the
installer, and `INSTALL.md`.

---

## The one rule for forkers

> "Everything under `doctrine/` and `capabilities/` is portable: plain Markdown
> and YAML, readable with no tools. `runtime/` holds the per-agent adapters,
> `enforcement/` holds the CI gates, `proof/` holds the evidence, and
> `reference-impl/` holds optional Python tooling. You may ignore the mechanical
> layers and the portable layers still apply."

---

## What the CI gates enforce

Eight gates orchestrated by `enforcement/bin/check-kit.sh` (thresholds in
`enforcement-rules.yaml`, the single source of truth):

| Gate script | Enforces |
|---|---|
| `enforcement/bin/check-line-caps.sh` | Pointer Markdown files at or under 100 lines |
| `enforcement/bin/check-tier-discipline.sh` | tier0 never references tier-2/tier-3 |
| `enforcement/bin/check-portability.sh` | No personal-data leaks anywhere in the shipped surface of either edition (including the Team-only `team/` and `derive/`); no .py outside reference-impl/ or team/; no scripts in doctrine/ |
| `enforcement/bin/check-counts.sh` | Skill count derived, never hand-typed; matches index and registry |
| `enforcement/bin/check-registry-coherence.sh` | Every registry pointer resolves and every SKILL.md is registered |
| `enforcement/bin/check-handoff-skills.sh` | HANDOFF.md lists the live Tier 1 skills, no stale or duplicate entries |
| `enforcement/bin/check-benchmark-figures.sh` | Benchmark figures live only in the generated results.md; headline docs never hand-type them |
| `enforcement/bin/check-runtime-wiring.sh` | settings.fragment.json wires all hook events with resolving paths and adapters |

Run them all with `enforcement/bin/check-kit.sh`. See `docs/known-limits.md` for
what is advisory rather than mechanically enforced.

---

## Version history

- v3.0.10 (2026-07-03): loop-governance contracts. The Loop Spec validator contract and
  heartbeat instrumentation doctrine (docs/loop-engineering.md), the agent-orchestration
  convention (doctrine/conventions/agent-orchestration.md), a content-sync of the legacy
  mirror distribution repo, and a bash-3.2 fix for the em-dash pre-commit hook.
- v3.0.9 (2026-07-02): fleet measurement. Part VIII Chapter 35 (Measuring the Fleet: DORA
  for agent dispatch), the fleet-measurement doctrine note, and the derived-not-typed
  doctrine note (published counts, versions, and metrics must be generated, loop-governed,
  or explicitly static-by-design).
- v3.0.8 (2026-07-02): enterprise translation. Part VIII Chapter 34 (The Enterprise
  Translation) and the mechanics-over-prose doctrine note (a rule is not shipped until it
  is a gate, a guard, or a derived artifact). Release verification now extracts built
  artifacts and scans them with a manifest-driven leak detector.
- v3.0.7 (2026-06-19): roster-accuracy pass, no doctrine change. The four skills
  retired in the v3.0.0 merge (context-loader and pattern-promoter folded into
  memory; provenance-check folded into release-captain's ship-gate provenance
  step; trigger-indexer demoted to the check-registry-coherence.sh CI invariant)
  were still listed as live and adoptable in the tier roster, the request-router
  recipes, the skill-author guide, and the adoption-captain reference templates.
  Those docs now reflect the real 12-skill Tier-1 roster and route each retired
  capability to its successor.
- v3.0.6 (2026-06-19): enforcement-coverage and honesty pass. The leak gate now
  scans the full shipped surface of BOTH editions (it previously scanned only the
  Individual surface, leaving the Team-only `team/` and `derive/` unscanned: the
  exact blind spot that let a private term reach the Team edition). A single
  `derive/always-skip.txt` is now the one source of truth for "ships to neither
  edition", read by both the derive and the gate so they cannot drift, with a
  planted-fixture self-test for the Team-surface coverage. A known-limits note on
  what the benchmark does and does not measure (context-loading cost, not
  multi-agent drift). No doctrine change.
- v3.0.5 (2026-06-19): runtime-reversibility, packaging-safety, and repo-hygiene
  pass, hardened by an adversarial pre-publication review. A settings-wiring
  integration test (assembles settings.json from the fragment, invokes the wired
  PreToolUse command, asserts the block), reversible installers (--dry-run and
  --uninstall) that now append rather than overwrite a user's existing hooks, a
  derive syntax gate plus a scrub fix so the shipped installer parses, removal of
  two private-deployment docs that were shipping in the Team edition, a leaner
  published root, and coherence fixes (reference-impl ships in both editions; a
  retired-skill reference corrected). No doctrine change.
- v3.0.4 (2026-06-19): impressiveness and depth pass. An enforcement-in-action
  proof (the hook shown blocking a real over-budget spawn), conformance cases
  (CT-AC/UD/SR/GL) executed in the self-test, README badges and an enforced-vs-
  advisory table under the hero, CONTRIBUTING/SECURITY/templates, a fixed
  goal-adapter false-positive plus a real iterating goal-loop, and the Team
  edition no longer publishing internal build-process docs. No doctrine change.
- v3.0.3 (2026-06-19): second-review close-out. A realistic middle baseline in
  the session-start benchmark (honest everyday ratio plus a labeled ceiling), an
  eighth gate (check-benchmark-figures) that forbids hand-typed benchmark figures
  in headline docs, the ARCHITECTURE stale-numbers fix, a corrected release date,
  and a repo description that states the enforcement scope. No doctrine change.
- v3.0.2 (2026-06-19): pre-publication hardening. An executive one-pager, a
  README that leads with the thesis (the headline figure is now generated, not
  hand-typed, so it cannot drift), real captured hook-block evidence in place of
  an illustration, clone-safe proof scripts, the CI workflow relocated to the
  repo root so it actually runs, a seventh gate documented, provenance pointed
  at a single canonical handle, and assorted version and reference fixes. No
  behavior change to the doctrine.
- v3.0.1 (2026-06-19): coherence and provenance remediation. Provenance
  verifiers now ship in both editions with a planted-fixture self-test; a
  HANDOFF roster gate, a deduped changelog, ccusage degradation docs, a
  session-router singular-term fix, a quick-recap convention, scripted
  installers, edition-specific zips, and an estimator-based reframing of the
  headline-multiplier and non-Claude enforcement claims. No behavior change to
  the doctrine.
- v3.0.0 (2026-06-19): co-owned consolidation. Six-layer architecture, the
  runtime-agnostic capability and adapter model, cross-repo skill-merge
  (memory, delegation, review), goal-parity, vendored runtime/claude-code hooks.
  SemVer-major signals a re-read-before-adopting boundary.
- v2.7.0: Cameron Sutcliff solo edition (CAOS), prose-only enforcement.
