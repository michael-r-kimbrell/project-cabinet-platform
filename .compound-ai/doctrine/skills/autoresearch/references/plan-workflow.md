# Plan Workflow -- /autoresearch:plan

Convert a goal into a validated, ready-to-execute autoresearch configuration.

**Output:** A complete `/autoresearch` invocation with Scope, Metric, Direction, and Verify -- all validated before launch.

## Trigger

- `/autoresearch:plan`
- "help me set up autoresearch", "plan an autoresearch run", "what should my metric be"

## Workflow

**Act fast. Infer defaults from the codebase. Present one config. Confirm once. Launch.**

### Phase 1: Capture Goal

If goal provided inline, use it. If not, ask once: "What do you want to improve?"

### Phase 2: Analyze Context

1. Read codebase structure (package.json, project files, test config)
2. Identify domain: backend, frontend, ML, content, DevOps
3. Detect existing tooling: test runner, linter, bundler, benchmark scripts
4. Check SKILL.md project-specific metrics table for known presets
5. Infer metric candidates from goal + tooling

### Phase 3: Build Config (Infer Everything)

From the goal + codebase analysis, infer ALL of these:

- **Scope:** file globs (validate they resolve to >=1 file, warn if >50 files)
- **Metric:** mechanical metric that outputs a parseable number
- **Direction:** higher or lower is better
- **Guard:** test command if metric is not tests themselves; "none" if metric IS tests
- **Verify:** shell command that runs tool + extracts metric number

**Metric validation (CRITICAL):**

| Check | Pass | Fail |
|------

<!-- @origin: compound-ai-operating-standards v2.0.0 -->
-|------|------|
| Outputs a number | `87.3`, `0.95`, `42` | `PASS`, `looks good` |
| Extractable by command | `grep`, `awk`, `jq` | Requires human judgment |
| Deterministic | Same input = same output | Random, flaky |
| Fast | < 30 seconds | > 2 minutes |

### Phase 4: Validate

**Mandatory dry run before accepting:**

1. Run the verify command on current codebase
2. Confirm exit code 0
3. Confirm output contains a parseable number
4. Record baseline metric value
5. If guard is set, run it once to confirm it passes

If dry run fails, fix it automatically or ask for help.

### Phase 5: Present & Launch

Present the complete config in one block:

```markdown
## Autoresearch Configuration

**Goal:** {goal}
**Scope:** {glob pattern}
**Metric:** {metric name} ({direction})
**Verify:** `{command}`
**Guard:** `{guard_command}` *(or "none")*
**Baseline:** {value from dry run}

Ready-to-use:

/autoresearch
Goal: {goal}
Scope: {scope}
Metric: {metric} ({direction})
Verify: {verify_command}
Guard: {guard_command}
```

Then ask ONE question: "Launch now (unlimited), bounded (how many?), or copy config?"

Default: launch unlimited.

## Metric Suggestion Database

### Code Quality
| Goal Pattern | Metric | Verify Template |
|---|---|---|
| test coverage | Coverage % | `{test_runner} --coverage \| grep "All files"` |
| type safety | `any` count | `grep -r ":\s*any" {scope} --include="*.ts" \| wc -l` |
| lint errors | Error count | `{linter} {scope} 2>&1 \| grep -c "error"` |
| build errors | Error count | `{build_cmd} 2>&1 \| grep -c "error"` |

### Performance
| Goal Pattern | Metric | Verify Template |
|---|---|---|
| bundle size | Size in KB | `{build_cmd} 2>&1 \| grep "First Load JS"` |
| response time | Time in ms | `{bench_cmd} \| grep "p95"` |
| lighthouse | Score 0-100 | `npx lighthouse {url} --output json --quiet \| jq '.categories.performance.score * 100'` |

### Content
| Goal Pattern | Metric | Verify Template |
|---|---|---|
| readability | Flesch score | `node scripts/readability.js {file}` |
| word count | Word count | `wc -w {scope}` |
| SEO score | Score 0-100 | `node scripts/seo-score.js {file}` |

### Refactoring
| Goal Pattern | Metric | Verify Template |
|---|---|---|
| reduce LOC | Line count | `{test_cmd} && find {scope} -name "*.ts" \| xargs wc -l \| tail -1` |
| reduce complexity | Cyclomatic complexity | `npx complexity-report {scope} \| grep "average"` |
| eliminate pattern | Pattern count | `grep -r "{pattern}" {scope} \| wc -l` |

## Error Recovery

| Error | Recovery |
|---|---|
| No test runner detected | Ask for test command |
| Verify command fails | Show error, suggest fix, re-validate |
| Metric not parseable | Add `grep`/`awk` to extract number |
| Scope resolves to 0 files | Show glob result, ask for fix |
| Scope too broad (>100 files) | Suggest narrowing |

## Anti-Patterns

- Do NOT accept subjective metrics
- Do NOT skip the dry run
- Do NOT suggest verify commands you haven't tested
- Do NOT overwhelm with questions -- max 2 questions total (goal + launch)
