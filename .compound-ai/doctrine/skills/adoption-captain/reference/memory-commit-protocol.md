# adoption-captain: Memory-Commit Protocol (Stage 8b)

The kit is not adopted until the host agent's persistent instruction
surfaces have been updated. Until that step is done, every future
session starts kit-adoption from zero. With it, the agent's default
operating context already includes the kit's routing, goal loop, token
budgeting, validation discipline, and preserve rules.

This is the discipline that makes the kit STICK rather than evaporate
between sessions. Stages 1-7 install the kit safely. Stage 8b commits
the kit's durable behavioral overlay to the agent's operating memory.

---

## The principle

The host agent reads instruction files at session start. If those files
do not mention the kit, the agent will not use the kit. If those files
mention the kit as an operating overlay, the agent will use it as a default.

The job is therefore to **update the right instruction files with the
right minimal additions** so the agent inherits kit awareness on every
future session, without overriding the host project's existing rules.

---

## The instruction surfaces (in order of discovery priority)

| Surface | Used by | Scope | Risk if updated wrong |
|---|---|---|---|
| `<project>/CLAUDE.md` | Claude Code | This project | Project-scoped; medium risk |
| `<project>/AGENT.md` | Generic / Codex / etc. | This project | Project-scoped; medium risk |
| `<project>/AGENTS.md` | Codex CLI | This project | Project-scoped; medium risk |
| `<project>/.aider.conf.yml` | Aider | This project | Project-scoped; medium risk |
| `<project>/CONVENTIONS.md` | Aider native | This project | Project-scoped; medium risk |
| `<project>/AGENTS.codex.md` or similar | Codex per-project | This project | Project-scoped; medium risk |
| `~/.claude/CLAUDE.md` | Claude Code | ALL projects for this user | Global; **high risk; explicit consent required** |
| `~/.codex/AGENTS.md` | Codex CLI | ALL projects for this user | Global; **high risk; explicit consent required** |
| Claude Code auto-memory | Claude Code (per-project) | Persistent per-project memory | Project-scoped; medium risk |

Default behavior: update PROJECT-LEVEL surfaces only. Global-level
updates require a separate explicit operator confirmation.

---

## The bounded section format

Every kit addition to an instruction file is delimited by markers so
the addition can be found, updated, or removed without disturbing the
rest of the file.

Markdown surfaces (CLAUDE.md, AGENT.md, AGENTS.md, CONVENTIONS.md):

```markdown
<!-- compound-ai:start v2.6.0 -->
## Compound AI Operating Standards

[contents]

<!-- compound-ai:end -->
```

YAML / config surfaces (.cursorrules if rule-format, .aider.conf.yml):

```yaml
# compound-ai:start v2.6.0
compound-ai:
  kit-path: .compound-ai
  [...]
# compound-ai:end
```

Plain text (rare; some projects use plain CONVENTIONS.txt):

```
# ---- compound-ai:start v2.6.0 ----
[contents]
# ---- compound-ai:end ----
```

The version stamp in the start marker lets future adoption runs detect
upgrades (e.g. v2.6.0 -> v2.7.0 should replace the section, not
duplicate it).

---

## What goes inside the section (per surface)

The contents are tailored from the adoption plan's mapping rubric.
Generic template:

```markdown
## Compound AI Operating Standards

This project uses the Compound AI kit at `.compound-ai/`. When working
in this project, use this durable behavioral overlay unless it conflicts
with preserved project rules.

### Default operating loop

For non-trivial work:

1. Check `.compound-ai/doctrine/conventions/trigger-registry.yaml`
   before answering.
2. Route matching requests through the smallest useful skill chain.
3. Use `goal-runner` for work with a verifiable finish line, backlog,
   multi-step execution, or "keep going until" language.
4. Load the minimum context needed for the current unit.
5. Validate the rendered or user-visible contract before declaring done.
6. Write useful memory at closeout: state, validation, remaining work,
   and promoted patterns.

Claude Code note: if `/goal` is available, it may automate the completion
condition, but the portable contract is still `goal-runner`.

### Adopted skills

The following kit skills are available and should be used when their
triggers fire:

| Skill | When to invoke |
|---|---|
| [skill-name] | [trigger phrase or condition] |
| ... | ... |

The full skill registry is at `.compound-ai/_skills-index.md`. The
router that auto-dispatches is at
`.compound-ai/doctrine/skills/request-router/SKILL.md`.
The machine-readable trigger registry is at
`.compound-ai/doctrine/conventions/trigger-registry.yaml`.

### Preserve rules (from adoption)

The following existing project rules MUST NOT be overridden by kit
defaults:

- [rule from preserve-map.md]
- [rule from preserve-map.md]

If a kit convention conflicts with a project convention, the project
convention wins.

### Validation commands (run after kit-relevant changes)

- Test: `[test command if discoverable]`
- Build: `[build command]`
- Lint: `[lint command]`
- Type-check: `[typecheck command]`

These were detected during adoption. If commands are wrong, update this
section.

### Kit resources for this project

- Kit field guide: `.compound-ai/docs/FIELD-GUIDE.md` (do NOT load in
  full; load specific chapters when an adopted skill requests them)
- Adoption report: `.compound-ai/adoption-report.md`
- Goal-runner contract: `.compound-ai/doctrine/skills/goal-runner/SKILL.md`
- Trigger registry: `.compound-ai/doctrine/conventions/trigger-registry.yaml`
- Release-captain (ship gate for ANY release): invoke via
  router trigger "ship gate"
- Panel skills: invoke for high-stakes deliverables

### Pointer

For the full operating contract, see `.compound-ai/AGENT.md`. This
section is the minimal pointer; the kit's own AGENT.md is the
authoritative version.
```

