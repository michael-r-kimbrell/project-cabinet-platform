# adoption-captain: Validation Protocol (Stage 7)

Stage 7 runs the host project's own test, build, lint, and typecheck commands
to confirm that Phase 1 changes did not break anything. The commands come from
Stage 1 discovery. The results feed directly into the adoption report.

**Pass criterion:** All detected commands exit 0. NOT-FOUND is honest, not
a failure. FAIL blocks the adoption from proceeding to Stage 8 until the
operator approves remediation.

---

## Output format per check

Every check produces exactly one of three results:

```
PASS   <category>: `<command>` exited 0
FAIL   <category>: `<command>` exited <code>; output: <first 3 lines of stderr>
NOT-FOUND   <category>: no command detected in Stage 1
```

Never invent a passing result. Never suppress a failure. If the command was
not detected in Stage 1, report NOT-FOUND rather than guessing.

---

## Node.js projects

**Detected by:** `package.json` present at project root.

**Package manager detection:**

```bash
if [ -f pnpm-lock.yaml ]; then RUNNER="pnpm run"
elif [ -f yarn.lock ]; then RUNNER="yarn"
else RUNNER="npm run"
fi
```

**Command table:**

| Category | Command | Pass criterion | Indicator |
|---|---|---|---|
| test | `$RUNNER test` | Exit 0 | `scripts.test` in package.json |
| build | `$RUNNER build` | Exit 0 | `scripts.build` in package.json |
| lint | `$RUNNER lint` | Exit 0 | `scripts.lint` in package.json |
| typecheck | `$RUNNER typecheck` OR `$RUNNER type-check` OR `npx tsc --noEmit` | Exit 0 | `scripts.typecheck` or `scripts.type-check`; fallback to tsc if typescript in devDependencies |

**NOT-FOUND handling:** If `package.json` has no `scripts.test`, report:
```
NOT-FOUND   test: no scripts.test in package.json; no alternative detected
```

**TypeScript detection:**

```bash
# Check if TypeScript is in devDependencies
node -e "const p=require('./package.json'); process.exit(p.devDependencies?.typescript ? 0 : 1)"
```

If TypeScript is present but `scripts.typecheck` is missing, run:
```bash
npx tsc --noEmit
```
and report the result as PASS or FAIL. Record the fallback command used.

---

## Python projects

**Detected by:** `pyproject.toml`, `setup.py`, or `requirements.txt` present.

**Virtual environment detection:**

```bash
# Check for active venv or common venv paths
if [ -n "$VIRTUAL_ENV" ]; then PYEXEC="python"
elif [ -d ".venv" ]; then PYEXEC=".venv/bin/python"
elif [ -d "venv" ]; then PYEXEC="venv/bin/python"
else PYEXEC="python3"
fi
```

**Command table:**

| Category | Command | Pass criterion | Indicator |
|---|---|---|---|
| test | `$PYEXEC -m pytest` | Exit 0 | `pytest` in requirements or pyproject; or `[tool.pytest]` section |
| test (alt) | `$PYEXEC -m unittest discover` | Exit 0 | No pytest, tests/ directory present |
| build | `$PYEXEC -m build` | Exit 0 | `pyproject.toml` with build-system table |
| lint | `$PYEXEC -m ruff check .` | Exit 0 | `ruff` in dev deps or pyproject `[tool.ruff]` |
| lint (alt) | `$PYEXEC -m flake8` | Exit 0 | `flake8` in requirements |
| typecheck | `$PYEXEC -m mypy .` | Exit 0 | `mypy` in dev deps or pyproject `[tool.mypy]` |

**Config extraction:**

```bash
# pytest flags from pyproject.toml
grep -A10 "\[tool.pytest.ini_options\]" pyproject.toml 2>/dev/null

# ruff config
grep -A5 "\[tool.ruff\]" pyproject.toml 2>/dev/null
```

When running pytest, use any flags declared in `[tool.pytest.ini_options]`
(e.g. `addopts = "--strict-markers"`). Running without the declared flags may
produce a different exit code than what CI would produce.

---

## Rust projects

**Detected by:** `Cargo.toml` present.

**Workspace detection:**

```bash
grep "\[workspace\]" Cargo.toml && CARGO_FLAGS="--workspace" || CARGO_FLAGS=""
```

**Command table:**

| Category | Command | Pass criterion | Indicator |
|---|---|---|---|
| test | `cargo test $CARGO_FLAGS` | Exit 0 | Cargo.toml present |
| build | `cargo build $CARGO_FLAGS` | Exit 0 | Cargo.toml present |
| lint | `cargo clippy $CARGO_FLAGS -- -D warnings` | Exit 0 | `clippy` is built into rustup |
| typecheck | (covered by `cargo build`) | -- | Rust build is type-checked |

**Note:** Rust does not have a separate typecheck step. `cargo build` includes
type checking. Record typecheck as:
```
PASS   typecheck: covered by cargo build (Rust; no separate typecheck step)
```

**Slow build mitigation:** If `cargo build` takes more than 90 seconds,
note the duration in the validation report. Do not time out; let it finish.
Stage 7 is expected to be slow for Rust projects with large dependency trees.

