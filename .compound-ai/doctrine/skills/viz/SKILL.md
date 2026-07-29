# Skill: viz
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Recommends visualizations, critiques existing charts, designs dashboards.
Grounded in Stephen Few's perception science (Perceptual Edge), Andy
Kriebel's practical storytelling (Makeover Monday), and the NYT Graphics
desk's annotation-first editorial discipline, with a 50+ item chart
taxonomy and explicit design rules.

## Triggers

"viz", "visualization", "data viz", "what chart should I use",
"recommend a chart", "dashboard design", "chart critique",
"makeover this chart", "visualize this data", "best way to show",
"chart selection", "dashboard layout", "is this chart wrong",
"annotate this chart", "data storytelling", "NYT-style"

## How to apply

1. **Identify the question type**, then load the matching reference:

| User question                                              | Load this reference                            |
|------------------------------------------------------------|------------------------------------------------|
| "what chart should I use", "recommend a chart"             | `reference/taxonomy.md` + `reference/rules.md` |
| color choices, palette decisions                           | `reference/rules.md` (Rules for color)         |
| dashboard design, monitoring layouts                       | `reference/rules.md` (Dashboard section)       |
| "critique this chart", "what is wrong with this"           | `reference/critique-protocol.md`               |
| pie chart anywhere in the request                          | `reference/rules.md` (Save the pies)           |
| "rich data poor data", clutter, chart-junk                 | `reference/rules.md` (Rich/poor data)          |
| executive dashboard, "for the C-suite"                     | `reference/taxonomy.md` (Executive section) + `reference/canon.md` |
| ready-to-use prompt for a specific chart type              | `reference/prompts.md`                         |
| where this canon comes from, attribution                   | `reference/canon.md`                           |
| storytelling, annotation, "make the chart tell the story"  | `reference/nyt-graphics.md`                    |

2. **Apply the rules every time** (do not need to be loaded - they are absolute):
   - **No pie charts.** Use a bar chart, slope chart, or simple table instead. See `reference/rules.md` for the full argument.
   - **Color must encode meaning.** Decorative color is a wasted channel.
   - **Default to a muted palette** with one accent color for emphasis.
   - **Dashboards are for monitoring.** If exploration is the goal, build an analytical display, not a dashboard.
   - **One screen, three stages**: scan → zoom → link. No scrolling on monitoring surfaces.
   - **Rich data over poor data.** Compact, contextual displays (sparklines, bullet graphs, small multiples) beat flashy gauges.

3. **For chart recommendations**, scan `reference/taxonomy.md` for the matching story type (COMPARISON, TREND, DISTRIBUTION, CORRELATION, COMPOSITION, FLOW, HIERARCHY, GEOGRAPHY, RELATIONSHIP, PERFORMANCE, RISK, CX, STRATEGY) and produce a ranked output with:
   - Top 3 chart types with fit reasoning
   - Audience/level/complexity tags
   - Pitfalls to avoid
   - Optional: ready-to-use prompt from `reference/prompts.md`

4. **For critique**, apply `reference/critique-protocol.md` (Kriebel makeover pattern): identify what is broken, name the principle violated, propose a specific fix.

## Pair with

- `cross-domain-translation`  -  when the chart's audience changes (exec ↔ analyst ↔ delivery)
- `quality-gate`  -  before shipping a visual, validate against the rules

## Source references

- `reference/taxonomy.md`  -  50+ chart types organized by story type
- `reference/rules.md`  -  Stephen Few's design rules, distilled
- `reference/canon.md`  -  Few and Kriebel canonical sources, with attribution
- `reference/prompts.md`  -  ready-to-use prompt templates per chart type
- `reference/critique-protocol.md`  -  the makeover pattern for fixing broken charts
- `reference/nyt-graphics.md`  -  NYT Graphics annotation-first principles, with attribution
