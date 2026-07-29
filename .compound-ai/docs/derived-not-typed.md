# Derived, Not Typed

> Compound AI Operating Standards, doctrine module. Drafted 2026-06-10 from an operator directive:
> references must not go stale, pages must stay updated, and published content must remain sensible.
> A published number that nobody regenerates is a lie
> with a delay. Enforced by `bin/verify-public-release.sh` (daily, drift sentinel) and
> `$ORCH_DIR/site-stats.py` (weekly, graph-refresh loop).

## The rule

Every count, version, date, or metric in a PUBLISHED artifact must be one of:

(a) **Generated** from a source of truth at render or patch time (script computes it, script
    writes it; a human never types the number).
(b) **Patched by a governed loop** (a Loop Spec in `compound-ai/loops/` names the job that keeps
    it current, with fail-loud behavior on compute failure).
(c) **Explicitly marked static-by-design** with an owner and a review date, because the value is
    narrative-historical ("Coverage was 113 companies in Feb 2026") and SHOULD never change.

Anything else is a violation: a hand-typed live fact with no keeper.

Published artifact = anything an outsider can read: site pages, public decks and presentations,
READMEs, manuals and field guides, GitHub repos and releases. Internal-only notes are exempt but
welcome to comply.

## The standard (ratified 2026-06-10)

Claims must be verifiable, formulas must be checked, and published facts need lineage, truth, and
traceability unless they are clearly framed as examples.

Three consequences beyond the rule above:

1. **Claims, not just counts.** A qualitative published claim ("zero API spend", "runs nightly")
   is held to the same standard as a number: there must be a check, a loop, or a marker behind it.
2. **Formulas get checked, not trusted.** Where a published figure is computed (a rate, a sum, a
   percentage), the derivation itself is verified by a second path at least once (test, cross-query,
   or independent recomputation) before it ships. A wrong formula faithfully regenerated is still a
   lie with lineage.
3. **Examples are exempt.** Illustrative numbers clearly framed as examples need no keeper; do not
   launder live facts by calling them examples.

Adoption queue: a downstream project with listing figures, valuations, and offer
math (formulas that must be checked, with lineage) is a major beneficiary. Apply
this standard there when that project reactivates.

## The static-by-design marker

Place adjacent to the literal, in the file's comment syntax:

- HTML / Markdown: `<!-- static-by-design owner:<who> review:<YYYY-MM> -->`
- TSX / TS / JS: `// static-by-design owner:<who> review:<YYYY-MM>`

Dated narrative ("Jun 2026: fleet size 7 agents") self-anchors: the date in the prose IS the
marker, no comment needed. An undated "7 agents" in present tense is NOT self-anchoring and needs
class (a), (b), or the marker.

## Worked examples (live on a local agent machine)

1. **`$ORCH_DIR/site-stats.py --apply`** (class a + b). Computes 9 "By The Numbers" stats
   from live sources (launchd plists, hermes cron, the project database, chroma sqlite, graph.json, loops dir)
   and patches the `data-stat` spans in `agentic-ecosystem.html`. All-or-nothing fail-loud: any
   stat computing 0/None aborts with zero edits. Governed by `loops/graph-refresh.spec.md`
   (Sun 21:00); the loop commits + pushes the deck only when the diff is confined to that file.
2. **`$ORCH_DIR/site-stats.py --check-site`** (class b, report-only). Derives kit truth
   (skills from the newest public starter-kit zip's `_skills-index.md`, chapters from the newest
   public standards md, shells and tiers from the zip layout) and compares against the hand-typed
   literals in `CompoundAI.tsx`. A mismatch writes a claude-inbox file; the TSX stays
   human-reviewed because the site needs a build. Wired into graph-refresh.sh.
3. **`compound-ai/bin/verify-public-release.sh`** (class b, report-only). Asserts the three
   public surfaces agree on the kit version: GitHub main `CITATION.cff` + release tag, the newest
   public md/zip pair, and the `KIT_VERSION` constants in both TSX pages. Runs daily via the
   drift sentinel; offline degrades to a SKIPPED note, never a false alarm.

## Checklist: adding a new derived fact

1. Name the source of truth (a file, a DB, a directory layout). If none exists, the fact is
   opinion, not a metric; do not publish it as a number.
2. Write the derivation as code (extend `site-stats.py` or a `bin/verify-*.sh`), zero tokens,
   read-only against the source.
3. Decide write authority: mechanical numeric patch = auto-apply allowed (fail-loud,
   all-or-nothing, diff-confinement guard); prose or anything needing a build = report-only,
   inbox file to a shared workspace inbox directory.
4. Wire it into a governed loop (graph-refresh for weekly site facts, drift sentinel for daily
   integrity facts) and update that loop's spec in `compound-ai/loops/`.
5. Run it once live and watch it PASS; force one failure and watch it report. Wired or it is not
   done.
6. Sweep the artifact for remaining hand-typed literals of the same kind; mark survivors
   static-by-design or delete them.
