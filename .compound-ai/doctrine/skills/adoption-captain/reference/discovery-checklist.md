# adoption-captain: Discovery Checklist (Stage 1)

Read this project before touching it. Discovery produces `discovery-report.md`
before any other stage begins. Nothing is written to the project during Stage 1.

---

## What to read, and why

### 1. Agent instruction files

These files define what the existing agent already knows and what rules it
already follows. They are the highest-risk surfaces: if adoption writes into
them carelessly, it corrupts the agent's operating contract.

| File | Agent(s) | Priority |
|---|---|---|
| `CLAUDE.md` | Claude Code | Read first |
| `AGENT.md` | Generic / Codex | Read first |
| `AGENTS.md` | Codex CLI | Read first |
| `AGENTS.codex.md` | Codex per-project variant | Read first |
| `.cursorrules` | Cursor | Read first |
| `.aider.conf.yml` | Aider | Read first |
| `CONVENTIONS.md` | Aider native / custom | Read if present |
| `.github/copilot-instructions.md` | GitHub Copilot | Read if present |
| Any `CONTEXT.md`, `INSTRUCTIONS.md`, `SYSTEM.md` | Custom | Read if present |

**Discovery commands.**

```bash
# Find all candidate instruction files, depth-limited
find . -maxdepth 3 \( \
  -name "CLAUDE.md" -o \
  -name "AGENT.md" -o \
  -name "AGENTS.md" -o \
  -name "AGENTS.codex.md" -o \
  -name ".cursorrules" -o \
  -name ".aider.conf.yml" -o \
  -name "CONVENTIONS.md" -o \
  -name "CONTEXT.md" -o \
  -name "INSTRUCTIONS.md" \
\) 2>/dev/null

# Check global agent files (not part of this project, but relevant)
ls ~/.claude/CLAUDE.md ~/.codex/AGENTS.md 2>/dev/null
```

**What to extract from each file.**
- Explicit rules (do X, never Y, always Z)
- Convention declarations (language style, naming, formatting)
- Tool or model restrictions
- Existing section markers (check for prior kit content)

---

### 2. Package and dependency files (stack detection)

Detect the project's language(s), frameworks, and runtime so Stage 7
validation can identify the correct test and build commands.

| File | Indicates |
|---|---|
| `package.json` | Node.js; check `scripts` for test/build/lint |
| `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml` | Package manager variant |
| `pyproject.toml` | Python (modern); check `[tool.pytest]`, `[tool.ruff]`, `[tool.mypy]` |
| `setup.py`, `setup.cfg` | Python (legacy) |
| `requirements.txt`, `requirements-dev.txt` | Python deps; check for pytest, ruff, black |
| `Cargo.toml` | Rust; workspace or single crate |
| `go.mod` | Go; extract module name and go version |
| `Gemfile` | Ruby; check for rspec, rubocop |
| `composer.json` | PHP |
| `build.gradle`, `pom.xml` | Java/Kotlin |
| `Makefile` | Any language; extract targets |

**Discovery commands.**

```bash
# Detect primary language files
ls package.json pyproject.toml setup.py Cargo.toml go.mod Gemfile 2>/dev/null

# Node.js: extract scripts block
node -e "const p=require('./package.json'); console.log(JSON.stringify(p.scripts,null,2))" 2>/dev/null

# Python: check for common tool sections
grep -l "pytest\|ruff\|mypy\|black\|flake8" pyproject.toml setup.cfg 2>/dev/null

# Makefile: list targets
make -qp 2>/dev/null | grep -E "^[a-zA-Z][a-zA-Z0-9_-]+:" | grep -v "^\." | sort | uniq
```

---

### 3. Test, build, lint, and typecheck commands

The goal is the exact commands that must still pass after adoption. Prefer
commands declared in the project itself over inferred conventions.

| Source | Commands to extract |
|---|---|
| `package.json` `scripts` | `test`, `build`, `lint`, `typecheck`, `type-check`, `check` |
| `Makefile` | `test`, `build`, `lint`, `check`, `ci` targets |
| `pytest.ini`, `tox.ini`, `pyproject.toml [tool.pytest]` | pytest invocation flags, coverage settings |
| `.github/workflows/*.yml` | CI jobs; extract the actual shell commands run |
| `Taskfile.yml` | task runner targets |

**Discovery commands.**

```bash
# GitHub Actions: extract run: lines from CI workflows
grep -r "run:" .github/workflows/ 2>/dev/null | head -60

# tox: show envlist
grep -A5 "\[tox\]" tox.ini 2>/dev/null

# pytest config
grep -A10 "\[tool.pytest" pyproject.toml 2>/dev/null
grep -A10 "\[pytest\]" pytest.ini setup.cfg 2>/dev/null
```

**Recording the result.** For each command category (test, build, lint,
typecheck), record either:
- `FOUND: <exact command>`
- `NOT-FOUND: no <category> command detected`

Do not invent a command. NOT-FOUND is an honest result.

---

### 4. State, decision, and architecture documents

These documents describe the project's current design intent. They are not
agent instruction files, but they tell you what the project is and what the
operator values.

