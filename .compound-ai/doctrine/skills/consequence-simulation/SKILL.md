# Skill: consequence-simulation
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Before committing to a path, simulates what it produces. Models second and
third-order effects before the first action executes. A decision that survives
premortem scrutiny is materially better than one that skips it.

## Triggers
"what could go wrong", "premortem", "stress test this plan",
"simulate the outcome", "what happens if", "failure modes",
"scenario planning", "what are the second-order effects",
"think through the consequences"

## How to apply

1. **State the decision or action clearly.**
   Define what is being evaluated: a plan, a recommendation, a system change,
   a communication. Ambiguous inputs produce ambiguous simulations.

2. **Run the forward simulation.**
   Trace the most likely outcome chain: what happens immediately, what happens
   in 30 days, what happens in 6 months. Be concrete, not abstract.

3. **Run the premortem.**
   Assume the decision has already failed catastrophically. Work backwards:
   what went wrong? What was the earliest signal that was ignored?

4. **Generate counterfactuals.**
   What would have happened if one key assumption had been different?
   Identify which assumptions the outcome is most sensitive to.

5. **Enumerate failure modes.**
   List 3-5 plausible failure modes ranked by probability and impact.
   For each, identify whether it is detectable before it becomes catastrophic.

## Techniques
- Scenario planning
- Premortem analysis
- Counterfactual reasoning
- Failure mode enumeration

## Output format
```
CONSEQUENCE SIMULATION
Decision under evaluation: [statement]

Forward simulation (most likely path):
  T+immediate: [outcome]
  T+30 days:   [outcome]
  T+6 months:  [outcome]

Premortem (assuming failure):
  Root cause: [what went wrong]
  Earliest signal: [what was ignored]

Key assumptions (sensitivity ranked):
  1. [assumption] -- [high / medium / low sensitivity]
  2. ...

Failure modes:
  1. [mode] -- P:[high/med/low], I:[high/med/low], detectable:[yes/no]
  2. ...

Recommendation: [proceed / modify / pause  -  with rationale]
```

## Source references
- Field Guide Chapter 5: Decision Framework Evaluation
- Field Guide Chapter 25: Quality Gates and Preservation
- `AGENT.md` -- model routing table (use synthesis-tier models for this skill)
