# agent-panel-planning: Full Protocol

Six stages, operator-driven. No orchestrator agent. The operator holds the
seal between stages and surfaces decision points at Stage 6.

This protocol pairs with `agent-panel-review` (which runs once execution
begins). Planning ends when the plan is ratified and tasks are assigned;
review begins when first drafts of the deliverable land.

---

## Stage 1: Frame

**Operator action.** Write one prompt that:

1. Defines the problem (not the solution, the problem)
2. Names the constraints (timeline, budget, audience, irreversibility)
3. Lists what counts as a complete plan (deliverables, owners, dependencies, success criteria)
4. Asks each panelist to frame the WHOLE problem, not a slice

**The hard rule: framing the whole problem.** A panel where each agent
gets a different sub-question is parallelization, not planning. Each agent
must produce a plan that covers the same scope. The independent framings
are the point.

**Operator's role at framing.** State what is locked (Cameron's "six locked
decisions" pattern from v1) and what is genuinely open. Pre-locking too much
turns the panel into a rubber stamp. Locking too little produces drift.

**Common failure: leading the panel.** A frame that anticipates a specific
solution shape will steer all three plans toward that shape. Resist. Frame
the problem and the constraints; let the agents frame the solution.

---

## Stage 2: Independent plans (sealed)

**Operator action.** Send the prompt to each panelist in a separate session.
Wait for the full first-pass plan from each.

**What each plan must contain (minimum):**
- The problem framed in the agent's own words
- The structural spine of the proposed solution
- Decision points the operator should rule on
- Owners for each major piece (proposed, not final)
- Dependencies and sequencing
- Open questions the agent cannot resolve alone

**The hard rule: sealed independence.** No panelist sees another panelist's
plan during this stage. No shared scratchpad. No "here's what Codex is
thinking" cues from the operator.

**Why this matters.** The whole value of multi-agent planning is the
independent framings. If panelist B sees panelist A's plan, B anchors on
A's framing and the panel converges before the convergence is earned.

**Operator discipline:**
- Run sessions in genuinely separate contexts
- Do not summarize one plan to another agent
- If the seal breaks, restart that panelist's plan
- Same-platform panels (e.g. three Claude sessions) need especially tight
  session separation; verify the contexts are isolated

**Stage 2 output (per agent):** a complete proposed plan, sealed.

---

## Stage 3: Cross-feedback (with element-level votes)

**Operator action.** Send each panelist the full first-pass plans of the
others. Ask each to produce structured cross-feedback using
`reference/cross-feedback-template.md`.

**The hard rule: critique elements, not plans.** Whole-plan critique
becomes noise. Element-level critique with votes produces signal.

For each other plan reviewed, the cross-feedback covers:
1. Strongest claim (cite the section)
2. Weakest claim (name the vulnerability)
3. Shared blind spot (something this plan and yours both missed)
4. One thing worth stealing (concrete: a framing, a structural move)

Plus a **decision-point voting block** on specific elements the operator
surfaces during framing. Examples:
- Title or naming choice
- Structural spine (whose proposed spine is strongest)
- In-scope / out-of-scope boundaries
- Owner assignment for specific pieces
- Timeline plausibility

Each vote requires one-line reasoning. No bare votes.

**Operator discipline:** the operator chooses which decision points get
voted on. Three to seven is the sweet spot. Voting on everything dilutes
the signal; voting on nothing leaves no convergence path.

---

## Stage 4: Concession + private revise + cross-suggestions (sealed)

This is the load-bearing stage. Most panels skip the third part of it and
get averaging instead of convergence.

**Operator action.** Send each panelist its own cross-feedback (the
critiques the others wrote of its plan) plus the votes that touched its
plan. Ask each panelist to produce three outputs, sealed:

1. **Concession + attribution.** Explicitly name what is conceded and to
   which other agent on what dimension. Example: "Codex's spine wins on
   breadth (concede), my title was too Claude-specific (concede), Kiro's
   substance density on Part V is stronger than mine (concede)."

2. **Revised private plan.** The agent's own plan, revised to absorb the
   conceded points. Dissents on any unaccepted critique get one line of
   reasoning each. No 500-word defenses.

3. **Path-forward suggestions for the OTHER agents.** For each other
   panelist, propose specific adjustments their plan should make. This is
   the move that makes the panel collaborative rather than competitive.
   The agent is not just defending its own plan; it is helping the others
   improve theirs.

**The hard rule: sealed again.** Stage 4 is sealed. Each agent does this
work without seeing the others' revisions or cross-suggestions. The open
phase comes next, at Stage 5.

**Why the cross-suggestions matter.** Without this move, every agent
revises only its own plan. The panel produces three improved but still
distinct plans. With this move, each agent has been told by the other
two what they think the agent should do next, which means the Stage 5
reconvene has a richer information basis to converge on.

---

## Stage 5: Reconvene (read each other's revised plans + cross-suggestions)

**Operator action.** Send each panelist:
- The other panelists' revised plans
- The cross-suggestions the other panelists wrote FOR this panelist
- The cross-suggestions this panelist wrote for the others (for context)

Ask each panelist to produce a short response covering:
1. **Accepted suggestions.** Which of the cross-suggestions for me do I
   adopt? Brief one-line reason each.
2. **Rejected suggestions.** Which do I reject? One-line reason each.
3. **My adjusted position.** Where do I now stand on the contested
   decision points from Stage 3?

**The hard rule: no relitigation.** This is reconvene, not redebate.
Adopt accepted suggestions silently. Reject rejected ones tersely.
Re-stating one's original position is wasted motion.

**What the operator does at Stage 5.** The operator reads all three
responses and identifies remaining splits  -  decision points where the
panel still disagrees after the reconvene. Those become Stage 6's
voting block.

---

## Stage 6: Voting + ratification + strength-matched task split

**Operator action  -  voting.** Surface remaining contested decision
points. For each, request a final vote from each panelist with one-line
reasoning. The operator may add their own vote and reasoning (operator
humility: the panel is advisory, the operator decides).

**Operator action  -  ratification.** Lock the plan. Write a one-page
ratification covering:
- The final structural spine
- Locked decisions (with attribution to whoever proposed the winning move)
- Open questions deferred to execution
- Success criteria (what counts as done)

**Operator action  -  strength-matched task split.** Assign owners. The
rule: tasks go to whoever **demonstrated dominant capability on that
dimension in this round**, not to whoever has the role label.

Example from the v1 build:
- Structural spine → Codex (demonstrated breadth on the architecture)
- Substance body → Kiro (demonstrated density on technical content)
- Foreword + voice → Claude (demonstrated arc and attribution discipline)
- Cross-platform translation chapter → Claude (specifically proposed it)

The assignment is empirical, not categorical. The same agent in a
different panel on a different deliverable might get a different role.

**Stage 6 output.** Ratification document + task assignment table.
Execution begins with these as inputs.

---

## When to skip stages

- **Skip Stage 4's cross-suggestions** when the deliverable is small
  enough that each agent revising only their own plan is sufficient.
  This shortens the panel by one cycle but produces three improved
  plans rather than one converged plan.

- **Skip Stage 6's voting** when the reconvene at Stage 5 produces
  full convergence (rare). Go straight to ratification + task split.

- **Skip the whole skill** when you do not need a plan, you need a
  deliverable review. Use `agent-panel-review` directly.

---

## The companion: execution

This skill ends at ratification + task split. Execution discipline is
covered separately in `reference/escalation-discipline.md`. The short
version: during execution, when an agent hits a decision point that
ratification did not cover, escalate to the operator with the panel's
prior context. Do not decide solo on something the panel did not see.
