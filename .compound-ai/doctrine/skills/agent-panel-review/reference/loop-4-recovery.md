# agent-panel-review: Loop-4 Recovery Framework

A healthy panel review converges between loops 1 and 3. Loop 1
convergence usually means you did not need a panel. Loop 2-3
convergence is the sweet spot: real disagreement processed into
a stronger merged deliverable. Loop 4 still arguing is a failure
mode that costs real time and attention, and it has identifiable
causes with specific recovery moves.

Most operators, on hitting Loop 4, default to "narrow the question
and restart." That is often correct, but it is also a generic
prescription that does not match the specific cause. This file is
the diagnostic framework.

---

## Symptoms of Loop-4 failure

The panel has been through three rounds of revise + critique. The
output is still:
- Internally inconsistent across revisions
- Convergent on minor points but split on a structural question
- Polished but no one wants to ship it
- Producing critique that re-states earlier critique
- Producing dissent lines that keep growing

Any one of these signals Loop 4. Three or more signals means stop
the panel and diagnose before another loop.

---

## Diagnostic: identify the cause

The five common causes, in roughly decreasing frequency:

### Cause 1: question too broad

**Diagnostic signal.** The disagreement keeps moving. Loop 1 was
about structure, Loop 2 about substance, Loop 3 about voice. Each
loop surfaces new dimensions of disagreement.

**Why it happens.** Stage 1 framing did not constrain the
deliverable enough. The panelists are producing legitimately
different deliverables.

**Recovery move.** Narrow the question explicitly. Identify the
ONE dimension that is currently most contested and re-frame the
panel around just that dimension. The other dimensions are
deferred. Re-run Stages 2-5 on the narrowed question only.

### Cause 2: hidden assumption splitting the panel

**Diagnostic signal.** Two panelists keep talking past each other.
Neither's critique seems to land because they are operating from
different unstated premises.

**Why it happens.** The Stage 1 frame left an assumption
unspecified, and the panelists made different assumptions when
producing their first-pass drafts. Subsequent revisions cannot
converge because the underlying disagreement is not on the table.

**Recovery move.** Surface the hidden assumption. Ask each
panelist to state, in one sentence: "The assumption I made that I
think the others did not make is X." When the assumptions surface,
the operator decides which is correct and reframes.

This is where `nod-protocol` Gate 3 ("find the shared assumption")
is the right co-skill. Run NOD on the contested point; the gate
forces the assumption surface.

### Cause 3: wrong panel composition

**Diagnostic signal.** One panelist's revisions keep getting
adopted in full. Another keeps getting overruled on every
dimension. The "panel" is functionally one panelist plus two
echoes.

**Why it happens.** The roles assigned to two panelists overlap
too heavily, or one panelist is producing genuinely worse output
on this deliverable's dimensions.

**Recovery move.** Swap a panelist. Pull out the panelist whose
revisions are not landing and replace with a different agent (or
the same agent with a re-scoped role prompt). Re-run from Stage 2
with the new panelist, NOT a full restart.

### Cause 4: scope creep

**Diagnostic signal.** Each loop's critique is longer than the
last. Each revision is also longer. The deliverable is
accumulating dimensions that were not in the original frame.

**Why it happens.** Stage 3 cross-critique introduced new
dimensions ("this should also cover X"), and subsequent revisions
absorbed them. The panel is now reviewing a deliverable that is
not the one ratified at Stage 1.

**Recovery move.** Re-anchor on the original frame. Strip any
content that was added via critique that was not in the
original deliverable definition. Acknowledge what is being cut
and why. Ratify the trimmed scope, then run one more loop to
clean up.

### Cause 5: fatigue

**Diagnostic signal.** Loops are starting to repeat themselves.
Critique cells contain "as I noted in Loop 2..." The panelists
are losing steam.

**Why it happens.** Panel work is cognitively expensive. After
three or four loops, the marginal signal per loop drops. The
panel may be done before the panelists are ready to admit it.

**Recovery move.** Operator picks. The merge architecture is the
operator's call (see `merge-framework.md`); at Loop 4 with
fatigue as the cause, the operator stops the panel and merges
from the best Stage 4 revisions. Ship a slightly imperfect
deliverable. A panel that ran four loops produced enough signal
even if the final loop did not close cleanly.

---

## The diagnostic procedure

Before running another loop, the operator runs the diagnostic:

1. **Read the last loop's critiques.** Look for the signals above.
2. **Categorize the cause.** Most loop-4 failures match one of the
   five causes. Some match two.
3. **Pick the matching recovery move.** Apply it BEFORE starting
   another loop.
4. **If the diagnostic is unclear, stop the panel and merge.** A
   panel that cannot diagnose its own failure is not going to
   converge on another loop.

This procedure usually takes 15-30 minutes. It saves the hours
that another loop would burn.

---

## The "ship the imperfect" rule

A panel that has gone to Loop 4 has produced enough signal to ship
a defensible deliverable, even if the panel itself has not
converged. The operator's discipline at Loop 4:

1. Run the diagnostic
2. If a recovery move is clear, run one more loop with the move
   applied
3. If no recovery move is clear, stop the panel and merge from
   Stage 4 revisions using the best per-dimension signals

The wrong move: keep looping. A Loop 5 that is the same panel doing
the same work with the same disagreement does not produce
convergence; it produces three increasingly tired panelists and a
deliverable that does not get better.

The wrong move (other version): scrap the panel entirely and start
solo. Three loops of panel work produced real signal. Discarding it
to start over is sunk-cost panic. Use what the panel produced even
if you have to merge it imperfectly.

---

## Loop-4 failure modes in `agent-panel-planning`

The framework above is written for `agent-panel-review`. The same
five causes apply to `agent-panel-planning` with one addition:

### Cause 6 (planning-specific): no agent demonstrated dominance

**Diagnostic signal.** Stage 6 ratification cannot complete the
strength-matched task split because no panelist clearly dominated
any single dimension. The cross-critique is roughly symmetrical
across all three plans.

**Why it happens.** The agents are too similar (e.g. three sessions
of the same model with similar role prompts), or the dimensions of
the deliverable are too few to produce strength differentiation.

**Recovery move.** Two options:
1. **Operator takes ownership of all dimensions** and the panel's
   role becomes critique-during-execution. The plan is the operator's;
   the panelists are reviewers.
2. **Re-frame the deliverable with more dimensions** so strength
   differentiation has surface area. Then re-run from Stage 2.

The wrong move: assign tasks arbitrarily to make the matrix look
balanced. Bandwidth-based assignment defeats the empirical-strength
rule.

---

## When to retire a panel after Loop 4

Some panels should not be re-run on the same deliverable. Signals:

- The diagnostic comes back as "all five causes apply." The frame
  was too broad AND a hidden assumption AND wrong composition AND
  scope creep AND fatigue. This is not a recovery situation; this
  is a "ratify what you have or abandon" situation.
- The deliverable's complexity has grown so much that a single
  panel cannot resolve it. Split into multiple smaller deliverables,
  each with its own panel.
- The operator notices the panel is producing convergence-theater
  at this point: agreement that nobody believes. Stop, ratify
  whatever has the most defensible signal, and ship.

A retired panel is not a failed pattern. It is honest
acknowledgement that the question was harder than the panel was
sized for. The deliverable still ships; it just ships from a
narrower base.
