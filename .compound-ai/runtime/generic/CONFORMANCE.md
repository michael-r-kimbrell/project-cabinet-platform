# Generic adapter conformance

This runtime is the graceful-degradation adapter for any agent, including
GUI-only tools.

## Mechanism

- `prompt-prelude.md` injects session-routing, usage-discipline, goal-loop, and
  result-shape instructions into any agent prompt.
- `dispatch.sh` is an optional shell wrapper that reads the
  `dispatch(task) -> result` JSON shape.
- The wrapper calls the shared `session-router.sh` before dispatch.
- The wrapper calls the shared `usage-guard.sh` before dispatch when
  `budget.pct_ceiling` is supplied.
- The wrapper performs a minimal goal loop for machine-readable completion
  conditions: it iterates up to `budget.iterations`, invokes the agent command
  once per iteration, checks completion separately from generation, and halts on
  repeated no-progress output.

## Contract mapping

- CT-AC-1 tested: `dispatch.sh` returns `id`, `status`, and `output`.
- CT-AC-2 tested: `budget.pct_ceiling=0` returns `status=halted`.
- CT-AC-3 tested: missing GoalContract skips goal evaluation without error.
- CT-AC-4 tested: unmet machine-readable completion conditions return
  `halted`, including the no-agent false-positive fixture.
- CT-AC-5 tested: routing context is injected into the dispatched prompt.
- CT-AC-6 tested: empty or unparsable task JSON returns `status=error`.

## Goal-loop mapping

- CT-GL-1 tested: completion met on iteration 1 returns `status=done`.
- CT-GL-2 tested: unmet completion after `budget.iterations=2` halts after 2
  iterations.
- CT-GL-3 tested: identical consecutive outputs set `no_progress_halt=true`.
- CT-GL-4 tested: a task without GoalContract completes without
  `completion_met`.
- CT-GL-5 tested: a closed usage ceiling halts before execution.
- CT-GL-6 tested by implementation inspection in the self-test: the evaluator
  function is separate from the agent command invocation.

When only `prompt-prelude.md` is used, conformance is advisory rather than
mechanically enforced.
