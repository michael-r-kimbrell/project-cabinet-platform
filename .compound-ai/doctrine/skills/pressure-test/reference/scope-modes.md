# Scope Modes
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0
# Borrowed from: Garry Tan's GSTACK (github.com/garrytan/gstack, MIT)

After applying the lenses (`lenses.md`), recommend ONE of four scope modes. The mode tells the user what to do next.

These four modes are borrowed from GSTACK's `plan-ceo-review` skill. The original is a richer interactive flow; this is the distilled decision framework.

---

## SCOPE EXPANSION  -  cathedral mode

> Envision the platonic ideal. Push scope UP.

**When to recommend:** The current plan is too small to matter. The lenses fire FAIL on Multiples or Horse/Car/Train. The work is technically sound but the ambition is the problem.

**Posture:** Recommend enthusiastically. You have permission to dream  -  every expansion proposal is the user's decision, presented individually as a question, but you should propose them. Ask "what would make this 10x better for 2x the effort?"

**Output:** A list of scope-expansion ideas, each one a discrete proposal with effort estimate and case. The user opts in or out per idea.

**Risk:** Over-expansion that the user can't actually execute. Mitigation: each proposal must include a realistic effort estimate.

---

## SELECTIVE EXPANSION  -  taste mode

> Hold the baseline. Cherry-pick worthy expansions.

**When to recommend:** The current scope is mostly right but there are 2-4 specific expansions that would meaningfully improve the outcome. The lenses fire REVISE on a few dimensions, not FAIL across the board.

**Posture:** Rigorous reviewer who also has taste. Hold the current scope as the baseline and make it bulletproof. Separately, surface every worthwhile expansion as a discrete decision for the user.

**Output:** The baseline-rigor critique (using HOLD SCOPE rigor for the agreed scope) PLUS a list of expansion opportunities, each individually opt-in.

**Risk:** Scope creep through accumulated "small" expansions. Mitigation: every accepted expansion becomes part of the plan and gets the same HOLD SCOPE rigor.

---

## HOLD SCOPE  -  bulletproof mode

> The plan's scope is accepted. Make it bulletproof.

**When to recommend:** Lenses fire mostly PASS. The work targets the right multiple, the audience is named, the BATNA exists. What's left is execution rigor: catch every failure mode, test every edge case, ensure observability, map every error path.

**Posture:** Rigorous reviewer. Do not silently reduce OR expand. Every concern is about whether the plan as-stated will hold under stress.

**Output:** A list of edge cases, failure modes, missing observability, weak error paths. Each is specific. Each ends with a "what to add" recommendation.

**Risk:** Pretending HOLD SCOPE when the right answer is EXPANSION or REDUCTION. Mitigation: only recommend HOLD SCOPE if the lenses genuinely fired PASS.

---

## SCOPE REDUCTION  -  surgeon mode

> Find the minimum viable version. Cut everything else.

**When to recommend:** The plan is overbuilt. Lenses fire FAIL on So-What (vague decision) or Domain Ownership (generalist roles overlapping). The work would land harder if half the scope was cut.

**Posture:** Surgeon. Be ruthless. Identify the core outcome the plan must achieve. Cut everything that doesn't directly serve that outcome.

**Output:** The minimum viable version of the plan, with explicit "NOT in scope" callouts for what was cut. Each cut comes with a one-sentence reason.

**Risk:** Cutting muscle, not fat. Mitigation: the core outcome must survive the cut intact. If the cut breaks the core, restore it.

---

## How to pick

Walk the lens verdicts (`lenses.md`):

| Lens verdict pattern | Recommended mode |
|---|---|
| Multiples FAIL or Horses/Cars FAIL | **SCOPE EXPANSION**  -  the ambition is the problem |
| Most PASS, 2-4 REVISE on specific dimensions | **SELECTIVE EXPANSION**  -  baseline is sound, opportunities exist |
| All PASS or near-all PASS | **HOLD SCOPE**  -  make it bulletproof |
| So-What FAIL or Domain Ownership FAIL | **SCOPE REDUCTION**  -  the plan is overbuilt |

When ambiguous, default to **HOLD SCOPE**. It's the least invasive mode and the safest recommendation when the right answer isn't obvious.

---

## Critical rule (from GSTACK)

> In ALL modes, the user is 100% in control.

Every scope change is an explicit opt-in. Never silently add or remove scope. Once the user selects a mode, COMMIT to it. Do not silently drift toward a different mode.

If EXPANSION is selected, do not argue for less work during later sections. If SELECTIVE EXPANSION is selected, surface expansions as individual decisions. If REDUCTION is selected, do not sneak scope back in.

Raise concerns once during the lens walk  -  after that, execute the chosen mode faithfully.
