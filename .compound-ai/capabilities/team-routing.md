# Team Routing Capability
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Team routing turns pasted raw intake into distilled, routed, living team records
and keeps a Command Center dashboard current. It is the Team edition org layer:
workstream assignment, ledger maintenance, daily logging, and task-state sync.

Individual edition kits omit `team/`; this capability documents the contract
Team edition implements.

## 1. Contract

The capability guarantees:

1. Raw intake is distilled into a fixed contract (key points, tasks, quotes,
   knowledge, lineage link) before any routing decision.
2. Each item is scored against a human-editable routing registry. Strong matches
   file immediately; low-confidence matches are proposed and require operator
   approval before writing.
3. Workstream ledgers are updated in place (current state), not appended as
   duplicates. Completed accountabilities append to the dated daily log.
4. `command-center/task_state.json` stays aligned with open and waiting items.
   Completion (`status: done`) persists across dashboard rebuilds.
5. Environment branching reads `team/capability-profile.md` (and optional local
   overrides). Absent vector search or scheduled agents is never an error.

## 2. Distillation contract

For each distinct intake item:

| Field | Requirement |
|-------|-------------|
| Key points | 2 to 4 facts in plain language |
| Captured tasks | Actions with owner and due date when present |
| Key quotes | Short verbatim lines, attributed |
| Knowledge | Durable facts or decisions worth keeping |
| Lineage link | Relative path to stored source under `knowledge/` |

Never paste raw intake into ledgers or logs. Link to the source file instead.

## 3. Routing algorithm

1. Load `team/team-router/templates/routing-registry.md`.
2. Score people signals and client/keyword signals per workstream row.
3. Highest signal match wins. One strong hit (person or client name) outweighs
   several weak keyword hits.
4. Tie or no clear match: output the best candidate with a one-line rationale
   and wait for operator confirmation.
5. On approval, write to the matched workstream ledger using
   `team/team-router/templates/team-ledger.md` as shape.

## 4. Inputs / Outputs

```
Inputs:
  intake       : string | path[]   - raw text or paths to source material
  registry     : path?            - defaults to team/team-router/templates/routing-registry.md
  profile      : path?            - defaults to team/capability-profile.md

Output:
  distillations: object[]         - one distillation contract per item
  routes       : object[]         - {workstream, confidence, approved: bool}
  ledger_paths : string[]         - updated workstream ledger files
  log_path     : string?          - dated daily log if completions recorded
  task_state   : path             - team/command-center/task_state.json
  refresh_hint : string           - manual refresh.py command or scheduled note
```

## 5. Adapter integration

Team routing is orthogonal to `adapter-contract.md` session hooks. When an
adapter dispatches a team-routing task:

1. Run `session-routing` and `usage-discipline` per the adapter contract.
2. Execute the team-routing procedure (distill, route, ledger, log, task state).
3. Return `dispatch(task) -> result` with `output` listing files written and
   `memory_update` summarizing workstream changes.

For runtimes without structured dispatch, load `team/team-router/SKILL.md` as
the graceful-degradation path.

## 6. Reference implementation

| Artifact | Role |
|----------|------|
| `team/team-router/SKILL.md` | Operator-facing procedure and triggers |
| `team/team-router/templates/` | Registry, ledger, and daily-log shapes |
| `team/command-center/refresh.py` | Renders `task_state.json` to HTML |
| `team/install/install.py` | Interactive Team edition setup |

## 7. Conformance test

```
CT-TR-1  Intake with a clear registry match routes without silent guesswork on low confidence.
CT-TR-2  A completed accountability appears in the dated daily log and task_state item status is done.
CT-TR-3  refresh.py renders done items struck-through without mutating task_state.json.
CT-TR-4  capability-profile vector_search: none uses folder search only; no error is thrown.
CT-TR-5  capability-profile scheduled_agents: false prompts manual refresh.py; true notes timer rebuild.
```
