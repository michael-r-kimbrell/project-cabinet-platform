# nod-protocol: Output Template

The output explicitly labels each gate. A failed gate is shown as failed,
not hidden. Readers can trust the protocol ran because they can read the
gate sequence and see no skips.

---

## Standard output

```
NOD PROTOCOL  -  [topic in 5-8 words]

Gate 1: Position
  [one sentence position]
  Pass: yes

Gate 2: Strongest opposite
  [3-6 sentences in the voice of a believer in the opposite case]
  Signing test: would a thoughtful opposite-side believer sign this? [yes/no]
  Pass: yes / redo

Gate 3: Shared assumption
  Both sides assume: [the assumption, one sentence]
  Pass: yes / not yet

Gate 4: Falsifiers
  Position is right if: [specific, testable]
  Opposite is right if: [specific, testable]
  Pass: yes / asymmetric / unfalsifiable

Gate 5: Exit
  Exit chosen: [Decide / Defer / Refuse]
  [The matching follow-on per the exit selected  -  see below]
  Pass: yes
```

## Per-exit content

### If Exit A: Decide
```
Decision: [position or opposite]
Confidence: [high / medium / low]
Reason: [why this side's falsifier is more likely satisfied]
What would change my mind: [specific, observable]
```

### If Exit B: Defer
```
Test to run: [specific test from Gate 4]
Cost: [time, money, opportunity cost]
Deadline: [date]
Owner: [who runs the test]
```

### If Exit C: Refuse
```
The real question is upstream: [the Gate 3 shared assumption]
Routing: [who needs to resolve the upstream question]
Why deciding now would be wrong: [one sentence]
```

---

## Worked example (synthetic)

```
NOD PROTOCOL  -  Whether to add a new agent to the daily pipeline

Gate 1: Position
  We should add the new triage agent to the daily 7 AM pipeline.
  Pass: yes

Gate 2: Strongest opposite
  Adding agents to the daily pipeline is how reliability dies. Every new
  agent introduces a new failure mode that does not surface until the
  pipeline is already in production. The triage value is real but the
  daily slot is not the right entry point  -  bake it into the weekly
  review where a human is already watching, then promote to daily after
  three weeks of clean runs.
  Signing test: yes, an SRE-minded operator would sign this.
  Pass: yes

Gate 3: Shared assumption
  Both sides assume the triage agent is the right agent for this work.
  Neither side has questioned whether triage should be agent-driven at
  all, or whether a rules-based filter would solve 80% of the value at
  10% of the operational burden.
  Pass: yes

Gate 4: Falsifiers
  Position is right if: triage agent runs 14 consecutive days with no
  silent failures and produces actionable output on at least 10 of 14
  days as judged by the operator.
  Opposite is right if: the triage agent has at least one silent failure
  in the first 14 days that requires manual intervention to catch.
  Pass: yes  -  both falsifiers are concrete and resolvable in 14 days.

Gate 5: Exit
  Exit chosen: Defer
  Test to run: 14-day weekly-slot trial of the triage agent, scoring
    actionable-output rate and silent-failure rate.
  Cost: ~2 operator-hours per week for monitoring.
  Deadline: 14 days from start.
  Owner: operator running the weekly review.
  Pass: yes
```

---

## Compact output (for inline use)

When NOD runs as a sub-step of another skill (e.g. inside
`pressure-test` or `parallel-lens-synthesis`), a compact form is fine:

```
NOD: position [X] / opposite [Y] / shared assumption [Z] /
falsifier-asymmetric: no / exit: Defer until [test]
```

Compact output still requires every gate to have run. It just suppresses
the prose.
