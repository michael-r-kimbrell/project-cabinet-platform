# New Project Bootstrap Checklist
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Complete this checklist before the first AI session on a new project.
Each item takes minutes and saves hours.

## Step 1: Create AGENT.md (30 minutes, saves hours)
- [ ] Project name and one-sentence description
- [ ] What this project is NOT (top 3 wrong assumptions)
- [ ] Hard constraints: what the AI must never do
- [ ] Tech stack: language, package manager, database, test runner, scheduler
- [ ] Current phase and what "done" means
- [ ] Explicit paths to spec, design doc, and backlog (not "see the docs folder")

## Step 2: Create context tier structure
- [ ] `context/tier0.md` -- 5-bullet operating contract, under 500 tokens
- [ ] `context/tier1-current.md` -- starts empty, updated each session
- [ ] `context/tier1-subsystem/` -- create subdirectory, add slices as needed

## Step 3: Seed the decision log
- [ ] Record founding architectural decisions before the first session
- [ ] Format: "We chose X over Y because [reason]"
- [ ] File: `_knowledge/decision-log.md`

## Step 4: Define the handoff protocol
- [ ] Which files does each session update? (STATE.md, session-log.md, BACKLOG.md)
- [ ] What is the format for session log entries? (see session-log.md template)
- [ ] Where does the backlog live? (BACKLOG.md)

## Step 5: Define the model routing table
- [ ] Which tasks use which model tier? (fill in AGENT.md model routing section)
- [ ] What is the fallback chain when the primary provider is unavailable?

## Step 6: Add schema validation before the first dependent consumer
- [ ] Every LLM-returning function routes through a schema validator
- [ ] Schema constants defined at module level, not inline
- [ ] Reference: `code/schema_validator.py`

## Step 7: Add observability before the first scheduled job
- [ ] `pipeline_runs` table or equivalent created
- [ ] Phase wrapper that records start, end, and status
- [ ] Reference: `code/pipeline_runs.sql`, `code/phase_wrapper.sh`

## Done when
All 7 steps complete. The first AI session can now load tier0 + tier1-current
and start work without re-explaining the project from scratch.
