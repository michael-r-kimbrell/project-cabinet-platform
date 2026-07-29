# Cursor adapter conformance

Cursor conforms through two surfaces:

- `dispatch.sh` wraps task dispatch with the shared generic shell adapter and
  sets `CAOS_RUNTIME_NAME=cursor`.

## Capability mapping

- Session routing: the wrapper calls the shared session router and injects the
  tier directive.
- Usage discipline: the wrapper calls the shared usage guard when a budget
  ceiling is supplied.
- Goal loop: the wrapper inherits the generic adapter loop for simple
  machine-readable completion conditions.

## Conformance status

- CT-AC-1 through CT-AC-6 tested through the thin `dispatch.sh` wrapper in
  `enforcement/tests/run-selftest.sh`.
- CT-GL-1 through CT-GL-6 inherited from the shared generic dispatcher; the
  generic runtime carries the executable goal-loop tests.
- GUI-only Cursor use is advisory.

Shell dispatch is mechanically checked.
