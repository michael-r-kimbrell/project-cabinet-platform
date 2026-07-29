# Loop Engineering

> Compound AI Operating Standards, doctrine module. Drafted 2026-06-10 from production practice on
> a local agent machine plus the June 2026 loops discourse. Sources: Boris Cherny (WorkOS Acquired Unplugged,
> 2026-06-02), Peter Steinberger (2026-06-07), Addy Osmani "Loop Engineering." (2026-06-08), Matt Van
> Horn "WTF Is a Loop?" (2026-06-08), Shann Holmberg's loop taxonomy (2026-06-08), Geoffrey Huntley's
> ralph loop (2025). Slots into the FIELD-GUIDE as the loop chapter; the operational counterpart is
> `compound-ai/skills/loop-engineering/SKILL.md`.

## The one-sentence version

Stop being the thing inside the loop. Design the system that prompts the agents, give it skills worth
calling, feedback so it can check itself, hard stops so it halts, memory on disk so it compounds, and
let it run on schedule while you decide what to build next.

"I don't prompt Claude anymore. I have loops running that prompt Claude and figuring out what to do.
My job is to write loops." (Boris Cherny). "You shouldn't be prompting coding agents anymore. You
should be designing loops that prompt your agents." (Peter Steinberger).

## What a loop is (and is not)

A loop is **cron plus a decision-maker in the body**. A cron job runs a fixed script; a loop runs a
model that reads current state, decides the next action, acts, checks whether it worked, and decides
whether to continue. The decision belongs to the agent, not a hardcoded branch. Stack loops so one
dispatches and supervises others, give them durable shared state, and you have something cron cannot
express. Everything interesting in loop engineering is what you wrap around that decision so it does
not run off a cliff.

The lineage, so we stop talking past each other: ReAct (2022, reason-act-observe under a watching
human) -> AutoGPT (2023, self-prompting toward a goal, famous for spinning) -> the ralph loop
(Huntley 2025, the same prompt file piped into the agent repeatedly, every iteration resetting
context to fixed anchor files) -> productized /goal and /loop commands (2026, run until a separate
validator confirms the stop condition) -> orchestration loops (now: loops supervising loops, on
schedule, with git-backed durable state). The single-agent ralph loop is the floor, not the
frontier; the orchestration layer above it is what changed in 2026.

## The anatomy: five building blocks plus memory (Osmani)

Every durable loop is assembled from the same six parts, whatever the runtime:

1. **Automations**, the heartbeat. Scheduled runs that do discovery and triage on their own and
   surface findings to a triage inbox. Without a schedule it is one run you did once, not a loop.
2. **Worktrees**, the isolation. Parallel agents get separate checkouts of shared history so edits
   cannot collide. Worktrees remove the mechanical collision; the operator's review bandwidth stays
   the real ceiling.
3. **Skills**, the compounding asset. Externalized intent: conventions, build steps, the
   "we don't do it like this because of that one incident", written once where every run reads it.
   A loop with no skills re-derives the project from zero every cycle and just burns money. A loop
   that calls sharp, named, tested skills compounds. **The loop is plumbing. The skill library is
   the asset.** (This is why compound-ai exists.)
4. **Connectors**, the hands. MCP and tool plugins so the loop acts in real systems: opens the PR,
   updates the ticket, posts the alert. A loop that can only see the filesystem is a tiny loop.
5. **Sub-agents**, the maker/checker split. The model that wrote the work is too nice grading its
   own homework. A separate verifier, with different instructions and ideally a different model,
   judges the work and the stop condition. The verifier is the only reason you can walk away.
6. **Memory on disk**, the spine. A markdown state file, a board, a ledger: what was tried, what
   passed, what is open, living outside any single conversation. The agent forgets between runs;
   the repo does not. Sounds too dumb to matter; it is the trick every long-running system depends
   on.

## The loop cycle (Holmberg)

Every agent in a loop, at every level of the tree, runs the same five phases: **Discovery** (find
what it needs to know) -> **Planning** (break into clear steps) -> **Execution** (do the work) ->
**Verification** (check against goal AND standard) -> **Iteration** (fix gaps, loop again; on pass,
hand off or ship). Fleet loops are the same cycle fractally: an orchestrator owns the goal,
specialists own slices, sub-agents own tasks, and every node runs discovery-through-iteration.

## Closed over open (the economics)

Open loops roam, discover, and build in wide space; they burn unbounded tokens and a loose standard
turns them into a fast slop machine. Closed loops are bounded: the human builds the path first, the
goal is explicit, the steps are set, and every step has an eval. Closed loops are cheap, repeatable,
and improve every run. **The standard is what keeps it honest.**

Default for a local agent machine: closed loops. Open/exploratory loops are an explicit operator decision with
an explicit budget, never a default.

## The three hard stops (non-negotiable)

The costliest thing is no longer writing the code, it is managing the loop, and the failure mode
everyone in production fears is the loop that does not stop. Every loop on a local agent machine carries all
three, declared in its spec before it first runs:

