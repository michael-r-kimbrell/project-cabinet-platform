# convergence-detection: Protocol

This protocol operationalizes pattern recognition across multiple disparate inputs before any label is assigned. The discipline is sequencing: observations precede hypotheses, hypotheses precede labels. The mechanism that makes this hard in practice is that analysts arrive with a hypothesis already in mind -- sometimes a good one -- and the temptation is to skip to confirming it. This protocol makes that shortcut visible by forcing all atomic observations to be written before any clustering begins. A hypothesis that survives explicit observation extraction is more trustworthy than one that was imposed on the material from the start.

The protocol is most valuable when the inputs come from different people, systems, or time periods, and when the pattern, if it exists, would not be visible to anyone looking at only one input at a time.

---

## Step-by-step procedure

1. **Ingest all inputs before forming any hypothesis.** Read or process every source document, signal, or data point in the corpus before writing anything analytical. The act of reading often generates intuitions; write them down separately as "hypothesis candidates" to be tested, not as conclusions. Do not assign labels, cluster, or draw conclusions during ingestion.

2. **Extract atomic observations.** From each input, extract the most concrete, specific observations available. An atomic observation is a single verifiable fact about a single input: "customer ticket #4412 reported a login failure after password reset," not "customers are having login problems." The test for atomic is: could a different analyst read this observation and confirm or deny it from the same source material? Write one observation per line.

3. **Run co-occurrence analysis.** Scan the atomic observation list for observations that appear in more than one input. Group every co-occurrence, including ones that seem coincidental. Do not discard any co-occurrence at this stage -- the goal is a complete map, not a filtered one. Record which inputs each co-occurrence appears in.

4. **Rank clusters by frequency and cross-input breadth.** Sort clusters by two dimensions: how many times the observation appears (frequency) and how many distinct inputs it appears across (breadth). A cluster that appears 10 times in one input is weaker evidence than a cluster that appears twice each across five independent inputs. Breadth is the stronger signal.

5. **Hypothesize the root cause.** For the highest-ranked clusters, ask: what single upstream cause would explain all observations in this cluster? Work from the observations backward to the mechanism. Write the hypothesis in the form: "If [mechanism] were true, we would expect to see [observations], which we do." Multiple competing hypotheses for the same cluster are allowed; rank them by how well they explain the full set of observations, not just the strongest ones.

6. **Name the pattern.** Only after root cause is hypothesized, assign a label to the pattern. The label should follow from the mechanism hypothesis, not from what the observations feel like. "Authentication failure cascade" is a label that follows a mechanism. "Login problems" is a label that precedes understanding.

7. **Flag anomalies separately.** List every observation that does not fit any cluster. Anomalies are not failures -- they are often the most informative outputs. An observation that does not fit means either the clustering is incomplete (a cluster exists that has not been found) or the anomaly is genuinely different and requires its own hypothesis.

---

## Output template

```
CONVERGENCE DETECTION
Corpus: [number of inputs, brief description of sources]

---

Atomic observations:
  [input-id] | [observation in one specific, verifiable sentence]
  [input-id] | [observation]
  [continue for all inputs]

---

Co-occurrence clusters:
  Cluster A: [observation theme]
    Appears in: [input-id list] ([N] of [total] inputs)
    Observations: [list the specific observations that compose this cluster]

  Cluster B: [observation theme]
    Appears in: [input-id list] ([N] of [total] inputs)
    Observations: [list]

  [continue for all clusters above threshold]

---

Root cause hypotheses:
  Cluster A -- Hypothesis: [mechanism statement]
    If true, explains: [list the observations it accounts for]
    Does not explain: [any observations in the cluster it fails to cover]

  Cluster B -- Hypothesis: [mechanism statement]
    [same format]

---

Pattern labels (assigned after hypothesis):
  [label]: [cluster + mechanism it describes]

---

Anomalies (do not fit any cluster):
  [input-id] | [observation] -- [why it diverges from all clusters]

---

Confidence: [high / medium / low]
  Rationale: [what determines confidence -- breadth of cluster, quality of root-cause hypothesis, proportion of anomalies]
```

---

## Worked example

**Corpus:** 7 post-incident reports from a software platform over 14 weeks, each describing a service disruption.

