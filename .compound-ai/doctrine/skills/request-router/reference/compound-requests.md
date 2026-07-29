# request-router: Compound Request Recipes

Some requests need more than one skill. Apply in sequence.

| Pattern | Skill chain |
|---|---|
| Analysis requests | `parallel-lens-synthesis`, then `consequence-simulation` |
| Decision requests | `consequence-simulation`, then `simulation-to-action-bridge` |
| Adversarial review of a plan | `pressure-test`, then `cross-domain-translation` for audience framing |
| Hard decision under uncertainty | `parallel-lens-synthesis`, then `nod-protocol` on the synthesis, then `simulation-to-action-bridge` |
| High-stakes deliverable start-to-finish | `agent-panel-planning` to converge on the plan, then `agent-panel-review` on the drafts, with `nod-protocol` on any contested decision |
| Full strategic cycle | `parallel-lens-synthesis`, `consequence-simulation`, `simulation-to-action-bridge` |
| Durable goal execution | `goal-runner`, then relevant capability skill, then `quality-gate` |
| Existing-project adoption | `adoption-captain`, then `goal-runner` for follow-on work |
| Pre-ship release verification | `release-captain` runs the ten-step ship gate; `agent-panel-review` if the deliverable also warrants editorial review |

## How to apply a chain

Run the first skill to completion before invoking the second. Each
skill's output becomes context for the next. Do not interleave the
skills. The sequence matters.

If a chain step returns "do not proceed" (e.g. `pressure-test` finds a
fatal flaw, or `nod-protocol` exits at Gate 5 with refusal), stop the
chain. Do not run downstream skills on a deliverable that failed an
upstream gate.

## When to break the chain

A compound request becomes a single-skill request when:
- One skill's output is sufficient for the operator's purpose
- The operator explicitly says "just one" (e.g. "just pressure-test this")
- Time pressure makes the chain expensive without proportional gain

In all other cases, run the chain. Compound patterns earn their cost
when the request signals real complexity.
