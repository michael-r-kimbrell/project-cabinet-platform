# Runtime adapters

Each subdirectory implements the shared capability contract for one agent runtime. None is privileged; every runtime gets a real adapter.

| Path | Status |
|------|--------|
| `claude-code/` | Full enforcement through hooks, workflows, and settings fragment |
| `codex/` | `AGENTS.md` directives plus shell dispatch wrapper |
| `cursor/` | Cursor rules plus shell dispatch wrapper |
| `generic/` | Prompt prelude plus optional shell wrapper for graceful degradation |

See `capabilities/adapter-contract.md` (CB-2) for the shared `dispatch(task) -> result` interface.
