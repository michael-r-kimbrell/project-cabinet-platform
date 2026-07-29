# Claude Code goal adapter

The Claude-side surface of the shared goal-loop capability
(`capabilities/goal-loop.md`). It maps Claude Code's native `/goal` command onto
the portable goal-loop contract and exposes the strengths the portable
goal-runner has that native `/goal` does not ship on its own.

Native `/goal` is NOT a dumber shim. It is the richest continuation surface in
the kit. This adapter keeps its automation and adds the kit's ceilings, so the
Claude side reaches parity with the portable goal-runner rather than trailing it.

## What native /goal already does better

- Cross-turn continuation: the host drives the loop without re-prompting.
- A built-in small evaluator model decides when the completion condition is met.
- Session-level persistence of the active goal.

The portable contract documents these affordances, and the generic adapter
approximates them with an explicit manual loop. Nothing here removes them.

## What this adapter adds (goal-runner strengths exposed on the Claude side)

### 1. Explicit budget ceiling wired to usage-discipline

The loop's `budget_pct` (from the loop-spec) is wired into
`hooks/usage-guard.sh`. On `PreToolUse` with matcher `Agent|Workflow`, the guard
denies further delegation once usage reaches `USAGE_GUARD_BLOCK_PCT`. So an
active `/goal` cannot spend past the configured ceiling: the halt is a mechanical
deny in the hook log, not a prose promise. Native `/goal` alone has no spend
ceiling; this is where it gets one.

Operators set the threshold in gitignored `settings.local.json`; a blank
`budget_pct` inherits the host default. Enforcement chain detail:
`doctrine/skills/goal-runner/reference/enforcement-chain.md`.

### 2. No-progress halt

When translating the goal contract into `/goal`, append the no-progress halt
rule to the goal text so the evaluator honors it:

```text
Halt if two consecutive iterations produce no measurable progress
(no-op or repeated-rejected output). Record progress to date and stop.
```

This makes the native loop stop spinning the same way the portable runner does.

### 3. Separate-evaluator completion check

Pass the completion condition as an observable check, not a vibe. The native
evaluator model is already separate from the maker turn; this adapter makes that
separation explicit by feeding it the same `completion_condition` a portable
evaluator would read. Keep validation, slow-lane quarantine, and memory closeout
in the visible plan; `/goal` decides whether to keep working, it does not replace
the quality gate, token budget, or closeout discipline.

## How to translate

Write the full goal contract first (objective, completion condition, validation,
context budget, stop conditions, memory update), then pass the completion
condition plus the no-progress rule to Claude Code:

```text
/goal <completion condition>. Halt if two consecutive iterations produce no
measurable progress; record progress and stop.
```

Use `/goal` only when the host is Claude Code v2.1.139+, the work has a
verifiable completion condition, the operator wants cross-turn continuation, and
the stop conditions are clear. Otherwise run the contract manually (see the
portable goal-runner). Native /goal is one vendor's automation shortcut layered
on the standard, not the standard itself.

## Host rules supersede

This adapter is not a replacement for host project rules. Where the host's own
`/goal`, continuation, or budget configuration conflicts with the kit contract,
the host rules win. The adapter wires the kit's `budget_pct` ceiling and
no-progress rule in as tunable defaults; it never overrides an explicit host
policy.

## Pointers

- Capability: `capabilities/goal-loop.md`
- Canonical contract: `doctrine/contracts/goal-contract.md`
- Portable runner + non-Claude fallback: `doctrine/skills/goal-runner/SKILL.md`
- Enforcement chain: `doctrine/skills/goal-runner/reference/enforcement-chain.md`
