# Doctrine: mechanics over prose

Born: Fable-week diagnosis, 2026-07-02 (222 signals, 20 sessions). The controlled experiment inside that
data was unambiguous: every hook-enforced or script-verified rule (em-dash hook, project-index drift
sentinel, loop-spec verifier) stopped recurring the day it became mechanical; every prose-only rule
(Chrome profile, Finnhub, canonical path, delegation doctrine, "wired or it isn't done") kept failing no
matter how prominently it was documented.

## The rule

A rule is not shipped until it is one of:

1. **A gate** that blocks the wrong action (PreToolUse hook, pre-commit hook, CI check, exit-nonzero verifier).
2. **A guard** that injects the correction at the moment of relevance (context-injection hook, dispatch wrapper).
3. **A derived artifact** that makes the wrong claim impossible to type (generated schema docs, generated
   inventories; see derived-not-typed.md).

Prose (CLAUDE.md, universal-rules.md, MEMORY.md) is documentation OF the rule and its rationale, never the
enforcement. Write both: the prose says why, the mechanism says no.

## Corollaries

- **Graduation rule** (universal-rules.md): any correction the operator makes twice becomes an entry in
  `compound-ai/hooks/correction-guards.json`, not just a memory line.
- **The enforcement layer self-tests** (`compound-ai/bin/verify-enforcement-layer.sh`, Drift Sentinel
  check): a silently dead gate is worse than no gate.
- **Mention vs use**: pattern-matching gates cannot tell talking-about from doing (the correction-guard
  blocked its own test fixtures twice on day one). Accept the strictness; assemble test fixtures by
  concatenation; never weaken a gate to make meta-work convenient.
- **Verification is a mechanism too**: "verify before claiming" ships as the wire-check skill's GO/NO-GO
  artifact, py_compile-plus-run (never ast alone), and second-model adversarial review.
