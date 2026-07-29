# agent-panel-review: Scorecard Rubric

A heavier alternative to the four-cell critique format from
`critique-format.md`. The scorecard is **quantitative**: ten dimensions,
0-100 score per dimension, one-line evidence with citation, composite
score, and a dual grade (strategy vs artifact production).

Use this when:
- The deliverable is high-stakes enough that quantitative comparison
  across drafts justifies the heavier output
- The operator needs an audit trail of scoring decisions for merge
  defensibility
- Standalone evaluation outside a panel (one operator scoring one
  deliverable for a quality gate)
- Post-mortem on a shipped artifact

Use the four-cell template instead when:
- The work needs fast cross-critique with minimal structure
- The panel is small (two panelists) and qualitative signal is enough
- Time pressure dominates rigor

The two formats are interchangeable at Stage 3 of `agent-panel-review`.
Operator's call which to require. Mixing within one panel produces
inconsistent signal; pick one and stick with it for that loop.

---

## The ten dimensions

| # | Dimension | What it scores |
|---|---|---|
| 1 | **Thesis sharpness** | Is the core claim quotable? Does the deliverable have one load-bearing sentence a reader can carry? |
| 2 | **Audience layering** | Does the artifact serve its target audience(s)? If multiple audiences, does it layer (within doc or by package)? |
| 3 | **Substance density** | Coverage AND concreteness. Patterns named AND demonstrated. Numbers, code, evidence behind every claim. |
| 4 | **Portability / vendor-neutrality** | Does it work across platforms? Are vendor names handled with substitution tables? No lock-in to one tool. |
| 5 | **Package design** | Is the artifact bundle well-shaped? Folder structure, download structure, file organization, manifest discipline. |
| 6 | **Reference artifact / immediate utility** | Can a reader leave with something to deploy? Templates filled in vs templates listed by name. |
| 7 | **Audience signaling** | Does the language and framing resonate with the specific intended audience? Domain-appropriate vocabulary; tone matches register. |
| 8 | **Discipline** | Is the length right? Concepts deduplicated? No restatement masquerading as content? Cuts that should have been made. |
| 9 | **Originality (signature contributions)** | What is novel here that no other source has? Specific patterns, framings, or artifacts that earn their own life. |
| 10 | **Critique-readiness** | Does the author anticipate critique? Self-aware of gaps? Names what is missing rather than hiding it? |

Each dimension scores 0-100. The discipline that makes the rubric work
is **evidence-cited scoring**: every score has a one-line note pointing
to a specific section or line of the artifact being scored.

---

## Required opening: verification performed

The scorecard's first line is NOT a dimension. It is a verification
declaration. The reviewer must state what was checked before scoring.

Without this, the scorecard can praise an artifact's "Package design"
while missing that the package fails on clean extract. Verification is
a gate, not a dimension.

Required format:

```
Verification performed: [yes/no, commands run, result]
```

Examples that pass:

```
Verification performed: yes. Clean unzip into /tmp; ran
scripts/verify-integrity.py (returned VERIFIED); ran scripts/
verify-origin.py --online (returned VERIFIED); confirmed manifest
version matches page version; confirmed SHA256SUMS covers current
assets. All checks passed.
```

```
Verification performed: no. Reviewed source files directly without
clean-extract test. This scorecard's Package Design dimension is
provisional pending verification.
```

If verification was skipped, dimensions 4 (portability) and 5
(package design) cap at 75 regardless of apparent quality. Operators
cannot score above 75 on dimensions that have not been observed in
action.

For deliverables that are not release artifacts (e.g. forewords,
strategic plans, single-document drafts), the verification line states
what was substituted: "Verification performed: yes. Read full artifact;
checked internal cross-references; verified all cited line numbers
resolve."

---

## The output format

