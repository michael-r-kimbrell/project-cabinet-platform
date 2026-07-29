# Skill: cross-domain-translation
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Re-encodes an idea for a different audience, domain, or register without losing
fidelity to the underlying reasoning. The thinking stays the same; the surface
adapts. Critical for executive briefings, technical handoffs, and cross-
functional alignment where terminology mismatch destroys otherwise sound ideas.

## Triggers
"translate this for", "explain this to a non-technical audience",
"rewrite for the board", "make this accessible", "shift the register",
"adapt this for", "how would I explain this to",
"executive summary", "technical-to-business translation"

## How to apply

1. **Identify the source register.**
   What assumptions does the current content make about the reader?
   What vocabulary, abstraction level, and decision frame does it use?

2. **Profile the target audience.**
   What do they already know? What do they care about? What decisions are they
   trying to make? What vocabulary signals credibility to them?

3. **Preserve the core claim exactly.**
   Write out the central claim in one sentence before translating. This is the
   invariant. Everything else is surface.

4. **Translate the surface, not the substance.**
   Replace jargon with domain-appropriate equivalents. Replace abstract metrics
   with concrete stakes. Replace technical causality with business consequence.

5. **Verify fidelity.**
   After translation, check: does the translated version support the same
   decision as the original? If not, something was lost -- revise.

## Techniques
- Audience adaptation
- Register shifting
- Analogy construction
- Technical-to-executive translation

## Output format
```
CROSS-DOMAIN TRANSLATION
Source register: [technical / academic / operational / executive / other]
Target register: [same options]
Core claim (invariant): [one sentence]

Translation:
[translated content]

Fidelity check:
  Original decision supported: [yes / no -- if no, note what was lost]
  Vocabulary swaps: [key term -> target term, ...]
```

## Source references
- Field Guide Chapter 26: Engagement Reuse and Governance
- `conventions/style-guide.md` -- register and voice conventions
- `AGENT.md` -- model routing table (implementation-tier models sufficient)
