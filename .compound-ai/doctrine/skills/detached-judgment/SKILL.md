# Skill: detached-judgment
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Evaluates evidence on its own terms, not through what you hope to be true.
Assigns confidence calibrated to evidence quality rather than preference.
Produces recommendations that can be defended under adversarial questioning.
Use when analysis needs to be free of advocacy bias, sunk-cost distortion, or
motivated reasoning.

## Triggers
"steelman the other side", "devil's advocate", "am I being objective",
"what's the case against this", "calibrate my confidence",
"would this survive scrutiny", "am I rationalizing",
"weight the evidence", "base rate check"

## How to apply

1. **List the claim and the evidence separately.**
   Write the claim in one sentence. Then list every piece of supporting
   evidence independently. Do not let the claim influence how evidence is
   described.

2. **Assess evidence quality, not just quantity.**
   For each piece of evidence: is it direct or circumstantial? Recent or
   dated? From a disinterested source or an advocate? High quality evidence
   is direct, recent, and independent.

3. **Construct the strongest opposing case.**
   What evidence points against the claim? Build the best version of the
   opposing argument -- not a straw man. If the opposing case is stronger than
   expected, that is the finding.

4. **Check the base rate.**
   Before committing to a claim, ask: how often is this type of claim true
   in comparable situations? A compelling specific case can still be wrong
   if the base rate is low.

5. **Assign calibrated confidence.**
   State confidence as a range with explicit reasoning. Avoid false precision.
   "High confidence" means the claim survives the opposing case and base rate
   check. "Low confidence" means one of those checks failed.

## Techniques
- Evidence weighting
- Calibrated confidence intervals
- Devil's advocate construction
- Base rate anchoring

## Output format
```
DETACHED JUDGMENT
Claim: [one sentence]

Evidence inventory:
  Supporting:
    [evidence] -- quality: [high/med/low], type: [direct/circumstantial]
    ...
  Opposing:
    [evidence] -- quality: [high/med/low], type: [direct/circumstantial]
    ...

Strongest opposing case: [summary]

Base rate check:
  Reference class: [comparable situations]
  Base rate: [how often this type of claim holds]

Calibrated confidence: [high / medium / low]
  Rationale: [why -- specifically which check passed or failed]

Recommendation: [statement with explicit uncertainty acknowledgment]
```

## Source references
- Field Guide Chapter 4: Evidence Evaluation Frameworks
- Field Guide Chapter 25: Quality Gates and Preservation
- `templates/quality-gates.md` -- quality thresholds for analytical outputs
- `AGENT.md` -- model routing table (synthesis-tier for contested claims)
