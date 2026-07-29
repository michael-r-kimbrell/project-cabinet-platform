# consequence-simulation: Protocol

This protocol operationalizes premortem and forward-simulation analysis for decisions where the cost of being surprised by outcomes is material. The core insight is that forward simulation and premortem analysis are not redundant -- they fail differently. Forward simulation misses tail risks that feel unlikely until they happen. Premortem catches them because it starts by assuming failure and works backward, which forces attention onto the mechanisms of failure rather than the probability of success.

Running both passes on the same decision produces an enumerated failure-mode map, ranked by detectability. That map is what distinguishes a decision that has been thought through from one that merely feels thought through.

---

## Step-by-step procedure

1. **Write the decision in one sentence.** Name what is being committed to: a plan, a recommendation, a system change, a message, a hire. The sentence must be specific enough that the simulation can trace consequences. "We should improve our process" does not simulate. "We should eliminate the manual review step in the intake workflow" does.

2. **Run the forward simulation.** Trace the most likely outcome chain at three horizons: immediate (within 24-72 hours of execution), medium-term (30-60 days), and long-term (3-6 months or the relevant planning horizon for this decision). Be concrete at each step. Name who does what, what changes in what system, and what stakeholder reaction occurs. Abstract forward simulations produce abstract recommendations.

3. **Run the premortem.** Set aside the forward simulation. Assume, as a given fact, that the decision has been executed and has failed badly. Write 3-5 sentences describing the failure as a post-mortem author would: what broke, who was affected, what the cost was. Then work backward: what was the earliest signal that something was wrong? At what point was the failure still preventable?

4. **Enumerate key assumptions.** The forward simulation and premortem both rest on assumptions. List every assumption that, if false, would materially change the outcome. Rank by sensitivity: high-sensitivity assumptions are ones where a modest change in the assumption produces a large change in the outcome.

5. **Generate the failure-mode map.** For each identified failure risk, produce three values: probability (high, medium, low), impact (high, medium, low), and detectability (yes the failure is detectable before becoming catastrophic / no it is not). Detectability is the most actionable dimension -- a high-probability, high-impact failure that is detectable early is manageable. The same failure that is undetectable is not.

6. **Issue a recommendation.** Choose one of three: proceed (forward simulation is sound and failure modes are manageable), modify (proceed with specific changes that address the highest-severity failure modes), pause (a high-sensitivity assumption has not been validated and the cost of being wrong is high). The recommendation must name the specific reason for the choice.

---

## Output template

```
CONSEQUENCE SIMULATION
Decision under evaluation: [one sentence -- specific, concrete, testable]

---

Forward simulation (most likely path):
  T+immediate: [what happens in the first 24-72 hours]
  T+30 days:   [what has stabilized or changed by day 30]
  T+6 months:  [where this decision puts the system/org/situation]

---

Premortem (assuming failure):
  The failure: [3-5 sentence description written as post-mortem]
  Root cause:  [mechanism that produced the failure]
  Earliest signal: [what was visible before it became catastrophic, and when]

---

Key assumptions (ranked by sensitivity):
  1. [assumption] -- sensitivity: [high / med / low]
     Why: [what changes if this assumption is false]
  2. [assumption] -- sensitivity: [high / med / low]
  [3-5 total]

---

Failure modes:
  1. [description] -- P:[high/med/low], I:[high/med/low], detectable:[yes/no]
  2. [description] -- P:[high/med/low], I:[high/med/low], detectable:[yes/no]
  [3-5 total]

---

Recommendation: [proceed / modify / pause]
  Rationale: [which forward-simulation finding and which failure mode drove this]
  If modify: [specific changes required before proceeding]
  If pause: [specific assumption to validate and how to validate it]
```

---

## Worked example

**Decision:** Migrate all customer-facing API traffic from the v1 endpoint to the v2 endpoint over a 48-hour cutover window starting next Monday.

