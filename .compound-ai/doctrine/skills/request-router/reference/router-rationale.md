# request-router: Rationale

Why the router has three modes, why judgment beats phrase-list, and
why the kit ships its own dispatcher rather than relying on agent
intuition.

---

## Why three modes

The router is the single entry point that every request passes through
before the agent responds. Three modes handle three distinct cases:

1. **Routing table.** Explicit matches on skill triggers. Auto-invoke,
   no operator confirmation. This is the bulk of the router's work
   and it is deterministic.

2. **Panel Offer fast-path.** Explicit panel/council phrasings.
   Auto-invoke the panel skill, no offer prompt. The operator named the
   tool; just use it.

3. **Panel Offer judgment.** Borderline cases where the operator
   signals council-tier intent without naming the tool. Apply
   criteria; offer the panel; let the operator opt in.

Without mode 3, the kit would either spam panel offers on every
"what do you think?" or never offer panels at all. Neither is correct.
The criteria-based judgment is what allows the agent to be responsive
without being naggy.

---

## Why judgment, not pattern matching

The earlier v2.2.0 router used phrase-list pattern matching for panel
offers. It triggered on phrases like "I'm not sure" and "your
thoughts?" -- which are normal collaborative dialogue, not
council-tier intent.

The v2.3.0 refactor replaced the phrase list with five explicit
criteria. The criteria are stable; the phrasings that match them drift
over time.

Three reasons criteria beat phrase lists:

1. **Substring matching is brittle.** "I keep going in circles" and
   "I've been spinning on this all day" are the same intent in
   different words. A phrase list catches one and misses the other.
   Criteria-based judgment catches both.

2. **Criteria document the judgment.** A phrase list is the answer
   without the question. Criteria explain why a phrase matches, which
   means an agent can apply judgment to novel phrasings.

3. **Criteria are auditable.** When the operator says "you offered a
   panel when I just wanted to chat," the criteria let you trace
   exactly which criterion fired and adjust. A phrase list does not
   surface that audit trail.

---

## Why the agent is the classifier (not an external hook)

The router is read by the agent at session start. There is no separate
runtime that intercepts requests. The agent IS the dispatcher; the
router file teaches the agent what to dispatch.

This matters because:
- No infrastructure dependency: the kit works with any agent that can
  read markdown
- Criteria evolve with the agent's understanding, not with a parser
- The agent can apply judgment to ambiguous cases, which a strict
  hook cannot

The cost: discipline. The agent must actually apply the criteria
before responding. The router file's job is to keep that discipline
top-of-mind by being short, declarative, and loaded at session start.

---

## Why the registry is canonical

Every active skill in the kit has at least one entry in
`trigger-registry.yaml`. This is intentional: the router can stay short,
while the routing surface remains complete and machine-readable.

The cost: the registry must be maintained. That is why v2.6.0 adds
`trigger-indexer`, which checks active `SKILL.md` files, pointer paths,
and count math whenever skills change.

---

## Why fast-path AND judgment-mode panel routes coexist

Some operators explicitly say "convene a panel." That phrasing is
deterministic; auto-invoke is the right behavior. Asking "are you
sure you want a panel?" after the operator said "convene a panel" is
friction without value.

Other operators signal council-tier intent without naming the tool
("I keep going back and forth on this; what do you think?"). For
those, the operator should be offered the panel, not silently routed
into one. The judgment mode handles the second case.

The two modes share the underlying panel skills (`agent-panel-planning`
and `agent-panel-review`). The difference is in how the request gets
to them: explicit invocation vs offered-and-accepted.

---

## Why compound requests get a separate reference

The compound-request recipes in `reference/compound-requests.md` are
not auto-invoked. They are documentation for the operator: when this
kind of request lands, these are the skill chains worth running.

The recipes are not in the routing table because:
- Routing-table matching is single-skill per row by design
- Compound chains require operator awareness (the chain takes longer
  than a single skill)
- Some compound chains are situational; the recipe is the starting
  point, not a strict prescription

When the agent recognizes a compound-request pattern, it should
surface the chain as a suggestion ("this looks like a hard-decision-
under-uncertainty request; the recipe is parallel-lens-synthesis →
nod-protocol → simulation-to-action-bridge -- want me to run that?")
rather than silently invoke all three.

---

## What the router does NOT decide

The router does not decide:
- Which agent runs each skill (that is operator/runtime, not the
  router)
- How long to spend on a skill (skill-specific protocols handle that)
- Whether a deliverable is ready to ship (`release-captain` handles
  that)
- Whether the operator is qualified for a given decision (out of scope)
- Whether to escalate to a human (out of scope; agents proxy to the
  operator who is human by definition)

The router is the dispatcher. Everything else lives in the skills it
dispatches to.

---

## Source references

- `_skills-index.md` -- complete skill registry, both infrastructure and capabilities
- `doctrine/tiers/AGENT-tier1.md` -- tier-level operating rules
- `AGENT.md` (root) -- model routing table
- `agent-panel-planning/reference/when-to-convene.md` -- the threshold guide for panel-offer responses
- `agent-panel-review/reference/critique-format.md` and `scorecard-rubric.md` -- panel review output formats
