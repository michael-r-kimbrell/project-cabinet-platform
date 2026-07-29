# Skill: parallel-lens-synthesis
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Runs independent reasoning threads from multiple vantage points in parallel,
then synthesizes them into a single coherent position. Forces perspective
plurality before convergence so the final output has already survived internal
disagreement.

## Triggers
"get multiple perspectives", "ensemble this", "red-team my reasoning",
"what would someone who disagrees say", "run parallel analysis",
"multi-agent consensus", "challenge this from another angle"

## How to apply

1. **Decompose the question into 2-4 independent lenses.**
   Each lens should represent a genuinely different vantage point:
   domain expert vs. skeptic, optimistic vs. pessimistic, first-principles vs.
   precedent-based, internal vs. external stakeholder.

2. **Reason through each lens independently.**
   Do not let lenses bleed into each other during this phase. Each thread
   should reach its own conclusion before synthesis begins.

3. **Surface disagreements explicitly.**
   Where lenses contradict, name the contradiction. Do not average them away.
   A real disagreement is a signal, not noise.

4. **Synthesize to a defensible position.**
   The final output integrates all lens findings. Where consensus exists,
   state it confidently. Where genuine uncertainty remains after synthesis,
   acknowledge it with calibrated language.

## Techniques
- Multi-agent consensus
- Ensemble reasoning
- Adversarial red-teaming
- Structured debate before synthesis

## Output format
```
LENS SYNTHESIS
Lenses applied: [list]

Lens 1  -  [name]: [finding]
Lens 2  -  [name]: [finding]
...

Disagreements: [explicit list or "none"]
Synthesis: [integrated conclusion]
Confidence: [high / medium / low  -  and why]
```

## Source references
- Field Guide Chapter 17: Model Routing by Cognitive Load
- Field Guide Chapter 18: Agent Interface Design
- Field Guide Chapter 19: Multi-Agent Coordination
- `AGENT.md` -- model routing table (use synthesis-tier models for this skill)
