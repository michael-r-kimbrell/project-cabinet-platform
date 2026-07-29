# Agent Orchestration and the Subagent Ladder

How a top-level orchestrator holds the big picture, spawns the *right* workers
with *only* the context they need, and chooses the right primitive for the job.
This convention ties together the pieces the kit already ships (the instruction
tiers, the `delegation` skill, `team-router`, `agent-panel-planning/review`, the
`model-routing` and `token-budget` contracts) and fills the gaps between them.

It is generic. Fleet-specific rosters (which named agent fills which lane) live
in the operator's private adapter, never here.

## 1. The orchestrator's big-picture contract

The top orchestrator is the only context that holds the whole map. It must:

- Load tier-0 (always) and tier-1 (current project) context, and nothing deeper
  until a task needs it. Deeper facts load on demand. See `doctrine/tiers/`.
- Treat the current-state source of truth (a project index / `STATE.md`) as
  authoritative over any instruction file's self-description. Instruction files
  describe rules and intent; they go stale on current-state facts.
- Never push its full context into a child. A child gets a scoped brief, not the
  orchestrator's window. The orchestrator keeps the conclusion; the child's
  working context is discarded when it returns.

## 2. Instruction-file precedence (resolving multi-level conflicts)

Instruction files exist at several directory levels (global, canonical adapter,
project root, subdirectory). Conflicts are resolved by tier, not by proximity:

```
tier 0  global / canonical operating standards   (always loaded; non-negotiables)
tier 1  project current-context                  (loaded for most project work)
tier 2  subsystem / directory-level notes         (loaded only when in that area)
tier 3  task-local / reference                    (loaded on demand)
+ current-state source of truth WINS over any tier for serve/deploy/store facts
```

Rules that keep the levels from fighting:

1. **One fact, one home.** A fact lives at exactly one tier. Lower tiers point
   up, they do not restate. Restated facts drift and contradict.
2. **Higher tier wins on conflict.** A project file may add detail but must not
   contradict a tier-0 non-negotiable.
3. **Current-state is derived, not asserted.** Serve/deploy/store/host facts come
   from the source-of-truth index, verified from live evidence, never from a
   file's own claim.
4. **Thin index, route don't duplicate.** An instruction file is a router to
   deeper docs, not a copy of them. If two files say the same thing, delete one.

When you find a contradiction, fix it at the source (promote the fact to its
correct tier and make the others point to it) rather than patching the symptom.

## 3. The subagent ladder

Subagents may spawn their own subagents. Each layer is a fresh, scoped context.

- **Depth is bounded.** Most runtimes cap nested spawning (commonly ~5 levels).
  Design for shallow trees; depth is for genuine decomposition, not habit.
- **The spawn knob is the child's toolset.** A child can spawn its own children
  only if its definition grants it the spawning tool. Omit that tool to make a
  leaf worker that cannot recurse. Grant it deliberately, per layer.
- **Scope context down, not across.** Layer N hands layer N+1 only the brief and
  the inputs that layer needs, plus a pointer to the one project context file it
  should load. Children do not inherit siblings' context.
- **Each layer returns a conclusion, not a transcript.** The parent keeps the
  distilled result; the child's working window is thrown away. This is the whole
  point: context stays small at every level.

### Agent definition convention

