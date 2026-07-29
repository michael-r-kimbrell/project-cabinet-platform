# adoption-captain: Adoption Report Template (Stage 8a)

The adoption report is the permanent record of what happened during adoption.
It is written to `.compound-ai/adoption-report.md`. Future sessions read this
file to understand what the kit is doing in this project and why.

The report is also the audit trail: if something breaks after adoption, the
report shows exactly what was added, what was validated, and what was committed
to the agent's instruction surfaces. Without it, debugging adoption issues
requires re-running the full discovery protocol.

---

## Report format

```markdown
# Compound AI Adoption Report
Date: YYYY-MM-DD
Operator: <operator name or handle>
Host project: <absolute path>
Kit version: v2.6.0

---

## Discovery summary

Primary language: <language>
Package manager: <manager>
Agent instruction files found: <list or "none">
State documents found: <list or "none">
CI/deploy config found: <list or "none">

Commands discovered:

| Category | Command | Source |
|---|---|---|
| test | <command or NOT-FOUND> | <source> |
| build | <command or NOT-FOUND> | <source> |
| lint | <command or NOT-FOUND> | <source> |
| typecheck | <command or NOT-FOUND> | <source> |

Full discovery details: `.compound-ai/discovery-report.md`

---

## Preserve map summary

| Class | Count |
|---|---|
| PRESERVE | N |
| ADD | N |
| MODIFY | N |
| DEFER | N |
| CONFLICT | N (resolved: N, unresolved: 0) |

Full preserve map: `.compound-ai/preserve-map.md`

Key PRESERVE rules carried into memory-commit:
- [rule 1]
- [rule 2]

---

## Adoption mapping

Full skill classification from Stage 4:

| Skill | Tier | Classification | Rationale |
|---|---|---|---|
| adoption-captain | T1 | active (this run) | Kit adopted in this session |
| engagement-bootstrap | T1 | skip | Existing project |
| request-router | T1 | adopt now | N skills adopted; router adds value |
| goal-runner | T1 | adopt now | Multi-step goals need a completion condition |
| memory | T1 | adopt now | Session state and patterns vary across sessions |
| token-economist | T1 | adopt now | LLM calls present; context cost matters |
| delegation | T1 | defer | Single-agent project; no routing surface yet |
| quality-gate | T1 | defer | No external deliverables yet |
| release-captain | T1 | skip | No versioned release process |
| agent-panel-planning | T1 | defer | Solo-agent project |
| agent-panel-review | T1 | defer | Solo-agent project |
| team-router | T1 | skip | Team edition only; solo operator |
| ultra-think | T2 | adopt now | Architecture decisions are frequent |
| detached-judgment | T2 | adopt now | Sycophancy risk noted |
| nod-protocol | T2 | defer | Not requested by operator |
| pressure-test | T2 | adopt now | Strategy outputs produced |
| convergence-detection | T2 | skip | No iterative LLM loops |
| autoresearch | T2 | defer | Single-pass research only |
| code-audit | T2 | adopt now | Active code repo |
| consequence-simulation | T2 | defer | Exploratory phase |
| parallel-lens-synthesis | T2 | adopt now | Frequent trade-off decisions |
| cross-domain-translation | T2 | skip | Single-domain project |
| simulation-to-action-bridge | T2 | defer | Consequence-simulation deferred |
| stakeholder-mapping | T2 | skip | Solo developer project |
| skill-creator | T2 | defer | No new skill creation planned |
| viz | T2 | skip | No visualization work |

---

## Adoption plan

Operator approved: Phase 1 (additive scaffolding)
Operator approved: Phase 2 (behavior changes)
Phase 3: not proposed / proposed but declined / pending

Phase 1 was approved on YYYY-MM-DD.
Phase 2 was approved on YYYY-MM-DD.

Conflict resolutions:

| Rule | Source | Resolution | Operator decision |
|---|---|---|---|
| [rule] | CLAUDE.md:23 | Skip kit hook | Accepted YYYY-MM-DD |

---

## File changes

### Files created

```
.compound-ai/AGENT.md
.compound-ai/_skills-index.md
.compound-ai/adoption-report.md              (this file)
.compound-ai/discovery-report.md
.compound-ai/preserve-map.md
.compound-ai/doctrine/skills/...   (kit content)
.compound-ai/doctrine/skills/...  (kit content)
.compound-ai/docs/FIELD-GUIDE.md
```

### Files modified

| File | What changed | Operator approved |
|---|---|---|
| `./CLAUDE.md` | Added `## Compound AI Operating Standards` section (bounded by markers) | Yes, YYYY-MM-DD |