```
SCORECARD: [artifact name] (reviewed by [reviewer])

Verification performed: [yes/no, commands run, result]

| # | Dimension | Score | Notes |
|---|---|---:|---|
| 1 | Thesis sharpness | NN | [one-line evidence with [Author:line] or [section] citation] |
| 2 | Audience layering | NN | [one-line evidence] |
| 3 | Substance density | NN | [one-line evidence] |
| 4 | Portability / vendor-neutrality | NN | [one-line evidence] |
| 5 | Package design | NN | [one-line evidence] |
| 6 | Reference artifact / immediate utility | NN | [one-line evidence] |
| 7 | Audience signaling | NN | [one-line evidence] |
| 8 | Discipline | NN | [one-line evidence] |
| 9 | Originality (signature contributions) | NN | [one-line evidence] |
| 10 | Critique-readiness | NN | [one-line evidence] |

Composite: XX/100, [grade-letter for strategy], [grade-letter for
artifact production].

What this output is best at:
  [one-paragraph prose summary naming the dimensions where this
  artifact dominates and citing the specific moves.]

What this output misses:
  [one-paragraph prose summary naming the dimensions where this
  artifact is weak and what would be needed to close those gaps.]
```

---

## Scoring scale

| Range | Meaning | Examples |
|---|---|---|
| 90-100 | Best in class | The dimension is a load-bearing strength; the artifact's value largely flows from this dimension. |
| 80-89 | Strong | Above average; the dimension does real work. |
| 70-79 | Adequate | Present and functional; not distinctive. |
| 50-69 | Thin | Identifiable gaps; the dimension is sketched not executed. |
| 30-49 | Weak | The dimension is named but the artifact does not deliver it. |
| 0-29 | Missing | The dimension is absent or so weak it does not count. |

---

## The dual grade

A single composite hides asymmetry. Some artifacts are strong on
strategic thinking (thesis, originality, audience) and weak on
artifact production (reference utility, package design, discipline).
The Codex evaluation pattern was the canonical example: composite
77/100 but two grades, A- on strategy plan, C+ on artifact production.

The dual grade surfaces this asymmetry:

- **Strategy grade**: weighted average of dimensions 1, 2, 7, 9, 10
  (thesis, audience layering, audience signaling, originality,
  critique-readiness)
- **Artifact production grade**: weighted average of dimensions 3, 4,
  5, 6, 8 (substance density, portability, package design, reference
  artifact, discipline)

Map composite to letter grade:
- 90-100 → A
- 85-89  → A-
- 80-84  → B+
- 75-79  → B
- 70-74  → B-
- 65-69  → C+
- 60-64  → C
- below 60 → re-do or refuse

The dual grade lets the operator make informed merge decisions:
"adopt this artifact's strategy spine but rebuild the body" or
vice versa.

---

## Evidence citation format

The Notes column requires a citation, not just an assertion. Citation
formats that work:

- `[Codex:73]` -- author name + line number from their draft
- `[section name]` -- section reference inside the artifact
- `[Stage 3 strongest-claim cell from Kiro]` -- panel-internal reference
- `[lines 314-316]` -- line-range reference

The citation makes the scorecard auditable. Without it, a score is
just opinion. With it, a score is a verifiable claim about a specific
piece of the artifact.

---

## When to use scorecard vs four-cell

| Situation | Use |
|---|---|
| Fast panel critique, qualitative signal sufficient | four-cell |
| Heavy panel critique, quantitative comparison helps | scorecard |
| Operator scoring own draft for self-check | scorecard |
| Operator scoring single agent's output | scorecard |
| Time-pressured review where structure must be light | four-cell |
| Post-mortem on shipped artifact | scorecard |
| Two-panelist code review | four-cell |
| Three-panelist editorial review | either; scorecard if rigor warrants the heavier output |

The two formats are interchangeable on a per-loop basis. A panel can
use four-cell at Stage 3 in Loop 1 and switch to scorecard in Loop 2
if rigor needs to step up. Mixing within ONE loop produces
inconsistent signal across panelists; the operator's job is to
commit to one format per loop.

---

## Pair with

- `agent-panel-review/reference/critique-format.md` (the four-cell template)
- `agent-panel-review/reference/merge-framework.md` (Stage 5 merge using dimension-level dominance from scorecards)
- `pressure-test/SKILL.md` (the CEO/scope lens critique pattern; scorecard works as the output format if pressure-test is run with full structure)
- `quality-gate/SKILL.md` (quality-gate can ingest scorecard outputs as part of the ship-decision)

---

## Anti-patterns

### Anti-pattern: scoring without citation

**Symptom.** Every dimension has a number; the Notes column is empty
or contains vague assertions ("could be stronger").

**Fix.** Every score requires a citation. Without it, the scorecard is
the reviewer's preferences with numbers attached. Reject and ask for
redo.

