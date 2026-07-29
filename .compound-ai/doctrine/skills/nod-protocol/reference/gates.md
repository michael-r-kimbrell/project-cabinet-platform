# nod-protocol: The Five Gates

Each gate has a procedure and a pass criterion. A gate that fails forces a
redo at that gate. You do not advance until a gate passes. This is the
discipline that separates structured opposite-construction from rhetorical
debate.

---

## Gate 1: State the position

**Procedure.** Write the position being defended in one sentence. No hedges,
no qualifiers, no "in some cases." The position must be specific enough that
the opposite case is constructable.

**Pass criterion.** The position is a single declarative sentence that a
reasonable reader can disagree with. "We should X" or "X is true" or
"X causes Y." Not "X might be worth considering."

**Common failures.**
- The position is too vague to oppose (e.g. "we should be more careful")
- The position is actually two positions in a trench coat (split them)
- The position is conditional on something not yet decided (close that first)

---

## Gate 2: Construct the strongest opposite

**Procedure.** Write the opposite case in 3-6 sentences as someone who
actually believes it would write it. Use their best evidence, their tightest
framing, their most charitable assumptions. The opposite case must read as
a position someone would defend in public.

**Pass criterion.** A thoughtful believer in the opposite case would sign
this paragraph. If you read it back and think "well, obviously they would
not actually say it like that," the gate has failed. Redo.

**Common failures.**
- **Strawman:** the opposite case is a weakened version that is easy to
  knock down. This is the most common failure and the most damaging. A
  strawman gate produces false confidence.
- **Cardboard cutout:** the opposite case has no specific evidence, only
  abstract worry. Real opposing positions cite specifics.
- **Self-flattering opposite:** the opposite case is constructed to make
  the original position look even better. Watch for this. If your opposite
  case has rhetorical tells, you wrote it wrong.

**The signing test.** Read the opposite paragraph as if you were a defender
of that position. Would you sign your name to it? If no, redo.

---

## Gate 3: Find the shared assumption

**Procedure.** Both the position and its opposite take something for granted.
Surface it. This is usually the question that should have been asked first
but never was. Examples:

- Position: "We should ship the feature now." Opposite: "We should delay
  until we have more data." Shared assumption: that the feature is the
  right feature to ship at all.
- Position: "Hire externally for this role." Opposite: "Promote internally."
  Shared assumption: that the role as currently scoped is correct.

**Pass criterion.** The shared assumption is named and is genuinely shared.
Both sides would acknowledge it if asked. The assumption is upstream of the
disagreement, not parallel to it.

**Common failures.**
- Naming a shared assumption that is actually just the position rephrased
- Naming three "shared assumptions" because you cannot decide which is real
  (pick the one that, if false, would dissolve the disagreement)
- Skipping this gate because it feels obvious (it usually is not)

**Why this gate matters.** Most decisions collapse at the shared-assumption
layer, not at position-vs-opposite. If you skip this gate, you fight the
wrong battle.

---

## Gate 4: Specify the falsifier

**Procedure.** For each side, write the test that would prove that side
right. The test must be specific, testable, and resolvable in a known
timeframe. "We would learn from doing it" does not pass.

For the position: what would have to be true for this to be correct?
For the opposite: what would have to be true for the opposite to be correct?

**Pass criterion.** Each falsifier is concrete enough that a third party
could agree on whether it has been met. "Revenue grows by X%" passes.
"Things go well" does not.

**Common failures.**
- Falsifier is the position restated (circular)
- Falsifier is unfalsifiable in any reasonable timeframe (escape hatch)
- Falsifier is asymmetric: position has a hard test, opposite has a soft one

---

## Gate 5: Decide, defer, or refuse

**Procedure.** Choose exactly one of three legitimate exits. Each exit
has its own discipline.

**Exit A: Decide with stated confidence.**
- The falsifier for one side is more likely satisfied than the other
- State the confidence (high, medium, low) and the reason
- State what would change your mind

**Exit B: Defer.**
- The falsifier is testable but not yet tested
- Name the test, name the cost, name the deadline
- A deferral without a deadline is a refusal in disguise

**Exit C: Refuse.**
- The shared assumption from Gate 3 is the real question
- Name it. Send the decision back upstream
- A refusal is not a failure; it is a routing decision

**Pass criterion.** The exit chosen matches the reasoning. A "decide" that
papers over a Gate 3 problem is a failed Gate 5.

**Common failures.**
- "Both sides have a point"  -  averaging is not deciding
- Decide because deciding feels productive (Gate 3 was skipped)
- Refuse because deciding feels risky (escape hatch)

---

## When the protocol does not apply

Not every question needs five gates. Skip nod-protocol when:

- The decision is reversible at low cost
- One side is obviously correct after Gate 2 (most position-opposite pairs
  do not survive Gate 2 honestly)
- The cost of deliberation exceeds the cost of being wrong

The router should not auto-fire nod-protocol on every borderline question.
It is a high-leverage skill applied to high-stakes decisions.
