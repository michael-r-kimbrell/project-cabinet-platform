# agent-panel-review: Full Protocol

The six-stage procedure with stage-by-stage discipline. The protocol is
operator-driven. There is no orchestrator agent. The operator runs the
panel by holding the seal between stages.

---

## Stage 1: Frame

**Operator action.** Write one prompt that defines:

1. The deliverable (what each panelist is producing)
2. The constraints (length, audience, format, what counts as in-scope)
3. The success criteria (what makes the output good)
4. The role for this panelist (if role-specific work is intended)

**The hard rule: one prompt, no variants.** Every panelist gets the same
deliverable definition. If you want role differentiation, name the role
in the prompt; do not change the deliverable.

**Anti-pattern.** Sending three different prompts to three agents and
calling it a panel. That is parallelization, not a panel. A panel
requires that the panelists were aimed at the same target.

---

## Stage 2: Independent first pass

**Operator action.** Send the prompt to each panelist in a separate
session. Wait for the full first attempt from each.

**The hard rule: sealed independence.** No panelist sees another
panelist's draft, summary, framing, or even acknowledgement that the
panel exists during this stage. Each one writes from scratch.

**Why this matters.** Models anchor heavily on prior context. If
panelist B sees even a paragraph of panelist A's draft, panelist B's
output is no longer independent. It is anchored. The whole point of the
panel is the unanchored signal each agent produces.

**Operator discipline:**
- Do not run the sessions in adjacent tabs of the same agent
- Do not paste any cross-session content into prompts
- Do not summarize what one agent said to another agent
- If you accidentally break the seal, restart that panelist's first pass

**Common failure: leaky session memory.** Some agents share context
across sessions in the same workspace. Verify your panel members are
running in genuinely separate contexts. A shared system prompt is fine;
a shared session history is not.

---

## Stage 3: Cross-critique

**Operator action.** Send each panelist the full first-pass outputs of
the other panelists. Ask each to produce a structured critique of the
others using the template in `critique-format.md`.

**The hard rule: critique the work, not the agent.** No "Claude is wrong
about X." Only "this output's weak spot is X because Y." The work is the
unit, not the producer.

**The four critique cells (per output reviewed):**
1. Strongest claim
2. Weakest claim
3. Shared blind spot (something this output and yours both missed)
4. One thing worth stealing

The cells are the discipline. Free-form critique becomes noise. The
template forces every reviewer to find both strength and weakness in
every output, including their own when re-read.

---

## Stage 4: Self-revise

**Operator action.** Send each panelist the critiques of their own work
from the other panelists. Ask them to revise.

**The hard rule: adopt or dissent in one line.** If a critique lands,
adopt it and revise. If it does not land, write one line of dissent
("the critique on attribution architecture mis-reads scope, keeping the
original framing because [reason]") and move on. Do not re-litigate.

**Anti-pattern: relitigation.** A revision that turns into a 500-word
defense of the original draft. The protocol breaks here. Force a one-
line dissent rule.

**Anti-pattern: capitulation.** A revision that adopts every critique
without judgment. Equally bad. Each panelist should retain some of its
original signal; adopting every critique flattens the panel into
groupthink.

The healthy revision adopts maybe 60-80% of critiques, dissents on the
rest with one-line reasoning, and produces a stronger version of the
original output.

---

## Stage 5: Converge

**Operator action.** Read the three revisions. Pick the merge
architecture.

**The hard rule: merge takes the strongest layer from each, not an
average.** Common merge patterns:

- **Spine-from-one, body-from-another, voice-from-third.** One agent
  produces the best structural skeleton; another fills in the strongest
  substance; the third's voice is best for delivery. Combine.
- **Concede-and-keep.** One agent's output is dominant on most
  dimensions; keep it as the base and merge in only the specific
  improvements from the others.
- **Synthesis by a single panelist.** If one panelist's revision shows
  the cleanest integration of the critiques, hand them the other two
  revisions and ask for a final merge.

The operator owns the merge. The panel produced the inputs; the
operator decides what ships.

---

## Stage 6: Loop or ship

**Decision criteria.**

| Loop count | Healthy state | Unhealthy state |
|---|---|---|
| 1 | Most gaps closed, one or two open | Full convergence on loop 1  -  you did not need a panel |
| 2 | Output close to ship-ready | Critiques still surfacing new gaps |
| 3 | Final polish loop | Disagreement persists on structural questions |
| 4+ | (rare) | Scope is wrong; close the loop, narrow the question, restart |

A panel that needs four or more loops is panel-pulling on a question
that has not been correctly framed. Stop, narrow the question, restart.

---

## Two-panelist panels

The protocol works with two panelists. Stage 3 cross-critique becomes
a one-to-one exchange. Stage 4 self-revise remains the same. Stage 5
merge is operator-driven as before.

Two-panelist panels are appropriate for:
- Decisions where two perspectives are clearly distinct (e.g. builder
  vs. critic, voice vs. substance)
- Time-constrained deliverables where three sessions are too much
  overhead
- Code review (one author, one reviewer is the canonical pattern)

Three is the sweet spot for editorial work. Two is the sweet spot for
code review. Four or more is usually too many; the marginal value of
a fourth panelist rarely justifies the orchestration cost.

---

## Same-model panels

A panel does not require multiple different models. Three sessions of
Claude in three different roles works for ~70% of the benefit of a
cross-model panel. The roles must be genuinely different (system
prompts, instructions, or named personas), and the seal in Stage 2
must still hold.

When cross-model panels are worth the extra cost:
- The work genuinely spans different model strengths (e.g. voice work
  + mechanics work)
- One model is known to have a blind spot the others do not
- High-stakes deliverables where the marginal cost is worth the
  marginal signal
