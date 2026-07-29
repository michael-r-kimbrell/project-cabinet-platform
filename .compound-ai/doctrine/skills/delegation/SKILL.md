# Skill: delegation
# Compound AI Operating Standards
# Authors: Cameron Sutcliff, Joshua Sutcliff (joshuadsutcliff)
# Source: github.com/cameronpsutcliff/compound-ai | License: Apache 2.0

## What this skill does

Routes work to the right agent or worker by capability, cost, and autonomy, then
dispatches it under a bounded contract. Folds three named worker roles (research,
generate, test) with cost-tier routing (conductor versus worker models) and the
autonomy ladder. Runtime-agnostic: any agent fleet, any model provider.

## Triggers

"delegate", "delegate this", "hand this off", "which agent should", "route this work",
"spawn a worker", "dispatch to an agent", "run this in parallel agents",
"research worker", "code generator", "test runner", "conductor or worker", "cost tier"

(Distinct from `request-router`, which routes a request to a *skill*. This skill
routes *work to an agent*.)

## Sub-routing (load only what the task needs)

| Intent | Role / mode | Load |
|---|---|---|
| Read-only investigation: scan repos, docs, logs, APIs | research worker | `reference/research-worker.md` |
| Bounded mechanical edits, patches, refactors | generate worker | `reference/generate-worker.md` |
| Run tests, reduce logs, classify failures | test worker | `reference/test-worker.md` |
| Pick which agent and which model tier | cost-tier routing | `reference/cost-tier-routing.md` |
| Decide how much unsupervised scope to grant | autonomy ladder | `reference/autonomy-ladder.md` |

## The two-axis rule

Route on two axes, not one. **Capability and cost** pick *which agent*.
**Autonomy level** picks *how much unsupervised scope* the agent gets. Name both
in every delegation. The autonomy ceiling is set by reversibility and blast
radius, not by how capable the agent is: irreversible or IP-touching work caps
low no matter the agent; reversible, sandboxed, mechanically-verifiable work
earns a higher ceiling.

## The worker contract (all roles)

Every delegated worker gets a fully self-specified task prompt and zero
conversation context, and returns the same evidence packet:

```
objective | findings | commands_run | uncertainties | stop_conditions_hit | outcome_status
```

`outcome_status` is one of success / partial / failure. A worker that hits a stop
condition reports partial; it does not guess past the boundary.

## Procedure

1. Name the work-class and its finish condition.
2. Route the agent by capability and cost (`reference/cost-tier-routing.md`).
3. Set the autonomy ceiling by reversibility and blast radius
   (`reference/autonomy-ladder.md`). Default conservative; raise deliberately.
4. Dispatch with the bounded contract: in-scope files, out-of-scope files, the
   evidence-packet shape, and the stop conditions.
5. Verify the returned packet before acting on it. Spot-check numeric claims.

## Checks

- Every delegation names both a target agent and an autonomy ceiling.
- The worker returned the evidence packet with an explicit `outcome_status`.
- Scope was a hard boundary: no out-of-scope edits; bleed reported as uncertainty.

## References
- `reference/research-worker.md` - read-only investigation contract
- `reference/generate-worker.md` - bounded code-editing contract
- `reference/test-worker.md` - test + log-reduction contract
- `reference/cost-tier-routing.md` - capability/cost routing and model tiers
- `reference/autonomy-ladder.md` - the L1 to L5 scope ladder and the routing rule
- `doctrine/contracts/model-routing.md` - the project model-assignment table
