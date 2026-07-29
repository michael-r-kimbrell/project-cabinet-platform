# Codex runtime adapter

Codex implements the shared runtime contract with:

- `AGENTS.md` for native Codex instructions.
- `dispatch.sh` for mechanical `dispatch(task) -> result` checks.
- `CONFORMANCE.md` for capability-contract mapping.

The wrapper delegates common shell mechanics to `runtime/generic/dispatch.sh`
and sets `CAOS_RUNTIME_NAME=codex`.