Define reusable agents as files with this frontmatter (one agent per file, in the
runtime's agents directory):

```yaml
---
name: <kebab-case-name>
description: <when to invoke this agent, the routing trigger>
tools: Read, Grep, Glob, Bash      # add the spawning tool ONLY to allow children
model: <cheapest tier that meets the bar>   # see model guardrails below
---
<system prompt: the role, its scope, what it returns, what it must NOT do>
```

A **project-scoped** agent's description names its project and its `tools`/`model`
are scoped to that project's needs; its system prompt tells it to load that one
project's context file and nothing else.

## 4. Model and cost guardrails

Cost is paid in tokens AND in machine memory (heavy models on a small box can
OOM under fan-out). Default conservative; escalate deliberately.

- **Default children to the cheapest adequate tier** (small/local/fast). Reserve
  the frontier tier for the one layer whose judgment genuinely needs it
  (final synthesis, adversarial review). See `doctrine/contracts/model-routing.md`.
- **Cap concurrency to the host.** Bound parallel heavy-model children to what
  the machine's RAM tolerates; a single deep all-frontier tree is the fastest way
  to a memory panic.
- **Bound the run by construction.** Count/time/token caps per the
  `token-budget` contract. A spawning loop without a cap is an incident waiting.

## 5. Choosing the primitive (use the whole arsenal)

| Situation | Reach for | Why |
|---|---|---|
| Open-ended decomposition; shape unknown until you start | **native subagent spawn** (Agent ladder) | dynamic, model-driven fan-out; each child a clean context |
| Known multi-stage shape (fan-out → verify → synthesize), needs determinism, loops, retries | **workflow orchestration** | deterministic control flow; pipeline beats barrier; resumable |
| One question, want confidence, not just an answer; high-stakes or contested | **multi-model panel** (agent-panel-planning/review) | independent + adversarial perspectives, incl. a different model, before committing |
| Work better done by a specific specialist or cost tier | **delegation skill / team-router** | routes to the right worker role + cost tier + autonomy level |
| Broad read across many files where you only need the conclusion | **read-only explore worker** | locates and concludes without dumping files into your context |

Compose them. A workflow stage can spawn a panel; an orchestrator can delegate a
subtree to a specialist that itself runs a workflow. The skill is matching the
primitive to the *shape and stakes* of the step, not using one for everything.

## 6. Anti-patterns

- **Context bleed.** Handing a child the parent's full window "so it has context."
  It needs a brief, not the world.
- **Frontier-by-default.** Spawning the heaviest model for leaf grunt work.
- **Unbounded recursion.** A spawn loop with no count/time/token cap.
- **Restated facts across tiers.** The root cause of multi-level instruction
  conflicts; fix by promoting to one tier and pointing up.
- **One-primitive-for-everything.** Using a panel for a lookup, or raw fan-out
  for a fixed DAG that wanted a deterministic workflow.

## See also

- `doctrine/tiers/`, the instruction-tier definitions this builds on.
- `doctrine/skills/delegation/SKILL.md`, worker roles, cost-tier routing, autonomy ladder.
- `doctrine/skills/agent-panel-planning/` and `agent-panel-review/`, multi-model panels.
- `doctrine/contracts/model-routing.md`, `doctrine/contracts/token-budget.md`.
- `doctrine/conventions/universal-skill-routing.md`, sharing skills without loading them all.

## Orchestrator-tier policy (panel depth scales with orchestrator strength)

The full staged panel protocol (sealed passes, fixed quorum, checkpoint gates) is scaffolding whose value
depends on who is orchestrating. Policy by orchestrator tier:

- **Frontier orchestrator (Fable-class):** LEAN MODE default. No staged panels. Instead: repo-grounded
  specialist dispatches (code-capable seats read the code before opining), word-capped spec one-shots, and
  a MANDATORY adversarial second model on every load-bearing claim (the wire-check NO-GO review). A panel
  is convened only for contested, years-long-consequence architecture, and then as: disclosed, 3 seats, one
  pass, straight to synthesis; further rounds only if real divergence appears.
- **Mid-tier orchestrators (Opus/Sonnet-class):** FULL staged panel protocol. The staged gates,
  checkpoints, and quorum discipline compensate for thinner synthesis; the protocol is their scaffolding,
  keep it.
- **Always on, every tier (not panel components, fleet law):** utilization-ledger lines, wire-check before
  ship claims, checkpoints on long work, mechanics-over-prose, independent verification (checker != maker).

Evidence base: a week of frontier-orchestrator production sessions. The panel catches that mattered all
came from ONE mechanism: independent refutation, which lean mode keeps. Panel friction (seat misfires,
truncations, phantom deliverables, stage ceremony) consumed orchestrator turns without adding catches when
the first pass converged, which it usually did (see Field Guide Ch 32 on loop-1 convergence).
