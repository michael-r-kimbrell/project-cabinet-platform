# Cost-tier routing (which agent, which model)

Route work by capability and cost, not by habit. Two layers: pick the agent for
the work-class, then pick the model tier for the task within it.

## Cost principle

Cheapest capable option first. Local and free where quality allows; paid
subscription budgets where they genuinely improve the result; avoid open-ended
metered pay-per-token. The conductor (the orchestrating agent) runs on a cheap
tier for mechanical confirmations and on the full tier only when the call has
consequences.

## Agent by work-class

Match the work-class to an agent role, not a brand. A fleet typically has:

| Work-class | Agent role |
|---|---|
| Read-only investigation, evidence gathering | a research worker (read-only) |
| Spec-driven, sequential multi-file implementation | a spec implementer |
| IDE-native iterative edits, frontend feasibility | an interactive build agent |
| Strategy, synthesis, narrative, cross-context judgment | the conductor / orchestrator |
| Hostile outside-view audit, premise checks | an independent auditor (a different model) |
| Grunt work: feed pulls, file moves, log scans | the cheapest local lane |

Seat from evidence and task shape, not habit. Record why each agent was chosen
and why benched agents were left out. Not every effort needs every agent; small
or low-stakes work runs lean.

## Model tier by task

This mirrors `doctrine/contracts/model-routing.md`. Define the table once per
project; do not make routing decisions inline.

| Task type | Model tier |
|---|---|
| Classification, extraction, formatting | local / smallest |
| Mechanical edit (copy, rename, no logic) | fast / cheap |
| Multi-file implementation (real judgment) | mid tier |
| Core synthesis (the primary value) | full tier - do not cheap out |
| Conductor on clean confirmations | fast / cheap |
| Conductor on design reviews | full tier |
| Session-start context loading | not an LLM call - read the file |

## Anti-patterns

- Full-tier model for classification: 5 to 10x cost, no quality gain.
- An LLM call to summarize what a file already says: load the file instead.
- One model for every task: overpays on the cheap ones.
- Routing decided inline: inconsistent and unauditable. Centralize the table.
