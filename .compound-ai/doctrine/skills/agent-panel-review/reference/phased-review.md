# Mode: phased-review (spec-drift review harness)

An automated, usage-gated review of a codebase or document set against a spec or
PRD, looking for drift, gaps, and correctness issues. This is the lite, portable
description of the method. The runnable Claude Code workflow ships at
`runtime/claude-code/workflows/phased-review.js`; any runtime can follow the same
five phases by hand or in its own orchestrator.

## When to use

- You have a spec, PRD, or contract, and an implementation to check against it.
- The surface is too large for one pass and benefits from parallel auditing.
- Not for daily code review or single-answer questions; use panel-review or a
  plain review for those.

## The five phases

1. **Contract.** Distill the spec into a numbered checklist of independently
   verifiable requirements, grouped by category (auth, api, data, ...).
2. **Baseline.** Review git log, TODO/FIXME comments, and known-issues docs to
   list already-known issues (so auditors do not re-report them) and to suggest
   audit surfaces.
3. **Audit.** For each surface, one auditor reports every genuine spec-versus-
   implementation gap or correctness bug, with `file:line` and a contract
   reference. Do not filter at this stage; filtering happens in verify.
4. **Verify.** One batched verifier per surface argues the KEEP case for each
   finding (why it might be wrong or not worth fixing), checks git history for
   why the code exists, then decides real or not and an action: delete, collapse,
   rewrite, or note.
5. **Synthesis.** Rank confirmed findings: DELETE (remove) over COLLAPSE (merge or
   simplify) over REWRITE (substantial fix) over NOTES (low-confidence). Score
   each by impact times ease. End with counts: confirmed, dropped, unverified
   overflow, unaudited surfaces.

## Hard caps (keep it cheap and bounded)

- At most 5 surfaces; at most 4 findings verified per surface.
- Audit in waves of 3 surfaces; at most about 25 total work agents.
- All work agents run on cheap or mid tiers, never the conductor tier.
- A usage gate checks the spend ceiling before each wave and before synthesis; at
  the cap, halt and return partial state (unaudited surfaces, unverified overflow,
  confirmed findings so far). Resume from where it halted.

## The discipline that makes it work

- **Adversarial verify, not confirmation.** The verifier's job is to argue
  against each finding first. A finding survives only if it still holds.
- **The conductor reviews the report; it does not run inside the harness.** The
  orchestrating model reads the ranked output and decides what to act on.
- This is the same no-ego, verify-before-you-trust discipline as panel-review,
  applied to a spec instead of a deliverable.
