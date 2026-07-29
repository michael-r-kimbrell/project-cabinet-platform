# Goal Loop Capability
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

The goal loop capability combines a verifiable finish-line contract with a
budget ceiling and a no-progress halt rule. It ensures every multi-step task
has an observable completion condition and a mechanical stop.

## 1. Contract

The capability guarantees:

1. A task with a GoalContract does not return `status="done"` unless the
   completion condition is verifiably met or the adapter explicitly cannot
   evaluate it (in which case `halt_reason` says so).
2. If the budget ceiling is reached before the completion condition is met,
   the task halts with `status="halted"` and records progress to date.
3. If two consecutive iterations produce no measurable progress (no-progress
   rule), the loop halts rather than spinning.
4. Completion evaluation is performed by a checker that did not produce the
   output being checked (the separate-evaluator principle). In a single-agent
   runtime this means the evaluation prompt is distinct from the generation
   prompt.
5. The loop integrates with usage-discipline: the budget ceiling here and the
   `USAGE_GUARD_BLOCK_PCT` ceiling in usage-discipline are both active; the
   tighter ceiling wins.

## 2. GoalContract structure

```
GoalContract:
  objective         : string   - what should be true when the work is done
  completion_condition: string - observable condition a separate evaluator checks
  validation        : string[] - commands, rendered checks, or gates to run
  context_budget    : string[] - files/pointers to load; keep minimal
  stop_conditions   : string[] - additional halt triggers beyond the defaults
  memory_update     : string?  - state/log/backlog updates to record at closeout

BudgetHint (in adapter-contract dispatch input):
  pct_ceiling       : number?  - halt when usage_pct >= this value
  cost_ceiling      : number?  - halt when cost estimate >= this value
  iterations        : number?  - halt after this many loop cycles
```

## 3. Loop execution model

```
for each iteration:
  1. Check usage-discipline. If blocked, halt with status=halted.
  2. Check budget.iterations. If exhausted, halt with status=halted.
  3. Execute the task prompt for this cycle.
  4. Run completion_condition evaluation (separate evaluator).
  5. If completion_condition met and validation passes: return status=done.
  6. Compare iteration output to previous. If identical (no progress): increment
     no-progress counter. If counter >= 2: halt with status=halted.
  7. Otherwise: continue.

On halt: record memory_update with progress to date, remaining validation gaps,
and the halt trigger.
```

## 4. Inputs / Outputs

Inputs are the `task` object from `adapter-contract.md` plus a populated
`goal` (GoalContract) field and optional `budget` (BudgetHint) field.

```
Output additions over base adapter result:
  iterations_run  : number    - how many cycles completed
  completion_met  : boolean?  - true if condition was evaluated and passed
  no_progress_halt: boolean   - true if the no-progress rule triggered the halt
```

## 5. Relationship to doctrine/contracts/goal-contract.md

`doctrine/contracts/goal-contract.md` is the operator-facing template for
writing GoalContracts. This capability file defines the runtime behavior that
enforces them. They are in sync: every field in the template has a corresponding
enforcement point here.

## 6. Reference implementation

Portable goal-runner (any runtime): `doctrine/skills/goal-runner/SKILL.md`.
The SKILL.md implements the loop above in instruction form, suitable for
prompt injection.

Claude-code runtime: the goal adapter (`runtime/claude-code/goal-adapter.md`) is
the Claude-side surface. It maps native `/goal` onto this capability and wires in
the goal-runner strengths: the usage-guard hook (`runtime/claude-code/hooks/usage-guard.sh`)
provides the mechanical block at the `USAGE_GUARD_BLOCK_PCT` threshold, turning
the budget ceiling into a hard hook-level stop, while the goal text injected
alongside `/goal` carries the no-progress halt rule and the separate-evaluator
completion check.

## 7. Capability parity: native /goal vs portable goal-runner

Two surfaces implement this capability: Claude Code's native `/goal` command and
the portable goal-runner that any agent honors. They are reconciled to the union
of best-of-both. The portable goal-runner stays the canonical CONTRACT; native
`/goal` is the Claude-side surface of the same capability, not a dumber shim.

| Dimension | Native /goal (Claude Code) | Portable goal-runner | Best-of-both reconciliation |
|---|---|---|---|
| Cross-turn continuation | Host drives the loop automatically across turns with no re-prompt | Operator or agent re-invokes the next unit by hand | Contract documents the continuation affordance; the generic adapter approximates it with an explicit act/validate/continue loop |
| Completion evaluation | Built-in small evaluator model decides done | Separate-evaluator principle stated (checker is not maker) | Native keeps its auto-evaluator; the adapter feeds it an explicit completion_condition so the check is auditable, not implicit |
| Budget ceiling | No explicit spend ceiling; runs until the evaluator stops | Explicit budget_pct wired to the usage-guard hook (mechanical deny) | Native /goal exposes the same ceiling: the runtime adapter wires budget_pct into usage-guard.sh so the Claude side halts on a hard block too |
| No-progress halt | Not guaranteed; can spin on repeated output | Halt after 2 no-op or repeated-rejected iterations | Native /goal exposes it: the runtime adapter injects the no-progress halt rule into the goal text |
| Validation discipline | Left to the evaluator's judgment | Validates the rendered, user-visible contract; lanes and slow-lane quarantine | Contract documents rendered-validation and lanes; both surfaces honor it |
| Memory closeout | Not built in | Memory update recorded at closeout | Both surfaces honor the closeout step |
| UX surface | First-class `/goal` command and session persistence | Prose contract any agent can run | Native is the Claude-side surface; portable is the canonical contract every agent honors |

### Reconciliation direction

- What native `/goal` does better (continuation and automation affordances): the
  portable contract in `doctrine/contracts/goal-contract.md` documents it, and
  the generic adapter in `runtime/generic/` approximates it through an explicit
  manual loop.
- What the portable goal-runner does better (explicit budget ceiling wired to
  usage-discipline, no-progress halt, separate-evaluator completion check):
  native `/goal` exposes it through the Claude-side goal adapter at
  `runtime/claude-code/goal-adapter.md`.

### Host rules supersede

This capability is not a replacement for host project rules. Where a host
runtime's own goal, continuation, or budget configuration conflicts with this
contract, the host rules win. The adapter wires the kit's ceilings in as
defaults the operator can tune per host; it never overrides an explicit host
policy.

## 8. Conformance test

```
CT-GL-1  A task with a GoalContract whose completion_condition is already met on
         iteration 1 returns status="done" and iterations_run=1.
CT-GL-2  A task with budget.iterations=2 that does not meet the completion_condition
         returns status="halted" after 2 iterations with a non-empty halt_reason.
CT-GL-3  Two consecutive identical outputs trigger no_progress_halt=true and
         status="halted".
CT-GL-4  A task with no GoalContract supplied completes without error on the
         goal-loop hook and returns completion_met=null (absent).
CT-GL-5  When usage-discipline blocks during iteration 2, the loop returns
         status="halted" with the usage block as halt_reason and records
         memory_update with work completed in iteration 1.
CT-GL-6  The completion evaluator prompt is distinct from the generation prompt
         (verified by inspection of the reference implementation).
```