### Anti-pattern: composite without dual grade

**Symptom.** One letter grade. The asymmetry between strategy and
artifact production is hidden.

**Fix.** Always produce both grades. Most artifacts are asymmetric;
the dual grade surfaces it. A reviewer who claims symmetric quality
across all ten dimensions probably didn't look closely enough.

### Anti-pattern: scoring above 90 without specific evidence

**Symptom.** Three or four dimensions score 90+ with weak Notes.

**Fix.** 90+ is "best in class" -- it has to be defensible. A
scorecard with too many 90+ scores has lost calibration. Re-score
with the scale's actual meaning ("best in class" means the dimension
is load-bearing for the artifact's value).

### Anti-pattern: scoring everything in the 70-79 band

**Symptom.** All ten dimensions score 73, 75, 78, 71, 76...

**Fix.** Real artifacts are asymmetric. If your scorecard shows
uniform mid-70s, you are scoring impressions, not evidence. Force
yourself to commit on each dimension: where is the artifact best?
Where is it weakest? Those should differ by more than 5 points.

### Anti-pattern: scoring the author, not the artifact

**Symptom.** Notes reference the producing agent ("Codex's strength
in attribution architecture").

**Fix.** Score the artifact. "The attribution architecture in this
draft is best-in-class on dimension 4." The work is the unit, not
the producer.

---

## Worked example (synthetic)

```
SCORECARD: Foreword draft (reviewed by Panelist B)

| # | Dimension | Score | Notes |
|---|---|---:|---|
| 1 | Thesis sharpness | 92 | "Does the system compound, or does it reset?" [line 12] lifts cleanly. |
| 2 | Audience layering | 70 | Names builder/exec/engineer split [lines 36-42] but doesn't layer within the doc -- shards by package instead. |
| 3 | Substance density | 75 | High coverage, low concreteness. Lists patterns by name but rarely shows the numbers. |
| 4 | Portability / vendor-neutrality | 96 | Best in class. Substitution table [lines 683-688] is the single most reusable artifact. |
| 5 | Package design | 94 | Three-download structure is more thoroughly designed than alternatives I've seen. |
| 6 | Reference artifact / immediate utility | 45 | Zero drafted artifacts. Templates listed but not written. Reader cannot leave with something to deploy. |
| 7 | Audience signaling | 70 | Hits the indie-operator register well; thinner on enterprise/exec signaling. |
| 8 | Discipline | 65 | 887 lines is excessive. Repetition between "Five Operating Layers" and "Eight Standards" -- same concepts named twice. |
| 9 | Originality (signature contributions) | 88 | The AI Tool Evaluation Framework (4 questions) is a clean original. Compound-vs-reset framing is signature. |
| 10 | Critique-readiness | 90 | Explicitly invited the critique pass and supplied the criteria. Earned a half-grade by anticipating gaps. |

Composite: 77/100. Strategy grade: A-. Artifact production grade: C+.

What this output is best at:
  Publication discipline and editorial governance. Dimensions 4 (portability),
  5 (package design), 1 (thesis), 9 (originality), and 10 (critique-readiness)
  carry the artifact. The substitution table at [lines 683-688] and the
  "What To Preserve / De-Emphasize" sections are the kind of editorial
  discipline a senior content lead would apply. If shipped, the rules
  in those sections must govern.

What this output misses:
  Any actual draft, any audience-within-one-document layering, and any
  specific voice work. Dimension 6 (reference artifact, scored 45) is
  the weakest spot. Templates are listed by name but not written, so a
  reader cannot leave with anything to deploy. The asymmetry between
  the A- strategy grade and the C+ artifact production grade tells the
  full story: this is excellent thinking that has not yet been
  executed.
```

---

## Composite math (reference)

For an evenly weighted scorecard:
- Composite = mean of all 10 dimension scores

For the dual grade (weighted):
- Strategy = mean of dimensions 1, 2, 7, 9, 10
- Artifact production = mean of dimensions 3, 4, 5, 6, 8

Operator may re-weight if the deliverable's nature warrants it (e.g.
code deliverables might weight dimensions 4 and 6 higher; narrative
deliverables might weight 1 and 7 higher). Re-weighting should be
declared at the top of the scorecard for transparency.
