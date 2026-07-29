# Codex adapter conformance

Codex conforms through two surfaces:

- `AGENTS.md` supplies native runtime directives for manual or hosted Codex use.
- `dispatch.sh` wraps task dispatch with the shared generic shell adapter and
  sets `CAOS_RUNTIME_NAME=codex`.

## Capability mapping

- Session routing: `dispatch.sh` calls `runtime/claude-code/hooks/session-router.sh`
  and injects the resulting tier directive into the prompt.
- Usage discipline: `dispatch.sh` calls `runtime/claude-code/hooks/usage-guard.sh`
  before execution when a budget ceiling is supplied.
- Goal loop: `dispatch.sh` inherits the generic adapter loop for simple
  machine-readable completion conditions.

## Conformance status

- CT-AC-1 through CT-AC-6 tested through the thin `dispatch.sh` wrapper in
  `enforcement/tests/run-selftest.sh`.
- CT-GL-1 through CT-GL-6 inherited from the shared generic dispatcher; the
  generic runtime carries the executable goal-loop tests.
- Prompt-only Codex use through `AGENTS.md` is advisory.

This adapter has no special authority relative to other runtimes.
