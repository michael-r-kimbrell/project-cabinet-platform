# Goal-loop capability

Formal contract behind `doctrine/GOAL-LOOP.md`, for adapters and skills
that want to check conformance rather than just read prose.

## Input shape

```json
{
  "task": "string — what's being asked",
  "acceptance_check": "string — how success will be verified, stated before work starts"
}
```

## Output shape

```json
{
  "done": ["string — what was completed and verified"],
  "not_done": ["string — what was in scope but not completed or not verified"],
  "verification_method": "string — how 'done' items were actually checked (ran it / read the file back / re-fetched the source), not asserted"
}
```

## Conformance test

A conforming loop never reports an item under `done` without a
corresponding entry in `verification_method` that describes an observation,
not an assumption. "I'm confident it works" is not a verification method.
"I ran the design-proposal generator against three test inputs and checked
the output dimensions match" is.
