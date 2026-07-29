# goal-runner: Enforcement Chain

How a loop's declared budget ceiling becomes a mechanical block instead of a
prose promise. This is the spine of the loop-spec net-positive proof: a naive
loop spins to its budget ceiling on trust, while a kit loop halts because a hook
denies the next delegation.

The chain has three links: the spec field, the session router, and the usage
guard. Each link is a separate authority; together they turn "stop when the
budget is spent" into an observable deny event in the hook log.

## Link 1: the spec field (`budget_pct`)

`templates/loop-spec.md` carries a `budget_pct` field: the usage-cap percent at
which the loop should halt. It is the loop author's declared ceiling, expressed
in the same unit the runtime enforces (percent of the configured cost cap), so
intent and enforcement speak the same language.

- Blank `budget_pct` means "inherit the host default" (`USAGE_GUARD_BLOCK_PCT`).
- A set `budget_pct` records the loop's intended ceiling for the operator, who
  tunes the actual block threshold per host in `settings.local.json`.

The spec field is documentation and intent. It does not itself block; it names
the number that the runtime link enforces.

## Link 2: the session router (`session-router.sh`)

On `UserPromptSubmit`, `session-router.sh` classifies the turn LIGHT, MEDIUM, or
HEAVY using cheap regex heuristics and injects a routing prior into the
conductor's context. It reads its routing data from `trigger-registry.yaml`.

What this link does for the chain: it shapes how much delegation a turn attempts
before any block is needed, so cheap work stays cheap and the heavy path is the
only one that approaches the ceiling. Honest limit, verified against the hook
source: a hook CANNOT change the main-loop model or effort. The router injects a
prior; it does not force a model. The real model-tier savings come from the next
link's delegation denial, not from the router.

The router is fail-open: a classification failure passes the prompt through
unchanged and never blocks legitimate work.

## Link 3: the usage guard block (`usage-guard.sh`)

On `PreToolUse` with matcher `Agent|Workflow`, `usage-guard.sh` runs in `block`
mode and is where the halt actually happens.

- Policy 1 (always): denies any `Agent` subagent that is not sonnet/haiku or a
  named cheap worker (`researcher|code-generator|tester`), regardless of usage
  level. This caps per-delegation cost.
- Policy 2 (threshold): when the current usage pct reaches
  `USAGE_GUARD_BLOCK_PCT`, it denies further `Agent|Workflow` spawns. This is the
  `budget_pct` ceiling made mechanical. The deny is written to the hook log, so
  the loop's halt is auditable after the fact.
- Fail-open by design: a broken `ccusage`, stale cache, or parse failure yields
  `pct = -1`, which never blocks. Enforcement protects against real overruns; it
  never strands legitimate work behind a broken probe.

The budget probe is pluggable: it defaults to `ccusage` when present and
degrades to a transcript-token estimate when absent. The portable doctrine does
not hard-require npm.

## Mechanical vs documented

Be precise about which parts of this chain block and which only advise:

| Element | Status |
|---|---|
| `budget_pct` field in the loop-spec | documented intent |
| Router LIGHT/MEDIUM/HEAVY prior | injected prior, not a hard route |
| Per-delegation model denial (Policy 1) | mechanical, always on |
| Budget-percent block (Policy 2) | mechanical, at `USAGE_GUARD_BLOCK_PCT` |
| Main-loop model/effort selection | NOT enforceable by a hook (known limit) |
| Minimal-tier loading at session start | advisory (see `docs/known-limits.md`) |

When the loop's `budget_pct` is set to match the host `USAGE_GUARD_BLOCK_PCT`,
the loop's declared ceiling and the mechanical block are the same number, and the
halt appears in the hook log as a denied delegation.

## Tuning and authority

- Thresholds are tunable, never hard-coded: `USAGE_GUARD_BLOCK_PCT`,
  `USAGE_GUARD_WARN_PCT`, `USAGE_GUARD_COST_LIMIT`, and `CHEAP_WORKERS` live in
  `enforcement-rules.yaml` defaults and are overridden per host in a gitignored
  `settings.local.json`.
- Defaults are non-draconian and hard-blocks sit at genuinely protective levels,
  not work-frustrating ones.
- Host project rules supersede this framework. This chain narrows delegation and
  spend; it does not override a host's own rules, and `session-router.sh` must
  never weaken that precedence.

## License status

The vendored hooks (`usage-guard.sh`, `session-router.sh`) are vendored under
Apache-2.0, adapted from Joshua Sutcliff's public claude-config
(`github.com/joshuadsutcliff`) and credited in `runtime/claude-code/NOTICE`.
This document describes the wired behavior; the live pct block is exercised by
the proof task. The portable doctrine (the `budget_pct` field and this contract)
stands independently of the runtime.

## Pair with

- `loop-spec.md` for the `budget_pct` field.
- `reference/durable-loop.md` rule 8 (respect budget) for the loop-side discipline.
- `enforcement-rules.yaml` for the tunable hook thresholds.
