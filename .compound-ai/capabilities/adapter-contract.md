# Adapter contract

Any AI agent runtime — Claude Code, Codex, Cursor, or a brand-new GUI-only
agent — plugs into this kit by satisfying this contract. The contract is
the same regardless of whether the runtime can mechanically enforce it.

## What every adapter must guarantee

| Guarantee | Hard-enforced by | Advisory-only fallback |
|---|---|---|
| Stays inside the workspace boundary | `runtime/claude-code/hooks/workspace-guard.sh` | `runtime/generic/PROMPT-PRELUDE.md`, restated every session |
| Doesn't read `.env` / secrets back into chat | Same hook, path match on `.env` | Same prelude |
| Caps subagent/session fan-out | `runtime/claude-code/hooks/usage-guard.sh` | Prelude + human spot-check |
| Routes tasks to the right model tier | N/A — human/agent judgment call | `capabilities/session-routing.md`, restated per session |

## Graceful degradation, on purpose

Claude Code gets real hooks: a `PreToolUse` hook can inspect a tool call
before it runs and block it with exit code 2. Most other runtimes don't
expose an equivalent interception point yet. Where a runtime can't
mechanically enforce a guarantee, the adapter still states the contract as
a prompt prelude — advisory, not silently absent. The gap between "hard
block" and "advisory" should always be visible, never assumed away.

## Adding a new runtime adapter

1. Create `runtime/<name>/`.
2. Read this contract and decide, honestly, which rows your runtime can
   mechanically enforce vs. which stay advisory.
3. Implement the hard-enforceable rows using whatever interception point
   the runtime exposes.
4. Write the rest as a prompt prelude, same shape as
   `runtime/generic/PROMPT-PRELUDE.md`.
5. Update the table above.
