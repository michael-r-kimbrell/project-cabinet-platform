# agent-panel-planning: Voting Format

Used at Stage 3 (element-level votes inside cross-feedback) and Stage 6
(final ratification votes on remaining contested decisions). The two
voting moments are different in purpose but share the format.

---

## Stage 3 voting: element-level, post-read

After each panelist has read the others' plans, they vote on specific
decision points the operator surfaced during framing.

**Format:**

```
DECISION-POINT VOTES (Stage 3)

D1  -  [decision point as the operator phrased it]
  Vote: [option chosen]
  Reasoning: [one line]

D2  -  [next decision point]
  Vote: [option chosen]
  Reasoning: [one line]
```

**Rules:**
- One vote per decision point. No abstentions.
- Reasoning required. No bare votes.
- Vote may concede to another agent's proposal explicitly.
- Three to seven decision points is the right range.

**What this voting is NOT.** It is not the final ratification. It is the
panel's directional signal. Disagreements that surface at Stage 3 get
processed through Stage 4 (concession + revise + cross-suggestions) and
Stage 5 (reconvene). The final vote happens at Stage 6.

---

## Stage 6 voting: ratification of remaining splits

After Stage 5's reconvene, some decision points may still be contested
(the panel did not converge on them). The operator surfaces these
remaining splits and runs a final vote.

**Format:**

```
RATIFICATION VOTES (Stage 6)

R1  -  [the remaining contested decision]
  Claude: [option]  -  [reasoning, one line]
  Codex: [option]  -  [reasoning, one line]
  Kiro: [option]  -  [reasoning, one line]
  Operator: [option]  -  [reasoning, one line]
  Locked: [final decision]
```

**The operator votes too.** The panel is advisory; the operator decides.
The operator's vote is on the record with its reasoning, just like the
agents'. This is operator humility made visible: the operator is in the
panel, not above it.

**Tie-break rules (in order):**

1. **Majority of agents.** Three agents, simple majority decides.
2. **Operator's vote breaks ties.** If 1-1-1 or 1-1 with one abstention,
   the operator's vote breaks the tie.
3. **Operator override.** The operator may override a unanimous panel
   vote with explicit reasoning. This should be rare. Frequent overrides
   mean the panel is performance.

---

## What to vote on (and what NOT to vote on)

**Vote on:**
- Specific structural choices (which spine, which title, which framework)
- In-scope / out-of-scope boundaries
- Owner assignments where the panel is genuinely split
- Inclusion / exclusion of specific patterns or artifacts
- Sequencing where order matters

**Do NOT vote on:**
- Subjective preferences with no decision impact ("which color do you
  prefer for the website")  -  operator decides directly
- Things the operator already locked in framing  -  these are not open
- Things the panel agreed on at Stage 3  -  these are not contested
- Compound questions ("should we do X and Y")  -  split into two votes

---

## Vote tally as audit trail

The operator records the full vote tally in the ratification document:

```
RATIFICATION SUMMARY

Decisions locked at Stage 3 (consensus, no Stage 6 vote needed):
  D1 (Title): Compound AI [unanimous]
  D2 (Audience layering approach): Medium-as-layer [unanimous]

Decisions locked at Stage 6 (after voting):
  R1 (Structural spine): Codex's 5-layer
    Vote: Codex/Codex/Codex/Codex (operator). Unanimous.
  R2 (Inclusion of cross-platform translation chapter): Include
    Vote: Claude/Codex/Claude (Kiro abstained on lack of context)/Claude (operator).
    Locked despite Kiro abstention because the case for inclusion was
    clearest at Stage 3.

Decisions left open (deferred to execution):
  Q1 (Specific failure incident for foreword): pending verification
  Q2 (License terms for code samples): pending legal review
```

This summary is the ratification document. It is the canonical record
of what was decided, by whom, and why.

---

## Anti-patterns

### Anti-pattern: voting on everything
**Symptom.** The operator surfaces fifteen decision points. The panel
spends most of its time on micro-decisions.
**Fix.** Three to seven decisions at Stage 3. Anything more becomes
noise. Many "decisions" are actually preferences  -  operator decides
directly.

### Anti-pattern: bare votes
**Symptom.** "D1: Compound AI. D2: Codex's spine."
**Fix.** Reasoning required. The reasoning IS the audit trail.

### Anti-pattern: changing votes silently between Stage 3 and Stage 6
**Symptom.** A panelist voted one way at Stage 3 and another way at
Stage 6 without explanation.
**Fix.** Vote changes between stages are allowed (Stage 4 concession
might shift a position) but must be acknowledged in the Stage 5
reconvene response, not silently flipped.

### Anti-pattern: operator does not vote
**Symptom.** Operator runs the vote but stays out of it.
**Fix.** Operator votes too, with reasoning. The panel is advisory;
the operator is in the panel, not above it. This is the discipline
that makes ratification honest.

### Anti-pattern: operator override without reasoning
**Symptom.** Operator overrides the panel vote without explanation.
**Fix.** Override is allowed but must be on the record with reasoning.
Otherwise the panel was performance.
