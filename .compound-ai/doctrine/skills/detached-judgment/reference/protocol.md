# detached-judgment: Protocol

This protocol operationalizes evidence-based confidence calibration for situations where the analyst, the decision-maker, or both have a stake in the outcome. Sunk-cost distortion, motivated reasoning, and advocacy bias are not character flaws -- they are predictable features of anyone who has invested effort or identity into a position. This protocol does not fix the psychology; it creates a structured process that produces outputs which can survive scrutiny even when the analyst is not neutral.

The key discipline is separation: the claim is written before evidence is gathered, and the strongest opposing case is constructed before confidence is assigned. A protocol that allows the opposing case to be built after confidence is assigned will produce a weaker opposing case every time.

---

## Step-by-step procedure

1. **State the claim in isolation.** Write the claim in a single sentence before reviewing or listing any evidence. The claim must be specific enough that someone could disagree with it on evidence. "The product has quality issues" does not pass. "The product's error rate exceeds the industry median by more than 2x" passes. Writing the claim first prevents the evidence from shaping the claim's framing.

2. **List all evidence independently.** Write every piece of evidence you have access to -- supporting and opposing -- before assigning quality ratings to any of it. List them as observations, not as arguments. "Error rate in Q3 was 4.7%" is evidence. "Error rate is concerningly high" is an argument.

3. **Assess evidence quality on three dimensions.** For each piece of evidence, rate: (a) directness -- is this a direct measure of the claim or an indirect proxy? (b) recency -- is this current or dated? A 2-year-old data point about a fast-moving market is low quality regardless of its precision. (c) source independence -- does the evidence come from a party with a stake in the conclusion? Testimony from an interested party is not worthless, but it is not independent.

4. **Construct the strongest opposing case.** Write the best argument against the claim using the evidence available. The opposing case must use real evidence -- it cannot rely on hypothetical counter-evidence that does not exist. It must be written as someone who actually believes the opposite would write it. Apply the same test as nod-protocol Gate 2: would a thoughtful believer in the opposing position sign this paragraph?

5. **Check the base rate.** Before assigning confidence, ask: in comparable situations of this type, how often does this kind of claim hold? This is the prior. The base rate check often reveals that a specific, compelling case for X is still wrong 70% of the time if the base rate for X is low. Identify the reference class and the base rate as explicitly as possible.

6. **Assign calibrated confidence.** Confidence is a function of three inputs: how much high-quality supporting evidence survives after opposing evidence is weighed, how strong the opposing case is relative to the supporting case, and what the base rate implies about the prior probability. High confidence requires that high-quality direct evidence outweighs the opposing case and that the base rate is compatible with the claim. State the specific reason for the confidence level.

---

## Output template

```
DETACHED JUDGMENT
Claim: [one sentence -- written before evidence review]

---

Evidence inventory:
  Supporting:
    [evidence item] -- direct/proxy: [direct/proxy], recency: [current/dated], source: [independent/interested]
    [evidence item] -- [same three-field format]
    ...
  Opposing:
    [evidence item] -- direct/proxy: [direct/proxy], recency: [current/dated], source: [independent/interested]
    ...

---

Evidence quality summary:
  High-quality supporting: [count and brief characterization]
  High-quality opposing: [count and brief characterization]
  Quality gap: [which side has better-quality evidence and why]

---

Strongest opposing case:
  [3-5 sentences written as a believer in the opposing position would write them.
  Must reference specific evidence from the inventory above.]

---

Base rate check:
  Reference class: [what type of situation this belongs to]
  Base rate: [how often this type of claim holds in comparable situations]
  Source: [how the base rate was estimated -- industry data, prior experience, analogy]

---

Calibrated confidence: [high / medium / low]
  Rationale: [explicitly: what evidence quality gap drove this, what the opposing case's strength was,
  and whether the base rate supports or undermines the claim]

---

Recommendation: [statement with explicit uncertainty acknowledgment]
  What would change this: [specific evidence that would shift confidence up or down]
```

---

## Worked example

**Claim:** The new sales process change increased qualified pipeline by more than what the seasonal pattern would predict.

**Evidence inventory:**

Supporting:
- Pipeline volume in weeks 1-4 post-change was 38% above the same period last year -- direct, current, from CRM (independent system).
- Sales team reported higher call connection rates -- proxy (self-reported), current, interested source.
- Conversion from first contact to qualified lead improved from 12% to 17% -- direct, current, independent.