1. **A maximum iteration count.** The loop halts at N no matter what.
2. **No-progress detection.** Two consecutive iterations with no state change (or a repeated
   already-rejected change) halt the loop. Never re-try the exact change already discarded.
3. **A budget ceiling.** Tokens, wall-clock, or dollars; whichever binds first. On a local agent machine the
   spend rule is inherited from universal doctrine: subscription and local capacity only, never
   metered API spend, so the ceiling is expressed in iterations, time, and subscription quota.

A loop missing any of the three is not a loop, it is an incident scheduled for later.

## Verification is the product

The fastest-growing theme in the discourse and the oldest rule in this stack ("wired or it isn't
done"; "exit 0 lies"): an open feedback path that writes without checking is a machine for
generating confident mistakes. Requirements:

- The stop condition is **verifiable**, stated as a check a fresh model or a script can evaluate
  ("all tests in test/auth pass and lint is clean"), never a vibe ("looks done").
- The checker is not the maker (separate sub-agent, different instructions, ideally different model;
  common patterns: a sealed review panel, a code-review pass, the Hermes vision gate on
  generated images, a registry-maintenance loop's health contracts).
- Done is a claim, not a proof, even with a verifier. Loops that ship artifacts route them through
  the same quality gates a human would face (a content reviewer, image rubric, CI).

## What the loop does not do for you (Osmani's warnings)

1. Verification responsibility stays with the operator: a loop running unattended is also a loop
   making mistakes unattended.
2. **Comprehension debt**: the faster the loop ships work you did not write, the wider the gap
   between what exists and what you understand, unless you read what it made.
3. **Cognitive surrender**: designing the loop with judgment is the cure; designing it to avoid
   thinking is the accelerant. Same action, opposite result. Build the loop; stay the engineer.

## How this maps onto a local agent machine

The primitives already exist here; loop engineering names and standardizes them:

| Building block | Claude Code | Codex | Hermes | System |
|---|---|---|---|---|
| Automations | /loop, hooks, scheduled cloud agents | Automations tab, $skills on schedule | cron jobs.json (interval/cron/once), no_agent scripts | launchd |
| Worktrees | --worktree, isolation: worktree subagents | built-in worktree threads | workdir field | n/a |
| Sub-agents | Agent tool, agent teams, Workflow | .codex/agents TOML | delegation toolset | n/a |
| Memory | state files, MEMORY.md, session logs | same files | cron output dirs + memory book | a shared workspace directory, ledgers |

Existing loops to retrofit under this standard: autoresearch (already implements the cycle and
mechanical-metric verification; needs the three hard stops declared per run), a content-and-website
automation fleet (several closed loops with vision and content gates), the IIP overnight pipeline (L4 with checkpoints), a
registry-maintenance loop design (a monitoring loop whose stop condition is the health contract).

The L1-L5 autonomy ladder is the permission system for loops: a loop's autonomy ceiling is set by
reversibility and blast radius (delegation.md), and bounded loops with checkpoints are L3, goal-run
loops with self-verification are L4. No loop on a local agent machine runs L5.

## The spec is mechanically checked (the validator contract)

A Loop Spec is no longer prose-only doctrine. A validator CLI checks every spec file
against ten mandatory fields: Purpose (<=280 chars), Origin, Runtime + Trigger, Inputs,
Outputs, Mutation Policy, Failure Policy, Registry Entry, Verification, Invariants.
Labels are case/spacing-insensitive; extra doctrine fields (Owner, Goal/stop, No-progress,
Budget ceiling, Autonomy ceiling...) are kept and ignored by the validator. `Invariants`
must be a table row or a trailing labeled line, never a `##` heading. A recurring
fleet-jobs audit matches every scheduled job to a spec by filename stem OR by the exact
scheduler label / cron id in Registry Entry, so that field must be exact. The loop-spec
template carries all ten fields; an earlier template missing six of them was the root
cause of a 41-of-42-invalid spec debt.

## Heartbeat instrumentation (the scheduler-tier verification layer)

Scheduled jobs lie by omission: the scheduler (launchd, cron) only knows the last exit
code, and a job that never fires leaves no evidence at all. The fix: failure-prone jobs
run inside a heartbeat wrapper (`heartbeat run --label <label> --max-runtime <s>
--expect-every <s> -- <original argv>`) that passes the child's exit code through
untouched and writes ground truth per label: pid, beat mtime, real exit code, duration.
A single scan job (every 30 minutes) alerts the operator channel on CRASHED, STALLED, or
MISSED, the "never fired" case no other watcher catches. Known gap, stated in its spec:
nonzero exits are recorded but not yet alerted. Adoption is job-by-job wrapping of the
scheduler entry; the instrumented set lives in the scan job's own Loop Spec Registry Entry.

## Attribution

Boris Cherny and Peter Steinberger framed the practice; Geoffrey Huntley's ralph loop proved the
discipline of context resets; Addy Osmani named the five building blocks and the failure modes;
Matt Van Horn traced the lineage and the economics; Shann Holmberg drew the taxonomy. The
synthesis, the closed-loop default, and the machine mapping are ours, paid for in production.
