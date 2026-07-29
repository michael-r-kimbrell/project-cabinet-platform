# release-captain: Origin and Attribution

## Pattern lineage

The `release-captain` skill was added in v2.4.0 in direct response to
Codex's structured critique of v2.3.1[^panel-coordination-v1]. The v2.3.1
release shipped with a verify-integrity failure (the ZIP build had deleted
historical release notes the manifest expected), a stale public manifest
(`manifest.json` still reported v1.0.0), a hardcoded v1.0.0 version badge
in the field guide reader, and several `SKILL.md` files over the kit's
own 80-line pointer-file budget.

Codex's critique surfaced all five failures as P0/P1 findings and
explicitly recommended the next high-value pattern:

> "I would not add another reasoning skill next. The next high-value
> move is a release-captain or ship-gate skill. [...] This is the kit
> shipping its own metabolism."

v2.3.2 fixed the five issues directly. v2.4.0 ships the
`release-captain` skill so this class of failure is mechanically
catchable on every future release.

## The ten-step gate

The ten steps are Codex's prescription, taken verbatim from the v2.3.1
critique:

1. Clean unzip into /tmp
2. Run `scripts/verify-integrity.py`
3. Run `scripts/verify-origin.py --online`
4. Confirm manifest version matches page version
5. Confirm SHA256SUMS covers the current assets
6. Confirm field guide UI badge matches markdown version
7. Confirm release notes link points to the current release
8. Confirm every public download returns 200
9. Confirm `SKILL.md` files stay within the line-count budget
10. Screenshot the website and field guide

The kit's contribution is operationalizing the gate as a Tier 1 skill
with structured output, anti-pattern catalog, and integration with the
request-router so it can be invoked on any release-relevant request.

## Why this skill is Tier 1

`release-captain` sits above any specific deliverable. It checks the
deliverable AND the surrounding metadata (manifests, version labels,
public artifacts). That cross-cutting scope is the Tier 1 signature.

Pairs with `agent-panel-review` (editorial review of the deliverable
itself) and `quality-gate` (generic deliverable quality). The three
form a release pipeline: panel-review for content quality, quality-gate
for output discipline, release-captain for shipping discipline.

## What this skill is NOT

Not a CI/CD system. Not a replacement for testing. Not an automated
release script. It is a **discipline checklist** operationalized as an
agent skill, executable by either a human operator or an AI agent
following the verification protocol.

The kit could automate every step with a shell script. The choice not
to: the skill should be runnable by an agent without infrastructure
dependencies. A human or agent reading `SKILL.md` and the references
can run the gate manually on any release.

## How this skill should be cited

When a release passes the gate, cite it in the release commit message:

> Ship-gate report: PASS (release-captain skill, 10/10).

When a release fails the gate, cite which step:

> Ship-gate report: BLOCK at step N (release-captain skill). See
> [path to report] for remediation.

## Recognition

This skill exists because Codex named the gap. The kit's own panel-
review pattern produced its own correction; the structured cross-
feedback in the review working folder is the provenance.
