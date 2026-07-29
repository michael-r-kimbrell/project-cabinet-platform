# Releases

Release notes for the Compound AI Operating Standards kit. Newest first.

## v3.0.10 (2026-07-03)

Loop governance hardened into mechanical contracts; distribution repos re-synced.

### Added

- **Loop Spec validator contract** (`docs/loop-engineering.md`). A Loop Spec is no longer
  prose-only doctrine: a validator checks every spec against ten mandatory fields (Purpose,
  Origin, Runtime + Trigger, Inputs, Outputs, Mutation Policy, Failure Policy, Registry
  Entry, Verification, Invariants), with exact-match registry rules so a recurring
  fleet-jobs audit can pair every scheduled job with its spec.
- **Heartbeat instrumentation doctrine** (`docs/loop-engineering.md`). The scheduler-tier
  verification layer: failure-prone jobs run inside a heartbeat wrapper that records ground
  truth (pid, beat, real exit code, duration), and a periodic scan alerts on CRASHED,
  STALLED, or MISSED, the "never fired" case no other watcher catches.
- **Doctrine convention: agent orchestration and the subagent ladder**
  (`doctrine/conventions/agent-orchestration.md`). Which primitive to reach for (direct
  subagent, deterministic workflow, multi-model panel, delegation), instruction-tier
  precedence, and the context-scoping rules for spawned workers.

### Fixed

- **Legacy mirror content-sync.** The `compound-ai-operating-standards` mirror carried
  v3.0.7 content under v3.0.8 and v3.0.9 tags (only its tag and citation moved). All three
  distribution repos now ship the same tree from the same derive, and release verification
  fails on a content-stale mirror (README content-version check).
- **Em-dash pre-commit hook now works on stock macOS bash.** The hook matched U+2014 with
  an ANSI-C unicode escape that bash 3.2 does not support, so it silently matched nothing;
  it now matches the raw UTF-8 bytes, locale-independent.
- **STANDARD.md version history restored.** A blanket version substitution at v3.0.9
  rewrote the v3.0.7 roster-accuracy history entry as "v3.0.9"; real entries for v3.0.8
  and v3.0.9 are now present and the v3.0.7 entry is v3.0.7 again.
- **Per-file kit version headers re-synced.** The "Compound AI Operating Standards
  vX.Y.Z" header carried by every skill, reference doc, adoption doc, license, and
  shell had gone stale (v3.0.7, some v3.0.4) because release bumps only touched root
  files; all 42 stamped files now move with the release.

## v3.0.9 (2026-07-02)

Fleet measurement doctrine: DORA for agent dispatch.

### Added

- **Part VIII, Chapter 35: Measuring the Fleet.** The DORA metrics translated to agent
  dispatch (dispatch frequency, submit-to-terminal lead time, per-gate change-failure
  attribution with substitution rate, time to restore), the instrument-before-the-pilot
  rule, three instruments (chokepoint metrics, utilization ledger, lane health probes),
  and the honesty rules: printed sample sizes and derived-not-typed scorecards.
- **Doctrine: fleet measurement** (`docs/fleet-measurement.md`). The compact operating
  rule behind Chapter 35.
- **Doctrine: derived, not typed** (`docs/derived-not-typed.md`). Published counts,
  versions, and metrics must be generated, loop-governed, or explicitly static-by-design.

### Notes

- Consolidates the v3.0.8 additions (Chapter 34: The Enterprise Translation;
  mechanics-over-prose doctrine) into all distribution repos.

## v3.0.8 (2026-07-02)

New chapter plus enforcement-layer doctrine.

### Added

- **Part VIII, Chapter 34: The Enterprise Translation.** How the personal operating system maps
  function-by-function into an organization-owned cloud account: the substitution table, the turn
  chokepoint, fail-closed budgets, and what must be repriced honestly instead of translated.
- **Doctrine: mechanics over prose** (`docs/mechanics-over-prose.md`). A rule is not shipped until it is a
  gate, a guard, or a derived artifact; prose documents the rule, the mechanism enforces it. Includes the
  graduation rule and the mention-vs-use corollary.

### Fixed

- Release verification now extracts built artifacts and scans them with a manifest-driven leak detector
  before any release passes. The home-path detector allowlists the documented fixture convention.

## v3.0.7 (2026-06-19)

Roster-accuracy pass. No doctrine change.

### Fixed

