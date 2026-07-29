# parallel-lens-synthesis: Protocol

This protocol operationalizes the multi-lens reasoning pattern for questions where a single vantage point produces a systematically incomplete answer. The core discipline is sequencing: lenses must run to a full independent conclusion before any synthesis begins. The most common failure in ensemble reasoning is premature contamination -- a lens that reads another lens's draft and drifts toward it. This protocol makes that impossible by enforcing a hard separation between the generation and integration phases.

The protocol is not about generating options. It is about forcing genuine disagreement to the surface so synthesis starts from a richer position than any single thread provides.

---

## Step-by-step procedure

1. **Decompose into 2-4 lenses.** Name each lens before reasoning through any of them. Lens choice determines what you see; choosing well is half the work. Each lens must represent a genuinely different vantage point: a different epistemic stance (empiricist vs. theorist), a different role (operator vs. investor vs. adversary), a different time horizon (immediate vs. long-run), or a different domain (technical vs. commercial). Two lenses that would reach the same conclusion are not two lenses -- they are one lens named twice.

2. **Run each lens to a full conclusion before writing the next.** Within each lens, reason only from the assumptions that lens would use. A financial-analyst lens does not worry about user experience; a user-experience lens does not discount cash flows. Finish the reasoning for Lens 1 completely, including a 1-2 sentence finding, before starting Lens 2.

3. **List every disagreement explicitly.** After all lenses are complete, compare findings. Where two lenses reach contradictory conclusions, write the contradiction in plain language. Do not soften it. A sharp contradiction is the most valuable output of the whole exercise.

4. **Identify the axis of disagreement.** For each contradiction, determine what the lenses actually disagree about. Often it is a shared assumption, not a factual dispute. Name the assumption. This is the question the synthesis must resolve.

5. **Synthesize to a single defensible position.** Integrate lens findings into one conclusion. Where lenses agree, state the consensus directly. Where they disagreed, explain which finding was given more weight and why. The synthesis cannot split the difference on a genuine contradiction -- it must choose.

6. **State calibrated confidence.** Confidence is determined by how cleanly the synthesis resolved the disagreements. High confidence: all major contradictions were resolved with clear reasoning. Medium: one significant disagreement was set aside rather than resolved. Low: the lenses disagree on something foundational and the synthesis is a judgment call.

---

## Output template

```
LENS SYNTHESIS
Question: [one sentence -- the specific question being evaluated]
Lenses applied: [lens 1 name] | [lens 2 name] | [lens 3 name (if used)] | [lens 4 name (if used)]

---

Lens 1 -- [name]:
Assumption set: [what this lens takes for granted]
Reasoning: [2-5 sentences of lens-specific analysis]
Finding: [one sentence conclusion from this lens]

Lens 2 -- [name]:
Assumption set: [what this lens takes for granted]
Reasoning: [2-5 sentences of lens-specific analysis]
Finding: [one sentence conclusion from this lens]

[Lens 3 and 4 if used, same format]

---

Disagreements:
  - [Lens A] vs [Lens B]: [state the contradiction in one sentence]
    Axis: [what the disagreement is actually about]
  [or: none]

---

Synthesis: [integrated conclusion in 3-8 sentences, resolving disagreements by explicit choice]

Confidence: [high / medium / low]
  Rationale: [which disagreements were resolved cleanly and which were set aside]
```

---

## Worked example

**Question:** A B2B software company is deciding whether to add a self-serve free tier to its product, currently sold exclusively through an enterprise sales motion.

**Lens 1 -- Growth/acquisition:** Self-serve tiers generate top-of-funnel volume that enterprise sales teams cannot reach cost-effectively. If even 2% of free users convert to paid, the payback math is positive at scale. Finding: add the free tier.

**Lens 2 -- Revenue/unit economics:** Free tier requires infrastructure, support, and onboarding investment that is not offset by enterprise conversion rates at current deal sizes. The sales team will lose time qualifying accounts that were never enterprise candidates. Finding: do not add the free tier until average contract value increases enough to absorb the bleed.

**Lens 3 -- Competitive positioning:** Three of the top five competitors already have self-serve options. Absence of a free tier increases friction for evaluators who want to trial before involving procurement. Finding: the reputational cost of not having one is already being paid.

**Disagreements:**
- Lens 1 vs. Lens 2: whether conversion revenue from free users covers infrastructure cost at current ACV. Axis: a shared assumption about current ACV level and what it implies for conversion math.

**Synthesis:** The disagreement is not ideological; it is a break-even calculation. At current ACV, Lens 2 is correct that the unit economics do not work. But Lens 3's point about competitive friction is not captured in Lens 2's model. The defensible position is: implement a time-limited trial (not an unlimited free tier), which generates evaluator access without permanent infrastructure load, and revisit unlimited free only when ACV crosses the break-even threshold.

**Confidence:** Medium. The ACV threshold was not calculated -- it was named as the pivot. The synthesis holds directionally but requires a number to be fully defended.

---

## Anti-patterns

### Anti-pattern: Lens 2 reads Lens 1's finding before completing its own

**Symptom.** Lens 2's reasoning begins with "Building on Lens 1's point..." or directly references the earlier finding. The lenses cease to be independent.

**Fix.** Write each lens as if the others do not exist. Only after all findings are written does cross-lens comparison begin. If working in a single generation pass, explicitly suppress awareness of earlier lens outputs.

### Anti-pattern: Two lenses that are the same lens renamed

**Symptom.** "Optimistic lens" and "upside lens" reach the same conclusion through the same reasoning. The disagreement surface is zero.

**Fix.** Before reasoning through any lens, confirm that each chosen lens would, in principle, reach a different conclusion on the question at hand. If two lenses would agree by construction, replace one with a genuinely contrary vantage point: a skeptic, a short-seller, an end user, a regulator.

### Anti-pattern: Synthesis by averaging

**Symptom.** The synthesis paragraph says "both perspectives have merit" and recommends a middle path without explaining which disagreement was resolved and how.

**Fix.** Every synthesis must name the contradiction, state which lens finding was given more weight, and state why. Averaging is a non-answer. The whole point of surfacing disagreement is to force a resolution, not to report that disagreement exists.

### Anti-pattern: Confidence claimed but not earned

**Symptom.** The output reports "High confidence" after a synthesis that papered over an unresolved contradiction.

**Fix.** Confidence must be set by the quality of the resolution, not by how clean the final paragraph sounds. If a major disagreement was set aside rather than resolved, confidence is medium at most. Write the actual reason for the confidence level, not a summary.

### Anti-pattern: Too many lenses dilute the synthesis

**Symptom.** Five or six lenses are run, producing so many findings that synthesis becomes a summarization exercise rather than an integration exercise.

**Fix.** Hard cap at 4 lenses. If the question seems to require more vantage points, step back and ask whether the question is too broad. A well-scoped question can be meaningfully evaluated from 2-3 perspectives. More than 4 lenses usually means the question needs to be split.

---

## When to skip this skill

- The question has a clearly correct answer that does not depend on vantage point. Parallel lenses on "what does this error message mean" add nothing.
- The stakes of the decision are low enough that being wrong is cheap and reversible.
- Time constraints make multi-lens reasoning impractical and a single strong opinion is more useful than a slow synthesis.
- The question is factual rather than analytical. Lens synthesis applies to judgment calls, not to data retrieval.
