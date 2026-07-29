# agent-panel-review: Worked Example

A synthetic three-panelist run of the protocol on a deliverable. The
example shows what each stage produces. It does not pull the curtain
back on any real artifact; it shows the method.

**Deliverable:** A 600-word public foreword for a new release. The
foreword needs to land for both technical builders and senior
operators. It must motivate the release without overpromising.

**Panel composition (Template 1: voice / substance / architecture):**
- Panelist A: voice role
- Panelist B: substance role
- Panelist C: architecture role

---

## Stage 1: Frame

The operator writes one prompt and sends it to all three panelists in
separate sessions:

> Draft a 600-word foreword for the upcoming release. The foreword
> must motivate the release for both technical builders and senior
> operators. Open on a concrete incident, not a definition. State the
> thesis early. End with a single specific commitment readers can
> verify. Keep voice plain and unhedged. Do not overpromise; the
> release does not solve everything.
>
> Your role on this panel: [VOICE / SUBSTANCE / ARCHITECTURE]
> (one role per panelist).

The role tag is the only variant. The deliverable definition is
identical for all three.

---

## Stage 2: Independent first pass (sealed)

Each panelist produces a 600-word foreword. None of them sees the
others' outputs.

**Panelist A (voice) produces:** A narrative-arc foreword that opens
on the incident, threads a metaphor through the body, and lands on a
specific verifiable commitment. Strong rhythm, weaker substance
beyond the incident.

**Panelist B (substance) produces:** A dense foreword with concrete
detail throughout, real numbers, named subsystems. Opens flat
("This release contains..."), buries the thesis, but the body is
load-bearing.

**Panelist C (architecture) produces:** A foreword built like a
structural spine: three clear sections (incident, thesis, commitment),
crisp transitions, no rhythmic flourish. Most readable for an
operator scanning it; least memorable for a builder reading it
straight through.

The operator now has three different first-pass outputs. None has
seen the others.

---

## Stage 3: Cross-critique (structured)

The operator sends all three outputs to each panelist with a request
to critique using the four-cell template.

**Sample critique (Panelist A reviewing Panelist B's output):**

```
CRITIQUE OF Panelist B's OUTPUT

Strongest claim:
  Lines 18-22, the named-subsystem detail with real numbers. This is
  what a builder needs to trust the release. No other panelist has
  this density.

Weakest claim:
  Opening sentence is "This release contains five new skills and
  four shells." That is a release-notes opening, not a foreword
  opening. The thesis is buried at line 31. By then the operator
  audience is gone.

Shared blind spot:
  Neither this output nor mine names what the release does NOT do.
  Both implicitly overpromise. The Stage 1 brief warned against this
  and we both missed it.

One thing worth stealing:
  The named-subsystem phrasing in lines 18-22 is concrete in a way
  my output is not. I will adopt that detail level for the body of
  my revision.
```

Each panelist produces two such critiques (one per other panelist),
plus optionally a self-critique. Total: 6-9 critique blocks.

---

## Stage 4: Self-revise (one-line dissent rule)

The operator bundles each panelist's incoming critiques and sends
them. Each panelist revises its first pass.

**Panelist B revises:**
- Adopts the opening-incident critique from Panelist A. Rewrites the
  first 100 words to open on the named incident.
- Adopts the "what this does not do" critique. Adds two sentences
  scoping what the release does not solve.
- Dissents (one line) from a critique that asked to remove the
  named-subsystem density: "The substance density is the load-bearing
  piece of this output; trimming it would defeat the voice/substance
  split."

The revision is stronger than the first pass. About 65% of the
critique landed; 35% was acknowledged and either dissented or noted
as out-of-scope for this revision.

---

## Stage 5: Converge (operator picks merge architecture)

The operator reads all three revisions. The merge architecture chosen:

- **Spine from Panelist C** (architecture). The three-section
  structure (incident → thesis → commitment) is the cleanest.
- **Body density from Panelist B** (substance). The named-subsystem
  detail and real numbers replace Panelist C's drier middle.
- **Opening incident from Panelist A** (voice). The incident opening
  has the strongest rhythm; it goes at the top of Panelist C's spine.
- **The "what this does not do" scoping** (surfaced as the shared
  blind spot) gets a paragraph at the end of the middle section.

The operator either does the merge themselves or hands the three
revisions to one panelist for final integration. In this example,
the operator does the merge directly because it is a 600-word piece;
for longer deliverables, integration by one panelist saves time.

---

## Stage 6: Loop or ship

The operator reads the merged draft. Two open issues remain:

1. The transition between the incident opening and the substance body
   is rough.
2. The closing commitment is concrete but slightly buried.

These are revision-level issues, not panel-level issues. The operator
fixes them in one pass without re-convening the panel.

**Ship.**

---

## What the example illustrates

1. **No agent could have produced the merged output alone.** Each
   contributed a specific dimension. The merge is the value.

2. **The seal in Stage 2 produced genuinely different first passes.**
   If Panelist B had seen Panelist A's narrative-arc opening, B's
   first pass would have anchored on it and the density would have
   been weaker. The seal preserved the density signal.

3. **The critique template prevented negging.** No panelist said "this
   output is worse than mine." The four-cell template forced strength
   recognition and specific weakness, which the producing panelist
   could act on.

4. **Stage 4's one-line dissent rule kept the revisions from
   collapsing into groupthink.** Each panelist retained ~30% of their
   distinctive signal even after revision. The merge benefits from
   that retention.

5. **The shared blind spot (the "what this does not do" scoping) was
   the most valuable output of the cross-critique.** No single agent
   would have surfaced it. Two agents, looking at each other's
   outputs, named what both had missed.

---

## Anti-example: what convergence theater looks like

For contrast: a panel run with the seal broken in Stage 2.

The operator sends the prompt to Panelist A, gets the first draft,
then sends Panelist B the prompt AND Panelist A's draft "for
reference." Panelist B produces a draft that anchors heavily on A's
structure but adds incremental detail. Panelist C, given both prior
drafts, produces a draft that smooths the differences.

The "panel" converges on loop 1. The output is fine. It is also
substantially worse than what a single Claude session with a strong
prompt would have produced, because the seal break destroyed the
independent signal that was the whole point of the panel.

If you find yourself "sharing prior drafts for reference," you have
broken the protocol. Stop, restart Stage 2, and seal it.
