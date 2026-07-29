# Session Routing Capability
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Session routing classifies each incoming task as LIGHT, MEDIUM, or HEAVY and
attaches a tier directive to the agent's context before execution. The
directive controls context loading depth, delegation fan-out, and validation
requirements for that task.

## 1. Contract

The capability guarantees:

1. Every task is classified into exactly one tier before the agent acts on it.
2. The tier directive is injected into the agent's context or system prompt for
   that task. The agent cannot override the tier classification unilaterally.
3. Classification uses the trigger registry as its primary signal and heuristic
   keyword matching as a fallback.
4. On classification failure, the router fails open to LIGHT (the safest,
   lowest-cost tier).
5. The operator may disable routing (for testing or override) via
   `SESSION_ROUTER_OFF=1`. When disabled, the router passes through with a
   logged note.

## 2. Tier definitions

| Tier   | Applies when                                           | Directive                                                                                              |
|--------|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| LIGHT  | Single-file fixes, quick lookups, no delegation needed | Keep context lean, use minimum pointer, avoid delegation unless asked.                                 |
| MEDIUM | Implementation, validation, scripts, local tool use    | Load the directly relevant skill or checklist, run local validation, keep fan-out capped.              |
| HEAVY  | Architecture, multi-agent, migration, release, review  | Use the registry to choose the planning or review path, stage work in waves, check usage before delegation. |

## 3. Inputs / Outputs

```
Inputs:
  prompt    : string   - the full user prompt for the task
  registry  : path?    - path to trigger-registry.yaml; falls back to
                         doctrine/conventions/trigger-registry.yaml

Configuration (env or settings file):
  SESSION_ROUTER_OFF   : "0" | "1"   - disables routing; default 0
  SESSION_ROUTER_SHOW  : "0" | "1"   - emit systemMessage in output; default 0
  CAOS_REGISTRY        : path?       - override registry path

Output:
  tier      : "LIGHT" | "MEDIUM" | "HEAVY"
  directive : string   - the full text directive injected into agent context
  match     : string   - matched trigger(s) or "heuristic" if no registry match
```

## 4. Classification algorithm

1. Load the trigger registry at the configured path.
2. For each trigger phrase in the registry, check if it appears (case-insensitive)
   in the prompt text.
3. Count heavy-signal keywords: `multi-agent`, `architecture`, `strategy`,
   `tradeoff(s)`, `review`, `converge`, `panel`, `migration`, `release`, `design`.
4. Count medium-signal keywords: `implement`, `validation`, `script`, `wire`,
   `test`, `refactor`, `debug`, `build`, `install`, `adapter`.
5. Classify:
   - HEAVY if heavy-count >= 2 or any of `multi-agent`, `architecture`,
     `tradeoffs` appears.
   - MEDIUM if medium-count >= 1 or any registry trigger matched.
   - LIGHT otherwise.

This algorithm is the normative definition. The reference implementation
in `runtime/claude-code/hooks/session-router.sh` is authoritative for
tie-breaking.

## 5. Reference implementation

`runtime/claude-code/hooks/session-router.sh`

Invoked as a `UserPromptSubmit` hook. Reads the prompt from stdin as JSON,
classifies it, and emits a `hookSpecificOutput` JSON object that Claude Code
injects into the agent's context for that prompt.

For runtimes without a hook framework, inject the following into the agent's
system prompt before the task (graceful-degradation form):

```
SESSION ROUTING: Classify this task as LIGHT, MEDIUM, or HEAVY using the
following rules, then follow the corresponding directive.

LIGHT  - single file, quick lookup, no delegation -> Keep context lean.
MEDIUM - implementation, validation, local tool use -> Load the relevant skill,
         run local checks, cap delegation.
HEAVY  - architecture, multi-agent, review, release -> Stage work in waves,
         consult the registry, check usage before delegating.

Classification: [AGENT SELF-CLASSIFIES HERE]
```

## 6. Conformance test

```
CT-SR-1  A prompt containing "multi-agent architecture" is classified HEAVY.
CT-SR-2  A prompt containing "implement the session router" is classified MEDIUM.
CT-SR-3  A prompt containing "what is 2+2" is classified LIGHT.
CT-SR-4  When the registry file does not exist, the router falls back to
         heuristic classification and still returns a valid tier.
CT-SR-5  When SESSION_ROUTER_OFF=1, the router returns a pass-through output
         and does not block the task.
CT-SR-6  The tier directive appears verbatim in the output for all three tiers.
```