### Files NOT modified (on protected list; operator declined or not proposed)

| File | Reason not modified |
|---|---|
| `./package.json` | No kit-driven dependency changes |
| `./.github/workflows/ci.yml` | Not proposed; CI unchanged |

---

## Validation results

Run date: YYYY-MM-DD HH:MM UTC
Phase: 1 (additive only)

| Category | Command | Result | Notes |
|---|---|---|---|
| test | `pnpm run test` | PASS | 47 tests, 0 failures |
| build | `pnpm run build` | PASS | dist/ generated (4.2s) |
| lint | `pnpm run lint` | PASS | 0 warnings |
| typecheck | `npx tsc --noEmit` | PASS | fallback; no scripts.typecheck |

---

## Memory-commit summary

Surfaces updated in Stage 8b:

| Surface | Path | Status | Marker confirmed |
|---|---|---|---|
| CLAUDE.md | ./CLAUDE.md | UPDATED | yes |
| AGENT.md | ./AGENT.md | SKIPPED (not present) | -- |
| ~/.claude/CLAUDE.md | global | SKIPPED (operator opted out) | -- |

Memory-commit verified: yes.
Surfaces updated: ./CLAUDE.md (markers confirmed present and properly paired).
Global surfaces touched: no.
Next session check: operator confirmed the section loads on next session start.

---

## Rollback instructions

To remove the kit from this project:

1. Delete `.compound-ai/`:
   ```bash
   rm -rf .compound-ai/
   ```

2. Remove the kit section from each modified instruction file:
   ```bash
   # CLAUDE.md
   perl -i -0pe 's/<!-- compound-ai:start[^>]*-->.*?<!-- compound-ai:end -->\n?//gs' ./CLAUDE.md
   ```
   Files modified: `./CLAUDE.md`

3. Verify:
   ```bash
   grep "compound-ai:start" ./CLAUDE.md  # Expected: no output
   ls .compound-ai/                       # Expected: No such file or directory
   ```

4. Run validation commands to confirm clean state:
   ```bash
   pnpm run test && pnpm run build && pnpm run lint
   ```
```

---

## Synthetic example: Node.js/TypeScript/React project

The following is a complete adoption report for a realistic project. It shows
what a real report looks like, including NOT-FOUND entries and partial phase
approvals.

---

```markdown
# Compound AI Adoption Report
Date: 2026-04-01
Operator: jsmith
Host project: ~/your-projects/task-board
Kit version: v2.6.0

---

## Discovery summary

Primary language: TypeScript
Package manager: pnpm (pnpm-lock.yaml detected)
Agent instruction files found: CLAUDE.md (18 rules, no prior kit content)
State documents found: README.md, CHANGELOG.md
CI/deploy config found: .github/workflows/ci.yml, vercel.json

Commands discovered:

| Category | Command | Source |
|---|---|---|
| test | `pnpm run test` | package.json scripts.test |
| build | `pnpm run build` | package.json scripts.build |
| lint | `pnpm run lint` | package.json scripts.lint |
| typecheck | NOT-FOUND | no scripts.typecheck; tsc fallback available |

Full discovery details: `.compound-ai/discovery-report.md`

---

## Preserve map summary

| Class | Count |
|---|---|
| PRESERVE | 8 |
| ADD | 4 |
| MODIFY | 0 |
| DEFER | 1 |
| CONFLICT | 1 (resolved: 1, unresolved: 0) |