- **Retired skills no longer presented as live.** The v3.0.0 skill-merge retired
  four Tier-1 skills (`context-loader` and `pattern-promoter` folded into
  `memory`; `provenance-check` folded into `release-captain`'s ship-gate
  provenance step; `trigger-indexer` demoted to the `check-registry-coherence.sh`
  CI invariant), but several docs still listed them as adoptable. The tier roster
  (`tier0.md`, `AGENT-tier1.md`), the `request-router` skill and its
  compound-request recipes, the skill-author guide example, and the
  `adoption-captain` reference templates (mapping rubric, adoption report,
  adoption plan, preserve map) now reflect the actual 12-skill Tier-1 roster and
  route each retired capability to its live successor.

### Changed

- **Portable example path in the release-verification walkthrough.** The
  `release-captain` verification protocol example used a maintainer-specific
  site path; it now uses a generic `/path/to/your-website/...` placeholder so
  the walkthrough is portable to any adopter.

## v3.0.6 (2026-06-19)

Enforcement-coverage and honesty pass. No doctrine change.

### Fixed

- **The leak gate now covers the full shipped surface.** `check-portability.sh`
  scoped its scan to the Individual edition surface (`include.txt` minus
  `exclude.txt`), so the Team-only `team/` and `derive/` directories shipped to
  the public Team edition were never leak-scanned. That is the exact blind spot
  that let a private term reach the Team edition in an earlier release. The gate
  now scans the union of what ships (both editions), with `team/` Python
  exempted from the dependency fence (the Team org layer carries an installer and
  a command-center tool). A planted-fixture self-test proves a leak in `team/` is
  now caught and guards the regression.

### Changed

- **One source of truth for "ships to neither edition."** A new
  `derive/always-skip.txt` lists the internal build-process and private-deployment
  docs that are dropped from both editions. `derive.sh` drops them and
  `check-portability.sh` excludes them from its scan by reading the same file, so
  the derive's drop set and the gate's scanned surface can no longer drift apart.
- **Benchmark scope stated plainly.** A known-limits note records what the
  session-start benchmark measures (context-loading cost, a character estimate)
  and what it does not (output quality, agent coherence, or multi-agent drift
  over a long engagement). The kit makes no claim about the latter.

## v3.0.5 (2026-06-19)

Runtime-reversibility, packaging-safety, and repo-hygiene pass. No doctrine
change. Hardened by an adversarial multi-lens pre-publication review.

### Added

- **Settings-wiring integration test.** The self-test previously called the
  hooks directly with stdin fixtures, which proves the hook logic but not that
  the Claude Code settings wiring invokes them. A new integration test
  (`enforcement/tests/settings-wiring-integration.sh`, wired into the self-test)
  assembles a real `settings.json` from `runtime/claude-code/settings.fragment.json`
  via the installer, extracts the exact wired `PreToolUse` command, and invokes
  THAT command with a realistic over-budget `Agent` spawn event, asserting a
  `block` (and that a compliant event passes). This closes the gap between "the
  hook returns block" and "the wired settings actually stop the call."
- **Reversible install.** `adoption/install.sh` and the Team installers
  (`install.sh`, `install.py`), plus `runtime/claude-code/install-adapter.sh`,
  gain `--dry-run` (print exactly what would be copied and which settings keys
  would be merged, change nothing) and `--uninstall` (back up settings before
  the first write and restore on uninstall; never delete kit files or user
  content the kit did not add). Both are documented in `adoption/INSTALL.md` and
  each installer `--help`.
- **Shipped-script syntax gate in the derive.** The derive step now runs
  `bash -n` over every shipped shell script and refuses to package a tree whose
  scripts do not parse, so an over-scrubbed or stale derive can never publish a
  non-parsing installer again.

### Fixed

- **The installer no longer ships broken.** The build-time scrub was deleting
  lines that referenced `~/.claude/settings.json` (it treated `.claude` as a
  private dotdir), which dropped a guard line and left the shipped
  `adoption/install.sh` with a shell syntax error even though the canonical
  source parsed cleanly. The scrub now allowlists the public agent-config
  dotdirs (`.claude`, `.codex`, `.gemini`, `.kiro`, `.compound-ai`, ...), and the
  new derive syntax gate backstops it.