**After atomic extraction, co-occurrence analysis surfaces:**

Cluster A: "rate limiter was bypassed" or "rate limit not applied" -- appears in 5 of 7 reports.
Cluster B: "deployment occurred within 6 hours of incident" -- appears in 4 of 7 reports.

These co-occur in 3 of 7 reports (Cluster A and B both present).

**Root cause hypothesis for Cluster A:** The rate limiter is configured at the application layer but not at the infrastructure layer. Application-layer deployments reset the rate limiter state, creating a window where burst traffic is not throttled.

- If true, explains: why rate limiting failures cluster around deployments (Cluster B co-occurrence), why the failures are transient rather than permanent, why manual restarts resolve them without code changes.
- Does not explain: two incidents in Cluster A that had no deployment within 24 hours. Those may be a separate mechanism.

**Pattern label:** "Deployment-triggered rate limiter desync" (follows the mechanism, not the symptom).

**Anomaly:** Report #6 shows a 4-hour service degradation with no rate limiter mention and no deployment. Likely a separate infrastructure issue unrelated to the primary pattern. Flagged for separate analysis.

**Confidence:** Medium. The cluster is strong (5 of 7 inputs), but the 2 incidents in Cluster A that do not fit the deployment hypothesis prevent high confidence.

---

## Anti-patterns

### Anti-pattern: Labeling before observing

**Symptom.** The analysis begins with a section called "the pattern I found" before atomic observations are listed. The observations are then selected to support the pre-assigned label.

**Fix.** The observation extraction step must produce a list that is longer than the analyst expected, including observations that do not fit the leading hypothesis. If the observation list confirms the hypothesis cleanly with no surprises, the extraction was filtered. Redo.

### Anti-pattern: Cluster breadth ignored in favor of frequency

**Symptom.** The highest-confidence finding is an observation that appears 8 times -- all from the same single source document. A different observation appears twice each in 5 independent sources and is rated lower.

**Fix.** Weight cross-input breadth above within-input frequency. A pattern that appears independently across 5 sources is stronger evidence of a real phenomenon than a pattern that appears 8 times in one document. In the output template, record both dimensions and make the breadth weighting explicit.

### Anti-pattern: Anomalies discarded as noise

**Symptom.** The output reports "the following observations did not fit and were excluded." No analysis of why they diverge is provided. The anomalies disappear.

**Fix.** Anomalies must be listed separately with a note on why they diverge. An anomaly that consistently appears across the corpus without fitting any cluster often signals a missing hypothesis, not a measurement error. Treat anomalies as a second-pass research question, not as garbage.

### Anti-pattern: Single mechanism forced onto all clusters

**Symptom.** The analysis identifies three distinct clusters and then proposes one root cause that supposedly explains all of them. The root cause is at a level of abstraction so high that it explains nothing specifically.

**Fix.** Each cluster needs its own hypothesis. "Poor engineering practices" is not a root cause for any specific cluster. A root cause must be mechanistic: it names a specific process, system, or decision that produced the observed pattern. Multiple clusters can share a root cause, but only if the mechanism genuinely accounts for all observations in all clusters.

### Anti-pattern: Confidence calibrated to hope

**Symptom.** The finding looks clean, the pattern is compelling, and confidence is reported as high -- but the corpus is small (3-4 inputs), the cluster breadth is low, or anomalies are numerous.

**Fix.** Confidence must be calibrated to: (a) how many inputs the corpus contains, (b) how broadly the cluster appears across independent sources, (c) how well the root-cause hypothesis accounts for edge cases, and (d) how many anomalies remain unexplained. High confidence requires strong performance on all four.

---

## When to skip this skill

- There is only one input. Pattern detection requires multiple sources; a single document cannot produce co-occurrence clusters.
- The pattern is already known and confirmed from prior analysis. Use this protocol to find patterns, not to re-document patterns that are already understood.
- The inputs are too heterogeneous to share atomic observations. If the sources measure fundamentally different things in fundamentally different ways, forcing a convergence analysis produces spurious clusters.
- The question is causal rather than descriptive. Convergence detection finds patterns and hypothesizes mechanisms -- it does not prove causation. If the task requires causal proof, the protocol is the wrong tool.
