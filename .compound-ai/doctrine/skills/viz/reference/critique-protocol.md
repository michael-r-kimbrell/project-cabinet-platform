# Viz Critique Protocol
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

The before / after critique pattern, built on Andy Kriebel's #MakeoverMonday method. Use when the user pastes a chart, links to one, or asks "is this chart wrong" / "makeover this" / "critique this viz".

## Phase 1  -  Read what is on the page

Before judging, describe what is actually there:

- **Chart type** (bar, line, pie, scatter, dashboard tile, etc.)
- **What the data shows** (one sentence summary of the visual content)
- **What the chart is trying to say** (the title's claim, or the absence of one)
- **Audience signal** (executive, analyst, operational, public  -  inferred from context)
- **Likely tool / output medium** (Excel, Tableau, Power BI, slide deck, web page, print)

Resist the temptation to start with critique. The reader's first move is to understand the chart on its own terms.

## Phase 2  -  Apply the rules from `rules.md`

Walk the 10 rules and check each. For every rule violated, note:

1. **The violation** (what the chart does wrong)
2. **The principle violated** (which rule, with the named source where applicable)
3. **The cost** (what the reader cannot do because of the violation: cannot compare magnitudes, cannot find the highlight, cannot judge the trend, etc.)

Example findings:
- "Pie chart with seven slices, three rotating away from anchor positions. Violates Rule 1 (Save the Pies for Dessert  -  Stephen Few). Reader cannot accurately compare slice magnitudes."
- "Rainbow palette across all bars in a single category. Violates Rule 2 (Color must encode meaning). Reader's eye wanders; no highlight."
- "KPI tile shows '$4.2M' with no comparison. Violates Rule 6 (Comparison context is mandatory). Reader cannot judge whether this is good or bad."

If a chart passes all 10 rules cleanly, say so. Critique is not synonymous with finding fault.

## Phase 3  -  Propose a specific fix

For each violation, propose a concrete alternative. Do not say "use a better chart"  -  say "use a horizontal bar chart sorted by value, with a single accent color on the bar the title is asking the reader to compare."

Format:
```
Issue: [violation]
Fix: [specific replacement, including chart type, palette decision, annotation strategy]
Why: [the principle, named]
```

## Phase 4  -  Render the makeover (optional)

If the user wants the makeover produced, not just described:

1. Reproduce the data structure (paste or summarize what was in the original)
2. Pick the recommended chart type from `taxonomy.md`
3. Apply the rules from `rules.md` to color and layout
4. Produce the output: HTML/SVG, Tableau / Power BI / matplotlib spec, or a verbal "build this chart with these specs" instruction

Pair this with `cross-domain-translation` if the chart's audience differs from the original.

## Output format

```
CRITIQUE
Chart in question: [one-line description of what was provided]

What the chart shows: [neutral description of content]
What the chart is trying to say: [the claim being made]
Audience signal: [executive / analyst / operational / public]

Rules check:
  Rule 1 (No pies):                [pass / fail  -  reason]
  Rule 2 (Color encodes meaning):  [pass / fail  -  reason]
  Rule 4 (Monitoring vs analysis): [pass / fail  -  reason]
  ... (only list rules that fired)

Findings:
  1. [Issue]: [Specific fix]  -  [Why, with named principle]
  2. ...

Recommended makeover:
  Chart type: [from taxonomy.md]
  Palette: [muted body + accent color description]
  Annotation: [one-line annotation pointing to the insight]
  Comparison context: [the baseline this chart needs]

Optional: paired-skill suggestions
  - If audience is shifting: cross-domain-translation
  - If this is going through quality review: quality-gate
```

## When NOT to critique

- The chart is a working sketch, not a finished deliverable
- The user asked for a chart RECOMMENDATION, not a critique (route to `taxonomy.md` instead)
- The chart is in a domain where the convention deviates from Few's rules with good reason (e.g. financial candlestick charts, scientific visualization with established conventions). Acknowledge the convention; do not pretend Few's rules override domain-specific patterns.

## Reference posture

Critique is not opinion. Every finding cites a rule from `rules.md`, which cites a source in `canon.md`. The viz skill's authority is borrowed, not asserted.
