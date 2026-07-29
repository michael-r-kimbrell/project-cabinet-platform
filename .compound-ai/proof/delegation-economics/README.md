# Proof: delegation economics

This is a scrubbed account of what the usage guard actually blocks today. It
carries no private paths, no personal framing, and no account or cost detail. It
describes the controls and why they pay for themselves.

## The problem delegation economics solves

Delegation is the main lever of a compound system: route work to the cheapest
agent that can do it well, run in parallel where it helps. Left ungoverned, the
same lever overruns the budget. Two patterns cause most of the waste:

1. **Expensive subagents.** A delegated subagent is spawned on a high-cost
   conductor-class model when a cheap worker would have done the job. The
   conductor model belongs in the main loop, where judgment lives, not fanned
   out across many subagents.
2. **Unbounded fan-out.** Delegation spawns more delegation with no usage
   ceiling, and the run drains its budget window before it finishes.

The doctrine has always described the right behavior. The enforced runtime makes
two parts of it mechanical, so they hold when an agent forgets.

## What `usage-guard.sh` blocks now

The guard runs as a PreToolUse hook on `Agent` and `Workflow` spawns. It has two
policies.

### Policy 1: deny conductor-model subagents

A subagent spawn is denied unless it specifies a cheap model (`sonnet` or
`haiku`) or uses a pinned cheap worker type (`researcher`, `code-generator`, or
`tester`). The conductor or manager model runs in the main loop only. This is
enforced always, independent of current usage, because it is a structural rule:
the expensive model coordinates, the cheap models execute.

Effect: the common, costly mistake of fanning out conductor-class subagents is
blocked at spawn time with a clear message to re-issue with a cheap model or a
named worker.

### Policy 2: usage-cap gate

Once a usage-cap proxy crosses a configurable block threshold
(`USAGE_GUARD_BLOCK_PCT`, default 90), further `Agent` and `Workflow` spawns are
blocked. The run is told to pause delegation and resume when usage drops, and
specifically not to absorb the delegated work back into the main loop. A separate
warn threshold (`USAGE_GUARD_WARN_PCT`, default 70) surfaces an advisory before
the hard block.

Effect: a run cannot quietly spend the whole window. It stops delegating near
the ceiling and resumes when there is room.

## Tunable, fail-open, humane

The enforcement is real but not draconian:

- **Tunable.** Thresholds are environment variables, overridable per host via a
  gitignored `settings.local.json`. No block percentage is hard-coded.
- **Fail-open.** A broken probe, a stale cache, or a parse failure yields a
  usage proxy of -1, which never blocks. A failure in the guard never stops
  legitimate work. This property is asserted in the self-test.
- **Protective defaults.** The defaults block genuine overruns, not ordinary
  work. The cost limit the proxy divides against is an estimate the operator
  sets to their own plan; the authoritative number stays the runtime's own usage
  view.

## Why it is net-positive

The cost of the controls is two hook invocations per spawn and a small config
surface. The return is that the two most expensive delegation mistakes, costly
subagents and unbounded fan-out, are caught mechanically instead of being
trusted to discipline. The guard exists because the failure it prevents actually
happened (see `docs/ENFORCEMENT-PROVENANCE.md`); it earns its place by making
that failure unrepeatable rather than merely discouraged.

## Provenance and license note

The `usage-guard.sh` hook is vendored under Apache-2.0, adapted from Joshua
Sutcliff's public claude-config (github.com/joshuadsutcliff) and credited in
`runtime/claude-code/NOTICE`. This narrative describes the behavior and the
economics; the vendored hook itself lives in `runtime/claude-code/hooks/`.
