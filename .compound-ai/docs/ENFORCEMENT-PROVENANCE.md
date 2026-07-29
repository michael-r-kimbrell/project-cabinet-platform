# Enforcement provenance

This kit has two authors and two lineages. This note records where the enforced
runtime came from and why it works the way it does, in neutral terms. It carries
no private paths, no vault names, and no personal framing.

## Two systems, one kit

- The **doctrine** (Layer A) is the portable Compound AI operating standard:
  vendor-neutral prose and data covering routing, token economics, goal and loop
  contracts, provenance, and memory. Authored by Cameron Sutcliff.
- The **enforced runtime** (Layer B) is a hook-enforced Claude Code runtime that
  already implements the controls the doctrine could only advise. Authored by
  Joshua Sutcliff. Public reference: `github.com/joshuadsutcliff`.

The doctrine describes what good operation is. The runtime makes parts of it
mechanical. The two were built independently and merged into this co-owned kit.

## Why the enforcement layer exists

The runtime was hardened by a real operating incident. A multi-agent run was
allowed to fan out without a usage ceiling and ran its budget to exhaustion
before it was stopped. The lesson was direct: a budget limit that an agent is
merely asked to honor is not a limit. The response was to add a real control,
`usage-guard.sh`, that blocks delegation and workflow spawns at a configurable
usage threshold rather than trusting the agent to stop on its own.

That history is why this kit can claim incident-hardened enforcement rather than
an untested design. The control exists because the failure it prevents actually
happened.

## The incident behind the durability doctrine

The usage-cap exhaustion above motivated the runtime control. A separate,
earlier incident motivated the durability patterns in the doctrine itself, and
it is the one quoted in the foreword and the executive read: an overnight run
meant to process 22 workstreams lost 18 of them, because a cache opened its own
database handle on every model call and bypassed the single-writer discipline
the system claimed on paper. The fix was structural (shared connection
threading, cache attribution, phase-level observability, fail-visible recovery),
not more prompting. That is the difference between a clever demo and an operating
standard, and it is why the doctrine treats durability as a first-class concern.
Full account in the Field Guide foreword (`docs/FIELD-GUIDE.md`).

## What the runtime enforces

- `usage-guard.sh` (PreToolUse): denies conductor-model subagents that are not on
  a cheap worker tier, and blocks `Agent` and `Workflow` spawns once a usage-cap
  proxy crosses a configurable block threshold. It fails open: a broken probe,
  stale cache, or parse error yields no block, so it never stops legitimate work.
- `session-router.sh` (UserPromptSubmit): classifies each prompt LIGHT, MEDIUM,
  or HEAVY and injects a routing prior. It is behavioral only. A documented hard
  limit is that a hook cannot change the main-loop model or effort.
- `phased-review.js`: a capped fan-out workflow that checks usage between waves
  and halts with partial state rather than overrunning.

Thresholds are tunable through environment variables and a gitignored
`settings.local.json`. The defaults are protective, not draconian. See
`docs/known-limits.md` for what stays advisory at runtime.

## License boundary

The enforced-runtime hooks (usage-guard, session-router) are vendored under
Apache-2.0, adapted from Joshua Sutcliff's public claude-config
(github.com/joshuadsutcliff) and credited in `runtime/claude-code/NOTICE`. The
doctrine, the originally authored CI gates, and this provenance note do not
depend on the runtime and proceed independently.
