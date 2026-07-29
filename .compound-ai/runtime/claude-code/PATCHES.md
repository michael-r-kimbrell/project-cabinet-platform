# Enforced Runtime Patch Notes

Status: APPLIED. The enforced-runtime hooks (usage-guard, session-router) are
vendored under Apache-2.0, adapted from Joshua Sutcliff's public claude-config
(github.com/joshuadsutcliff) and credited in `NOTICE`.

## Module Boundary

The files in this module preserve the public runtime contract:

- `hooks/usage-guard.sh` (vendored, Apache-2.0) supports `pct`, `block`,
  `inform`, and `refresh`.
- `hooks/session-router.sh` (vendored, Apache-2.0) reads `CAOS_REGISTRY` or
  falls back to `doctrine/conventions/trigger-registry.yaml`.
- `workflows/phased-review.js` is a local compatibility implementation that
  exposes a capped-wave dry-run plan and checks the usage guard before
  continuing; its portable doctrine is folded into the `agent-panel-review`
  skill.
- `agents/` records the cheap-worker names recognized by the guard; their
  portable contracts are folded into the `delegation` skill.

## Compound AI Patches

The vendored hooks carry these Compound AI patches; preserve them when updating:

- Keep all thresholds tunable through environment variables or
  `settings.local.json`.
- Keep fail-open behavior for malformed input, missing probes, and parse errors.
- Keep `BUDGET_PROBE` pluggable. Supported values are `auto`, `ccusage`,
  `estimate`, or a local command that prints a numeric percentage.
- Keep `session-router.sh` data-driven through `CAOS_REGISTRY` with the registry
  fallback above.
- Keep hook paths relative in `settings.fragment.json`.

## Local Overrides

Create a gitignored `settings.local.json` beside `enforcement-rules.yaml`, inside
`runtime/claude-code/`, or in the Claude settings directory. Supported shape:

```json
{
  "env": {
    "USAGE_GUARD_WARN_PCT": "70",
    "USAGE_GUARD_BLOCK_PCT": "90",
    "USAGE_GUARD_COST_LIMIT": "100",
    "USAGE_GUARD_CACHE_SECS": "180",
    "BUDGET_PROBE": "auto",
    "CHEAP_WORKERS": "researcher|code-generator|tester",
    "SESSION_ROUTER_SHOW": "0",
    "SESSION_ROUTER_OFF": "0"
  }
}
```

## Install Adapter

Preview the Claude settings merge without writing anything:

```bash
bash operating-standards/runtime/claude-code/install-adapter.sh --dry-run
```

The dry-run prints the merged settings JSON. Use `--install` only in a local
operator-controlled checkout after reviewing the output.
