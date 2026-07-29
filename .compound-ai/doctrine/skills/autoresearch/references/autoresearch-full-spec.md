<!-- @origin: compound-ai-operating-standards v2.0.0 -->

# Autoresearch -- Autonomous Goal-directed Iteration

Inspired by [Karpathy's autoresearch](https://github.com/karpathy/autoresearch). Constraint-driven autonomous iteration for ANY measurable work.

**Core idea:** You are an autonomous agent. Modify, Verify, Keep/Discard, Repeat.

## Subcommands

| Subcommand | Purpose |
|------------|---------|
| `/autoresearch` | Run the autonomous loop (default) |
| `/autoresearch:plan` | Build Scope, Metric, Direction & Verify from a Goal |
| `/autoresearch:security` | STRIDE + OWASP Top 10 security audit |

### /autoresearch:security

Load: `references/security-workflow.md` for full protocol.

Scans codebase, builds STRIDE threat model + attack surface map, then iteratively tests each vector. Every finding requires code evidence (file:line + attack scenario). Creates `security/{YYMMDD}-{HHMM}-{slug}/` with structured reports.

**Flags:** `--diff` (delta mode), `--fix` (auto-remediate Critical/High), `--fail-on {severity}` (CI/CD gate).


## When to Activate

- `/autoresearch` or "iterate autonomously", "keep improving", "run overnight"
- `/autoresearch:plan` or "set up autoresearch", "plan an autoresearch run"
- `/autoresearch:security` or "security audit", "threat model", "OWASP", "STRIDE"
- Any task needing repeated iteration with measurable outcomes

## Loop Modes

**Unlimited:** `/autoresearch` -- loops forever until Ctrl+C.
**Bounded:** `/loop 25 /autoresearch` -- exactly 25 iterations, then summary.

| Scenario | Recommendation |
|----------|---------------|
| Run overnight | Unlimited |
| Quick improvement session | `/loop 10 /autoresearch` |
| Targeted fix | `/loop 5 /autoresearch` |
| Exploratory | `/loop 15 /autoresearch` |

## Setup Phase (Do Once)

1. **Read all in-scope files** for full context before any modification
2. **Define the goal** -- extract or infer a mechanical metric:
   - Code: tests pass, build succeeds, performance benchmark improves
   - Content: word count target hit, SEO score improves, readability score
   - Design: Lighthouse score, accessibility audit passes
   - If no metric exists, define one or use simplest proxy (e.g. "compiles without errors")
3. **Define scope constraints** -- which files can you modify? Which are read-only?
4. **Define guard (optional)** -- a command that must ALWAYS pass (prevents regressions while optimizing main metric)
5. **Create results log** -- `autoresearch-results.tsv` (see `references/results-logging.md`)
6. **Establish baseline** -- run verify + guard on current state, record as iteration #0
7. **Show config, confirm once, BEGIN THE LOOP**

## The Loop

Read `references/autonomous-loop-protocol.md` for full protocol.

```
LOOP (FOREVER or N times):
  1. Review: Read current state + git history + results log
  2. Ideate: Pick next change based on goal, past results, what hasn't been tried
  3. Modify: Make ONE focused change to in-scope files
  4. Commit: Git commit the change (before verification)
  5. Verify: Run the mechanical metric
  6. Guard: If guard is set, run the guard command
  7. Decide:
     - IMPROVED + guard passed (or no guard) -> Keep, log "keep"
     - IMPROVED + guard FAILED -> Revert, rework (max 2 attempts).
       Never modify guard/test files. If still failing -> log "discard (guard failed)"
     - SAME/WORSE -> Git revert, log "discard"
     - CRASHED -> Try to fix (max 3 attempts), else log "crash" and move on
  8. Log: Record result in results log
  9. Repeat
     - Unbounded: NEVER STOP. NEVER ASK "should I continue?"
     - Bounded (N): Stop after N iterations, print final summary
```

## Critical Rules

1. **Loop until done** -- unbounded: loop until interrupted. Bounded: N times then summarize.
2. **Read before write** -- always understand full context before modifying
3. **One change per iteration** -- atomic changes. If it breaks, you know exactly why
4. **Mechanical verification only** -- no subjective "looks good". Use metrics
5. **Automatic rollback** -- failed changes revert instantly. No debates
6. **Simplicity wins** -- equal results + less code = KEEP. Tiny improvement + ugly complexity = DISCARD
7. **Git is memory** -- every kept change committed. Agent reads history to learn patterns
8. **When stuck, think harder** -- re-read files, re-read goal, combine near-misses, try radical changes

## Completion Protocol

On loop completion (bounded) or early goal achievement:

1. Print final summary: baseline -> current best, keeps/discards/crashes, best iteration


## Project-Specific Metrics

Adapt the generic table below to your project:

### Generic Domain Table

| Domain | Metric | Scope | Verify Command | Guard |
|--------|--------|-------|----------------|-------|
| Backend code | Tests pass + coverage % | `src/**/*.ts` | `npm test` | -- |
| Frontend UI | Lighthouse score | `src/components/**` | `npx lighthouse` | `npm test` |
| ML training | val_bpb / loss | `train.py` | `uv run train.py` | -- |
| Content | Word count + readability | `content/*.md` | Custom script | -- |
| Performance | Benchmark time (ms) | Target files | `npm run bench` | `npm test` |
| Refactoring | Tests pass + LOC reduced | Target module | `npm test && wc -l` | `npm run typecheck` |
| Security | OWASP + STRIDE coverage | API/auth/middleware | `/autoresearch:security` | -- |


## Principles Reference

See `references/core-principles.md` for the 7 generalizable principles from autoresearch.
