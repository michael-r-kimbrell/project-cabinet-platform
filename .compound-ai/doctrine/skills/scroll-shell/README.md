# Scroll Shell

Part of the Compound AI Operating Standards v3.0.10 kit.

## What this produces

A long-form, narrative HTML page with a persistent sidebar TOC, scroll-spy navigation, scroll-triggered reveal animations, an interactive slider that drives cascading calculations, hover tooltips, tabbed views, and CSS-only chart placeholders. Designed for analytical essays, scrollable explainers, internal whitepapers, and "act-structured" data stories. Vanilla HTML + JavaScript, no framework, no build step.

## Capabilities

- **Scroll-triggered animations:** elements with class `.reveal` fade and slide in on entry via IntersectionObserver. Stagger with `.reveal-delay-1`, `.reveal-delay-2`, `.reveal-delay-3`.
- **Interactive slider:** an HTML5 range input drives four cascading outputs in real time. Edit the `recalc()` function to wire your own math.
- **Tooltip system:** inline dashed-underline `<span class="tip" data-tip="id">` triggers a positioned tooltip with a smooth entrance, content sourced from the `#tipRegistry` block. Works on hover, focus, and touch.
- **Tab-like view toggles:** state-driven switching between panes inside a section.
- **CSS bar charts:** vanilla HTML; bars animate from 0 to `data-value` once the chart enters view. See the inline comment above the `chart-cssbars` block, **swap in Recharts or Chart.js when you need axes, real tooltips, or interactivity on data points.**
- **SVG line chart:** a sketched inline SVG with a gradient fill. Same swap guidance applies for production use.
- **Tabular-nums:** `font-variant-numeric: tabular-nums` applied via the `.tabular` class and on metric values, sliders, and outputs so digits align.
- **Gradient text:** the `.gradient-text` class for headline emphasis on key metrics.
- **Act-level structure:** five `.act` sections demonstrate progressive disclosure (Open, Tension, Model, Explore, Close) with scoped reveals.
- **Sidebar TOC + scroll-spy:** IntersectionObserver highlights the active section in the sidebar as the reader scrolls.
- **Theme toggle:** light/dark via `data-theme` on `<html>`.

## How to use it

1. Open `index.html` in any modern browser. No build step.
2. Each `<section class="act">` is one narrative act. Add, rename, or reorder them.
3. Wire the slider math by editing `recalc()` in the script block.
4. Tooltips: add an entry to `#tipRegistry` with a `data-id`, then reference it with `<span class="tip" data-tip="id">`.
5. Tabs: add a `.view-toggle` with buttons that have `data-view` and matching `.view-pane[data-pane]` blocks.
6. Charts: edit the values on `.cssbar-row[data-value]`. For real charts, replace the `chart-cssbars` block with a Recharts/Chart.js mount point.
7. Deploy by hosting as static HTML.

## Tier 2 skills that pair well

- **`viz`** to pick the right chart type before you fill in bar/line data.
- **`cross-domain-translation`** to write the framing devices and tooltips that map jargon to everyday language.
- **`shape`** to plan the act structure before drafting copy.
- **`build`** to populate this shell with generated content end-to-end.
- **`clarify`** to sharpen lede sentences and tooltip prose.

## What this is NOT

- Not Substack, Ghost, or Medium. No CMS, no comments, no subscriber management, no SEO scaffolding beyond what you add.
- Not Observable or Streamlit. The interactive slider is a UI demo, not a notebook engine. There is no Python/JS evaluator inside the page.
- Not D3 or Plotly. The charts are placeholders; swap in a real charting library when you need axes, ticks, log scales, or interactive data tooltips.
- Not a React/Vue/Svelte component. Intentionally vanilla so the shell is drop-in for anyone, not framework-locked.
