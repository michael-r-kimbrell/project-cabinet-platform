# cross-domain-translation: Protocol

This protocol operationalizes register-shifting for situations where the same analytical content must reach an audience whose vocabulary, decision frame, and fluency differ from the source. The invariant is the underlying claim: what is true, what the evidence supports, and what the recommended action is. Every surface element is up for replacement. The discipline here is to confirm, before starting the translation, that you have correctly extracted the invariant -- because the most common failure is to accidentally translate the claim itself, not just its packaging.

This protocol is applied after the analysis exists. It does not generate new reasoning. It encodes existing reasoning into a form the target audience can receive and act on.

---

## Step-by-step procedure

1. **Identify the source register.** Before touching the content, characterize what the existing material assumes about its reader: their vocabulary, their abstraction level, their decision authority, and the questions they are trying to answer. Technical registers assume domain knowledge and focus on mechanism. Executive registers assume operational context and focus on consequence. Academic registers assume methodological rigor and focus on validity. Operational registers assume process familiarity and focus on action steps.

2. **Write the core claim in one sentence.** Extract the single claim the source material is making. Not the background, not the caveats, not the methodology -- the claim. This sentence is the invariant that the translation must preserve. If you cannot extract the core claim in one sentence, the source material may not have one, and the translation work cannot proceed until it does.

3. **Profile the target audience.** Answer four questions about the target reader: (a) What decisions do they make? (b) What vocabulary signals credibility to them? (c) What is their prior knowledge of this domain? (d) What would they need to change their behavior? Answers to these four questions determine every translation choice.

4. **Map vocabulary swaps.** List the domain-specific terms in the source and their target-register equivalents. Terms without equivalents must be either explained (if keeping them is necessary for fidelity) or replaced with an analogy that preserves the functional meaning. Do not skip this step -- untranslated jargon is the most common reason a good analysis fails to land.

5. **Translate the surface.** Rewrite the content for the target audience, replacing vocabulary per the map, adjusting abstraction level to match what the audience can act on, and replacing technical causality with business or operational consequence. The translated version should not contain terms from the vocabulary map's left column.

6. **Verify fidelity.** After translating, place the core claim from Step 2 next to the translated version and ask: does the translated version, if read by the target audience, support the same decision as the original? If the translated version could lead a reasonable reader to a different conclusion, the translation has lost something. Revise until the decision supported is identical.

---

## Output template

```
CROSS-DOMAIN TRANSLATION

Source register:  [technical / academic / operational / executive / other]
Target register:  [same options]

Core claim (invariant): [one sentence -- do not modify this line during translation]

---

Audience profile:
  Decisions they make: [what authority or role this audience holds]
  Credibility vocabulary: [2-4 terms that signal competence to them]
  Prior knowledge: [what they already know about the domain]
  Behavior change needed: [what the translation must move them to do or believe]

---

Vocabulary map:
  [source term] -> [target term or analogy]
  [source term] -> [target term or analogy]
  [add as many as needed]

---

Translation:
[Full translated content here. This section should stand alone --
a reader who has not seen the source should be able to act on this.]

---

Fidelity check:
  Core claim preserved: [yes / no -- if no, describe what was lost and revise]
  Decision supported matches original: [yes / no]
  Untranslated jargon remaining: [list or "none"]
```

---

## Worked example

**Source material (technical register):** "The P99 latency on the ingest pipeline has degraded from 340ms to 1,100ms over the past two weeks. The degradation correlates with a 4x increase in batch job concurrency introduced in the 2.7 release. Thread contention on the shared database connection pool is the likely root cause. Without remediation, we estimate throughput will degrade by 60% under Monday's projected load."

**Core claim (invariant):** Without a fix deployed before Monday, the data pipeline will fail under expected load.

**Target audience:** A product director who approves engineering prioritization decisions but does not read code.

**Audience profile:**
- Decisions they make: whether to reprioritize sprint work to unblock an emergency fix.
- Credibility vocabulary: "customer impact," "revenue risk," "SLA," "deployment."
- Prior knowledge: knows the product exists, knows the pipeline feeds customer-facing reports, does not know what P99 latency means.
- Behavior change needed: approve engineering team pulling two engineers off sprint work to ship a hotfix today.

**Vocabulary map:**
- P99 latency -> slowest response times experienced by customers
- Ingest pipeline -> the process that loads customer data into the reporting system
- Thread contention / connection pool -> a resource bottleneck introduced in the last software update
- Throughput degradation -> reports fail to generate within the promised window

**Translation:** "A software update shipped two weeks ago is causing the data loading process to slow down. At current trajectory, it will not finish within our promised window under Monday's data volume, which means customer reports will be delayed or missing. We have identified the cause and can deploy a fix -- but it requires two engineers to pull off their current work today. If we do not fix this before Monday, customers will see failures."

**Fidelity check:** The translated version supports the same decision (approve the emergency reprioritization) as the technical original. No jargon remains. The core claim is preserved.

---

## Anti-patterns

### Anti-pattern: Translating the claim, not just the surface

**Symptom.** The technical source says "the system will fail under Monday's load with 95% confidence." The executive translation says "there are some performance concerns we are monitoring." The claim has been weakened from a prediction to a concern.

**Fix.** Write the core claim before translating. After translating, compare the translated version to the original claim. If the translated version is softer, more uncertain, or more hedged than the original, the translation has introduced distortion. Restore the original claim's force.

### Anti-pattern: Using source vocabulary in the translation

**Symptom.** The "executive summary" still contains terms like "P99," "connection pool," or "thread contention" without explanation. The audience cannot decode these terms, and the translation fails to land.

**Fix.** Run the vocabulary map before writing the translation. Every term on the map's left column is forbidden in the translated output unless explicitly explained inline.

### Anti-pattern: Audience profile is generic

**Symptom.** The audience is profiled as "non-technical people" or "executives" without specifying what decisions they make or what vocabulary signals credibility to them. The translation addresses a category, not a reader.

**Fix.** Profile the audience using the four questions in Step 3. "Non-technical" tells you nothing about what they need to decide or what they already know. A VP of Sales and a CFO are both non-technical but require completely different translations of the same engineering finding.

### Anti-pattern: Fidelity check skipped

**Symptom.** The translated version is fluent and accessible but could be read as support for a different decision than the original. The check was skipped because the translation felt good.

**Fix.** The fidelity check is not optional. Place the original core claim and the translated version side by side and explicitly ask whether the same decision is supported. If not, revise. "Feels faithful" is not a check.

### Anti-pattern: Translation adds new claims

**Symptom.** The translated version includes framing, context, or implications that were not in the source material. The translator has become an analyst.

**Fix.** Translation does not add content. If the source is silent on a question the target audience will have, note that gap in the output rather than inventing an answer. Adding claims corrupts the fidelity of the translation and creates liability.

---

## When to skip this skill

- The source and target audience share enough context that the original is already legible to them. Translating to an audience that can read the original wastes time and risks introducing distortion.
- The content is so short (a single sentence, a yes/no) that register adaptation is trivial and does not need a formal protocol.
- The translation is to a domain so unfamiliar that the core claim cannot be accurately encoded at all. In this case, flag the gap rather than produce a translation that misrepresents the finding.
- The translation task is stylistic rather than substantive -- editing for tone, not re-encoding for a different knowledge base. Use a style guide instead.