Opposing:
- The prior year period overlapped with a competitor's product recall, which inflated the comparison baseline -- direct, current, from market data (independent).
- Seasonal uplift in this segment averages 22-31% in Q1 -- direct, historical, from industry report (independent).

**Evidence quality summary:**
- High-quality supporting: 2 direct, current, independent data points.
- High-quality opposing: 2 direct, independent data points. The seasonal baseline opposing evidence is particularly strong because it directly reframes the supporting evidence.
- Quality gap: roughly even. The opposing case explains a meaningful portion of the observed uplift.

**Strongest opposing case:** "The 38% pipeline increase looks like process performance but is partially or fully explained by two confounds. The Q1 seasonal pattern for this segment produces 22-31% baseline uplift without any process change. The comparison period last year was suppressed by a competitor event, making the year-over-year figure an inflated comparison. After adjusting for both, the incremental lift attributable to the process change may be near zero."

**Base rate check:** Reference class: B2B sales process changes implemented without A/B testing. Base rate for detecting statistically meaningful improvement in pipeline that survives confound adjustment: roughly 30-40% in published sales operations literature. Most changes that appear to work in before/after analysis do not hold after seasonal adjustment.

**Calibrated confidence:** Low. The opposing case accounts for most of the observed improvement through known confounds. The base rate for uncontrolled before/after process changes is unfavorable. The supporting evidence is real but its magnitude is within the range explained by the opposing case.

**Recommendation:** Do not attribute the pipeline increase to the process change until a controlled period or seasonal-adjusted comparison is available. Continue the process change but do not deprioritize other pipeline initiatives based on this data.

**What would change this:** A seasonal-adjusted, competitor-controlled comparison showing the uplift exceeds the seasonal baseline would upgrade confidence to medium or high.

---

## Anti-patterns

### Anti-pattern: Opposing case built from hypotheticals

**Symptom.** The strongest opposing case reads: "One could argue that..." or "It is possible that..." with no reference to actual evidence in the inventory. The opposition is speculative.

**Fix.** The opposing case must use evidence from the inventory. If the inventory contains no opposing evidence, that is itself a finding -- and it may mean the claim has not been seriously tested yet, not that it is correct. Add a note that no opposing evidence was found and flag the gap.

### Anti-pattern: Confidence assigned before the opposing case is written

**Symptom.** The output reads "Confidence: high" in the evidence quality section, before the opposing case is constructed. The opposing case then looks like it was written to justify the confidence rather than to challenge it.

**Fix.** Confidence is assigned last, after the opposing case and base rate check are complete. If you have already formed a confidence impression, write it down as a "pre-check confidence" and then explicitly compare it to the post-check conclusion. If they match, no problem. If the opposing case revised your view, that revision is the finding.

### Anti-pattern: Source independence conflated with source credibility

**Symptom.** An internal team's self-report is rated "high quality" because the team is credible. The rating ignores that the team has a stake in the conclusion.

**Fix.** Evidence quality ratings are not character judgments. An interested-source report can be accurate, but it is not independent, and independence is a quality dimension that must be tracked separately. A credible source with a stake in the outcome is rated "interested" regardless of credibility.

### Anti-pattern: Base rate check is skipped when the claim feels strong

**Symptom.** The evidence is compelling, the opposing case is weak, and the base rate check is listed as "not applicable" or simply omitted because the conclusion already feels clear.

**Fix.** The base rate check is mandatory regardless of evidence quality. A compelling specific case is still subject to the base rate prior. If the base rate is unavailable, estimate it with a reference class and note the uncertainty. "I do not know the base rate" is an acceptable answer; skipping the check is not.

### Anti-pattern: Recommendation does not acknowledge uncertainty

**Symptom.** The confidence level is "medium" but the recommendation is phrased as "the evidence clearly shows we should X." The confidence rating and the recommendation language are inconsistent.

**Fix.** Recommendation language must match the confidence level. Medium confidence produces a recommendation with explicit conditions: "if the seasonal-adjusted comparison confirms the uplift, then X; if not, then Y." High confidence still acknowledges what would change the judgment.

---

## When to skip this skill

- The analyst has no stake in the outcome and the evidence is straightforward. Detached judgment protocols add overhead that is only worth it when bias risk is real.
- The decision is time-critical and acting on imperfect evidence is better than delaying for a calibration exercise. Fast judgment calls are sometimes correct tradeoffs.
- The claim is not empirical -- it is a values judgment or a strategic priority where evidence calibration is not the relevant frame.
- The evidence base is too thin to support any calibration at all. Three data points in a volatile domain produce a calibrated confidence interval of "low" by construction; running the full protocol adds no signal.
