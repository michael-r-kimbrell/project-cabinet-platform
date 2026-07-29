# agent-panel-planning: Strength-Matched Task Assignment

Stage 6's task split. The rule: tasks go to whoever **demonstrated dominant
capability on that dimension in this round**, not to whoever has the role
label.

This is the move that makes the panel pattern more than ceremony. Without
strength-matched assignment, agents agree but no one is accountable for the
work. With it, the plan ships with explicit owners whose ownership is
empirically justified.

---

## The principle: empirical, not categorical

| Categorical assignment (wrong) | Empirical assignment (right) |
|---|---|
| "Claude is the voice agent" | "On this round, Claude's foreword was strongest. Claude owns voice." |
| "Codex is the architecture agent" | "On this round, Codex's spine had the most breadth. Codex owns spine." |
| "Kiro is the substance agent" | "On this round, Kiro's Part V density beat the others. Kiro owns substance migration." |

The same agent on a different panel for a different deliverable might
end up with a different role. Strengths are demonstrated per-round, not
preset.

---

## What to assign

The task split table covers:

1. **Major sections of the deliverable.** Spine, body, opening, attribution,
   provenance, packaging.
2. **Specific artifacts.** Foreword, manifest, code samples, glossary.
3. **Process roles for execution.** Editor of last resort, ratification
   gatekeeper, integration point.
4. **Open questions.** Each open question gets an owner who will close it.

Minimum table size: one task per agent. Maximum: as many tasks as there
are agents-times-dimensions, but more than ~3 tasks per agent gets
unwieldy.

---

## The assignment process

**Step 1: List the dimensions of the deliverable.**

These come from the ratified plan. Examples for a field guide:
- Structural spine
- Substance body
- Foreword and voice
- Code samples
- Attribution architecture
- Manifest and provenance
- Vendor-neutral translation

**Step 2: For each dimension, identify who demonstrated dominance.**

Read the Stage 3 cross-feedback (the "strongest claim" cells) and the
Stage 5 reconvene outputs. The agent most frequently named as strongest
on a dimension owns it.

If two agents are roughly tied on a dimension, the tie-break heuristic:
- The agent whose plan most directly addressed that dimension wins it
- If still tied, the agent whose cross-suggestions on this dimension
  were most actionable wins
- If still tied, the operator decides

**Step 3: Write the assignment table.**

```
TASK ASSIGNMENT (ratified)

| Task | Owner | Why |
|---|---|---|
| Structural spine | Codex | Stage 3 strongest-claim cell; Stage 5 reconvene confirmed. |
| Substance body Parts II-V | Kiro | Density and code-sample integration in first-pass plan. |
| Foreword + attribution architecture | Claude | First-pass plan included the annotated artifact concept. |
| Provenance scripts + manifest | Codex | First-pass plan was the only one to surface provenance verification. |
| Cross-platform translation chapter | Claude | First-pass plan proposed it; other plans missed it. |
| "What I'm leaving out" discipline | Claude | First-pass framing of negative-space discipline. |
```

The "Why" column is the audit trail. Without it, the assignment looks
arbitrary; with it, the assignment is defensible.

**Step 4: Lock the dependencies.**

Some tasks block others. Spine before body. Body before foreword. Foreword
before manifest. The assignment table should be paired with a dependency
graph (or at minimum a sequencing note) so the panel knows in what order
the assigned work executes.

---

## What happens when no agent dominated a dimension

Three options, in order of preference:

1. **Operator owns it.** If the panel did not surface a clear dominant
   agent on a dimension, the operator may take ownership directly. This
   is honest about the panel's limits.

2. **Pair assignment.** Two agents share the dimension. One drafts, the
   other reviews. Less efficient but produces signal on a dimension
   the panel could not resolve alone.

3. **Defer the dimension.** Some dimensions can be deferred to execution
   (the agent doing the surrounding work absorbs it). Flag explicitly
   in the ratification document so it does not vanish.

The wrong move: assign it to whoever has bandwidth. Bandwidth-based
assignment defeats the empirical-strength rule.

---

## Operator's discipline at task assignment

**The operator may override the panel's recommendations.** The panel
proposes; the operator decides. But overrides should be rare and
justified. If the operator routinely overrides, the panel is performance.

**The operator may add their own tasks.** Some pieces of the work do not
fit the panel's framing (e.g. "the operator approves the manifest before
release"). Add these explicitly.

**The operator may decline to assign a task.** If a task is genuinely
unclear, leave it unassigned and surface it as an open question that
must close before execution. This is honest about uncertainty.

---

## Common failure modes

### Failure: assignments follow preset role labels
**Symptom.** Claude got voice, Codex got architecture, Kiro got substance,
exactly as in the previous panel. No empirical basis cited.
**Fix.** Read the actual Stage 3 cross-feedback. Maybe Claude's spine
beat Codex's on this round. Reassign based on what the panel actually
showed, not on prior assumption.

### Failure: every dimension goes to a different agent
**Symptom.** Three agents, three dimensions per agent. Clean but
suspicious  -  real strengths cluster.
**Fix.** It is fine for one agent to own 4-5 dimensions if they
genuinely dominated. Forcing parity is artificial.

### Failure: tasks without "Why"
**Symptom.** Assignment table has Task and Owner but no audit trail.
**Fix.** The Why column is the difference between a defensible
assignment and an arbitrary one. Always include it.

### Failure: assignment without sequencing
**Symptom.** Three agents each have three tasks, all "start now."
Dependencies not surfaced.
**Fix.** Pair the assignment table with a sequencing note. Even a
rough order of operations beats parallel chaos.
