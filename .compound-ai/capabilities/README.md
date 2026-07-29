# Capabilities
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Runtime-agnostic capability contracts. Any agent runtime that implements these
files satisfies the kit's behavioral guarantees. No runtime is privileged.

## Files

| File | What it defines |
|------|-----------------|
| `adapter-contract.md` | The shared `dispatch(task) -> result` interface and capability hook order. Start here. |
| `usage-discipline.md` | Tunable, fail-open spend/work ceiling. Blocks delegation when budget is exhausted. |
| `session-routing.md`  | LIGHT/MEDIUM/HEAVY tier classification. Injects a context directive before execution. |
| `goal-loop.md`        | Verifiable finish-line contract + budget ceiling + no-progress halt. |
| `team-routing.md`     | Team edition org layer: distill intake, route workstreams, ledger, Command Center. |

## How any agent implements these

### Step 1: implement dispatch()

Your adapter must accept a task and return a result matching the schema in
`adapter-contract.md` (section 2). The four fields that must always be present:
`id`, `status`, `output`, and (when status is not "done") `halt_reason`.

### Step 2: wire the pre-execution hooks

Before running the task:

1. Call `session-routing` with the task prompt. Attach the returned `directive`
   to the agent's context for this call.
2. Call `usage-discipline` with the tool name and any budget hints. If it
   returns `decision="block"`, stop and return `status="halted"`.

### Step 3: wire the post-execution hook

After the agent produces output:

3. If the task included a `GoalContract`, run the `goal-loop` completion check.
   If the condition is not met and the budget allows another iteration, loop.
   Otherwise return the appropriate status.

### Mechanism is yours to choose

Each runtime uses its own mechanism for these three steps. The kit ships:

- `runtime/claude-code/` - bash hooks, wired via `PreToolUse` and
  `UserPromptSubmit`. Full hard enforcement.
- `runtime/codex/` - AGENTS.md directives + a wrapper.
- `runtime/cursor/` - rules file + wrapper.
- `runtime/generic/` - prompt-prelude injection. Works for any agent that can
  accept a system prompt. This is the graceful-degradation path.

See `runtime/README.md` for conformance status per runtime.

## Conformance

A runtime is conformant when the numbered tests in each capability file pass
(CT-AC-*, CT-UD-*, CT-SR-*, CT-GL-*). Run `enforcement/tests/run-selftest.sh`
to verify the claude-code runtime. Other runtimes add entries to the same
self-test file.

## Fail-open principle

Every capability hook fails open when it cannot run or cannot determine the
answer. A broken hook never silently kills a task. The one exception: a
`usage-discipline` `block` decision is always a hard stop, because that is the
point of having the ceiling.
