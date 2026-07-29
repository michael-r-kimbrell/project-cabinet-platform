# Viz Rules
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

The non-negotiable rules for visualization design. Most are distilled from Stephen Few's *Perceptual Edge* canon, with practical storytelling input from Andy Kriebel's #MakeoverMonday archive. See `canon.md` for full attribution.

---

## 1. Save the pies for dessert

**No pie charts.** Use a bar chart, slope chart, or simple table instead.

Pie chart slices are only easy to judge at anchor positions (0%, 25%, 50%, 75%, 100%). Once slices shift away from these positions, human perception cannot accurately decode the angles. Bars are read along a single common axis, which makes magnitude comparison precise and effortless.

If you must label every slice with both name and percentage to make a pie chart readable, you have built a table in a circle. Use the table.

The single legitimate use: showing one part of one whole at a single anchor position. Almost never the right call.

## 2. Color must encode meaning

Color is a visual channel. Decorative color wastes it.

- **Rule:** different colors only when they correspond to differences of meaning.
- **Rainbow bars** (one color per bar in a series)  -  wrong. Use one muted color, with one accent on the bar that matters.
- **Heatmap colors**  -  must have sufficient contrast against any overlaid text or numbers.
- **Background color**  -  keep it consistent across displays. The same data color looks different against different backgrounds (perceptual relativity).

## 3. Default to a muted palette with one accent

Soft, natural colors for the body. Bright or dark colors only for the data you want the eye to land on. A dashboard or chart with three "important" highlights has no highlights.

## 4. Dashboards are for monitoring, not analysis

A dashboard is a visual display of important information consolidated on a single screen for at-a-glance monitoring. If the goal is exploration or insight generation, build an analytical display, not a dashboard.

**Three-stage monitoring pattern:**
1. **Scan** the big picture.
2. **Zoom** in on important specifics.
3. **Link** to supporting detail.

Everything must fit on one screen. Scrolling or tab-switching breaks visual memory and defeats the at-a-glance purpose.

## 5. Rich data over poor data

Choose compact, contextual displays. Sparklines, bullet graphs, small multiples, and tables-with-trendlines convey more actionable information per square inch than gauges, single-number tiles, or animated 3D effects.

A "Key Metrics" table with seven metrics, sparklines, bullet graphs, and alert icons beats three traditional gauges in the same screen real estate every time.

## 6. Comparison context is mandatory

Numbers without a comparison are noise. Every metric on a dashboard needs at least one of:
- Plan vs. actual
- Forecast
- Standard or norm
- Peer benchmark
- Competitor reference
- Prior period (last week, last month, same period last year)

"Sales were $4.2M" tells you nothing. "Sales were $4.2M, 8% over plan, second-best quarter in two years" tells you everything.

## 7. Pre-attentive attributes are the fast channel

Use the human visual system's pre-attentive processing for the most important data: position, length, slope, hue, intensity, size. Avoid forcing the reader to count, compare angles, or decode color gradients for primary insights.

Position and length are the strongest pre-attentive cues. That is why bars (length) and scatter plots (position) outperform pies (angle) and donuts (arc).

## 8. Chart selection follows story type

Before picking a chart, name the story type:
- **COMPARISON**  -  comparing values across categories or entities → bar
- **TREND**  -  change over time → line
- **DISTRIBUTION**  -  spread, frequency, shape → histogram, box plot
- **CORRELATION**  -  relationship between variables → scatter
- **COMPOSITION**  -  parts of a whole → stacked bar, treemap (not pie)
- **FLOW**  -  sequence, handoffs, process → swimlane, sankey, gantt
- **HIERARCHY**  -  nested or ranked → tree, issue tree, treemap
- **GEOGRAPHY**  -  spatial → choropleth, dot map
- **RELATIONSHIP**  -  networks, dependencies → network graph, dependency map
- **PERFORMANCE**  -  actuals vs targets → bullet graph, scorecard
- **RISK**  -  probability + impact → heat map, risk matrix
- **CX / STRATEGY**  -  qualitative or framework-driven → journey map, 2x2 matrix

Pick the chart that maps cleanly to the story type. Trying to make a chart do two story types at once produces clutter.

## 9. Audience matters more than the data

Same dataset, different audience, different chart.

- **Executive**  -  high-level, decision-ready, one number with one comparison. Use signal vs. noise charts, executive one-pagers, scorecards.
- **Stakeholder**  -  credible, polished, explainable. Bar charts, dashboards, waterfall charts.
- **Analyst**  -  tolerates complexity, wants detail. Scatter plots, control charts, heatmaps, small multiples.
- **Delivery / operational**  -  needs operational specificity. Process maps, swimlane diagrams, bottleneck analysis.

When the audience shifts, pair this skill with `cross-domain-translation` to re-encode without losing fidelity.

## 10. Annotate the insight, not the data

A chart without annotation forces the reader to find the insight. Add a one-line annotation that points to what the chart shows. Position the annotation at the data point being explained.

Bad: a chart with a generic title.
Good: a chart titled "Sales fell 23% in Q3 after pricing change" with an arrow pointing to the Q3 bar.

---

## Quick reference table

| Situation | Default move |
|---|---|
| Comparing categories | Horizontal bar chart, sorted by value |
| Showing trend over time | Line chart, time on x-axis |
| Multiple metrics in one view | Small multiples (faceted bar / line) |
| Part-to-whole | Stacked bar or treemap (NEVER pie) |
| Performance vs target | Bullet graph |
| KPI tile | Big number + sparkline + comparison value |
| Heatmap colors | Muted gradient, never red-green for accessibility |
| Default accent color | Single accent against a muted body palette |
| Chart for "the C-suite" | Executive one-pager, scorecard, signal-vs-noise chart |
| Chart for "the analyst" | Scatter plot, small multiples, control chart |

When in doubt, default to a bar chart. It is almost always at least the second-best option, and rarely worse than the alternative.
