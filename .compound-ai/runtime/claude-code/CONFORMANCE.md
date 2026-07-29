# Claude Code adapter conformance

Claude Code is the full-enforcement adapter for the shared capability
contract. It is not privileged; it only has a richer hook surface.

## Mechanism

- `settings.fragment.json` wires `SessionStart`, `UserPromptSubmit`, and
  `PreToolUse`.
- `hooks/session-router.sh` implements session-routing on `UserPromptSubmit`.
- `hooks/usage-guard.sh` implements usage-discipline on `SessionStart`,
  `UserPromptSubmit`, and `PreToolUse`.
- `workflows/phased-review.js` is a capped workflow example, not required by
  the adapter contract.

## Contract mapping

- CT-AC-1 advisory: Claude Code returns native agent output; wrapper-like structured
  results are supplied by workflows that call this runtime.
- CT-AC-2 tested at hook level: `PreToolUse` usage guard blocks `Agent|Workflow` at the configured
  ceiling.
- CT-AC-3 advisory: no GoalContract is required for ordinary prompts.
- CT-AC-4 advisory: GoalContract checks are handled by the portable goal-loop doctrine,
  by the Claude-side goal adapter (`goal-adapter.md`), or by workflows that call
  the runtime. The goal adapter maps native `/goal` onto the goal-loop capability
  and wires `budget_pct` into the usage guard, adds the no-progress halt, and
  passes the completion condition to the separate evaluator (best-of-both parity;
  see `capabilities/goal-loop.md`).
- CT-AC-5 tested at hook level: session-routing injects the tier directive before execution.
- CT-AC-6 tested at hook level: malformed hook input fails open for hooks and leaves the task
  visible to the operator.

## Capability conformance status

- CT-UD-1 through CT-UD-6 tested by `enforcement/tests/run-selftest.sh`.
- CT-SR-1 through CT-SR-6 tested by `enforcement/tests/run-selftest.sh`.
- Full `dispatch(task) -> result` CT-AC execution is supplied by the generic
  dispatcher and the codex/cursor thin wrappers, not by native Claude Code
  hooks alone.

The enforced-runtime hooks (usage-guard, session-router) are vendored under
Apache-2.0, adapted from Joshua Sutcliff's public claude-config
(github.com/joshuadsutcliff) and credited in `NOTICE`. No private runtime
internals are included.
