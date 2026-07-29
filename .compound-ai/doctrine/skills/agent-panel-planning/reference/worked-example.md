# agent-panel-planning: Worked Example

A synthetic three-panelist run of the protocol. The example shows what
each stage produces. It does not pull the curtain back on any real
artifact; it shows the method.

**Deliverable to plan:** a public release of a small operating-standards
kit. The operator wants a 4-6 week build with one canonical website page,
a downloadable ZIP, and a GitHub repo. Panel composition: three agents
(A, B, C) with no pre-assigned roles.

---

## Stage 1: Frame

Operator's prompt to all three panelists:

> Propose a plan to ship the operating-standards kit publicly within 4-6
> weeks. The plan must cover: structural spine of the deliverable, the
> website page, the downloadable ZIP, the GitHub repo, attribution
> conventions, license terms, and a process for verifying provenance.
> Frame the WHOLE problem; each plan must cover all dimensions.
>
> Constraints: vendor-neutral language only. No mention of proprietary
> internal subsystems. Plain attribution to outside sources where used.
>
> Decision points for the panel to vote on at Stage 3:
>   D1  -  Canonical title
>   D2  -  Structural spine (what are the layers / parts)
>   D3  -  License split (single license vs split docs/code)
>   D4  -  Provenance verification (mandatory phone-home vs optional)
>   D5  -  In-scope chapter list (which 25-40 chapters)

The frame surfaces five decision points and locks the constraints
(vendor neutrality, no proprietary internals, attribution discipline).

---

## Stage 2: Independent plans (sealed)

Each agent produces a full first-pass plan in a separate session. None
sees the others' plans.

**Agent A's plan (summary):**
- Title: "Compounding AI Operating Standards"
- Spine: Part I-VI structure organized by reading depth
- License: dual (CC BY 4.0 docs, Apache 2.0 code)
- Provenance: mandatory verification with phone-home
- Chapters: 35 chapters, audience-layered within each chapter
- Strengths: detailed reading-mode framework, attribution proposal

**Agent B's plan (summary):**
- Title: "Compound AI Operating Standards"
- Spine: 5 layers (Context, Tokens, Orchestration, Quality, Translation)
- License: dual (CC BY 4.0 docs, Apache 2.0 code)
- Provenance: optional verification, no phone-home failure
- Chapters: 32 chapters mapped 1-to-1 onto the 5 layers
- Strengths: parsimonious spine, packaging discipline, provenance design

**Agent C's plan (summary):**
- Title: "Compound AI Standards"
- Spine: 6-part structure organized by capability (Context, Memory,
  Token Economics, Quality, Lineage, Translation)
- License: single CC BY-SA 4.0
- Provenance: optional verification
- Chapters: 28 chapters with code samples in every applicable chapter
- Strengths: substance density, working code samples, integration with
  existing artifacts

All three sealed. The operator now has three independent framings of
the same problem.

---

## Stage 3: Cross-feedback (with element-level votes)

Each agent produces structured cross-feedback on the other two plans.
Six cross-feedback blocks total. Each agent also votes on the five
decision points.

