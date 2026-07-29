# Loop Spec: {loop-name}

<!-- @origin: compound-ai-operating-standards v3.0.0 -->

> Required before any loop runs. One file per loop, living next to the loop's
> definition. Full specification:
> `doctrine/skills/loop-engineering/references/loop-engineering-full-spec.md`

| Field | Value |
|---|---|
| Purpose (one sentence) | |
| Owner (human) | |
| Runtime + trigger | {runtime + job id/label} @ {schedule or event} |
| Goal / stop condition (verifiable) | |
| Max iterations (per run / per goal) | / |
| No-progress rule | halt after 2 no-op or repeated-rejected iterations |
| Budget ceiling | {tokens / time / iterations / quota} |
| Budget % ceiling (`budget_pct`) | {0-100} usage-cap percent at which the loop halts. Backed by `usage-guard.sh` pct: at this percent the PreToolUse block (matcher `Agent\|Workflow`) denies further delegation, so the halt is a mechanical block in the hook log, not a prose promise. Leave blank to inherit the host `USAGE_GUARD_BLOCK_PCT` default. See `doctrine/skills/goal-runner/reference/enforcement-chain.md`. |
| Verification (checker is not maker) | {gate name + how it runs} |
| Memory file (read first, write last) | {path} |
| Escalation target | {inbox / ticket / alert channel} + what is never auto-acted |
| Autonomy ceiling | {scope} because {reversibility / blast radius} |
| Open or closed | closed (open requires explicit operator go) |
| Skills loaded | |
| Registry entry | {job registry id} |
| Review cadence (human reads output) | |

## Iteration anchor set (context reset each cycle)

- this spec
- {state file}
- {skills}

## Notes / incident history

-
