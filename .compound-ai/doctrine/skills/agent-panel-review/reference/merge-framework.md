# agent-panel-review: Merge Framework (Stage 5)

Stage 5 is "the operator picks the merge architecture from the three
revisions." That sentence undersells the work. The merge is where the
operator's bias is most likely to reassert: it is easy to call the layer
that matches your instinct "strongest" and proceed. This file is the
framework for executing Stage 5 without that bias collapsing the panel's
signal.

The merge is the only Stage in the panel-review protocol where the
operator's judgment is the deciding factor, not the panel's. Get it
wrong and the panel becomes performance. Get it right and the merged
deliverable is honestly stronger than any single agent's revision.

---

## The principle

The merge takes the strongest layer from each revision, not an average.
Concretely: for each dimension of the deliverable, identify which
revision's treatment is dominant, justify the call from the panel's own
outputs, and integrate.

The hard part is identifying "strongest" without bias. The rest of this
file is the procedure.

---

## Step 1: List the dimensions

A revision is not a monolith. It has layers:
- **Structural spine** (the ordering, the section breakdown, the
  scaffolding)
- **Substance density** (the claims, examples, code, evidence)
- **Voice and tone** (rhythm, register, opening hook)
- **Attribution and provenance** (who is credited, what is cited)
- **Open-question handling** (what is named explicitly as deferred)
- **Closing arc** (how the deliverable lands)

Some deliverables have additional dimensions: code samples, charts,
appendix, glossary. Add them to the list before picking strongest.

For a 600-word piece, ~3-4 dimensions is enough. For a 5,000-word piece,
~6-8 dimensions. Listing the dimensions explicitly forces the merge to
be per-dimension, not per-revision.

---

## Step 2: Score each dimension from the panel's outputs

For each dimension, read:

1. **Stage 3 "strongest claim" cells** (cross-critique). Which revision's
   treatment of this dimension was named strongest by the OTHER panelists?
   If two panelists independently called Revision A's spine the
   strongest, that is signal.

2. **Stage 4 concession lines.** Did any panelist explicitly concede on
   this dimension to another? "Concede to Codex on structural spine" is
   the panel itself declaring Codex dominant on spine.

3. **Stage 4 one-thing-worth-stealing cells.** What did each panelist
   propose to steal from each other's revisions on this dimension? The
   adoption signals dominance.

The dimension's "strongest" treatment is whichever revision is most
frequently named across these three sources. Tally is the audit trail.

---

## Step 3: Run the operator-bias check

This is the discipline that protects the merge from operator drift.
Before locking the strongest on a dimension, run two questions:

1. **"Am I calling this strongest because I agree with it?"** The honest
   answer is sometimes yes. That is not automatically wrong, but it is a
   signal to slow down. If the panel agrees with the operator AND the
   operator's instinct, the merge is on solid ground. If the panel did
   not converge on the same dimension the operator likes, the operator
   is overruling the panel and that override should be on the record
   with explicit reasoning, not silently smuggled into the merge.

2. **"If the dominant revision were from the panelist I respect least,
   would I still call it strongest?"** This is the unbiased-source test.
   If the answer is no, the merge is biased by which agent produced the
   work, not by the work itself. Reconsider.

Run both checks per dimension. Two yeses means the merge call is safe.
A no on either means escalate the merge to a fast mini-panel on that
dimension specifically, or accept the override with explicit reasoning.

---

## Step 4: Integrate, with attribution

Write the merged deliverable. For each dimension, the merge document or
the commit message should name the source revision and the reason. Like:

```
MERGE ARCHITECTURE

| Dimension | Source revision | Why |
|---|---|---|
| Structural spine | Codex's revision | Stage 3 cross-critique: Claude
   and Kiro both named Codex's 5-layer spine as strongest. Stage 4:
   I conceded my Part I-VI to Codex on this dimension. |
| Substance density | Kiro's revision | Stage 3: Codex called Kiro's
   Part V "the strongest section in the panel." Stage 4: Claude
   conceded on substance migration. |
| Foreword opening | Claude's revision | Stage 3: Kiro and Codex both
   named Claude's incident opening as strongest. Stage 4: I retained
   it through revision. |
| ...
```

