# Usage Discipline Capability
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Usage discipline is a tunable, fail-open spend/work ceiling. It prevents
runaway delegation and cost overruns without blocking work when the guard
itself cannot run.

## 1. Contract

The capability guarantees:

1. Before any sub-agent delegation or autonomous workflow step, the adapter
   checks the current usage level against configured thresholds.
2. If usage is at or above the block ceiling, the task halts with
   `status="halted"` and a `halt_reason` explaining the ceiling.
3. If usage is between the warn ceiling and block ceiling, the adapter
   proceeds but attaches a warning to the result.
4. If the usage level cannot be determined, the adapter fails open: the task
   proceeds and the guard records an unknown-usage note.
5. Configuration is per-runtime and per-operator. Defaults must be
   conservative enough to prevent large unexpected spend but permissive
   enough that a fresh session always starts.

The guard applies to delegation (sub-agent calls) and workflow steps.
It does not apply to read-only tool calls (file reads, searches).

## 2. Inputs / Outputs

```
Inputs:
  tool_name          : string    - name of the tool being invoked
  model              : string?   - model identifier if applicable
  subagent_type      : string?   - named worker role if applicable
  estimated_usage_pct: number?   - caller-supplied usage percent [0-100]
  prompt             : string?   - prompt text, used for fallback estimation

Configuration (env or settings file):
  USAGE_GUARD_WARN_PCT   : number  - default 70
  USAGE_GUARD_BLOCK_PCT  : number  - default 90
  USAGE_GUARD_COST_LIMIT : number  - absolute cost ceiling for ccusage probe
  BUDGET_PROBE           : string  - "auto" | "ccusage" | "estimate" | shell command

Output:
  decision    : "allow" | "block"
  reason      : string
  usage_pct   : number   - measured or estimated; -1 if unknown
```

## 3. Reference implementation

`runtime/claude-code/hooks/usage-guard.sh`

The implementation probes usage via `ccusage` (when available), falls back to
prompt-length estimation, and returns a JSON object matching the output schema
above. It is invoked as a `PreToolUse` hook for matchers `Agent` and
`Workflow`.

**Dependency note: `ccusage`.** On claude-code, `ccusage` is the metered-read
backend: it surfaces Claude Code's local session-cost data so the guard can
compare real spend against `USAGE_GUARD_COST_LIMIT`. It is an optional,
third-party CLI (`npm install -g ccusage`), not bundled with the kit. When it is
absent, broken, or returns unparseable output, the capability degrades to local
character/prompt-length estimation: it still returns a valid decision, it never
issues a metered API call to determine usage, and it never blocks on the probe
failing (fail-open, per Contract clause 4). The estimate is inform-by-default,
not authoritative; the authoritative read is Claude Code's `/usage`. Other
runtimes have no `ccusage` equivalent and always run on the estimation path
described in section 3's graceful-degradation prompt.

Key behaviors to replicate in other runtimes:
- Always return a valid JSON object even on internal error.
- Cheap approved workers (sonnet, haiku, named roles in `CHEAP_WORKERS`) skip
  the model check but still respect the pct ceiling.
- `decision: "block"` must produce a non-zero exit code so the hook framework
  can stop the tool call.

For runtimes without a hook framework, inject the following into the agent's
system prompt before the task (graceful-degradation form):

```
USAGE DISCIPLINE: Before delegating any sub-task, estimate your current
session usage as a percentage of your budget ceiling. If usage is at or above
[USAGE_GUARD_BLOCK_PCT]%, stop and return status=halted. If between
[USAGE_GUARD_WARN_PCT]% and [USAGE_GUARD_BLOCK_PCT]%, proceed but note the
warning in your result.
```

## 4. Conformance test

```
CT-UD-1  A tool call with tool_name="Agent" and usage_pct >= USAGE_GUARD_BLOCK_PCT
         returns decision="block".
CT-UD-2  A tool call with tool_name="Agent" and usage_pct < USAGE_GUARD_WARN_PCT
         returns decision="allow".
CT-UD-3  A tool call with tool_name="Bash" (non-delegation) is not evaluated;
         guard returns decision="allow" immediately.
CT-UD-4  When the usage probe fails entirely, the guard returns decision="allow"
         with usage_pct=-1 (fail-open confirmed).
CT-UD-5  Setting USAGE_GUARD_BLOCK_PCT=0 causes every delegation call to return
         decision="block" (ceiling fully closed).
CT-UD-6  An agent designated in CHEAP_WORKERS is allowed through the model check
         but is still subject to the pct ceiling.
```