**Forward simulation:**
- T+immediate: Traffic routing rules redirect to v2. v2 response times are logged and compared to v1 baseline. The on-call engineer monitors error rates.
- T+30 days: v1 endpoint is decommissioned. All integrations running against v1 have either migrated or received a deprecation notice. Support ticket volume returns to baseline.
- T+6 months: v2 is the only production surface. v1 debt is retired. Engineering team can begin planned v2 feature work that was blocked.

**Premortem:** The cutover completed on schedule. Two days later, a batch integration maintained by a partner team hit v2 with a payload format the team thought was handled by the compatibility layer -- it was not. The integration failed silently for 72 hours before anyone noticed. By the time the failure was caught, the partner had 3 days of corrupted data in their system. The compatibility layer had been tested against internal clients, not partner payloads.

- Root cause: incomplete coverage of the compatibility layer's input validation.
- Earliest signal: one test case in the staging suite used a slightly non-standard payload format that was manually flagged during QA review but not blocked by automation.

**Key assumptions:**
1. All integrations hitting v1 are known and documented -- high sensitivity. If false, unknown consumers hit a dead endpoint with no warning.
2. The v2 compatibility layer handles all payload variants currently in production -- high sensitivity. The premortem identified this as the actual risk.

**Failure modes:**
1. Undocumented integration hits dead v1 endpoint post-cutover -- P:medium, I:high, detectable:yes (returns 404, generates alert).
2. Compatibility layer rejects valid but non-standard payload format -- P:medium, I:high, detectable:no (fails silently for async consumers).

**Recommendation:** Modify. Proceed with the cutover after adding a shadow-mode logging pass on v1 for 5 days pre-cutover to enumerate actual traffic shapes. The compatibility layer must be validated against live traffic samples, not just known integrations.

---

## Anti-patterns

### Anti-pattern: Forward simulation that restates the plan

**Symptom.** T+immediate says "the migration proceeds as planned." T+30 days says "the team completes the work." Nothing is traced; the simulation is a rephrasing of the decision.

**Fix.** Forward simulation must name actors, systems, and observable changes at each horizon. If you cannot describe what someone sees differently after the decision executes, you have not simulated -- you have summarized.

### Anti-pattern: Premortem without a mechanism

**Symptom.** The premortem says "the project failed due to poor execution" or "the plan was not followed." It names the failure without explaining the causal chain.

**Fix.** The premortem must name a mechanism: what specific thing broke, in what sequence, and why that sequence was plausible. Abstract failure modes produce no useful design signal. "The compatibility layer was not tested against partner payloads" is a mechanism. "Execution was poor" is not.

### Anti-pattern: All failure modes rated low probability

**Symptom.** The failure-mode table lists five risks, all rated "P:low, I:low." The recommendation is "proceed" with no modifications.

**Fix.** If the premortem identified a plausible, concrete failure, at least one failure mode must reflect it. A premortem that produces no medium or high probability failure modes was not run honestly. Rate based on the premortem evidence, not on optimism.

### Anti-pattern: Recommendation does not follow from the map

**Symptom.** The failure-mode map includes a high-probability, high-impact, non-detectable failure. The recommendation is "proceed."

**Fix.** A non-detectable high-impact failure mode forces either "modify" (to add a detection mechanism) or "pause" (to validate the assumption that generates the failure). "Proceed" can only be chosen when the failure-mode map does not include undetectable high-impact risks.

### Anti-pattern: "Pause" as avoidance

**Symptom.** The recommendation is "pause" with a vague rationale like "more information is needed" and no specific validation to perform.

**Fix.** A pause recommendation must name the specific assumption to validate, the method for validating it, and a deadline. Pause without a validation plan is not risk management; it is postponement dressed as discipline.

---

## When to skip this skill

- The decision is easily reversible at low cost. If you can try it and undo it in an hour, premortem analysis costs more than being wrong.
- The decision surface is already well-understood from prior executions of the same type. Routine operational decisions do not need fresh forward simulation.
- The time available for analysis is shorter than the time required to run the protocol honestly. A compressed simulation is worse than a fast judgment.
- The failure modes are already enumerated by an external authority (a security audit, a legal review, a QA suite). Do not duplicate work that has been done rigorously elsewhere.
