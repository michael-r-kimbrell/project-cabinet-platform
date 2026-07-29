# agent-panel-planning: Concession Discipline (Stage 4)

Stage 4 is sealed again. Each panelist produces three outputs without
seeing the other panelists' revisions. The three outputs are:

1. **Concession + attribution**  -  what is conceded, to whom, on what dimension
2. **Revised private plan**  -  the agent's plan, revised
3. **Path-forward suggestions for the OTHER agents**  -  concrete adjustments
   proposed for each other panelist's plan

The third output is the load-bearing one. Most multi-agent workflows skip
it. Skipping it produces three improved-but-still-distinct plans. Including
it sets up Stage 5's reconvene with the cross-information needed to actually
converge.

---

## Output 1: Concession + attribution

The format is explicit. Each concession names the dimension and the agent
who won that dimension.

```
CONCESSIONS

Concede to [Agent X] on [dimension]:
  [One-line reasoning. What did their plan get right that mine did not?]

Concede to [Agent Y] on [dimension]:
  [One-line reasoning.]

Hold on [dimension]:
  [What I am not conceding, and why. One line.]
```

**Example (synthetic):**

```
CONCESSIONS

Concede to Codex on structural spine:
  Codex's 5-layer spine is more parsimonious than my Part I-VI; substance
  maps cleanly onto it without overhang.

Concede to Kiro on substance density in Part V:
  Kiro's Quality Immune System framing is sharper than my draft; it should
  be the canonical version.

Concede to operator's framing on audience layering:
  Medium-as-layer (website does exec work, deliverables do builder work)
  supersedes my within-document layering proposal.

Hold on cross-platform translation chapter:
  Both other plans omit this. I am keeping it; the kit needs it.
```

**Rules:**
- One concession per dimension, no compound concessions
- Each concession names a specific other agent (or the operator's framing)
- "Hold" lines are allowed and important; they prevent capitulation
- No concession means no concession  -  do not invent one to look reasonable

---

## Output 2: Revised private plan

The agent's own plan, revised. The revision absorbs all concessions and
any unaccepted critiques get one line of dissent.

**The hard rule: adopt or dissent in one line.** A revision that turns
into a 500-word defense of the original plan is relitigation. The protocol
breaks here. Force the one-line dissent rule.

**Healthy revision profile:**
- ~60-80% of cross-feedback absorbed
- ~20-40% retained as original signal with one-line dissents
- The plan reads as a stronger version of the first pass, not as a
  capitulation to the others

**Two failure modes bracket the healthy revision:**

| Failure | Symptom | Fix |
|---|---|---|
| **Relitigation** | 500-word defense of original plan | One-line dissent rule. Move on. |
| **Capitulation** | Adopts every critique without judgment | Each panelist must retain some original signal. Otherwise panel flattens into groupthink. |

---

## Output 3: Path-forward suggestions for the OTHER agents

This is the move that makes the panel collaborative rather than competitive.
Each agent, having now absorbed the critiques of its own plan, proposes
specific adjustments for the other agents' plans.

**Format:**

```
PATH FORWARD: SUGGESTIONS FOR OTHERS

For [Agent X]:
  1. [Specific adjustment with reasoning.]
  2. [Specific adjustment with reasoning.]

For [Agent Y]:
  1. [Specific adjustment with reasoning.]
  2. [Specific adjustment with reasoning.]
```

**Example (synthetic):**

```
PATH FORWARD: SUGGESTIONS FOR OTHERS

For Codex:
  1. Add audience-layering explicitly  -  your spine does not name how the
     plan reaches different audiences. Adopt Cameron's medium-as-layer.
  2. The "five locked decisions" list is good but missing a sixth on
     voice/persona; surface it for the operator at Stage 6.

For Kiro:
  1. Your Part V substance is the strongest; consider pulling the Quality
     Immune System framing into its own section so it can be cited
     independently.
  2. The code samples need vendor-neutral translation; right now they
     name specific subsystems that should be abstracted.
```

**Rules:**
- 2-4 specific adjustments per other agent (not more)
- Each must be actionable, not advisory ("consider thinking about" fails)
- Reasoning required per suggestion
- No "you should do what I did" suggestions  -  that is competitive, not
  collaborative

**Why this move matters.**

Without Output 3, every agent revises only its own plan. At Stage 5
reconvene, each agent reads two improved-but-still-distinct plans and
has no targeted information about what the others recommend they do
next. Convergence becomes a guessing game.

With Output 3, each agent arrives at Stage 5 with two sets of incoming
suggestions for themselves plus the revised plans. Reconvene then has
real information to converge on: each agent can accept some incoming
suggestions, reject others, and arrive at a position the panel has
collectively shaped.

---

## Anti-patterns

### Anti-pattern: no concessions ("my plan was great")
**Symptom.** The concession block is empty or trivial ("I concede the
typo in line 3").
**Fix.** Every first-pass plan has real concessions to make. If the
panelist cannot find any, the cross-feedback failed or the agent is
defending too hard. Redo Stage 3 or restart Stage 4.

### Anti-pattern: total concession ("everyone else was right")
**Symptom.** The agent concedes everything and produces a revised plan
that is essentially one of the other agents' plans.
**Fix.** Retain some original signal. The panel is supposed to produce
convergence, not collapse.

### Anti-pattern: missing Output 3
**Symptom.** Concessions + revised plan, but no path-forward for others.
**Fix.** This is the load-bearing move. Without it, Stage 5 reconvene
has no cross-information and the panel will produce three distinct
plans rather than converged consensus. Redo.

### Anti-pattern: vague cross-suggestions
**Symptom.** "Codex should think about audience layering."
**Fix.** Specific and actionable. "Codex's spine adds a section after
Layer 3 that names the website as exec layer and downloads as builder
layer."

### Anti-pattern: self-flattering cross-suggestions
**Symptom.** "Codex should adopt my spine."
**Fix.** Cross-suggestions should help the other agent's plan get
stronger on its own terms, not converge toward yours. If the
suggestion reads "do what I did," rewrite it.
