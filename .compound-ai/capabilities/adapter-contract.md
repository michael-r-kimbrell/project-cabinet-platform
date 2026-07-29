# Adapter Contract
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Every runtime adapter satisfies this contract. No runtime is privileged.
The contract is runtime-agnostic: it describes shape and obligations, not mechanism.

## 1. Contract

An adapter is a runtime-specific module that:

1. Accepts a task from the operator or orchestrator.
2. Applies the three capabilities before and after execution: usage-discipline, session-routing, goal-loop.
3. Returns a structured result.
4. Fails open on any capability error (never silently swallows a task).

The adapter does not own policy. Policy lives in the capability contracts.
The adapter owns only the wiring from task to capability to result.

## 2. Interface shape: dispatch(task) -> result

```
Input (task):
  id        : string          - unique task identifier (caller-assigned)
  prompt    : string          - the work to be done
  goal      : GoalContract?   - optional structured goal (see goal-loop.md)
  context   : string[]        - paths or blobs the agent should load
  budget    : BudgetHint?     - optional: {pct_ceiling, cost_ceiling, iterations}

Output (result):
  id        : string          - echoed from input
  status    : "done" | "halted" | "blocked" | "error"
  output    : string          - the agent's response or artifact path
  usage     : UsageSummary?   - {pct_used, cost_estimate} if measurable
  halt_reason: string?        - populated when status is not "done"
  memory_update: string?      - state the caller should persist
```

Fields marked `?` are optional. An adapter may omit them if the runtime cannot
supply them. Consumers must treat absent optional fields as unknown, not zero.

### Status values

| status    | meaning |
|-----------|---------|
| `done`    | completion condition met and validation passed |
| `halted`  | budget ceiling or no-progress rule triggered a clean stop |
| `blocked` | adapter lacks required access or a genuine irreversible decision |
| `error`   | unrecoverable failure; task not completed |

## 3. Capability hooks

Before execution, the adapter MUST invoke:

1. `session-routing` - classify the task and attach the tier directive to context.
2. `usage-discipline` - check budget; block if ceiling is reached.

After execution, the adapter MUST invoke:

3. `goal-loop` completion check - verify the completion condition if a
   GoalContract was supplied.

Hook failures are non-fatal unless explicitly configured otherwise. On failure,
the adapter logs the failure reason and proceeds (fail-open). The exception:
`usage-discipline` returning `block` is always a hard stop.

## 4. Reference implementation

Full-enforcement reference: `runtime/claude-code/hooks/usage-guard.sh` (usage-discipline)
and `runtime/claude-code/hooks/session-router.sh` (session-routing).
These are the canonical bash implementations. Other runtimes may use any
mechanism that satisfies the same observable behavior.

Graceful-degradation path: `runtime/generic/` - prompt-prelude injection that
approximates each capability hook through instruction text alone.

## 5. Conformance test

A runtime adapter is conformant when all of the following pass:

```
CT-AC-1  dispatch() returns a result with all required fields (id, status, output).
CT-AC-2  A task submitted with budget.pct_ceiling=0 returns status="halted", not "done".
CT-AC-3  A task submitted without a GoalContract completes without error on the goal-loop hook.
CT-AC-4  A task with a GoalContract and an unmet completion condition returns status != "done"
         unless the adapter explicitly cannot evaluate the condition (in which case a warning
         appears in halt_reason).
CT-AC-5  The session-routing hook runs before execution and its tier directive appears in
         the agent's context or system prompt for that task.
CT-AC-6  An unparsable or empty task returns status="error" with a non-empty halt_reason.
```

These tests are exercised by `enforcement/tests/run-selftest.sh` for the
generic dispatcher and thin runtime wrappers. Claude Code hook-level coverage
is recorded under CT-UD and CT-SR in the same self-test.
