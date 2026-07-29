# Autonomous Loop Protocol

Full rules for the autoresearch iteration loop.

## Loop Modes

- **Unbounded (default):** Loop forever until Ctrl+C
- **Bounded:** Loop exactly N times when chained with `/loop N`

When bounded, track `current_iteration` against `max_iterations`. After the final iteration, print summary and stop.

## Phase 1: Review

Before each iteration, build situational awareness:

1. Read current state of in-scope files (full context)
2. Read last 10-20 entries from results log
3. Read `git log --oneline -20` to see recent changes
4. Identify: what worked, what failed, what's untried
5. If bounded: check current_iteration vs max_iterations

**Why read every time?** After rollbacks, state may differ from what you expect. Never assume.

## Phase 2: Ideate

Pick the NEXT change. Priority order:

1. **Fix crashes/failures** from previous iteration first
2. **Exploit successes** -- if last change improved metric, try variants in same direction
3. **Explore new approaches** -- try something the results log shows hasn't been attempted
4. **Combine near-misses** -- two changes that individually didn't help might work together
5. **Simplify** -- remove code while maintaining metric. Simpler = better
6. **Radical experiments** -- when incremental changes stall, try something dramatically different

**Anti-patterns:**
- Don't repeat exact same change that was already discarded
- Don't make multiple unrelated changes at once (can't attribute improvement)
- Don't chase marginal gains with ugly complexity

**Bounded mode:** If <3 iterations left, prioritize exploiting successes over exploration.

## Phase 3: Modify (One Atomic Change)

- Make ONE focused change to in-scope files
- The change should be explainable in one sentence
- Write the description BEFORE making the change (forces clarity)

## Phase 4: Commit (Before Verification)

```bash
git add <changed-files>
git commit -m "experiment: <one-sentence description>"
```

Commit BEFORE running verification so rollback is clean: `git reset --hard HEAD~1`

## Phase 5: Verify (Mechanical Only)

Run the agreed-upon verification command. Capture output.

**Timeout rule:** If verification exceeds 2x normal time, kill and treat as crash.

**Extract metric:** Parse the verification output for the specific metric number.

## Phase 5.5: Guard (Regression Check)

If a **guard** was defined, run it after verification.

- **Verify** answers: "Did the metric improve?"
- **Guard** answers: "Did anything else break?"

**Guard rules:**
- Only run if defined (optional)
- Run AFTER verify -- no point checking guard if metric didn't improve
- Pass/fail only (exit code 0 = pass)
- If guard fails, revert and try to rework (max 2 attempts)
- NEVER modify guard/test files -- adapt the implementation instead

**Guard failure recovery (max 2 rework attempts):**

1. Revert (`git reset --hard HEAD~1`)
2. Read guard output to understand WHAT broke
3. Rework the optimization to avoid the regression
4. Commit reworked version, re-run verify + guard
5. If both pass -> keep. If guard fails again -> one more attempt, then give up

Guard/test files are read-only. If after 2 rework attempts the optimization can't pass the guard, discard and move on.

## Phase 6: Decide (No Ambiguity)

```
IF metric_improved AND (no guard OR guard_passed):
    STATUS = "keep"
ELIF metric_improved AND guard_failed:
    git reset --hard HEAD~1
    FOR attempt IN 1..2:
        Analyze guard output, rework implementation (NOT tests)
        git add + commit reworked version
        Re-run verify
        IF metric_improved:
            Re-run guard
            IF guard_passed:
                STATUS = "keep (reworked)"
                BREAK
        git reset --hard HEAD~1
    IF still failing after 2 attempts:
        STATUS = "discard"
ELIF metric_same_or_worse:
    STATUS = "discard"
    git reset --hard HEAD~1
ELIF crashed:
    IF fixable: Fix, re-commit, re-verify, re-guard
    ELSE: STATUS = "crash", git reset --hard HEAD~1
```

**Simplicity override:** If metric barely improved (+<0.1%) but change adds significant complexity, treat as "discard". If metric unchanged but code is simpler, treat as "keep".

## Phase 7: Log Results

Append to results log (TSV format):

```
iteration  commit   metric   status   description
42         a1b2c3d  0.9821   keep     increase attention heads from 8 to 12
43         -        0.9845   discard  switch optimizer to SGD
44         -        0.0000   crash    double batch size (OOM)
```

## Phase 8: Repeat

### Unbounded Mode (default)

Go to Phase 1. **NEVER STOP. NEVER ASK IF YOU SHOULD CONTINUE.**

### Bounded Mode (with /loop N)

```
IF current_iteration < max_iterations:
    Go to Phase 1
ELIF goal_achieved:
    Print: "Goal achieved at iteration {N}! Final metric: {value}"
    Run completion protocol (see SKILL.md)
    STOP
ELSE:
    Run completion protocol (see SKILL.md)
    STOP
```

**Final summary format:**
```
=== Autoresearch Complete (N/N iterations) ===
Baseline: {baseline} -> Final: {current} ({delta})
Keeps: X | Discards: Y | Crashes: Z
Best iteration: #{n} -- {description}
```

### When Stuck (>5 consecutive discards)

1. Re-read ALL in-scope files from scratch
2. Re-read the original goal/direction
3. Review entire results log for patterns
4. Try combining 2-3 previously successful changes
5. Try the OPPOSITE of what hasn't been working
6. Try a radical architectural change
7. If still stuck after 3 more attempts, alert the user: "Autoresearch stuck on {goal} after {N} iterations. {keeps} keeps, last {discards} all discarded. May need human direction."

## Crash Recovery

- Syntax error: fix immediately, don't count as separate iteration
- Runtime error: attempt fix (max 3 tries), then move on
- Resource exhaustion (OOM): revert, try smaller variant
- Infinite loop/hang: kill after timeout, revert, avoid that approach
- External dependency failure: skip, log, try different approach

## Communication

- **DO NOT** ask "should I keep going?"
- **DO NOT** summarize after each iteration -- just log and continue
- **DO** print a brief one-line status every ~5 iterations (e.g., "Iteration 25: metric at 0.95, 8 keeps / 17 discards")
- **DO** alert if you discover something surprising or game-changing
- **DO** print a final summary when bounded loop completes
- **DO** notify the user on completion and when stuck
