# Known Limits

Compound AI Operating Standards v3.0.10

This document states honestly what the kit enforces mechanically, what remains
advisory, and what the human always controls. A Thoughtworks-grade reader will
find these in ten minutes anyway; naming them builds trust.

---

## Mechanical enforcement (real blocks)

These are enforced by CI gates or runtime hooks. They actually stop violations.

**CI gates** (run on every push/PR via `.github/workflows/enforce.yml`):
- Pointer files exceeding 100 lines: blocked by `check-line-caps.sh`.
- tier0 content referencing tier-2/tier-3 paths: blocked by `check-tier-discipline.sh`.
- Personal paths, private vault names, or denylist content in shippable files:
  blocked by `check-portability.sh`.
- Skill count drift between SKILL.md files, index, and registry: blocked by
  `check-counts.sh`.
- Phantom registry entries (pointer resolves to no real file): blocked by
  `check-registry-coherence.sh`.
- settings.fragment.json missing required hook events or unresolvable hook
  paths: blocked by `check-runtime-wiring.sh`.

**Runtime hooks** (Layer B, Claude Code only, when `runtime/claude-code/` is
installed and the hooks are wired):
- Conductor-model subagent spawning (non-sonnet/haiku, non-cheap-worker Agent
  calls): hard-blocked by `usage-guard.sh` Policy 1, always, regardless of
  usage level.
- Agent/Workflow tool calls at or above the cost-cap proxy block threshold
  (default 90%): hard-blocked by `usage-guard.sh` Policy 2.

**Other runtimes (codex, cursor, generic) are advisory, not hard-block.** The
runtime hard blocks above are real only on Claude Code, which exposes
`PreToolUse` and `UserPromptSubmit` hooks. On every other runtime the same
discipline is carried by a prompt prelude plus an optional dispatch wrapper: the
agent is told the contract and is expected to honor it, but nothing mechanically
stops a violating tool call. This is graceful degradation by design, not a hidden
gap. No claim in this kit should be read as promising universal hard-blocking;
enforcement is hard where the runtime supports it and advisory everywhere else.

---

## Advisory at runtime (the human and agent are trusted, no mechanical block)

**Minimal-tier loading.** The tier model (tier0 always, tier1 on task, tier2
on demand, tier3 never direct) is a behavioral convention. No hook can force
an agent to load only tier0 at session start. Runtime hooks operate on
tool-call events, not on what context the agent loads. This limit is verified
against Claude Code hook architecture. A future Claude Code feature could
close this gap; the doctrine is ready for it.

**Weekly usage cap.** `usage-guard.sh` operates on a 5-hour block cost proxy
via `ccusage`. The verified note from `session-router.sh`: "a hook CANNOT
change the main-loop model or effort level." More broadly, no reliable
programmatic signal exposes the Claude Code plan's true weekly limit. The
`USAGE_GUARD_COST_LIMIT` parameter is a configurable approximation. The
authoritative check is Claude Code's `/usage` command. When the proxy and
`/usage` disagree, tune `USAGE_GUARD_COST_LIMIT` in `settings.local.json`.

**Usage ceiling is estimator-based unless `ccusage` is installed.** The
usage-guard cost ceiling reads real metered spend only when the third-party
`ccusage` CLI is present (`npm install -g ccusage`). Without it, `usage-guard.sh`
falls back to local character/prompt-length estimation: the usage figure is an
estimate, not a billing read, and it never triggers a metered API call to find
out. Probe absence or failure is fail-open (the hook exits 0, never blocking
work). Treat the displayed ceiling as advisory; the authoritative figure is
Claude Code's `/usage`. Install ccusage to upgrade the estimate to a read of
Claude Code's own cost data. See `capabilities/usage-discipline.md` and the
ccusage step in `adoption/INSTALL.md`.

**Session-router tier injection.** `session-router.sh` classifies prompts as
LIGHT/MEDIUM/HEAVY and injects a routing prior into the conductor's context.
This is behavioral guidance, not a hard block. The agent may override the
classification with its own judgment. The hook documents this explicitly:
"heuristic prior - override with your own judgment if the task is actually
lighter/heavier."

**Main-loop model and effort.** Verified against Claude Code v2.1.179: hooks
cannot change the main-loop model or effort level after session start. Those
are set interactively via `/model` and `/fast`. The session-router documents
this as a hard limit in its source header.

**Pattern promotion scoring.** The ACE (`helpful=N harmful=N`) scoring and
5-outcome evolution pass from the enforced runtime are advisory evaluations
produced by the agent. They are not mechanically verified against external
outcomes.

---

## The human always controls

- Whether to install Layer B (enforced runtime) at all.
- Threshold values: `USAGE_GUARD_BLOCK_PCT`, `USAGE_GUARD_WARN_PCT`,
  `USAGE_GUARD_COST_LIMIT`, `USAGE_GUARD_CACHE_SECS` via `settings.local.json`.
- Whether to disable `session-router.sh` entirely (`SESSION_ROUTER_OFF=1`).
- The main-loop model and effort level (interactive `/model`, `/fast`).
- The plan-level weekly budget (managed in the Claude Code subscription UI).
- Whether to include Layer C (`reference-impl/`) in a release zip.
- The public push gate (no automation in this kit pushes or tags).

---

## What "fail-open" means here

Both runtime hooks (`usage-guard.sh`, `session-router.sh`) are fail-open: a
broken `ccusage` binary, stale cache, missing `python3`, or JSON parse error
results in the hook exiting 0 with no injection or block. A hook failure never
blocks legitimate work. This property is preserved from the vendor
implementation and is self-tested in `enforcement/tests/run-selftest.sh`.

---

## What the benchmark measures (and does not)

The session-start benchmark measures one thing: the **context-loading cost** of
a tiered, route-on-demand layout versus an un-tiered one, as a character
estimate (bytes / 4), pure shell, reproducible on a bare laptop. It is an
order-of-magnitude signal, not a tokenizer-exact or billing figure.

It does **not** measure output quality, agent coherence, or real-world
multi-agent drift over a long engagement. Those are harder to measure and the
kit makes no claim about them. The benchmark shows the kit loads less context
per session; whether that yields better or more coherent work is left to the
operator's own observation, not asserted here.
