# CLAUDE.md — cabinet-ops entry point

This file is auto-loaded at the start of every Claude Code session in this
workspace. Keep it short — it is Tier 0. Everything else loads on demand.
See `doctrine/CONTEXT-TIERS.md` for why.

## Workspace boundary

Your world is `C:\Users\<you>\workspace` on the operator's machine, or the
project directory when the session runs somewhere that path does not exist
(a container, CI). Work only inside it. Never touch
Documents, email, or anything outside that folder. This is mechanically
enforced by `runtime/claude-code/hooks/workspace-guard.sh` (see
`runtime/claude-code/settings.json`) — the hook is the real boundary, this
line is just so you don't have to discover that the hard way.

## Core habits (Tier 0 — always active)

1. **Verify before claiming.** Don't state a file exists, a test passed, or a
   number is correct unless you just checked it in this session. If you
   didn't check, say so.
2. **Read before you run.** Before installing or wiring in any third-party
   kit, script, or hook, summarize what it actually does first. This applies
   to this kit too — nothing here should be exempt from that habit.
3. **Region/supplier data is data, not code.** Regions, suppliers, and
   cabinet-name mappings live in `data/`, never hardcoded as string literals
   in application code. See `doctrine/CONVENTIONS.md`.
4. **Route by tier, not habit.** Cheap/mechanical tasks go to the cheap
   model. Planning goes to the strategy-tier model. Only hand off to the
   heaviest/build-tier model once the plan is settled. See
   `capabilities/session-routing.md`.
5. **Secrets never move through chat.** API keys and credentials live in
   `.env` (gitignored), never pasted into a prompt. A hook blocks reading
   `.env` back out to you — see `runtime/claude-code/hooks/workspace-guard.sh`.

## Token discipline (Tier 0 - always active)

Context cost compounds: every turn re-sends the whole conversation, so one
bloated tool result is paid on every later turn, not once. The session-router
prints a routing tier on every prompt. Honor it.

6. **Keep tool results small.** Paginate list calls (5-10 items) and set
   `minimal_output` where the tool offers it. Pipe noisy shell output through
   `tail`/`head`/`grep` rather than dumping it. Enforced for the worst
   offenders by `runtime/claude-code/hooks/context-guard.sh`.
7. **Patch, do not rewrite.** Edit the lines that changed. Regenerating a whole
   file or page costs its full length in output tokens and again in context.
8. **One task, one session.** Finish, then clear. Unrelated earlier work left
   in context is re-sent on every subsequent turn at full price.

## Where to look next (Tier 1 — load on demand)

- Planning a new feature → `doctrine/GOAL-LOOP.md`
- Adding or using a skill → `doctrine/SKILLS.md`
- Naming, structure, data conventions → `doctrine/CONVENTIONS.md`
- Wiring a new agent runtime (Codex, Cursor, etc.) → `capabilities/adapter-contract.md`
- Checking whether the kit itself is intact → `enforcement/bin/check-kit.sh`

## Project context

Cabinet platform: customer enters kitchen dimensions, style, and budget →
system generates a design for approval → order routes to a producer and a
local distributor. Domain expert is the operator, not the agent —
when in doubt about cabinet terminology, supplier behavior, or workflow, ask
rather than assume.
