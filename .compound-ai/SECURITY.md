# Security

## Reporting a vulnerability

If you find a security issue in this kit, open a GitHub security advisory on the
repository, or open an issue marked `security` with enough detail to reproduce.
We will acknowledge and respond. Please do not include secrets or private data
in a public issue.

## Threat model (what this kit does and does not protect)

This kit is shell scripts, Markdown, and a small amount of maintainer Python. It
runs with the privileges of the agent or operator that invokes it. It is an
operating-discipline layer, not a sandbox. Adopt it with these properties in
mind.

- **The runtime hooks fail open.** `usage-guard.sh` and `session-router.sh` are
  designed so that on malformed input or an internal error they allow the action
  rather than block it (a broken guard must not brick your agent). This means a
  hook failure degrades to no-enforcement, not to a hard stop. The usage ceiling
  is also an estimate unless `ccusage` is installed. See `docs/known-limits.md`.
- **Hard enforcement is Claude Code only.** On Codex, Cursor, and the generic
  runtime the disciplines are advisory: the agent is given the contract and is
  expected to honor it. Nothing mechanically stops a violating tool call on
  those runtimes. Do not rely on this kit as a hard control outside Claude Code.
- **Goal completion is evaluated against agent output.** The goal-loop checks a
  completion condition; treat that condition as a convenience, not a security
  boundary. Do not gate anything safety-critical on it alone.
- **The installer writes to your settings.** Wiring the Claude Code runtime
  edits hook configuration. Review what it changes before you run it, and keep a
  copy of your prior settings. Use the dry-run path if available.
- **No secrets ship in this kit, by gate.** `check-portability.sh` blocks
  personal paths and known private terms from the shippable surface. If you fork
  it, keep your own secrets out the same way; do not commit credentials.

## Provenance

Verify what you downloaded matches the canonical release before you trust it:

```bash
python3 reference-impl/scripts/verify-integrity.py
```

This checks every file against the signed manifest (`compound-ai.manifest.json`
+ `compound-ai.sha256`). `verify-origin.py --online` additionally compares
against the published canonical manifest.