---

## Go projects

**Detected by:** `go.mod` present.

**Command table:**

| Category | Command | Pass criterion | Indicator |
|---|---|---|---|
| test | `go test ./...` | Exit 0 | go.mod present |
| build | `go build ./...` | Exit 0 | go.mod present |
| lint | `go vet ./...` | Exit 0 | go.mod present |
| lint (extended) | `golangci-lint run` | Exit 0 | `golangci-lint` in PATH |
| typecheck | (covered by `go build`) | -- | Go build is type-checked |

**golangci-lint detection:**

```bash
which golangci-lint 2>/dev/null && echo "FOUND" || echo "NOT-FOUND"
```

If golangci-lint is found, run it. If not found, report NOT-FOUND for extended
lint without failing. `go vet` is always available.

---

## Ruby projects

**Detected by:** `Gemfile` present.

**Command table:**

| Category | Command | Pass criterion | Indicator |
|---|---|---|---|
| test | `bundle exec rspec` | Exit 0 | `rspec` in Gemfile |
| test (alt) | `bundle exec rake test` | Exit 0 | `rake` in Gemfile, no rspec |
| build | `bundle exec rake build` | Exit 0 | `rake build` target present |
| lint | `bundle exec rubocop` | Exit 0 | `rubocop` in Gemfile |
| typecheck | `bundle exec srb tc` | Exit 0 | `sorbet` in Gemfile |

**Gemfile detection:**

```bash
grep "rspec\|minitest\|rubocop\|sorbet" Gemfile 2>/dev/null
```

---

## Makefile projects (any language)

**Detected by:** `Makefile` present with relevant targets.

**Target extraction:**

```bash
make -qp 2>/dev/null | grep -E "^(test|build|lint|check|ci|typecheck):" | sort
```

If Makefile targets are found for any category, prefer them over language-
specific defaults.

| Category | Makefile target | Command |
|---|---|---|
| test | `test` | `make test` |
| build | `build` | `make build` |
| lint | `lint` | `make lint` |
| typecheck | `typecheck` or `check` | `make typecheck` or `make check` |
| CI composite | `ci` | `make ci` (runs all; use if individual targets not found) |

---

## Multi-language projects

If multiple stack indicators are detected (e.g. a Python backend with a
Node.js frontend), run validation for each detected stack separately.

```
PASS   test (Node.js): `pnpm run test` exited 0
PASS   test (Python): `python -m pytest` exited 0
PASS   build (Node.js): `pnpm run build` exited 0
NOT-FOUND   build (Python): no build command detected
```

---

## When FAIL is reported

FAIL blocks Stage 8. The agent presents the failure to the operator:

```
FAIL   test: `pnpm run test` exited 1
Output (first 5 lines):
  FAIL src/api.test.ts
  > Error: Cannot find module './helpers'
  ...

This failure was present BEFORE adoption-captain ran (Stage 1 was read-only).
Was this test already failing, or did Phase 1 changes cause it?
```

The agent must distinguish between pre-existing failures and failures caused
by adoption. If the failure was present before Phase 1 (detectable by running
the command before making any changes, which is Stage 7 best practice), record
"pre-existing failure" and allow the operator to decide whether to proceed.

If the failure is new (caused by Phase 1 changes), the agent identifies the
cause, proposes remediation, and the operator approves before Stage 8 proceeds.

---

## Validation report format

Written as a section in the adoption report:

```markdown
## Validation results

Run date: YYYY-MM-DD HH:MM UTC
Phase: 1

| Category | Command | Result | Notes |
|---|---|---|---|
| test | `pnpm run test` | PASS | 47 tests, 0 failures |
| build | `pnpm run build` | PASS | dist/ generated |
| lint | `pnpm run lint` | PASS | 0 warnings |
| typecheck | `npx tsc --noEmit` | PASS | (fallback; no scripts.typecheck) |
```

---

## Anti-patterns

### Anti-pattern: inventing a test command

**Symptom.** No test command was discovered in Stage 1. Agent runs
`npm test` anyway because "that is the convention."

**Fix.** If it was not discovered, it is NOT-FOUND. Report that honestly.
Do not run undiscovered commands during Stage 7. If the command fails on an
undiscovered invocation, the failure is the agent's fault, not the project's.

### Anti-pattern: reporting PASS without running the command

**Symptom.** Agent skips running validation because "nothing in .compound-ai/
could affect the test suite."

**Fix.** Stage 7 runs validation unconditionally. Phase 1 installs files under
`.compound-ai/` and may modify a CLAUDE.md or AGENT.md. Even if the risk seems
low, the command runs and the result is recorded. "Seemed fine" is not a
validation result.

### Anti-pattern: timing out and reporting NOT-FOUND

**Symptom.** `cargo build` takes 4 minutes. Agent reports NOT-FOUND for build
because the command "did not return in time."

**Fix.** Slow commands finish. Validation does not time out on commands that
are running. Report PASS or FAIL based on the actual exit code when the
command completes. Slow duration is noted, not penalized.