- **Install no longer overwrites a user's existing hooks.** The Claude settings
  merge replaced each hook event wholesale; it now appends the kit's hook
  entries and never removes a user's own, deduped so re-install is idempotent.
  Uninstall restores from the pre-install backup, or removes only the kit's own
  entries when no backup exists. The "never deletes" promise is now literally
  true.
- **Two private-deployment docs were shipping in the Team edition.**
  `docs/derived-not-typed.md` and `docs/brief-standard.md` carried
  private-deployment specifics (a named private project, real scheduled-job
  labels, an internal pipeline). They are now dropped from BOTH editions
  alongside the other internal-process docs.
- **reference-impl packaging claims were stale.** Several docs (`STANDARD.md`,
  `docs/ARCHITECTURE.md`, `reference-impl/README.md`, `adoption/ADOPT.md`,
  `derive/transform-rules.md`, and an `exclude.txt` comment) still said
  `reference-impl/` is excluded from the Individual edition, but since v3.0.1 it
  ships in both editions so adopters can run the documented
  `verify-integrity.py` / `verify-origin.py` step. The prose now matches the
  build: the Individual zip stays lean by omitting the canonical working docs,
  `derive/`, and `team/`, not the reference tooling.
- **A retired skill was referenced as live.** `AGENT.md`, the canonical
  operating contract, told every agent to promote patterns via
  `pattern-promoter`, a skill retired into `memory`; it now points at the
  `memory` skill (preserve mode). The Field Guide's historical skill appendix is
  flagged as historical, with `_skills-index.md` named as the live roster.

### Changed

- **Leaner published root.** Internal working files (`BACKLOG.md`, `STATE.md`,
  `session-log.md`, `Project.md`) are no longer shipped in either edition; the
  published root carries only adopter-facing furniture. No doctrine or
  capability change. The decluttered files are now framed as project-local
  (created during adoption, read if present) in the agent contract and handoff
  template.
- Minor coherence fixes: the rules-schema `version` in `enforcement-rules.yaml`
  is labeled as independent of the kit release, and the provenance verifiers are
  referenced by full path in the adoption guide.

## v3.0.4 (2026-06-19)

Impressiveness and depth pass driven by a five-persona cold-reviewer panel (all
five would-star) plus runtime hardening. No doctrine change.

### Added

- **Enforcement-in-action proof.** `proof/enforcement-in-action/` runs the real
  `usage-guard` hook and shows it BLOCKING an over-budget conductor-model
  subagent spawn (exit 2, `decision: block`) and ALLOWING a compliant
  cheap-model spawn, with the exact before/after. The enforcement is no longer
  only a diagram.
- **Conformance is self-proving.** The self-test now executes the CT-AC, CT-UD,
  CT-SR, and CT-GL conformance cases against the generic, codex, and cursor
  adapters, so "any agent honors the contract" is tested, not asserted.
- **README status badges** (CI, release, license) and a "what is actually
  enforced" table under the hero, so the mechanism is legible in the first 30
  seconds. `CONTRIBUTING.md`, `SECURITY.md` (which doubles as the threat model),
  and issue / pull-request templates.

### Fixed

- **Goal-adapter false-positive.** `runtime/generic/dispatch.sh` evaluated a
  completion condition against the dispatch prompt with no agent run, returning
  a phantom `done`. It now evaluates only real agent output, halts when no agent
  ran, runs real bounded iterations, and reports the true iteration count with a
  no-progress halt.
- **Internal-process docs leak.** The Team edition was publishing build-process
  artifacts (`FINAL-REVIEW.md`, `HG-2-DEBATE.md`, `PUBLICATION-CHECKLIST.md`,
  `component-ledger.md`). These are now excluded from both editions.

### Changed

- Softened the "any agent, none privileged" framing to match `known-limits.md`
  (hard-enforced on Claude Code, contract-honored elsewhere). Sourced the
  18-of-22 incident in `docs/ENFORCEMENT-PROVENANCE.md`. Relabeled the Field
  Guide as the deep reference (not required to adopt) and dropped its draft tag.

## v3.0.3 (2026-06-19)

A second review pass (an external reviewer plus an internal multi-model panel)
converged on two open items; this closes them. No doctrine or behavior change.

### Added

- **A realistic benchmark baseline.** `proof/session-start-benchmark/measure.sh`
  now measures three sets, not two: full-resident (the ceiling), a realistic
  single-tier no-router bundle, and the kit's tier-0. It reports both the
  honest everyday ratio (realistic vs kit) and the upper-bound ceiling (naive vs
  kit), so the headline is no longer a best-vs-worst straw man. Numbers stay
  script-generated.