**Sample cross-feedback (Agent A reviewing Agent B's plan):**

```
CROSS-FEEDBACK ON Agent B's PLAN

Strongest claim:
  B's 5-layer spine is the most parsimonious of the three. Substance
  maps onto it cleanly without overhang.

Weakest claim:
  B's plan does not name how the deliverable reaches different audiences.
  The spine is good but the audience-translation move is missing.

Shared blind spot:
  Neither B's plan nor mine surfaces a "what this kit is NOT" discipline.
  C is the only one of us who handled negative space.

One thing worth stealing:
  B's optional-verification provenance design. My mandatory phone-home
  would create lock-in. Adopt B's framing.

Element-level votes:
  D1: Compound AI. My title had -ing; B's is cleaner.
  D2: B's 5-layer spine. Most parsimonious.
  D3: Dual license. Consensus across all three plans.
  D4: Optional verification (B's framing). My mandatory was over-reach.
  D5: B's 32 chapters; my 35 has overhang; C's 28 has gaps in Part V.
```

The operator collects all six cross-feedback blocks. The voting tally
emerges:

| Decision | Vote tally (A/B/C) | Direction |
|---|---|---|
| D1 Title | Compound AI / Compound AI / Compound AI Standards | Compound AI (2/3) |
| D2 Spine | B's 5-layer / B's 5-layer / C's 6-part | B's 5-layer (2/3) |
| D3 License | dual / dual / single | Dual (2/3) |
| D4 Provenance | optional / optional / optional | Unanimous |
| D5 Chapters | B's 32 / B's 32 / B's 32 (after concession) | Unanimous after C concession |

---

## Stage 4: Concession + private revise + cross-suggestions (sealed)

Each agent produces three outputs, sealed.

**Sample from Agent A:**

```
CONCESSIONS
  Concede to B on title (drop -ing).
  Concede to B on spine (adopt 5-layer).
  Concede to B on provenance (optional not mandatory).
  Hold on chapter audience-layering within: this is mine to deliver
    if A owns chapters.

REVISED PRIVATE PLAN
  [Revised plan adopting concessions. Title now Compound AI. Spine
  now 5-layer mapping. Provenance optional. Audience-layering retained
  as my chapter-internal discipline.]

PATH FORWARD: SUGGESTIONS FOR OTHERS

For Agent B:
  1. Add a "what this is NOT" section at the kit-root level. Your
     spine has it as a possible chapter; it should be foreword-adjacent.
     Reasoning: C surfaced negative-space discipline; both you and I
     missed it. Adopt at root level, not chapter.
  2. Your packaging discipline is strongest of the three; consider
     proposing yourself as owner of provenance scripts + manifest.

For Agent C:
  1. Your code samples are the strongest of the three. Consider
     proposing yourself as owner of substance migration into B's spine.
     Reasoning: B's spine + your substance density is the strongest
     combination this panel can produce.
  2. The single-license model has not survived the vote. Concede to
     dual; reframe your license argument as "single is simpler if we
     ever need to consolidate later" rather than a current proposal.
```

All three agents produce similar three-part outputs, sealed.

---

## Stage 5: Reconvene

Each agent reads:
- The other two revised plans
- The cross-suggestions FOR them (from the other two)
- The cross-suggestions they wrote for the others (for context)

**Sample from Agent B's reconvene response:**

```
ACCEPTED SUGGESTIONS:
  From A: add a "what this is NOT" section at root level. Adopting.
  From A: my packaging discipline owns provenance scripts. Adopting.
  From C: my plan's chapter 14 needs a code sample for the cache pattern.
    Adopting. Will pair with C on that chapter specifically.

REJECTED SUGGESTIONS:
  From C: split the docs license to CC BY 4.0 from CC BY-SA 4.0.
    Rejected; current dual already locks CC BY 4.0. C's note was
    based on an outdated read of my plan.

MY ADJUSTED POSITION:
  D1 Title: Compound AI (was always my position).
  D2 Spine: my 5-layer (consensus).
  D3 License: dual (consensus).
  D4 Provenance: optional (was my position; A conceded).
  D5 Chapters: 32 (consensus after C's concession).

  Remaining contested: ownership of "what this is NOT" section.
  A proposed me; I'd defer to C who first surfaced negative-space
  discipline.
```

The operator now has three reconvene responses. Most decisions have
converged. One split remains: ownership of the "what this is NOT"
section.

---

## Stage 6: Voting + ratification + task split

The operator surfaces the one remaining split as a Stage 6 vote:

```
R1  -  Owner of "what this is NOT" section:
  A: C  -  was first to surface negative-space discipline.
  B: C  -  defer to C.
  C: C accept ownership; the discipline is mine.
  Operator: C.
  Locked: C owns "what this is NOT".
```

The ratification document:

```
RATIFICATION

Locked decisions:
  D1 Title: Compound AI Operating Standards
  D2 Spine: B's 5-layer (Context / Tokens / Orchestration / Quality / Translation)
  D3 License: dual (CC BY 4.0 docs, Apache 2.0 code)
  D4 Provenance: optional verification, no phone-home failure
  D5 Chapters: 32

Mid-panel emergence: "what this is NOT" section added at root level.

Open questions deferred to execution:
  Q1 Specific failure incident anchoring the foreword (pending verification)
  Q2 Whether to include cross-platform translation chapter

Task assignment:
  | Task | Owner | Why |
  |---|---|---|
  | Spine + structural mechanics | B | Strongest spine in first pass |
  | Substance body (Parts I-V) | C | Strongest code samples + density |
  | Foreword + voice + attribution | A | First-pass plan included annotated artifact |
  | Provenance scripts + manifest | B | First-pass plan was the only one with provenance design |
  | "What this is NOT" section | C | First to surface negative-space discipline |
  | Cross-platform translation chapter | A | Mid-panel suggestion; A volunteered |
  | Final ratification gatekeeper | Operator | Standard role |

  Sequencing: spine first (B), substance migration in parallel with
  foreword (C and A), provenance scripts pre-release (B), Cross-platform
  translation last (A).
```

The plan is ratified. Execution begins.

---

## What the example illustrates

1. **The independent framings produced three distinct first-pass plans.**
   No agent could have produced this breadth alone. The Stage 2 seal is
   what made the three framings genuinely distinct.

2. **The cross-feedback voting (Stage 3) collapsed most disagreement
   quickly.** Four of five decision points reached majority in one pass.
   This is healthy convergence.

3. **Stage 4's cross-suggestions were the load-bearing move.** Without
   "Path Forward for Others," each agent would have revised only its own
   plan. With it, the panel arrived at Stage 5 with collective shaping
   information and converged in one reconvene.

4. **The strength-matched task split at Stage 6 is empirical.** Agent A
   got voice and attribution because A's first-pass plan included the
   annotated artifact. Agent C got substance because C's first-pass code
   samples were strongest. The assignment is defensible from the panel's
   own outputs.

5. **One mid-panel emergence ("what this is NOT" section) was successfully
   integrated.** The pattern surfaces something no agent had in their
   first pass; the panel recognizes it, the operator ratifies it.

---

## Anti-example: what convergence theater looks like

For contrast: a panel where Stage 2's seal breaks.

The operator sends the prompt to Agent A, gets the first-pass plan, then
sends it to Agent B "for reference." Agent B's plan anchors heavily on
A's spine but adds incremental detail. Agent C, given both prior plans,
produces a plan that smooths the differences.

Stage 3 cross-feedback produces uniformly mild critique because the
three plans are already 80% aligned. Stage 4 concessions are trivial.
Stage 5 reconvene produces "we all basically agree." Stage 6 task
assignment defaults to preset roles because nothing in the panel
demonstrated specific strengths.

The "panel" converges on loop 1 with high confidence. The output is
fine. It is also substantially worse than what a single strong agent
session would have produced, because the seal break destroyed the
independent signal that was the whole point of the panel.

**If you find yourself "sharing prior plans for reference" before
Stage 4, you have broken the protocol. Stop, restart Stage 2, and
seal it.**
