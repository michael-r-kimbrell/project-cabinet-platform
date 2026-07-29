# Ultra Think: Deep Multi-Angle Analysis

When triggered:

1. **Read the framework**: `reference/ultra-think-framework.md` for the canonical seven lenses.

2. **Apply ALL seven lenses** before producing output. Do not compress; the value is in the process not just the conclusion.

   1. **First principles**: strip assumptions, what is actually true here
   2. **Inversion**: what would make this fail, worst-case scenario
   3. **Second-order effects**: what happens after the obvious consequence
   4. **Competing hypotheses**: 2-3 alternative explanations or approaches
   5. **Blind spots**: what someone who disagrees would point to
   6. **Constraints and trade-offs**: real costs (time, complexity, reversibility)
   7. **Synthesis**: clearest path forward and why

3. **Output structure**: show reasoning under each lens explicitly, then a clear recommendation. Mark uncertainty honestly.

4. **When triggered as a critic** (e.g. by `/pressure-test` or another skill calling for critique): focus on lenses 2 (inversion), 3 (second-order), and 5 (blind spots). Return a verdict (PASS / REVISE / FAIL) with one-paragraph rationale per lens.

## When to use

- Architecture decisions
- Strategic pivots or major product decisions
- Stakeholder engagement strategy or delivery approach
- Any situation where the first obvious answer feels too easy
- As a critic in a critique loop after another skill produces a deliverable

## Required upstream resources

- Tier `Project.md` for context on what is being decided
- Tier `_knowledge/decisions/` for prior decisions that constrain or inform

## Source materials

- `reference/ultra-think-framework.md`

Do NOT compress the seven-lens reasoning. The structure is the value.
