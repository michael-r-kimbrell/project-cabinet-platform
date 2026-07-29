# Usage discipline

## The problem

Subscription usage (5-hour rolling window + weekly cap on paid Claude
plans) burns fastest on: long conversations, large file/context loads, and
Opus/Fable-tier models used for mechanical work. An agent that spawns
subagents freely can burn a session's budget on one task.

## The contract

- **Session-router:** before starting non-trivial work, name which model
  tier the task needs (see `capabilities/session-routing.md`) and say so.
- **Fan-out ceiling:** subagent spawns (Claude Code's Task tool) are capped
  per session. `runtime/claude-code/hooks/usage-guard.sh` hard-blocks past
  the ceiling; other runtimes get this as an advisory line in their
  prelude.
- **Free-lane routing:** genuinely mechanical, high-volume tasks (bulk
  supplier-name lookups, formatting, simple rewrites) route to a free API
  lane (NVIDIA NIM, Gemini Flash, OpenRouter, Groq, or local Ollama) instead
  of paid usage, per the getting-started guide, step 6. Keys live in
  `.env`, never in chat.

## What this is not

This is not a cost-cutting mandate to use the cheapest model everywhere.
Planning and design-generation work is exactly where the strategy/build
tiers earn their cost — the discipline is routing correctly, not routing
cheap.
