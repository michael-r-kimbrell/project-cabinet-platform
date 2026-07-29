# Pressure-Test Output Template
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

The structured verdict format. Use this exact shape so users learn what to expect from the skill.

---

```
PRESSURE TEST
═══════════════════════════════════════════════════
Subject: [one-line description of what's being critiqued]
Context: [what the user is trying to accomplish]

───────────────────────────────────────────────────
LENS WALK
───────────────────────────────────────────────────

1. Multiples, not percentages
   Verdict: [PASS / REVISE / FAIL / N/A]
   Evidence: [one sentence  -  why this verdict]
   Refinement: [specific change if REVISE/FAIL]

2. Horses → Cars → Trains
   Verdict: [PASS / REVISE / FAIL / N/A]
   Evidence: [one sentence]
   Refinement: [specific change]

3. The So-What Test
   Verdict: [PASS / REVISE / FAIL / N/A]
   Evidence: [Named user? Named decision? Named follow-on?]
   Refinement: [what's missing]

4. Man + Machine = Multiples
   Verdict: [PASS / REVISE / FAIL / N/A]
   Evidence: [orchestrator? routed models? costed economics?]
   Refinement: [what's missing]

5. Incentive Awareness
   Verdict: [PASS / REVISE / FAIL / N/A]
   Evidence: [stakeholder incentives mapped?]
   Refinement: [missing incentive maps]

6. Rational Decisions for Rational Reasons
   Verdict: [PASS / REVISE / FAIL / N/A]
   Evidence: [manufactured urgency check]
   Refinement: [data the decision needs]

7. Hope Is Not a Strategy
   Verdict: [PASS / REVISE / FAIL / N/A]
   Evidence: [walk-away? BATNA? failure signal?]
   Refinement: [what to define before launch]

8. The Iceberg Test
   Verdict: [PASS / REVISE / FAIL / N/A]
   Evidence: [is this melting?]
   Refinement: [exit condition or alternative]

9. Chapters of Life
   Verdict: [PASS / REVISE / FAIL / N/A]
   Evidence: [current chapter or next?]
   Refinement: [what to anchor to next chapter]

10. Domain Ownership
    Verdict: [PASS / REVISE / FAIL / N/A]
    Evidence: [one mandate per component? structured I/O?]
    Refinement: [where roles overlap or drift]

───────────────────────────────────────────────────
SCOPE MODE RECOMMENDATION
───────────────────────────────────────────────────

Recommended mode: [SCOPE EXPANSION / SELECTIVE EXPANSION / HOLD SCOPE / SCOPE REDUCTION]

Why this mode: [one paragraph  -  which lens verdicts triggered this recommendation]

What this mode requires of you next:
  - [specific next action  -  depends on the mode]
  - [...]

───────────────────────────────────────────────────
SEQUENCED REFINEMENTS
───────────────────────────────────────────────────

In order of leverage (highest first):

1. [Refinement]  -  affects: [which lens / outcome]
2. [Refinement]  -  affects: [which lens / outcome]
3. [Refinement]  -  affects: [which lens / outcome]

───────────────────────────────────────────────────
OPEN QUESTION THAT COULD INVALIDATE THIS PLAN
───────────────────────────────────────────────────

[One question. The answer to this question is the most leverage-able input to whether the plan should proceed at all. Surface it explicitly so the user can answer before committing.]

───────────────────────────────────────────────────
PAIR-WITH SUGGESTIONS
───────────────────────────────────────────────────

[If applicable:]
  - cross-domain-translation  -  to re-encode the refined plan for [specific audience]
  - quality-gate  -  before shipping the refined version
  - simulation-to-action-bridge  -  to convert refinements into a sequenced action plan

═══════════════════════════════════════════════════
```

## Notes on writing the verdict

- **PASS** is allowed and should be used when the lens genuinely doesn't fire. Don't manufacture concerns.
- **N/A** is allowed for lenses that don't apply to the artifact (e.g. lens 4 for a marketing critique).
- **Refinement specificity** is the test of whether this skill is doing its job. "Consider the multiple" is not a refinement. "Reframe the multiple as 100 analyst-hours/week reclaimed and re-evaluate against 3x ambition" is a refinement.
- **The scope mode is binding.** Once recommended, the rest of the output should be consistent with it. Don't recommend HOLD SCOPE and then surface a half-dozen expansion ideas.
- **Sequence refinements by leverage**, not by lens order. The user wants to know which fix matters most.
