# Loop Engineering: Full Specification

<!-- @origin: compound-ai-operating-standards v3.0.0 -->

A loop is cron plus a decision-maker in the body. A cron job runs a fixed
script. A loop runs a model that reads the current state, decides the next
action, acts, checks whether it worked, and decides whether to continue. The
decision belongs to the agent, not a hardcoded branch. Everything in this
specification is what you wrap around that decision so the loop is an asset
instead of an incident.

This skill applies whenever you build or modify ANY recurring agent run:
scheduled jobs that invoke an agent, /loop or /goal style runs, automations,
watchers, or anything that re-prompts a model without the operator present.

## The anatomy (six parts every durable loop assembles)

1. **Automation**: the schedule or event trigger that makes it a loop instead
   of one run you did once.
2. **Isolation**: worktrees or per-agent file ownership when loops run in
   parallel. Two writers in one checkout is a collision scheduled for later.
3. **Skills**: externalized intent the loop reads every cycle instead of
   re-deriving the project from zero. The loop is plumbing; the skill library
   is the asset.
4. **Connectors**: the hands that act in real systems (CLIs, APIs, MCP).
5. **Sub-agents**: the maker/checker split. The model that wrote the work is
   too generous grading its own homework.
6. **Memory on disk**: a state file outside any conversation recording what
   was tried, what passed, what is open. The agent forgets between runs; the
   repo does not.

## Before you build: the Loop Spec

No loop runs without a spec. Copy `doctrine/contracts/loop-spec.md`
next to the loop's code or into its job definition and fill every field:

1. **Purpose**: one sentence, what the loop produces.
2. **Goal / stop condition**: VERIFIABLE. A check a fresh model or a script
   can evaluate ("all tests in test/auth pass and lint is clean"). Never a
   vibe ("looks done").
3. **Cadence + trigger**: schedule (cron/interval) or event; which runtime
   owns it.
4. **The three hard stops** (all required; a loop missing any of the three is
   not a loop, it is an incident scheduled for later):
   - Max iterations per run AND per goal. The loop halts at N no matter what.
   - No-progress rule: two iterations with no state change, or a repeat of an
     already-rejected change, halt the loop.
   - Budget ceiling: tokens, wall-clock, dollars, or subscription quota,
     whichever binds first.
5. **Verification**: who checks, and that the checker is not the maker. Name
   the gate: a separate sub-agent, a validator model, a script, CI.
6. **Memory**: the on-disk state file or ledger the loop reads first and
   writes last, with its path.
7. **Escalation**: where failures and findings land (inbox file, ticket,
   alert channel), and what is NEVER auto-acted on.
8. **Autonomy ceiling**: how much unsupervised scope the loop gets, justified
   by reversibility and blast radius. A loop that ships public artifacts earns
   tighter gates than one that reads logs.
9. **Open or closed**: closed by default. Closed loops are bounded: the human
   builds the path first, the goal is explicit, every step has an eval. Open
   exploratory loops require an explicit operator go and a tighter budget.

## Build rules

- **One atomic change per iteration**: explainable in one sentence,
  attributable when a metric moves. Never bundle unrelated changes.
- **Read state before every iteration.** After rollbacks, reality differs
  from your assumption. State file first, then recent results, then act.
- **Reset context each iteration** to the anchor set: spec + state file +
  skills, not the accumulated conversation. Accumulated context drifts;
  anchored context repeats reliably.
- **Skills over inline prompts.** If the loop's prompt explains the project,
  extract that into a skill and have the loop load it.
- **Memory on disk, not in context.** Append-only where feasible; the next
  run picks up where this one stopped.
- **Fail loud.** Empty output, swallowed exceptions, and exit-0 lies are
  forbidden. A loop that cannot fail visibly cannot be trusted to run alone.
  Assert three things: freshness (it ran when it should), exit (it ended
  cleanly), output (it produced what it claims).

## Verification patterns

- Maker/checker sub-agent split: different instructions, ideally a different
  model.
- Validator pattern: a fresh model evaluates the stop condition, not the
  worker that produced the work.
- Mechanical metric: a number a script computes. If you cannot compute it,
  redesign the stop condition until you can.
- Existing gates: CI, tests, linters, content-review gates already in the
  host project.
- Post-publish verification: a later check confirms the artifact actually
  landed where it claims. Done is a claim, not a proof.

## Runtime mapping (adapt to what the host has)

- **Claude Code**: /loop (interval runs), hooks (lifecycle triggers), Agent
  tool and agent teams (sub-agents), worktree isolation, skills directories.
- **Codex**: Automations (schedule + triage inbox), skill invocation,
  per-agent sub-agent configs, built-in worktrees, /goal.
- **Any agent CLI**: system scheduler (cron, launchd, Task Scheduler) wrapping
  a headless invocation that loads the anchor set. Prefer the agent runtime's
  own scheduler when the loop needs agent decisions; prefer a plain script
  when the work is deterministic (script-first rule: do not spend model calls
  on work a script does better).

## Operating an existing loop

- Pause over delete. Reversible disable with a dated suffix.
- Every loop appears in a job registry with a health contract. A loop nobody
  monitors is a silent failure factory.
- When a loop fails twice consecutively, it files its own escalation and
  stops. It does not keep burning iterations.
- Loop output is reviewed by a human at the cadence named in the spec.
  Comprehension debt is real: if the operator stops reading what the loop
  ships, the loop gets paused.

## Anti-patterns (refuse these)

- A loop without all three hard stops.
- Stop conditions that are vibes ("until it's good").
- The maker grading its own homework.
- State that lives only in the conversation context.
- Open-ended exploration on a default budget.
- Re-prompting the full project context every iteration instead of extracting
  a skill.
- A second loop added because the first one was never registered or
  monitored. Consolidate; do not accrete.
