# Autonomy ladder (how much unsupervised scope)

A delegation-scope axis, orthogonal to capability and cost. Adapted from the
SAE-style L1 to L5 ladder in the autonomous-agent literature. Capability and cost
pick *which* agent; autonomy picks *how much* unsupervised scope that agent gets.

| Level | Scope of the delegated decision | Human role | Example |
|---|---|---|---|
| L1 Autocomplete | token or line continuation | drives every step | inline code completion |
| L2 Task execution | one task, each action approved | approves each action | a single edit reviewed before apply |
| L3 Multi-step with checkpoints | 10 to 100 actions toward a goal | sets goal, reviews at checkpoints | a scoped multi-step task, a bounded loop |
| L4 Bounded full autonomy | runs to a goal, self-corrects, ships an artifact | sets goal, evaluates the final output | an autonomous run behind a guard, an overnight pipeline |
| L5 Self-directed | chooses its own problems across a portfolio | sets the area only | not granted to any agent by default |

## The routing rule

Every delegation names an autonomy ceiling, not just a target agent. The ceiling
is set by **reversibility and blast radius**, not by agent capability:

- Irreversible or IP-touching work caps at L2, no matter how capable the agent.
- Reversible, sandboxed, mechanically-verifiable work earns L4.
- Default conservative and raise the ceiling deliberately.

## Graduated autonomy

Autonomy is earned and revocable. An agent earns a higher ceiling on a work-class
through demonstrated reliable behavior, and the ceiling drops automatically when
a safety boundary is approached. Kill switches and a spend or work guard are the
mechanisms that make a high ceiling safe to grant.

The ceiling should travel with the work item, not just live in doctrine. Carry an
explicit autonomy level on the task record (the dispatch file, the loop spec, the
authority ladder) so the limit moves with the work, not with the agent.
