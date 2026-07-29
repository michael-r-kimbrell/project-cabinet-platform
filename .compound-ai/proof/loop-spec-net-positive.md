# Proof: the loop spec is net-positive

A goal-and-loop contract is only worth its overhead if it changes what the run
actually does. This artifact contrasts two runs of the same recurring job: one
naive, one governed by a loop spec whose budget ceiling is wired to a real hook.
The difference is mechanical, not aspirational.

## The two runs

### Baseline: naive loop, no contract

A recurring job is started with a prompt and a schedule and nothing else. There
is no goal contract, no stop condition, no iteration cap, and no budget ceiling
the runtime can enforce. The agent is asked, in prose, to "be efficient."

What happens:

- No explicit stop condition, so the run keeps finding more to do.
- No iteration cap, so it fans out work into more work.
- The only real limit is the usage cap itself. The run spins until it exhausts
  the budget window, then stops because it has to, not because it is done.
- The operator inherits a half-finished result and a spent window.

"Be efficient" is a request, and a request is not a limit. This is the failure
mode that hardened the enforcement layer in the first place: a multi-agent run
allowed to fan out without a ceiling ran its budget to exhaustion before it was
stopped. See `docs/ENFORCEMENT-PROVENANCE.md`.

### Kit run: loop spec with the budget ceiling wired to a hook

The same job runs under a loop spec. The contract names a goal, a stop
condition, an iteration cap, a no-progress rule, and a budget ceiling. The
budget ceiling is not prose: it is wired to the usage-cap gate in
`usage-guard.sh`. Before the loop spawns more delegated work, the gate reads
the current usage proxy with `usage-guard.sh pct` and blocks the spawn once it
crosses the configured `USAGE_GUARD_BLOCK_PCT` (default 90). The halt is a hook
decision, visible in the hook log, not a behavior the agent has to remember.

The "after" half is taken from a real, in-production loop spec,
`loops/lessons-review.spec.md` (scrubbed). Its contract:

| Field | Value |
|---|---|
| Goal / stop condition | at most 3 evidenced proposals plus 1 digest file; an empty week is a valid result |
| Max iterations | 1 pass / 20 turns / 3 proposals |
| No-progress rule | nothing clears the durable, non-obvious, evidenced bar means digest only |
| Budget ceiling | a single weekly session |
| Verification | the human ratifies; the loop proposes, never ratifies |
| Autonomy ceiling | propose-only on doctrine |

Every one of these is a brake the naive run did not have. The stop condition can
be satisfied early (an empty week is a valid result), the iteration cap bounds
the worst case, and the budget ceiling is backed by a hook that blocks rather
than asks.

## Why this is net-positive

| Dimension | Naive loop | Loop spec + wired ceiling |
|---|---|---|
| Stop condition | implicit (budget exhaustion) | explicit, can satisfy early |
| Worst-case cost | the full usage window | bounded by iteration cap and block threshold |
| Budget limit | a prose request | a hook decision (`usage-guard.sh` block) |
| Failure mode | half-done work, spent window | partial, resumable, under ceiling |
| Operator load | inherits a runaway | inherits a bounded, verifiable result |

The overhead of the contract is a few lines of front matter. The payoff is that
the run cannot quietly become the incident that created the enforcement layer.

## Mechanism: the budget ceiling is a real block

The wiring is the point. `usage-guard.sh` runs as a PreToolUse hook on
`Agent` and `Workflow` spawns. Its `pct` mode returns the current usage proxy
(fail-open to -1 when the probe is unavailable, so it never blocks legitimate
work). Its `block` mode denies the spawn once the proxy is at or above
`USAGE_GUARD_BLOCK_PCT`. The loop spec's budget ceiling points at the same gate,
so "stop at the ceiling" is enforced by the same control for an interactive
session and for a scheduled loop.

### Hook-block log reproduction

The `usage-guard.sh` hook is vendored under Apache-2.0 (adapted from Joshua
Sutcliff's public claude-config, github.com/joshuadsutcliff; see
`runtime/claude-code/NOTICE`) and wired in `runtime/claude-code/`. This capture
uses the checked-in threshold-crossing workflow fixture.

Reproduction command:

```sh
USAGE_GUARD_NOTICE_FILE=/tmp/compound-ai-proof-usage-guard.notice \
  bash runtime/claude-code/hooks/usage-guard.sh block \
  < enforcement/tests/fixtures/usage-guard/workflow-cap-hit.json
```

Input fixture: `enforcement/tests/fixtures/usage-guard/workflow-cap-hit.json`.
It sends a `Workflow` PreToolUse payload with `estimated_usage_pct` set to 95.

Actual output:

```json
{"decision":"block","reason":"usage block threshold reached","usage_pct":95}
```

Exit status: `2`.

This is the real block emitted by the hook for the checked-in fixture. The proof
claim is limited to wiring and enforcement behavior: a threshold-crossing
workflow spawn is denied by the hook.