The attribution is the audit trail. Without it, the merge looks
arbitrary. With it, the merge is defensible from the panel's outputs.

---

## Step 5: One-pass operator polish

After integration, the merged draft is the operator's responsibility to
polish for cohesion. Transitions between sources, voice consistency,
small inconsistencies between the spine and the body that emerge in
integration. This is the operator's job, not a panelist's.

The polish is bounded. If the polish becomes substantive rewriting, the
merge architecture was wrong: probably one dimension's source revision
does not actually integrate cleanly. Restart that dimension's merge.

---

## Common failure modes

### Failure: operator merges by overall preference, not per-dimension

**Symptom.** "I like Revision A best, so I'm using A as the base and
patching in bits from B and C."

**Fix.** Force the per-dimension table. A revision is not a unit;
its layers are. The base-and-patch pattern collapses the panel's
per-dimension signal.

### Failure: operator bias goes unnamed

**Symptom.** Three of three dimensions go to the operator's preferred
panelist. No audit trail explaining why.

**Fix.** Run Step 3 honestly. If the operator still genuinely thinks
their preferred panelist won on every dimension, document the override
explicitly: "I'm calling A strongest on all three dimensions despite
the panel converging on B for dimension 2 because [reason]." Override
on the record is fine. Silent override is the panel becoming
performance.

### Failure: merge produces a Frankenstein

**Symptom.** The merged draft reads as three voices uncomfortably
glued together.

**Fix.** Pick ONE voice to dominate (usually the source revision for
voice/tone), then integrate the other dimensions through that voice's
filter. Step 5 polish addresses cohesion; the merge architecture
should not produce a draft that needs heavy polish to be readable.

### Failure: operator merges before Stage 4 lands

**Symptom.** Operator starts merging from Stage 3 cross-critique
outputs because "the direction is obvious."

**Fix.** Wait for Stage 4 revisions. The revisions absorb 60-80% of
the critiques and produce a stronger version of each panelist's work.
Merging from Stage 3 outputs means merging from inferior revisions.

### Failure: merge is delegated to a panelist who keeps their own work

**Symptom.** Operator hands the merge to Panelist A. Panelist A
produces a merged deliverable that looks suspiciously like Panelist
A's revision.

**Fix.** If delegating the merge, hand it to the panelist whose
revision was NOT dominant on most dimensions. That panelist has the
least incentive to favor their own work and the most context on what
the others produced.

---

## When the operator-bias check fails

Sometimes Step 3 returns a no on a dimension. The operator's call
differs from the panel's signal. Three legitimate exits:

1. **Override with explicit reasoning.** "I'm overruling the panel on
   spine because [reason not visible to the panel]." On the record. The
   panel may not have had context the operator has; overriding is
   sometimes correct. Frequent overrides mean the panel was the wrong
   tool.

2. **Mini-panel on the dimension.** Send the three revisions back to
   the panelists with a focused prompt: "the operator is split between
   X and Y on dimension Z. Argue for one. One paragraph." Take the
   stronger argument.

3. **Defer.** If the dimension is not blocking, ship the merge with the
   dimension flagged as open. Address in a next-loop pass or in a
   separate ratification.

The wrong move: silent override. That breaks the panel's audit trail
and turns the merge into operator preference dressed up as panel
output.

---

## The honest test of a healthy merge

After Step 5, ask: "Would the panel, if they saw the merged
deliverable, agree that it represents the strongest version of their
collective work?"

If yes, the merge succeeded. If no, the merge has drifted from the
panel's signal and the operator should re-run the questionable
dimensions before shipping.

This is the merge's accountability check. Without it, the merge is
the operator's preference with the panel's name on it.