- **A benchmark-figures gate.** `enforcement/bin/check-benchmark-figures.sh`
  (the eighth gate, wired into `check-kit` with a planted-fixture self-test)
  fails if the headline docs hand-type a benchmark figure instead of pointing at
  the generated `results.md`. This enforces the kit's own derived-not-typed rule.

### Fixed

- **A derived-not-typed violation.** `docs/ARCHITECTURE.md` hand-typed stale
  benchmark counts that contradicted the regenerated `results.md`. The prose now
  points at `results.md` in every headline doc; no benchmark figure is
  hand-typed anywhere (the new gate guards this).
- **Release-date label.** The v3.0.0 changelog heading is corrected to its
  actual tag date (2026-06-19); a note records that the early v3.0.x releases are
  same-day pre-publication hardening passes, not instability.

### Changed

- **Repo description** reframed to state the enforcement scope (hard on Claude
  Code, advisory on other runtimes) instead of an unqualified "enforcement-backed."

## v3.0.2 (2026-06-19)

Pre-publication hardening from a multi-model review pass. No doctrine or
behavior change; this makes the kit hold up to a cold, skeptical clone.

### Added

- **EXECUTIVE.md**, a one-screen executive read at the repo root: the problem,
  the shift, what is enforced versus advisory, in business terms.

### Fixed

- **The CI now actually runs.** The enforce workflow lived under
  `enforcement/.github/`, a path GitHub Actions never triggers (zero runs ever).
  Relocated to the repo-root `.github/workflows/`; the gates, the self-test, and
  the fresh-clone simulation now run and pass on every push and PR.
- **The proof numbers cannot drift.** `proof/session-start-benchmark/measure.sh`
  now emits `results.md` itself, and the derive step regenerates it per edition,
  so the committed figure always matches the tree. The README no longer
  hand-types the ratio.
- **Real evidence replaced an illustration.** `proof/loop-spec-net-positive.md`
  now carries a captured `usage-guard` hook-block, not a mock labeled "shape
  only."
- **Clone-safe proof.** `proof/loop-adoption-evidence/measure.sh` exits cleanly
  on a fresh clone instead of erroring, and its results are labeled internal
  maintainer evidence rather than implying public reproducibility.
- **README leads with the thesis,** not a hedged metric; the empty install
  command block is fixed (a derive-scrub false positive on `.git` was eating
  it); a dead reference to `universal-skill-routing.md` in the Individual
  edition is resolved (the file now ships).
- **Honest counts.** HANDOFF.md is synced to the current version and no longer
  hand-types skill counts; the STANDARD gates table lists all seven gates.

### Changed

- **Provenance points to one canonical handle** (`github.com/joshuadsutcliff`);
  the prior secondary handle is removed throughout. Lineage `@origin` tags
  retain original history.
- Removed a redundant CI demo job; corrected the LICENSE summary to credit both
  authors.

## v3.0.1 (2026-06-19)

A coherence and provenance patch on the v3.0.0 co-owned release. No doctrine or
behavior change; this release makes the kit's own claims and tooling honest and
self-consistent for publication.

### Fixed

- **Provenance tooling now ships to adopters.** `reference-impl/scripts/verify-integrity.py`
  and `verify-origin.py` are stdlib-only and now ship in BOTH editions (they
  were excluded from the Individual tree while 15+ docs told adopters to run
  them). A planted-fixture self-test runs the verifier against the shipped
  manifest and asserts both a clean pass and a tamper-failure.
- **HANDOFF roster drift gate.** `HANDOFF.md` listed two retired skills as live
  Tier-1. The roster is corrected and a new `check-handoff-skills.sh` gate
  (wired into `check-kit`) blocks future drift between the roster and the
  registry. The Individual derive now also strips the Team-only `team-router`
  from the roster so the editions stay coherent.
- **Changelog dedupe.** `_skills-index.md` carried two overlapping change
  summaries with a contradictory skill count; collapsed to one authoritative
  block reconciled against the skills on disk.
- **ccusage degradation is documented.** The usage ceiling runs on character
  estimation when `ccusage` is absent (fail-open, zero metered spend). Install
  guidance and a known-limit entry now state this plainly.
