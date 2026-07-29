# Skill: convergence-detection
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Surfaces recurring patterns, shared root causes, or thematic coherence across
disparate inputs before naming them. Prevents premature labeling and forces
signal extraction from noise. Most useful when processing multiple documents,
sessions, signals, or data sources that may share underlying structure the
analyst has not yet identified.

## Triggers
"find the pattern", "what's the common thread", "root cause analysis",
"why does this keep happening", "cluster these", "what connects these",
"find the signal across these inputs", "thematic analysis",
"what am I missing across all of these"

## How to apply

1. **Ingest all inputs without labeling.**
   Read all source material before forming hypotheses. Premature labels anchor
   analysis and suppress pattern detection.

2. **Extract atomic observations.**
   Reduce each input to its most concrete, specific observations. Avoid
   abstractions at this stage. Write facts, not interpretations.

3. **Run frequency analysis.**
   Which observations recur across multiple inputs? List every co-occurrence,
   even ones that seem coincidental. Do not discard yet.

4. **Test for root cause.**
   For the most frequent co-occurrences: is there a single upstream cause that
   would explain all of them? Work backwards from the pattern to the mechanism.

5. **Name the pattern last.**
   Only after root cause is hypothesized should you assign a label. The label
   should follow the evidence, not guide it.

6. **Flag anomalies.**
   Inputs that don't fit any pattern are often the most informative. List them
   separately with a note on why they diverge.

## Techniques
- Cross-document pattern recognition
- Root cause analysis
- Thematic clustering
- Anomaly flagging

## Output format
```
CONVERGENCE DETECTION
Inputs analyzed: [count and brief description]

Atomic observations: [list, one per line]

Frequency clusters:
  Cluster 1: [observations] -- appears in [N] inputs
  Cluster 2: [observations] -- appears in [N] inputs
  ...

Root cause hypothesis:
  [pattern name]: [mechanism that explains the cluster]

Anomalies (do not fit any cluster):
  [observation] -- [why it diverges]

Confidence: [high / medium / low -- and why]
```

## Source references
- Field Guide Chapter 22: Intelligence Lineage
- Field Guide Chapter 24: Observability for Scheduled Jobs
- `code/schema_validator.py` -- structured output for pattern detection results
- `AGENT.md` -- model routing table (synthesis-tier for large corpora)
