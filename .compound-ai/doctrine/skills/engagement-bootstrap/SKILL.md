# Skill: engagement-bootstrap
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Creates the root project files for a new project using this kit.

## Triggers
"new project", "bootstrap", "set up project", "initialize", "start from scratch"

## What it creates
1. `AGENT.md` -- fill in project name, constraints, tech stack, context map
2. `Project.md` -- fill in project overview, phase, what done means
3. `STATE.md` -- starts empty, updated each session
4. `session-log.md` -- starts empty, append newest entries at top
5. `BACKLOG.md` -- starts empty, add open items as discovered
6. `_map.md` -- fill in the file navigation manifest
7. `context/tier0.md` -- 5-bullet operating contract, under 500 tokens
8. `context/tier1-current.md` -- starts empty, updated each session

## Bootstrap sequence
1. Copy `AGENT.md` from the kit template
2. Fill in: project name, constraints, tech stack, context map
3. Copy `Project.md` and fill in: what this is, current phase, what done means
4. Create `context/tier0.md` with 5 bullets: name, phase, top 3 constraints, pointer to AGENT.md
5. Leave `STATE.md`, `session-log.md`, `BACKLOG.md`, `context/tier1-current.md` empty
6. Run the new-project checklist: `checklists/new-project.md`

## What NOT to do at bootstrap
- Do not inline the full spec into AGENT.md (link to it instead)
- Do not put session history into AGENT.md (that is session-log.md)
- Do not put current state into AGENT.md (that is STATE.md)

## Source references
- `AGENT.md` -- the operating contract template
- `Project.md` -- the project overview template
- `context/tier0.md` -- the always-load context template
- `checklists/new-project.md` -- the 7-step bootstrap checklist
- Field Guide Chapter 28: New Project Bootstrap Checklist