Key PRESERVE rules:
- "All component names use PascalCase; no exceptions"
- "Commits use Conventional Commits format: feat/fix/chore/docs"
- "React state is managed via Zustand; do not introduce Redux or Context API"

Conflict resolved: CLAUDE.md rule "em dashes permitted in comments for clarity"
-- kit hook skipped for this project. Operator accepted YYYY-MM-DD.

---

## Adoption mapping

| Skill | Tier | Classification | Rationale |
|---|---|---|---|
| adoption-captain | T1 | active (this run) | Kit adopted in this session |
| engagement-bootstrap | T1 | skip | Existing project |
| request-router | T1 | adopt now | 5 skills adopted; router justified |
| goal-runner | T1 | adopt now | Active sprint; multi-step tasks run to done |
| memory | T1 | adopt now | session-log.md present; state varies across sessions |
| token-economist | T1 | skip | No LLM calls in this project |
| delegation | T1 | skip | Solo developer; no agent routing |
| quality-gate | T1 | adapt | Ships to Vercel; gate adapted for PR review |
| release-captain | T1 | defer | No versioned package; Vercel auto-deploys |
| agent-panel-planning | T1 | defer | Solo developer |
| agent-panel-review | T1 | defer | Solo developer |
| team-router | T1 | skip | Team edition only; solo developer |
| ultra-think | T2 | adopt now | Architecture decisions expected |
| detached-judgment | T2 | adopt now | Operator requested more pushback |
| nod-protocol | T2 | adopt now | Operator requested more pushback |
| pressure-test | T2 | defer | No strategy outputs currently |
| convergence-detection | T2 | skip | No LLM loops |
| autoresearch | T2 | skip | No research work |
| code-audit | T2 | adopt now | Active React/TS codebase |
| consequence-simulation | T2 | skip | Implementation work only |
| parallel-lens-synthesis | T2 | adapt | Architecture trade-offs; adapt for TS context |
| cross-domain-translation | T2 | skip | Engineer-only project |
| simulation-to-action-bridge | T2 | skip | Consequence-simulation skipped |
| stakeholder-mapping | T2 | skip | Solo developer |
| skill-creator | T2 | defer | No new skill creation planned |
| viz | T2 | skip | No data visualization |

---

## File changes

### Files created

```
.compound-ai/AGENT.md
.compound-ai/_skills-index.md
.compound-ai/adoption-report.md
.compound-ai/discovery-report.md
.compound-ai/preserve-map.md
.compound-ai/doctrine/skills/ (subset: 5 adopted skills)
.compound-ai/doctrine/skills/ (subset: 4 adopted skills)
.compound-ai/docs/FIELD-GUIDE.md
```

### Files modified

| File | Change | Approved |
|---|---|---|
| `./CLAUDE.md` | Added compound-ai section (42 lines, marker-bounded) | Yes |

---

## Validation results

Run date: 2026-04-01 14:22 UTC

| Category | Command | Result | Notes |
|---|---|---|---|
| test | `pnpm run test` | PASS | 112 tests, 0 failures, 3 skipped |
| build | `pnpm run build` | PASS | 8.4s; 847KB bundle |
| lint | `pnpm run lint` | PASS | 0 errors, 0 warnings |
| typecheck | `npx tsc --noEmit` | PASS | fallback; 0 errors |

---

## Memory-commit summary

| Surface | Path | Status | Markers |
|---|---|---|---|
| CLAUDE.md | ./CLAUDE.md | UPDATED | confirmed |
| ~/.claude/CLAUDE.md | global | SKIPPED (opt-out) | -- |

Memory-commit verified: yes.
Surfaces updated: ./CLAUDE.md.
Global surfaces touched: no.
Next session check: verified on same day; kit section present in CLAUDE.md.

---

## Rollback instructions

1. `rm -rf .compound-ai/`
2. `perl -i -0pe 's/<!-- compound-ai:start[^>]*-->.*?<!-- compound-ai:end -->\n?//gs' ./CLAUDE.md`
3. Verify: `grep "compound-ai:start" ./CLAUDE.md` -- expected: no output
4. Run: `pnpm run test && pnpm run build`
```
