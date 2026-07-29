# adoption-captain: Non-Breaking Rules (Stage 6)

Stage 6 applies the changes approved in Stage 5. This document defines
the hard constraints that prevent Stage 6 from becoming destructive.
Every rule here applies regardless of what the operator approved in Stage 5.

---

## Default placement

The kit goes in `.compound-ai/` at the project root.

```
<project-root>/
  .compound-ai/
    AGENT.md
    _skills-index.md
    adoption-report.md
    discovery-report.md
    preserve-map.md
    doctrine/tiers/
    doctrine/skills/
    docs/
```

**Never** place kit content in the project root itself. Files dropped at the
project root become part of the project and are at high risk of being
committed, pushed, or confused with project files. `.compound-ai/` is a clear
namespace boundary.

---

## Files that require explicit per-file approval before modification

The agent MUST NOT modify any of the following files without showing the exact
change (diff or full replacement block) and receiving a per-file "yes" from
the operator. "Accept Phase 1" from Stage 5 is not sufficient for this list.

### Agent instruction files

- `CLAUDE.md`
- `AGENT.md`
- `AGENTS.md`
- `AGENTS.codex.md`
- `.cursorrules`
- `.aider.conf.yml`
- `CONVENTIONS.md`
- Any other instruction file discovered in Stage 1

Even when the adoption plan proposes a minimal pointer addition, the agent
presents the exact diff and waits for per-file approval before writing.

### Project state and history files

- `README.md`
- `STATE.md`
- `session-log.md`
- `BACKLOG.md`
- `CHANGELOG.md`
- `TODO.md`
- `ENHANCEMENTS.md`

These files represent the operator's own record of the project. The kit has
no legitimate reason to modify them during adoption.

### Package and build files

- `package.json`
- `package-lock.json`
- `yarn.lock`
- `pnpm-lock.yaml`
- `pyproject.toml`
- `setup.py`
- `setup.cfg`
- `requirements.txt`
- `Cargo.toml`
- `Cargo.lock`
- `go.mod`
- `go.sum`
- `Gemfile`
- `Gemfile.lock`
- `Makefile`

The kit does not modify package or dependency files during adoption. If a
kit feature requires a new dependency (unlikely for a prompt-layer tool), this
is surfaced as a separate proposal, not a silent write.

### CI and deploy configuration

- `.github/workflows/*.yml`
- `vercel.json`
- `fly.toml`
- `railway.toml`
- `netlify.toml`
- `render.yaml`
- `.circleci/config.yml`
- `Dockerfile`
- `docker-compose.yml`

CI and deploy configs govern what happens in production. The kit does not
touch them without an explicit proposal reviewed by the operator.

---

## The "ask before" protocol

When Stage 6 encounters a file on the protected list that the adoption plan
proposes to modify, the agent:

1. Pauses before making the change
2. States: "I am about to modify [file]. This file is on the protected list.
   The planned change is: [exact diff]. Confirm?"
3. Waits for explicit "yes" per file
4. If "no": records the decision in the adoption report and skips that file;
   does not retry in this session

A batch "yes to all" is acceptable only if the operator explicitly states it
applies to the named files after reviewing all diffs.

---

## Handling an existing `.compound-ai/` directory

If `.compound-ai/` already exists at the project root, it may be:

- A prior installation of this kit (upgrade scenario)
- A different tool that uses the same path (rare, but possible)
- Operator-created scaffolding that should not be overwritten

**Detection step** (Stage 1 should have caught this, but confirm at Stage 6):

```bash
ls .compound-ai/
cat .compound-ai/AGENT.md 2>/dev/null | head -5
```

**Outcomes:**

| What is found | Action |
|---|---|
| Prior kit installation (AGENT.md has compound-ai header) | Upgrade scenario: present version comparison and propose selective updates |
| Unknown content (no kit markers) | Do not overwrite; surface to operator: "`.compound-ai/` exists and does not appear to be a prior kit installation. What should I do?" |
| Empty directory | Proceed normally |

**Upgrade vs. replacement.**

For a prior kit installation, the agent compares the existing kit version
(from the `AGENT.md` header or from any version stamp in the directory) to
the current kit version (v2.6.0). The agent then:

1. Lists files that are new in v2.6.0 (safe to add)
2. Lists files that have changed (propose replacement per file)
3. Lists files that are in the existing kit but not in v2.6.0 (surface to
   operator: "these files are from the prior version and may no longer be
   needed; should I remove them?")

Never silently overwrite an existing `.compound-ai/` directory.

---

## Non-default installation paths

If the operator requests a non-default path (e.g. `.ai/`, `_compound/`,
`tools/kit/`), that is permitted with these constraints:

1. Record the non-default path in the adoption report
2. All references within the kit's own files that point to `.compound-ai/`
   must be updated to the custom path
3. The memory-commit section in instruction files must use the custom path
4. The rollback procedure below must reference the custom path

The validation step (Stage 7) must still pass with the kit at the custom path.

---

## Rollback procedure

To fully remove the kit from a project after adoption:

**Step 1.** Delete the kit directory:

```bash
rm -rf .compound-ai/
# Or the custom path if non-default was used
```

**Step 2.** Remove the marker-bounded sections from instruction files. For
each file listed in the adoption report under "Memory-commit: surfaces
updated":

```bash
# Open the file and delete from:
#   <!-- compound-ai:start v2.6.0 -->
# to (and including):
#   <!-- compound-ai:end -->
```

This is scriptable. A helper:

```bash
#!/usr/bin/env bash
# Removes compound-ai marker sections from a file
# Usage: remove-kit-markers.sh CLAUDE.md
FILE="$1"
perl -i -0pe 's/<!-- compound-ai:start[^>]*-->.*?<!-- compound-ai:end -->\n?//gs' "$FILE"
```

**Step 3.** Verify the instruction files are clean:

```bash
grep -l "compound-ai:start" CLAUDE.md AGENT.md .cursorrules 2>/dev/null
# Expected: no output (no files contain the marker)
```

**Step 4.** Run the project's test and build commands to confirm the project
is unchanged from its pre-adoption state.

The rollback removes the kit's memory-commit sections but does not restore the
instruction files to their exact pre-adoption state if the operator made
other changes during or after the adoption session. The marker system ensures
the kit's additions are cleanly bounded and removable; other changes are the
operator's responsibility.

---

## Anti-patterns

### Anti-pattern: treating Phase 1 approval as blanket permission

**Symptom.** Operator says "accept Phase 1." Agent proceeds to modify
CLAUDE.md without presenting the diff for per-file approval.

**Fix.** Per-file approval is separate from phase approval. Phase approval
says "this phase is in scope." Per-file approval says "make this specific
change to this specific file." Both are required for protected files.

### Anti-pattern: silent upgrade of existing .compound-ai/

**Symptom.** Agent finds `.compound-ai/` from a prior v2.3.x installation
and overwrites it entirely to install v2.6.0.

**Fix.** Prior kit installations require the upgrade flow: version comparison,
per-file review of changes, operator confirmation of each replacement.

### Anti-pattern: adding kit files to the project root

**Symptom.** Agent drops `AGENT.md` or `_skills-index.md` at the project
root because `.compound-ai/` "seems cluttered."

**Fix.** All kit files go under `.compound-ai/` (or the custom path). The
only file the kit may propose adding to the project root during adoption is
a minimal pointer in an existing instruction file, shown as a diff first.
