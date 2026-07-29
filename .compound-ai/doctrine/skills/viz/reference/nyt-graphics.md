# Reference: NYT Graphics principles
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0
# Attribution: The New York Times Graphics desk (Amanda Cox, Archie Tse, Gregor Aisch, and colleagues). Quotes verified against the sources listed at the bottom. See `_citations.md` (key: nyt-graphics).

The annotation-first editorial discipline of the New York Times Graphics desk, distilled for chart critique and data storytelling. Few explains how perception works; Kriebel shows how to fix a chart; the NYT desk shows how to make a chart carry an argument. Load this reference for "make this chart tell the story", "annotate this", "editorial", "NYT-style", or any storytelling-over-monitoring request.

## 1. The annotation layer is the product

Amanda Cox: "The annotation layer is the most important thing we do... otherwise it's a case of here it is, you go figure it out." (Eyeo talk, first documented in Andy Kirk, *Data Visualization: A Successful Design Process*, 2012.)

Rule: a chart is done when the takeaway is written ON it, not when the data renders. Headline states the finding (not the topic); the key data point carries a label saying why it matters. The argument must survive a screenshot.

## 2. Tse's three interaction rules (Malofiej 2016)

Archie Tse, "Why We Are Doing Fewer Interactives", verbatim:

1. "If you make the reader click or do anything other than scroll, something spectacular has to happen."
2. "If you make a tooltip or rollover, assume no one will ever see it. If content is important for readers to see, don't hide it."
3. "When deciding whether to make something interactive, remember that getting it to work on all platforms is expensive."

Supporting analytics from Gregor Aisch: only ~10-15% of readers ever click interactive elements.

Rule: never gate the message behind a hover, filter, or click. A KPI explanation living in a tooltip is an explanation that does not exist.

## 3. Label directly, kill the legend

Consistent desk practice: series labeled at line end or in the chart area, in the series color; units stated once in the subtitle, not on every tick. A legend is a failed label. Label at the point of divergence, which is where the story usually is.

## 4. Static-first, mobile-first

Since ~2015-2016 (operationalized by Tse's ai2html, open-sourced 2015): design the phone version first and treat it as the real version. If a chart needs 1200px to be legible, the encoding is wrong, not the screen. Small multiples beat one dense desktop-only chart.

## 5. Show uncertainty honestly

The 2016 election needle encoded forecast uncertainty as jitter across the 25th-75th percentile band: honest, effective, and emotionally costly. Show the band, not just the point; use motion to encode uncertainty only when the data is genuinely live.

## 6. The NYT critique pass

Run after the Few pass (perception) and the Kriebel pass (makeover):

1. Title states the FINDING, not the topic.
2. Takeaway annotated on the chart, at the data point that proves it.
3. Legend replaced by direct labels wherever possible.
4. Nothing essential hidden behind hover, click, filter, or tab.
5. Reads at phone width without pinching.
6. Estimates and forecasts show visible uncertainty.
7. The argument survives a screenshot.

## Exemplars worth naming

- "How the Recession Reshaped the Economy, in 255 Charts" (2014): small multiples at scale.
- "512 Paths to the White House" (2012): the rare interactive that earns its clicks.
- "You Draw It" (2015): prediction-before-reveal engagement in service of the argument.
- The election needle (2016): uncertainty encoding and its UX cost.

## Sources

- https://github.com/archietse/malofiej-2016 (Tse's slides, primary)
- https://www.niemanlab.org/2016/03/at-the-malofiej-infographics-world-summit-the-best-form-of-storytelling-is-often-static/
- https://www.softwareandart.com/amanda-cox-making-illustrations-better-with-an-annotation-layer/
- Andy Kirk, *Data Visualization: A Successful Design Process*, Packt 2012, ch. 4
- https://medium.com/@dominikus/the-end-of-interactive-visualizations-52c585dcafcb (Aisch's analytics)
- https://mobilevis.github.io/assets/mobilevis2018_paper_20.pdf (ai2html impact)
