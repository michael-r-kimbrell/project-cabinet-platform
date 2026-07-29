# Generic runtime adapter

Generic is the graceful-degradation runtime for any agent.

- `prompt-prelude.md` can be pasted or injected before a task for GUI-only
  agents.
- `dispatch.sh` is an optional shell wrapper that reads the adapter contract
  task JSON and returns a structured result JSON.
- `CONFORMANCE.md` documents which guarantees are mechanical and which are
  advisory.

When only the prelude is used, the capabilities are honor-based. When the shell
wrapper is used, session routing, usage discipline, and simple goal checks are
mechanically applied.