| File | Contents |
|---|---|
| `README.md` | Project description, setup instructions, conventions |
| `ARCHITECTURE.md` | System design; data flows; component boundaries |
| `docs/decisions/` or `decisions/` | ADRs (Architecture Decision Records) |
| `TODO.md`, `BACKLOG.md`, `ROADMAP.md` | Pending work |
| `CHANGELOG.md` | What changed and when; reveals project maturity |
| `session-log.md` | Agentic work log if present |
| `STATE.md` | Current operational state if present |
| `ENHANCEMENTS.md` | Project-specific enhancement log |

**Discovery commands.**

```bash
# Check standard doc locations
ls README.md ARCHITECTURE.md TODO.md BACKLOG.md CHANGELOG.md \
   STATE.md session-log.md 2>/dev/null

# ADRs
find . -type d \( -name "decisions" -o -name "adr" \) 2>/dev/null
find . -maxdepth 4 -name "*.md" -path "*/decisions/*" 2>/dev/null | head -20
```

---

### 5. CI and deploy configuration

Deploy config reveals the project's delivery pipeline. Changes that break CI
or alter deploy paths are high-risk even if tests pass locally.

| File | Platform |
|---|---|
| `.github/workflows/*.yml` | GitHub Actions CI/CD |
| `vercel.json` | Vercel |
| `fly.toml` | Fly.io |
| `railway.toml` | Railway |
| `.circleci/config.yml` | CircleCI |
| `Dockerfile`, `docker-compose.yml` | Container builds |
| `.travis.yml` | Travis CI |
| `netlify.toml` | Netlify |
| `render.yaml` | Render |

**Discovery commands.**

```bash
ls .github/workflows/ 2>/dev/null
ls vercel.json fly.toml railway.toml netlify.toml render.yaml Dockerfile \
   docker-compose.yml 2>/dev/null
```

---

## Discovery report format

Write the output to `discovery-report.md` at the project root (temporary;
this file is moved to `.compound-ai/` in Stage 5 if adoption proceeds).

```markdown
# Discovery Report
Date: YYYY-MM-DD
Host project: <path>
Agent: adoption-captain v2.6.0

## Agent instruction files

| File | Exists | Notes |
|---|---|---|
| CLAUDE.md | yes/no | <key rules found, or "empty"> |
| AGENT.md | yes/no | ... |
| .cursorrules | yes/no | ... |

## Stack detection

Primary language: <language or UNKNOWN>
Package manager: <npm/pnpm/yarn/pip/cargo/go/bundler or NOT-FOUND>

## Commands

| Category | Command | Source |
|---|---|---|
| test | <command or NOT-FOUND> | <source file> |
| build | <command or NOT-FOUND> | <source file> |
| lint | <command or NOT-FOUND> | <source file> |
| typecheck | <command or NOT-FOUND> | <source file> |

## State and decision documents

| File | Exists | Summary (1 line) |
|---|---|---|
| README.md | yes/no | ... |
| CHANGELOG.md | yes/no | ... |

## CI and deploy

| Platform | Config file | Exists |
|---|---|---|
| GitHub Actions | .github/workflows/ | yes/no |
| Vercel | vercel.json | yes/no |

## Existing kit content

Prior compound-ai markers found: yes/no
If yes: which files, which version stamp.

## Rule inventory (from instruction files)

List each explicit rule found, with source file and line range:

1. [rule text] -- source: CLAUDE.md:12-14
2. ...
```

---

## If discovery turns up nothing

Some projects have no CLAUDE.md, no README, no CI, and one package.json with
no scripts. That is a valid state, not an error.

In that case, record each category as NOT-FOUND and ask the operator:

1. "No agent instruction file found. Do you have one under a different name?
   If not, Stage 6 will add only `.compound-ai/` contents; no instruction
   file will be created unless you request it."

2. "No test command detected. How do you currently verify the project builds
   correctly? (Exact command preferred.)"

3. "No CI config found. Is this project deployed anywhere? If yes, what does
   the deploy step look like?"

Record operator answers directly in the discovery report. Proceed to Stage 2
once the operator confirms the report is complete.

---

## Anti-patterns

### Anti-pattern: skipping unrecognized instruction files

**Symptom.** Agent reads CLAUDE.md but ignores a file named CONTEXT.md or
SYSTEM-PROMPT.md that contains the project's actual operating rules.

**Fix.** If a file in the project root has a name suggestive of agent
instructions and is not on the standard list, read it and include it in
discovery. Use judgment on depth: project root and `docs/` are fair game;
`node_modules/` is not.

### Anti-pattern: inferring commands that are not declared

**Symptom.** Agent notes that the project uses pytest, then infers "so the
test command is `pytest`" without verifying.

**Fix.** Commands must be discovered from a declared source (package.json
scripts, Makefile target, CI workflow, pytest.ini). If the only evidence is
the presence of a dependency, record NOT-FOUND with a note: "pytest in
requirements.txt; no invocation found." Ask the operator for the exact command.

### Anti-pattern: treating global instruction files as project files

**Symptom.** Agent reads `~/.claude/CLAUDE.md` and lists its rules as if
they belong to the project.

**Fix.** Global instruction files are noted in the discovery report under a
separate "Global agent context" heading. They inform Stage 2 but they are not
in scope for modification. Only project-level files are adoption targets.
