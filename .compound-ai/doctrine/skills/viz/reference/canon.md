# Viz Canon
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

The sources behind the rules and taxonomy in this skill. Cite these when justifying a recommendation; the reasoning lands harder when grounded in named canon than in unattributed assertion.

## Stephen Few  -  *Perceptual Edge*

Few is the central canon for this skill. His work translates visual perception research into practical chart design rules. The viz skill's design rules (no pies, color must encode meaning, dashboards are for monitoring, rich data over poor data) come directly from his published material.

**Canonical works:**

- **"Save the Pies for Dessert"** (Visual Business Intelligence Newsletter, 2007)  -  the definitive argument against pie charts. Anchor positions, slice perception, the failure mode of label-stuffing.
- **"Practical Rules for Using Color in Charts"**  -  the five color rules: consistent backgrounds, purposeful color use, color for communication not decoration, color differences only when they mean differences, soft palettes with highlight accents.
- **"Information Dashboard Design"** (book)  -  the foundational text on dashboards as monitoring surfaces. Defines the three-stage scan-zoom-link pattern.
- **"Rich Data, Poor Data"**  -  the case for compact, contextual displays (sparklines, bullet graphs, small multiples) over flashy gauges.
- **"Why Most Dashboards Fail"**  -  the argument that most dashboards fail because they ignore visual perception and human cognition principles.

**Key concepts referenced in this skill:**
- Pre-attentive attributes (position, length, slope, hue, intensity, size)
- Visual perception relativity (the same gray appears different against different backgrounds)
- Single-screen rule for dashboards (visual memory breaks across scrolling)
- Comparison context (numbers without a baseline are noise)

## Andy Kriebel  -  *#MakeoverMonday*, *VizWiz*

Kriebel's contribution is the practical critique pattern: take a real-world chart and rebuild it. The viz skill's `critique-protocol.md` is built around the Makeover Monday pattern.

**Canonical material:**

- **#MakeoverMonday** (community archive)  -  weekly before/after critiques of published visualizations. Demonstrates the rules in `rules.md` against real charts found in the wild.
- **VizWiz** (blog)  -  Kriebel's practical, project-driven writing on Tableau dashboards and chart selection.

**Key concepts referenced in this skill:**
- The "before / after" critique pattern (identify what is broken → name the principle violated → propose specific fix)
- Practical storytelling: data + design + narrative working together
- The reader's path: what does the reader see first, second, third?

## Taxonomy heritage

The 50+ item chart taxonomy in `taxonomy.md` synthesizes:
- Few's rules for chart selection
- Kriebel's project-driven library of "the right chart for X data"
- Standard analytics methodology categories (PROJECT, STRATEGY, RISK, DATA, PROCESS, CX, SYSTEMS, ADVANCED, EXECUTIVE)
- The story-type framework (COMPARISON, TREND, DISTRIBUTION, CORRELATION, COMPOSITION, FLOW, HIERARCHY, GEOGRAPHY, RELATIONSHIP, PERFORMANCE, RISK, CX, STRATEGY)

This taxonomy is broader than Few's or Kriebel's individual lists because it includes strategic frameworks (SWOT, BCG, Porter), process diagrams, and CX-specific patterns. Treat it as a chart picker, not a teaching reference. The teaching reference is Few and Kriebel.

## Light credits

The 50+ chart taxonomy was assembled by Elizabeth Griemann and adapted here. Analytics delivery methodology context (story-type framing, audience-level distinctions) draws on Patrick Dyer's enterprise analytics training material. This skill is a synthesis layer over their work plus Few + Kriebel canon; the originals are richer than what fits in a pointer skill.

## When to cite

When recommending a specific chart type or design principle:
- "Pie charts hide the data  -  Stephen Few, *Save the Pies for Dessert*"
- "Numbers need comparison context  -  Few's *Information Dashboard Design*"
- "Before / after critique pattern  -  Kriebel's #MakeoverMonday"

When the user asks "why?"  -  answer with the principle and the source. The viz skill's authority is borrowed from these canon, not asserted independently.

## Where to read more

- **stephenfew.com**  -  articles, books, newsletter archive
- **makeovermonday.co.uk**  -  community archive of weekly chart rebuilds
- **vizwiz.com**  -  Kriebel's blog
- **Edward Tufte**  -  *The Visual Display of Quantitative Information* (the precursor canon to Few; not directly cited in this skill but the lineage runs through Tufte → Few)