- **session-router singular term.** A heavy-routing term matched only its
  plural form; routing now uses one term source with consistent substring
  matching, covered by a new fixture.

### Changed

- **Honesty pass.** The headline multiplier is reframed as an estimator-based,
  order-of-magnitude figure (no metered tokenizer read), and the docs state
  that hard-blocking enforcement is real on Claude Code while other runtimes
  honor the contract by prompt-prelude and wrapper (advisory, graceful
  degradation).
- **Scripted installers.** Cross-platform `install.sh` and `install.bat` for the
  Team edition (idiot-proof, mirror the reference Python installer) plus a lean
  `adoption/install.sh` for the Individual edition.
- **Quick-recap convention** added under `doctrine/conventions/`.
- **Edition-specific release zips** (`compound-ai-individual-vX.Y.Z.zip`,
  `compound-ai-team-vX.Y.Z.zip`); the two editions no longer overwrite one zip.
- **Denylist negative-space fix.** The shipped denylist files no longer carry a
  literal private workspace name; literal personal terms live only in the
  gitignored maintainer denylist, which the build-time scrub now also reads.

## v3.0.0 (2026-06-19)

Co-authored by **Cameron Sutcliff**
([cameronpsutcliff](https://github.com/cameronpsutcliff)) and **Joshua
Sutcliff** ([joshuadsutcliff](https://github.com/joshuadsutcliff)).

Version 3 is the co-owned merge of two complementary systems into one kit. It
is a SemVer-major release: re-read before adopting.

### Headline changes

- **Co-owned merge.** Cameron's solo edition contributed the portable doctrine,
  the tiered context model, and the skill library. Joshua's reference runtime
  contributed hook-level enforcement. The two systems are now one kit, owned by
  both authors, with cross-repo skills consolidated into unified named skills
  (`memory`, `delegation`, `review`) that sub-route by intent.

- **Enforced runtime adopted from the collaborator.** The Claude Code runtime
  vendored under `runtime/claude-code/` comes from Joshua's System B reference
  ([joshuadsutcliff](https://github.com/joshuadsutcliff)),
  hardened by a real multi-agent operating incident. It wires usage ceilings
  and tier routing to live `PreToolUse` and `UserPromptSubmit` hooks, so the
  discipline is a mechanical hard block, not a polite request.

- **Blocking CI gates.** Enforcement moved from prose to code. The gates under
  `enforcement/` block real violations, including a planted-fixture self-test
  that proves the checks fire. Run them with `enforcement/bin/check-kit.sh`.

- **Doctrine, capabilities, runtime architecture.** Shared behavior was lifted
  out of both systems into a runtime-agnostic capability model. Doctrine
  (`doctrine/`) is the portable core any agent honors. Capabilities
  (`capabilities/`) define the contracts every adapter must satisfy. Runtime
  adapters (`runtime/`) implement those contracts per agent, with none
  privileged: Claude Code hard-enforces through hooks while Codex, Cursor, and
  the generic adapter honor the same contract. The enforcement Joshua proved on
  one runtime is now a contract any agent can satisfy.

- **The session-start proof.** Loading the full operating reference at session
  start costs roughly two orders of magnitude more context than this kit loads,
  because the
  kit routes to one short procedure on demand instead of keeping the whole
  reference resident. The token counts are character estimates (bytes / 4), not
  a tokenizer count, so the figure is order-of-magnitude. No metered API and no
  model call: pure shell, reproducible on a bare laptop with
  `bash proof/session-start-benchmark/measure.sh`. The ratio is
  estimator-independent because both sets use the same divisor.

### Compatibility

SemVer-major signals a re-read-before-adopting boundary. The doctrine and
capability contracts apply with no runtime dependency. The enforced Claude Code
runtime is wired and ready: its hooks (usage-guard, session-router) are vendored
under Apache-2.0, adapted from Joshua Sutcliff's public claude-config
(github.com/joshuadsutcliff), and credited in `runtime/claude-code/NOTICE`.

### Attribution

`Compound AI Operating Standards by Cameron Sutcliff and Joshua Sutcliff`.
Documentation and data under CC BY 4.0, originally authored code and the
vendored enforced-runtime hooks under Apache 2.0. See `LICENSE` and `NOTICE`.

### Prior versions

- v2.7.0: Cameron Sutcliff solo edition (CAOS), prose-only enforcement.