### Shared skill routing (include only when present)

If the host has multiple agent runtimes sharing skills, add this section:

```markdown
### Shared skill routing

Native runtime roots remain native:

- Claude: `~/.claude/skills`
- OpenSpace/shared agents: `~/.agents/skills`
- Codex-specific: `~/.codex/skills`

Shared skills route to the canonical global root:
`~/.compound-ai/skills`.

Edit the canonical copy first. After changing shared skills, run:

```bash
~/.compound-ai/bin/skill_drift.py
```
```

Only include paths that exist on the host machine. If no shared skill routing
exists, omit this section.

Contents are PROJECT-SPECIFIC, not boilerplate. The "adopted skills"
table includes only what the mapping rubric classified as "adopt now"
or "adopt with adaptation," not the full registry.

---

## Per-surface formatting differences

Most surfaces are markdown and use the template above. Adjustments:

**`.cursorrules`** (Cursor): typically a plain-text rules file. Adapt
the section to plain-text bullet form. Cursor reads it line by line.

**`.aider.conf.yml`** (Aider): YAML configuration. The kit addition
should be a structured `compound-ai:` section, not free-text.

**`AGENTS.md`** (Codex CLI): markdown, but Codex's parser is sensitive
to heading hierarchy. Use `##` for the kit section as shown.

**Claude Code auto-memory**: file-per-fact pattern. Write a single
`compound-ai-kit.md` entry to the auto-memory directory containing the
section contents.

---

## Operator approval flow

Stage 8b is operator-gated per surface. The agent does NOT modify
instruction files silently.

For each surface detected, the agent presents:

1. The path that would be modified
2. The full diff (what will be added; nothing is removed)
3. Whether the surface is project-level or global

The operator approves per surface or declines per surface. A decline
records the decision in the adoption report; the agent does not retry
that surface in this session.

For global surfaces (~/.claude/CLAUDE.md, ~/.codex/AGENTS.md), the
agent surfaces an EXTRA confirmation: "This is a global instruction
file that affects all projects for this user, not just this one.
Confirm you want kit awareness in your global agent context?"

Default for global: skip unless operator explicitly opts in. Most
operators want kit awareness scoped to the project, not their entire
agent surface.

---

## Verifying the commit took effect

After the section is added, the agent confirms:

1. **File exists check**: the surface file now contains the
   marker-bounded section
2. **Marker check**: both `compound-ai:start` and `compound-ai:end`
   markers are present and properly paired
3. **Idempotency check**: running adoption-captain again with the
   same kit version SHOULD detect the existing section and skip the
   addition. (For real upgrade, the version stamp in the start marker
   triggers replacement, not duplication.)

The adoption report's memory-commit section lists each updated surface
with a "verified" timestamp.

---

## Rollback procedure

If the operator wants to fully remove the kit from their instruction
surfaces:

1. Open each surface file listed in the adoption report's memory-commit
   section
2. Locate the `compound-ai:start` ... `compound-ai:end` markers
3. Delete everything between (and including) the markers
4. Save the file

The markers are designed to make this trivially scriptable. A future
`adoption-captain --uninstall` flow could automate this; v2.6.0 ships
the discipline, not the automation.

---

## Anti-patterns

### Anti-pattern: silent edits to global files

**Symptom.** Agent edits `~/.claude/CLAUDE.md` without an explicit
global-scope confirmation.

**Fix.** Global surfaces always require a second confirmation distinct
from the project-level approval flow.

### Anti-pattern: replacing existing sections without markers

**Symptom.** Agent finds existing kit content in CLAUDE.md without
markers and rewrites it directly.

**Fix.** If existing kit content exists without markers, treat it as
operator-authored. Ask before modifying. The marker convention only
applies to additions by `adoption-captain`.

### Anti-pattern: boilerplate contents

**Symptom.** Every project gets the same 22-skill list pasted in.

**Fix.** Contents are tailored from the mapping rubric. Only adopted
skills appear. Triggers are scoped to the project's actual use cases.

### Anti-pattern: skipping the verification step

**Symptom.** Agent reports "memory-commit complete" without confirming
the markers are present and properly formed.

**Fix.** Every memory-commit ends with the three verification checks
listed above. Without verification, the agent cannot honestly claim
the commit succeeded.

### Anti-pattern: updating EVERY surface even if redundant

**Symptom.** Agent updates both `CLAUDE.md` and `AGENT.md` and
`AGENTS.md` when they are all read by the same agent.

**Fix.** Most projects have ONE authoritative instruction surface for
each agent type. Detect which is active; update only that one. If
multiple are active for different agents (e.g. project has both
Claude Code AND Codex sessions), update one per agent.

---

## The verification line in the adoption report

The adoption report's memory-commit section ends with this declaration:

```
Memory-commit verified: yes/no.
Surfaces updated: [list of paths with marker confirmation].
Global surfaces touched: yes (with operator confirmation) / no.
Next session check: [if possible, opened a fresh session and confirmed kit
section loaded; if not possible, document the operator's manual confirmation].
```

Without this line, the adoption report is incomplete and the
release-captain-style discipline of the protocol has been broken.
