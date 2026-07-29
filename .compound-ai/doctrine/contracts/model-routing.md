# Model Routing Decision Table
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Define your project's model routing once. Every pipeline reads from this table.
Routing decisions are not made inline.

## Your MODEL_ASSIGNMENTS

Fill in the model names for your stack. Examples use tier labels.

| Task type | Model tier | Your model | Notes |
|---|---|---|---|
| Classification, extraction, formatting | Local / smallest | [fill] | No design judgment needed |
| Mechanical edit (copy, rename, no logic) | Fast / cheap | [fill] | 60-80% savings vs. full model |
| Multi-file implementation | Mid tier | [fill] | Real engineering judgment |
| Core synthesis (primary value) | Full tier | [fill] | Do not cheap out here |
| Orchestrator on clean confirmations | Fast / cheap | [fill] | Mechanical, no deliberation |
| Orchestrator on design reviews | Full tier | [fill] | When the call has consequences |
| Session start context loading | Not an LLM call | N/A | Read the file directly |

## Provider cascade

When the primary provider is unavailable, fall back in order:

1. Primary: [fill]
2. Secondary: [fill]
3. Fallback: [fill]

Retry in-place with exponential backoff before cascading:
- Attempt 1: immediate
- Attempt 2: 2 seconds
- Attempt 3: 4 seconds
- Attempt 4: 8 seconds
- Then cascade to secondary

## Circuit breaker

After [N] consecutive failures on one provider, enter cooldown for [M] minutes.
Recommended defaults: N=3, M=10.

## Routing anti-patterns to avoid

| Anti-pattern | Cost | Fix |
|---|---|---|
| Full-tier model for classification | 5-10x cost, no quality gain | Route to local model |
| LLM to summarize what a file already says | Redundant synthesis | Load the file directly |
| Same model for all tasks | Overpaying on cheap tasks | Define routing table |
| Routing decisions made inline | Inconsistent, hard to audit | Centralize in MODEL_ASSIGNMENTS |
