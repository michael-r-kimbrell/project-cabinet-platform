# agent-panel-planning: When to Convene

A planning panel is upstream of `agent-panel-review`. Review evaluates a
deliverable; planning shapes what gets built and who builds what. Pick
the right tool for the moment.

---

## Convene a planning panel when at least one is true

1. **The plan itself is the question, not just the execution.** What gets
   shipped, what gets cut, what gets sequenced first. If you do not yet
   know the right shape of the deliverable, you need planning, not
   review.

2. **Multiple agents have genuinely different framings of the problem.**
   You can sense this when single-agent first passes feel locally
   complete but miss something the other framings would catch. The
   independent framings are where planning value sits.

3. **The work will be divided across agents and you need strength-matched
   routing.** Without a planning panel, work assignments default to
   preset roles. With one, assignments are empirical: whoever
   demonstrated dominance on a dimension owns that dimension.

4. **An operator wants to test their own framing against independent
   reframings.** This is the operator-humility case: you suspect your
   own framing has gaps and you want the panel to catch them before
   execution locks them in.

5. **The deliverable is high-stakes and durable, and the cost of being
   wrong about scope exceeds the cost of the panel.** Major releases,
   irreversible architectural choices, public commitments.

---

## Do NOT convene a planning panel when

1. **The plan is obvious and only execution matters.** Skip planning,
   go straight to execution. Use `agent-panel-review` on the drafts
   that emerge.

2. **One agent has already framed the problem well.** Run
   `pressure-test` or `nod-protocol` on that agent's framing instead.
   The planning panel produces breadth; if you already have a strong
   single framing, you need depth instead.

3. **Time pressure dominates accuracy.** A planning panel takes
   meaningful operator time (framing, holding seals, surfacing
   decision points, running votes). For time-critical work where the
   cost of waiting exceeds the cost of being wrong, single-agent
   plans are correct.

4. **The decision is reversible at low cost.** Trying a refactor for
   two hours and reverting is cheaper than convening a planning panel
   on whether to refactor.

5. **You already know the answer and want validation.** A planning
   panel that confirms a foregone conclusion is performance. Just write
   the plan.

---

## Planning vs review: pick one

| Question | Skill |
|---|---|
| "What should we build, and who is best at what?" | `agent-panel-planning` |
| "Is what we built any good?" | `agent-panel-review` |
| "What might go wrong with this plan?" | `pressure-test` or `consequence-simulation` |
| "Is there a strong opposing view to this plan?" | `nod-protocol` |
| "Should this even be AI's job?" | Field guide Chapter 30  -  When NOT to use AI |

---

## Operator-humility patterns

The most common reason to convene a planning panel: the operator
suspects their own framing is incomplete and wants wider perspective
input. Phrases that signal this in operator self-talk:

- "I am not sure if this is the right approach"
- "I want a second opinion before I commit"
- "What am I missing here"
- "This feels high-stakes and I do not want to walk it back"
- "I have a draft plan but I want to test it against alternatives"

When the operator says (or thinks) any of these, the kit's discipline
is to offer the panel. The router watches for these patterns and
prompts the offer. See the "Panel offer triggers" section in
`doctrine/skills/request-router/SKILL.md`.

The operator can always decline ("I want to think alone first," "this
is below the panel threshold"). Declining is healthy. Routinely
declining means the threshold should rise; routinely accepting means
the threshold should fall.

---

## Two-panelist planning panels

Three is the default. Two works if the work genuinely has two distinct
dimensions (e.g. voice / mechanics, or product / engineering). With
two panelists:

- Stage 3 cross-feedback becomes a one-to-one exchange
- Stage 4 cross-suggestions go in both directions (each agent proposes
  paths for the one other agent)
- Stage 5 reconvene is the two-agent version of the same move
- Stage 6 voting: operator's vote breaks ties; the panel is advisory
  by definition with only two agents

Two-panelist panels are appropriate for:
- Time-constrained planning where three sessions are too much overhead
- Work that genuinely has two dimensions
- Operator wants a sanity-check rather than a multi-frame convergence

---

## Larger panels (four or more agents)

Four-or-more agent panels are usually too many. The marginal value of a
fourth panelist rarely justifies the orchestration cost. Stage 4's
cross-suggestions in particular become unwieldy: each agent has to
propose paths for three other agents, producing 12 cross-suggestion
documents per loop.

When a fourth agent IS justified:
- The work has four genuinely distinct dimensions
- One panelist will not be available for all stages and a replacement
  needs to slot in
- The operator wants explicit cross-platform breadth (e.g. one each of
  Claude, Codex, Kiro, Gemini)

For most work, three is the sweet spot. Reduce to two for time pressure;
do not expand to four unless the work genuinely warrants it.

---

## Standing panels vs convened panels

The default in this kit is the **convened panel**: assemble the
panelists for a specific deliverable, run the protocol, dissolve. This
file has been covering convened panels.

A **standing panel** is the other model: two or three agents in
permanent operating relationship, with defined standing roles, used
as the default operating structure rather than as a per-deliverable
convening. Each new question goes through the standing panel without
the framing-and-seal overhead of a convened panel.

The trade-off:

| Aspect | Standing panel | Convened panel |
|---|---|---|
| Convening cost | Near zero (always available) | Real (framing, seal-setup) |
| Role posture | Refined over time, accumulated context | Per-deliverable role flexibility |
| Cross-context memory | Yes (the panel knows prior decisions) | No (each panel starts fresh) |
| Drift risk | Roles can ossify; one panelist can dominate | Lower (composition can change) |
| Sustaining discipline | High (the panel must stay engaged) | Lower (panel exists only for one job) |
| Best for | Steady-state work with persistent collaborator | Episodic high-stakes deliverables |

A standing panel is stronger than a convened panel **if you can
sustain the discipline**. The strong-form discipline includes: keeping
both panelists engaged on every non-trivial decision, naming the
operator's adjudication role explicitly (the operator owns the merge
in standing operation just as in convened), and resisting role
ossification (occasionally swap roles to keep the postures fresh).

If you cannot sustain the discipline (the panel becomes one agent
plus an echo), convened panels per high-stakes deliverable are the
right pattern.

This trade-off was surfaced during cross-kit review.[^adam-federman]
The convened-panel default in this file is correct for most users;
the standing-panel option is worth considering for users who have a
persistent multi-agent operating relationship.

---

## The retrospective question

After each planning panel ships, run this retrospective:

1. **Did the panel surface framings I would not have found alone?**
   If yes, the panel earned its cost.
2. **Did the panel converge too fast (loop 1)?** Usually means the
   framing was clearer than the panel suggested at start; could have
   skipped planning.
3. **Did the panel fail to converge (Stage 5 still wide open)?**
   Usually means the framing was too broad; narrow the question, re-run.
4. **Did the strength-matched task split hold up during execution?**
   The honest test: when escalations happened, did the assigned owner
   handle them, or did they bounce back to the panel?
5. **Would I run a planning panel on this kind of deliverable again?**
   This is the calibration question. Update the threshold.

Over time, the operator's threshold for convening planning panels
should sharpen. Early in panel-use, you will convene too often. After a
few panels, you will know.
