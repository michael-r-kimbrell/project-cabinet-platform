# Skill: pressure-test
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Adversarial review of a plan, idea, code change, strategy, or deliverable.
Combines executive operating lenses (the WHAT to evaluate) with structured
scope-mode discipline (the HOW to land on a verdict). Inspired by Garry Tan's
GSTACK plan-ceo-review for the scope-mode discipline.

Use when you want a rigorous critique that produces specific refinements,
not generic "consider X" advice. The output forces a verdict.

## Triggers

"pressure test", "pressure test this", "critique this", "rip this apart",
"stress test this idea", "stress test this plan", "rethink this",
"am I being ambitious enough", "is this 10x or 10%", "what would a CEO say",
"what's wrong with this", "tear this down", "find the holes"

## How to apply

1. **Identify what is being reviewed** (a plan, an idea, code, a deliverable, a strategy). If unclear, ask before proceeding.

2. **Load `reference/lenses.md`** and apply each lens. For every lens, produce:
   - Verdict: PASS / REVISE / FAIL
   - Evidence: one sentence explaining the verdict
   - Specific refinement: what changes if this lens fires

3. **Load `reference/scope-modes.md`** and recommend ONE of four scope modes:
   - **SCOPE EXPANSION**  -  dream bigger, this is too small to matter
   - **SELECTIVE EXPANSION**  -  hold the baseline, cherry-pick worthy expansions
   - **HOLD SCOPE**  -  scope is right, make it bulletproof
   - **SCOPE REDUCTION**  -  cut to minimum viable, kill the rest

4. **Load `reference/output-template.md`** and produce the structured verdict.

5. **Pair with `cross-domain-translation`** if the refined version needs to be re-encoded for a specific audience (board, engineering team, customer).

## What this skill does NOT do

- It does not produce generic advice ("consider feedback from users"). Every refinement is specific and actionable.
- It does not pull punches. If the right answer is "kill this," it says kill this.
- It does not require the user to specify a scope mode upfront. The skill recommends one.
- It does not score the work numerically. Verdicts are categorical (PASS / REVISE / FAIL per lens) and the scope mode is binding.

## Compound use

Often paired in sequence:

- **`parallel-lens-synthesis` → `pressure-test`**  -  generate options, then pressure-test the winner
- **`consequence-simulation` → `pressure-test`**  -  model outcomes, then pressure-test the planned action
- **`pressure-test` → `cross-domain-translation`**  -  pressure-test the plan, then re-encode for the audience that needs to hear it

## Source references

- `reference/lenses.md`  -  the 10 executive operating lenses (multiples, horses/cars, so-what, incentive map, iceberg, etc.)
- `reference/scope-modes.md`  -  the four-mode scope discipline borrowed from GSTACK
- `reference/output-template.md`  -  the structured verdict format

## Attribution

The four scope modes are borrowed from Garry Tan's GSTACK (`github.com/garrytan/gstack`, MIT licensed). The executive operating lenses are synthesized from canonical board-level operating discipline.
