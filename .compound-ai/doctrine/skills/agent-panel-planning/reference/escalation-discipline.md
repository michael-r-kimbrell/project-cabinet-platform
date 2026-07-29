# agent-panel-planning: Escalation Discipline (Post-Ratification)

The planning panel ends at Stage 6 ratification + task split. Execution
begins. This file covers the discipline that keeps execution honest:
when an agent hits a decision point during build that ratification did
not cover, escalate to the operator with the panel's prior context, not
to decide solo.

This is the operator-in-the-loop pattern, and it is what makes the
panel's plan durable through execution. Without escalation discipline,
agents drift from the ratified plan in ways the panel did not foresee
and the operator did not approve.

---

## The rule

During execution, an agent must escalate to the operator when ALL of
the following are true:

1. The agent has hit a decision point not covered by ratification
2. The decision would commit to one of multiple valid paths
3. The reversibility cost is non-trivial (rolling back means rework, not
   a quick edit)
4. The decision affects work assigned to other panelists (their downstream
   work depends on this choice)

If any of these is false, the agent decides solo and notes the decision
in the session log. If all four are true, escalate.

---

## What escalation looks like

When the agent escalates, it provides the operator with:

1. **The decision point.** Stated clearly, one or two sentences.
2. **The relevant ratification context.** What did the panel decide that
   touches this point? Cite the ratification document.
3. **The options the agent sees.** Two to four valid paths. The agent
   should NOT recommend one as the default before asking; that biases
   the operator.
4. **The blast radius.** What downstream work depends on this choice?
   Which other panelists' tasks are affected?
5. **The cost of waiting.** How urgent is this? Can the agent proceed
   on adjacent work while the operator decides?

**Format:**

```
ESCALATION

Decision point:
  [One or two sentences. What is the question?]

Ratification context:
  [Cite the relevant lock from Stage 6 ratification. If nothing in
   ratification covers this, say so explicitly.]

Options:
  A. [First valid path. One line.]
  B. [Second valid path. One line.]
  C. [Third valid path, if applicable.]

Blast radius:
  [What downstream work depends on this? Which panelists' tasks?]

Urgency:
  [Can the agent proceed on adjacent work? If not, why?]

Operator decision:
  [Operator fills in. The agent waits.]
```

---

## What NOT to escalate

The discipline is bounded. Agents should NOT escalate:

- **Reversible decisions.** A function name, a paragraph order, a section
  heading. If undoing it takes minutes, just decide.
- **Decisions ratification clearly covered.** Re-asking what the panel
  already decided wastes the operator's time and signals the agent did
  not absorb ratification.
- **Decisions inside the agent's own task domain.** If the agent owns
  "voice and foreword," foreword-internal choices stay with the agent.
- **Preference questions where the agent is genuinely indifferent.**
  Just pick and note.

Over-escalation defeats the panel by reverting all decisions to the
operator. The discipline is to escalate the right decisions, not all
decisions.

---

## What the operator does with escalations

When an escalation lands, the operator has three exits:

**Exit A: Decide and respond.** Pick an option, note the reasoning, send
back to the agent. The agent proceeds.

**Exit B: Mini-panel.** If the decision is genuinely contested, the
operator may run a fast mini-panel: send the escalation to the relevant
panelists, get one-line votes with reasoning, decide. This is the panel's
metabolism during execution.

**Exit C: Punt to next ratification.** If the decision is not blocking
(the agent can work around), defer to a later checkpoint. The escalation
becomes an open question logged for the next ratification touchpoint.

The wrong move: ignore the escalation. Silence is interpreted as
"proceed at your discretion," which means the agent decides solo and the
operator loses the loop.

---

## Why this discipline matters

In the v1 build, several decisions emerged mid-execution that the
ratified plan did not anticipate. The HG-2 incident (the foreword's
opening story) is the canonical example: the panel ratified a foreword
structure but did not lock the specific failure incident. During
execution, three candidates surfaced and the agents could not agree.

Two outcomes were possible:
- **Without escalation:** one agent decides, the foreword ships, the
  other two agents notice and either accept or reopen the debate
  after-the-fact, producing wasted revisions.
- **With escalation:** the agent flags the decision, the operator runs
  a mini-panel (which became the HG-2 debate), the panel converges on
  the WAL contention story, the foreword ships once.

The HG-2 debate was the escalation discipline working. It surfaced a
real decision point, the panel converged, the operator ratified the
mid-execution choice, and the work continued without rework.

---

## The agent's self-check

Before deciding solo on something that feels uncertain, the agent runs
this check:

1. Does ratification cover this? (If yes, follow ratification.)
2. Is this reversible at low cost? (If yes, decide and note.)
3. Does this affect other panelists' work? (If yes, escalate.)
4. Am I genuinely indifferent? (If yes, pick and note.)

If steps 1, 2, and 4 are no and step 3 is yes, the answer is
escalate.

---

## Anti-patterns

### Anti-pattern: silent solo decisions
**Symptom.** Agent decides on a covered-by-the-rule escalation point and
ships it without telling the operator. Other panelists discover later.
**Fix.** When in doubt, escalate. The cost of a quick operator check is
small. The cost of silent drift is large.

### Anti-pattern: escalation as helplessness
**Symptom.** Agent escalates every minor choice ("should I use semicolons
or commas in this list").
**Fix.** Run the self-check. Most of these are reversible at low cost or
inside the agent's own task domain.

### Anti-pattern: escalation without options
**Symptom.** "I am not sure how to proceed."
**Fix.** Escalation must name options. The agent has read the situation;
it should be able to name at least two valid paths. Naming options is
the agent's contribution to the decision.

### Anti-pattern: operator override of every escalation
**Symptom.** Operator overrides the panel's framing on every escalation,
imposing decisions the panel did not see.
**Fix.** Use the mini-panel exit when override is tempting. If the
operator routinely overrides without panel input, the panel's plan has
limited durability and v-next planning should narrow the panel's scope.
