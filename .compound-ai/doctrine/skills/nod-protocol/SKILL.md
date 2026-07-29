# Skill: nod-protocol
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

A gated opposite-construction protocol. Forces the strongest version of the
opposite case before any conclusion lands. Each of five gates must clear
before the next is opened. Strawmen fail the gate. The goal is not to win
the argument; the goal is to know what would have to be true for the other
side to be right.

This is the adversarial reasoning skill the kit was missing in v2.0.0.
`detached-judgment` gestures at neutrality; `pressure-test` runs critique;
`nod-protocol` runs structured opposite-construction with refusal rights.

## Triggers

"play devil's advocate", "argue the opposite", "steelman the other side",
"what would [opposite person] say", "construct the opposite case",
"NOD this", "opposite perspective", "what am I missing here",
"is there a strong opposing view"

## How to apply

Run the five gates in order. Do not skip. Each gate has a clear pass criterion.

1. **Gate 1: State the position.** One sentence. No hedging. No "kind of."
2. **Gate 2: Construct the strongest opposite.** Write the opposite case as
   someone who actually believes it would write it. Strawmen fail. Pass test:
   "Would a thoughtful believer in the opposite case sign this paragraph?"
3. **Gate 3: Find the shared assumption.** What does both sides take for
   granted? This is where the highest-leverage challenge lives. Most decisions
   collapse here, not at the position-vs-opposite layer.
4. **Gate 4: Specify the falsifier.** For each side, what would have to be
   true for that side to be right? Make it testable, not rhetorical.
5. **Gate 5: Decide, defer, or refuse.** Three legitimate exits:
   - Decide with stated confidence
   - Defer because the falsifier is testable but not yet tested
   - Refuse to decide because the shared assumption is the real question

Load `reference/gates.md` for full gate procedure and pass-fail criteria.

## Output format

Load `reference/output-template.md`. The output explicitly labels each gate
and its pass status. A failed gate forces a redo; you do not advance past it.

## Anti-patterns

Load `reference/anti-patterns.md`. Common failure modes:
strawman opposite, premature consensus, ego-driven gate-skipping,
"both sides have a point" averaging.

## Pair with

- `parallel-lens-synthesis`  -  run multiple lenses first, then NOD the synthesis
- `detached-judgment`  -  calibrate confidence before the final gate
- `pressure-test`  -  for full adversarial critique with CEO/scope lenses
- `agent-panel-review`  -  when the opposite case needs another agent to write it

## Source references

- `reference/gates.md`  -  five-gate procedure, pass criteria, common failures
- `reference/output-template.md`  -  required output structure
- `reference/anti-patterns.md`  -  how this skill fails when applied lazily
- `reference/origin.md`  -  pattern lineage and attribution
