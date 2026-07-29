# agent-panel-planning: Cross-Feedback Template

Stage 3's structured cross-feedback. Each panelist writes one cross-feedback
block per OTHER plan reviewed. The template is the discipline that turns
plan-level critique into element-level signal.

The format is paired with the four-cell critique pattern from `agent-panel-review`
but adds an explicit voting block on decision points the operator surfaces.

---

## The block template (per plan reviewed)

```
CROSS-FEEDBACK ON [Panelist X]'s PLAN

Strongest claim:
  [The single most defensible move in this plan.
   Specific. Cite the section or decision.]

Weakest claim:
  [The single most vulnerable move.
   Name the vulnerability, not a vague worry.]

Shared blind spot:
  [Something this plan and yours both missed.
   The cell where the panel earns its cost.]

One thing worth stealing:
  [What you would adopt from this plan into yours.
   Concrete: a framing, a phrase, a structural move.]

Element-level votes:
  [Vote on each decision point the operator surfaced.
   Format below.]
```

---

## Element-level voting format

The operator surfaces 3-7 decision points during framing. Each panelist
votes on each, with one-line reasoning.

```
Decision points (per the operator's framing):

  D1  -  Title: "Compound AI" vs "Compounding AI Operating Standards"
       My vote: Compound AI.
       Reasoning: Cleaner noun-phrase; aligns with BAIR's published frame.

  D2  -  Structural spine: Codex's 5-layer vs Kiro's 6-part vs Claude's Part I-VI
       My vote: Codex's 5-layer.
       Reasoning: Most parsimonious; substance maps cleanly onto it.

  D3  -  Inclusion of attribution architecture as separate artifact
       My vote: include.
       Reasoning: The non-coercive provenance design is itself a contribution.

  D4  -  Audience layering inside one document
       My vote: drop (Cameron's framing supersedes).
       Reasoning: Medium-as-layer is sharper than within-doc layering.
```

**Rules:**
- One vote per decision point. No abstentions.
- One-line reasoning required. No bare votes.
- Reasoning may concede points to the agent whose proposal won the vote.

---

## What makes the format work

**One block per plan reviewed.** Each panelist writes 2 blocks (one per
other panelist) plus optionally a self-block. Total cross-feedback per
panel: 6-9 blocks.

**Element-level voting prevents plan-vs-plan tribalism.** Whole-plan
voting forces panelists to defend their own first pass. Element-level
voting lets them recognize specific wins by other plans without
surrendering their whole framing.

**The shared-blind-spot cell finds what no agent caught alone.** This
is the cell that justifies the panel's cost. Without it, three plans
each get critiqued for their individual weaknesses but no one names
the thing all three missed.

**The one-thing-to-steal cell wires the panel to actually adopt
others' work.** Without it, Stage 4 revisions stay parochial. With it,
Stage 4 revisions incorporate concrete moves from the other plans.

---

## Anti-patterns

### Anti-pattern: whole-plan voting
**Symptom.** Vote block reads "I vote for my own plan" or "I vote for
Codex's plan overall."
**Fix.** The operator's framing must surface specific decision points,
not whole plans. If the framing missed this, redo the framing before
Stage 3.

### Anti-pattern: critique without votes
**Symptom.** A panelist writes long prose critique but skips the voting
block.
**Fix.** Both halves are required. Critique surfaces signal; votes
surface convergence direction.

### Anti-pattern: votes without reasoning
**Symptom.** "D1: Compound AI. D2: Codex's spine. D3: include."
**Fix.** One-line reasoning per vote. The reasoning is the audit trail.
Without it, the vote is unaudited tribal preference.

### Anti-pattern: critiquing the agent
**Symptom.** "Codex's plan is weak on attribution architecture."
**Fix.** Critique the plan, not the producing agent. "This plan is weak
on attribution architecture." The work is the unit.

### Anti-pattern: cross-feedback as plan-rewrite
**Symptom.** The weakest-claim cell turns into a 200-word rewrite of
the other plan's section.
**Fix.** Cross-feedback surfaces; the producing agent revises at Stage 4.
The reviewer does not rewrite.

---

## What the operator does with cross-feedback

After Stage 3, the operator reads all 6-9 cross-feedback blocks before
sending them to the panelists for Stage 4. The operator's discipline:

1. Verify every block uses the template (reject any free-form
   submissions, ask for redo)
2. Verify the votes block is filled for every decision point
3. Tally the votes preliminarily (this becomes Stage 6's starting point)
4. Bundle each panelist's incoming cross-feedback (from the other two)
   and send to Stage 4

The operator does not edit cross-feedback. The operator enforces format.
