# Skill: release-captain
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Runs the ten-step ship gate on a candidate release. Either every check passes and the release ships, or any failure blocks the ship until fixed. The kit ships its own metabolism: this skill exists because v2.3.1 shipped with a verify-integrity failure that later patches had to correct. `release-captain` makes that class of failure mechanically catchable before the push, not after.

Tier 1 infrastructure skill. Required for any release that produces a public download or public-facing artifact.

## Triggers

"ship gate", "release captain", "is this ready to ship", "pre-release check", "verify the release", "run the ship gate", "release verification", "can we ship this"

## When to apply

Apply on EVERY release that produces:
- A new ZIP download for public consumption
- A public-facing markdown deliverable (field guide, release notes)
- A public-facing website version bump
- A new manifest or SHA256SUMS

Skip on non-release work: feature-branch experiments, draft documentation, internal-only changes that do not touch the public surface.

## The ten-step ship gate

Full procedure in `reference/checklist.md`. Each step has a pass/fail criterion; any failure blocks the ship.

1. **Clean unzip into /tmp.** Extract the candidate ZIP into a fresh directory; do not test against the local working copy.
2. **Run `scripts/verify-integrity.py`** in the extracted directory. Must return `local files match bundled manifest`.
3. **Run `scripts/verify-origin.py --online`.** Must return `VERIFIED` against the canonical website manifest.
4. **Confirm manifest version matches page version.** Public `manifest.json`, the ZIP's internal manifest, and the website hero badge must all agree.
5. **Confirm SHA256SUMS covers the current assets.** Every file in `public/compound-ai/` that should be checksummable must have a row.
6. **Confirm field guide UI badge matches markdown version.** Reader page badge must equal the filename of the loaded markdown.
7. **Confirm release-notes link points to the current release.** `releaseUrl` constant must resolve to the actual GitHub release tag.
8. **Confirm every public download returns 200.** ZIP, markdown, SHA256SUMS, manifest.json -- all 200 OK from production.
9. **Confirm `SKILL.md` files stay within line-count budget.** Each `SKILL.md` under 100 lines (target 80). Any file over budget blocks the ship.
10. **Screenshot the website and field guide.** Two screenshots: landing page hero + field guide reader. Stored alongside the release artifacts.

## Output

The skill produces a structured ship-gate report. Format in `reference/output-template.md`. The report lists each of the ten steps with pass/fail, evidence (command output, screenshot path, file path), and a final SHIP / BLOCK decision.

A BLOCK decision must name the failing step and the remediation. Operators do not override BLOCK silently; remediation is the only legitimate path forward.

## Verification protocol

Per-step procedure with the exact commands to run lives in `reference/verification-protocol.md`. Operators or operating agents can follow it without prior context.

## Anti-patterns

- **Skipping steps because they "should be fine."** The ship gate exists for the class of failure operators do not catch in self-review. v2.3.1 shipped with a verify-integrity failure because no one re-ran verify-integrity on a clean extract.
- **Running the gate on the local working copy.** The local copy has uncommitted state, unbundled files, and convenient pre-built artifacts. A clean unzip into /tmp is the only honest test.
- **Treating screenshots as optional.** Visual sanity checks catch what command-line checks miss (e.g. badge mismatches, broken styling, off-by-one stat numbers).
- **Approving a SHIP with a BLOCK pending remediation.** All ten steps must pass before SHIP. "Will fix after" is the path to v2.3.1-style failures.

## Pair with

- `agent-panel-review` -- if the release is also a deliverable that warrants editorial review, run the panel before running the ship gate
- `provenance-check` -- the verify-origin step inside the ship gate IS the provenance check; `release-captain` invokes it
- `quality-gate` -- generic deliverable quality before this skill's release-specific gate

## Reference files

- `reference/checklist.md` -- the ten steps in full with pass/fail criteria
- `reference/verification-protocol.md` -- exact commands and expected outputs per step
- `reference/output-template.md` -- ship-gate report format
- `reference/origin.md` -- pattern lineage; credits Codex's v2.3.1 critique that surfaced the need for this skill
