# Citations Registry
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

This file is the canonical attribution registry. Citation markers in the
field guide and reference files use the `[^key]` convention; the field
guide reader resolves them to superscript tooltips with the entries
below.

Each entry has a `key`, a display name, a one-line "what they
contributed," and an optional link. Keep entries tight: tooltip readers
should be able to absorb the citation in three seconds.

---

## Format

Each citation is a section keyed by `## adam-federman`. The body is:

```
**Name:** [Full name]
**Contribution:** [One-line: what they contributed to this kit]
**Where in the kit:** [Which skill or chapter applies]
**Link:** [Optional external link]
```

The reader's tooltip shows Name + Contribution. Link renders as a clickable
"more" affordance when present.

---

## adam-federman

**Name:** Adam Federman
**Contribution:** The NOD opposite-perspectives protocol pattern (gated opposite-construction without emotion) and the standing-panel-vs-convened-panel design observation surfaced during cross-kit review.
**Where in the kit:** `nod-protocol` skill (origin file); `agent-panel-planning/reference/when-to-convene.md` (standing-vs-convened section).
**Link:** _

## michael-sutcliff

**Name:** Michael Sutcliff
**Contribution:** The CEO operating-lens framework adapted into the pressure-test skill (ten mental models including Multiples-not-percentages, Iceberg Test, Hope-Not-Strategy, and Domain Ownership).
**Where in the kit:** `pressure-test/reference/lenses.md`.
**Link:** _

## stephen-few

**Name:** Stephen Few
**Contribution:** The Perceptual Edge canon for data visualization: no pies, color encodes meaning, dashboards for monitoring not exploration, rich data over poor.
**Where in the kit:** `viz/reference/canon.md`, `viz/reference/rules.md`.
**Link:** https://www.perceptualedge.com/

## andy-kriebel

**Name:** Andy Kriebel
**Contribution:** The Makeover Monday pattern for visualization critique and improvement, adopted as the viz skill's critique protocol.
**Where in the kit:** `viz/reference/critique-protocol.md`.
**Link:** https://www.vizwiz.com/p/makeover-monday.html

## nyt-graphics

**Name:** The New York Times Graphics desk (Amanda Cox, Archie Tse, Gregor Aisch, and colleagues)
**Contribution:** Annotation-first editorial discipline for the viz skill: the annotation layer as the most important layer (Cox), the Malofiej 2016 interaction rules (Tse), engagement analytics behind interaction skepticism (Aisch), direct labeling over legends, and static/mobile-first delivery via ai2html.
**Where in the kit:** `viz/reference/nyt-graphics.md`, routed from `viz/SKILL.md`.
**Link:** https://github.com/archietse/malofiej-2016

## liz-griemann

**Name:** Elizabeth Griemann
**Contribution:** Hands-on viz taxonomy refinement and chart-selection heuristics that informed the viz skill's prompts and taxonomy reference.
**Where in the kit:** `viz/reference/canon.md` light credits.
**Link:** _

## patrick-dyer

**Name:** Patrick Dyer
**Contribution:** Viz training context and the discipline of grounding chart selection in canon rather than visual preference.
**Where in the kit:** `viz/reference/canon.md` light credits.
**Link:** _

## garry-tan

**Name:** Garry Tan
**Contribution:** The GSTACK scope-mode framework (SCOPE EXPANSION, SELECTIVE EXPANSION, HOLD SCOPE, SCOPE REDUCTION) adapted into the pressure-test skill's scope discipline.
**Where in the kit:** `pressure-test/reference/scope-modes.md`.
**Link:** https://twitter.com/garrytan

## pmi-pmbok

**Name:** PMI / PMBOK
**Contribution:** The standard stakeholder management framework (influence-interest grid, four quadrants of engagement strategy).
**Where in the kit:** `stakeholder-mapping/SKILL.md`.
**Link:** https://www.pmi.org/

## mendelow

**Name:** Aubrey L. Mendelow
**Contribution:** Mendelow's matrix (the influence-interest grid with Manage Closely / Keep Satisfied / Keep Informed / Monitor quadrants).
**Where in the kit:** `stakeholder-mapping/SKILL.md`.
**Link:** _

## michael-elizarov

**Name:** Michael Elizarov
**Contribution:** The linkedin-osint-toolkit (MIT-licensed open-source toolkit for LinkedIn-based organizational mapping). Acknowledged as the optional upstream data source for the stakeholder-mapping skill.
**Where in the kit:** `stakeholder-mapping/SKILL.md` (Data sources section).
**Link:** https://github.com/michaelelizarov/linkedin-osint-toolkit

## bair-compound-ai

**Name:** Berkeley AI Research (Matei Zaharia, Omar Khattab et al.)
**Contribution:** The "Compound AI Systems" academic frame (February 2024) that named the shift from single-model architectures to compositional model systems. This kit sits in dialogue with that frame as the operating layer.
**Where in the kit:** Foreword note on the word "compound."
**Link:** https://bair.berkeley.edu/blog/2024/02/18/compound-ai-systems/

## panel-coordination-v1

**Name:** Claude, Kiro, and Codex (the three-agent build of v1)
**Contribution:** The original three-agent file-based handoff that produced v1.0.0 of this kit. The panel-review and panel-planning patterns in v2.1-v2.2 are formalizations of what worked in that build.
**Where in the kit:** `agent-panel-review`, `agent-panel-planning`, Field Guide Chapters 31 and 32.
**Link:** _

---

## How citations render in the reader

In the field guide markdown, a citation marker looks like:

```
The NOD framing was contributed by Adam Federman[^adam-federman].
```

The reader's marked.js parser swaps the marker for a superscript span
with hover tooltip:

```html
The NOD framing was contributed by Adam Federman<sup
class="citation" data-key="adam-federman" title="Adam Federman --
The NOD opposite-perspectives protocol pattern...">[1]</sup>.
```

The superscript number is auto-assigned per citation order on the
rendered page. Hover reveals the tooltip with Name + Contribution.

Inline `<abbr>` tags work as a fallback for environments that do not
parse the citation extension.

---

## What is NOT cited via this registry

- **Public-domain conventions** (Stephen Few cites his own predecessors;
  Mendelow's matrix is in the public-domain management literature). The
  registry credits the proximate source.
- **Skill mechanics that emerged inside this kit** (the four-cell
  critique format, the five-gate NOD adaptation, the strength-matched
  task assignment from demonstrated dominance). These are this kit's
  own contributions.
- **The kit's own operational provenance** (the reliability incident
  behind the foreword, the IIP proof point). Not citations; they are the
  kit's own provenance.

If a contribution warrants a citation entry, add it here. The registry
is the single source of truth.
