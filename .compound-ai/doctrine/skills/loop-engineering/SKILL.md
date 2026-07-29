# Loop Engineering

<!-- @origin: compound-ai-operating-standards v3.0.0 -->

When triggered, read the full skill specification at:

```
references/loop-engineering-full-spec.md
```

That file contains the complete framework: the Loop Spec contract, the three
hard stops, build rules, verification patterns, runtime mapping, and
anti-patterns. This SKILL.md is a thin dispatcher: it carries triggers and
points to the spec. Do not inline spec content here.

Use this skill whenever you are about to create or modify any recurring,
self-prompting, or goal-seeking agent run: a scheduled job that invokes an
agent, a /loop or /goal run, an automation, a watcher that re-prompts a model,
or any system that acts without the operator present. No loop runs without a
Loop Spec (template: `doctrine/contracts/loop-spec.md`).

## Source materials

- `references/loop-engineering-full-spec.md` (full skill specification)
- `doctrine/contracts/loop-spec.md` (the per-loop spec template)

Read on demand only.
