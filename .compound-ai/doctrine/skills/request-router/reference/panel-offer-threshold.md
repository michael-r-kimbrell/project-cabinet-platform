# request-router: Panel Offer Threshold

The router's Panel Offer judgment uses five criteria (see `SKILL.md`).
This file is the detailed threshold guide: what triggers, what does not,
how to phrase the offer, how to handle borderline cases.

The fast-path (explicit "convene a panel" phrasings) is handled by the
routing table in `SKILL.md`. This file covers the harder case: when
the operator signals council-tier intent without using the word
"panel."

---

## The five criteria, expanded

### Criterion 1: Explicit invitation to another model or agent

The operator gestures toward an agent OTHER than the one they are
talking to.

Examples that match:
- "I want another model's read on this"
- "what would [other agent] say"
- "second opinion from a different model"
- "let's get [Codex/Gemini/Kiro] in on this"
- "have any of my other agents looked at this?"

The distinguishing signal: the operator names a different agent
explicitly, or refers to OTHER agents in the plural. Asking THIS
agent for thoughts is not criterion 1.

### Criterion 2: Stuck-state signal

The operator describes their own reasoning looping.

Examples that match:
- "I keep going back and forth"
- "I've changed my mind three times"
- "I can't decide between X and Y"
- "I keep talking myself out of it"
- "I've been spinning on this all day"

The distinguishing signal: the operator names a loop pattern. "I'm not
sure" is not stuck-state; it is uncertainty. Stuck-state describes
repeated reconsideration.

### Criterion 3: High-stakes + explicit "don't decide alone"

Two parts: the decision is hard to reverse, AND the operator signals
they do not want to commit solo.

Examples that match:
- "this is too important to decide alone"
- "I don't want to commit without more eyes on it"
- "this is irreversible and I'm not confident"
- "I want this checked before I lock it"

The distinguishing signal: explicit don't-decide-alone framing. "This
is important" alone does not satisfy criterion 3.

### Criterion 4: Explicit panel or council words

Even outside the fast-path phrasings.

Examples that match:
- "I want a council on this"
- "let's get a few agents together"
- "I want this run through the panel pattern"
- "convene a review"

Some of these are caught by the fast-path. Anything that did not
match the routing table but still uses panel/council language goes
here.

### Criterion 5: Complete draft + want alternatives

The operator has produced a plan they wrote, and they explicitly want
it tested against other framings.

Examples that match:
- "I drafted this plan, want to test it against alternatives"
- "I have a framing but want to see other framings"
- "here's my approach; what would a panel produce?"
- "challenge this draft with alternative plans"

The distinguishing signal: the operator has a finished plan AND wants
alternative plans, not just critique. Just-critique requests route to
`pressure-test`, not a planning panel.

---

## What does NOT trigger an offer (full list)

The most important section. Without this, the kit spams panel offers
on routine collaborative dialogue.

| Operator says... | Treat as... |
|---|---|
| "what do you think?", "your thoughts?", "your take?" | Normal collab. Just answer. |
| "is this any good?", "any feedback?" | Normal collab. Just answer. |
| "I'm not sure how to approach this" | Engage deeper solo. T2, not T3. |
| "help me think through this", "walk me through it" | Engage deeper solo. T2. |
| "I'm stuck on this" | Engage deeper solo. T2, unless paired with criterion 2 above. |
| "tear this apart", "rip this apart" | Invoke `pressure-test`, not a panel. |
| "is this important?", "is this risky?" | Ask back. Do not assume T3. |
| "review this", "check this" | Engage solo. Use `quality-gate` or `pressure-test` if structured review is wanted. |
| "what could go wrong here?" | Invoke `consequence-simulation`, not a panel. |
| "what's the best approach?" | Engage solo. Borderline; use soft-offer if the question feels high-stakes. |

The distinction is whether the operator is gesturing toward OTHER
agents or just asking THIS agent to engage. Asking this agent more
deeply is solo collaboration. Asking for OTHER agents' input is
council-tier.

---

## The full offer response template

When a Panel Offer judgment criterion matches, respond with the
template BEFORE doing anything else. The operator opts in or declines.

```
This sounds like [reason matching the triggered criterion].
Want me to set up a panel? [Two or three] agents would each
[propose an approach / produce a sealed first-pass review]
independently, then we'd converge. I can sketch the panel
composition or you can name the agents.

If you'd rather think alone first, just say so and I'll proceed solo.
```

Specific phrasings to fill the bracketed slots:

- For planning panels: "propose an approach independently"
- For review panels: "produce a sealed first-pass review"
- For two-agent setups: "Two agents would..."
- For three-agent setups: "Two or three agents would..."

---

## The soft-offer pattern (borderline cases)

When the operator's signal is borderline (matches a criterion weakly,
or sits between T2 and T3), do NOT derail with a full panel-offer
question. Instead:

1. Answer the question as posed.
2. End with one sentence mentioning the panel as available.

Example response shape:

> [Full answer to the operator's question.]
>
> If you want another model's perspective specifically, I can set up a
> panel with [Codex / Kiro / Gemini]: we'd each propose independently
> then converge. Up to you.

The operator can ignore it (continue the conversation) or take it
("yes, set up the panel"). No friction either way. The soft-offer
keeps the kit responsive without being naggy.

When to soft-offer vs full-offer:
- One criterion barely matches → soft-offer
- Multiple criteria match → full-offer
- Criterion 1 (explicit other-agent invitation) matches → full-offer
  always; the operator is asking explicitly
- Criterion 4 (explicit panel words) matches → full-offer always

---

## When NOT to offer (even on a criterion match)

Some criterion matches do not warrant an offer.

| Situation | Behavior |
|---|---|
| Question is small and reversible at low cost | Just answer. Skip the offer. |
| Operator already declined a panel offer in this session for the same topic | Do not re-offer. Respect the decline. |
| Operator explicitly said "let me think alone" | Respect it. |
| Matched phrase is incidental (e.g. "I'm not sure I follow your last message") | Not a panel signal. Just answer. |
| Operator is mid-execution and the panel would interrupt | Defer the offer to the next natural break. |

If you are unsure whether to offer, lean toward the soft-offer
pattern. A declined soft-offer takes zero operator response (they just
continue). A skipped offer that should have happened costs much more.

---

## Calibration over time

The operator's tolerance for panel offers will sharpen. Early in
kit-use, the right discipline is: when in doubt, soft-offer. Over the
first dozen panels, the operator will tell you (explicitly or by
declining) which signals warrant full offers and which warrant
nothing.

Update the criteria interpretation, not the criteria themselves. The
five criteria are stable; how aggressively they trigger an offer is
the operator's preference and will calibrate.
