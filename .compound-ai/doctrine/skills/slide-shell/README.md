# Slide Shell

Part of the Compound AI Operating Standards v3.0.10 kit.

## What this produces

A self-contained, single-file HTML deck. Open it, drop in your content, and you have a keyboard-driven presentation with speaker notes, theme switching, animated charts, and touch support. Designed for browser-first delivery (executive briefings, demo decks, internal show-and-tells) without needing PowerPoint, Keynote, or a slide service.

## Capabilities

- **Keyboard navigation:** `ArrowRight` / `Space` / `PageDown` next, `ArrowLeft` / `PageUp` prev, `Home` first, `End` last, `F` fullscreen, `T` theme toggle, `S` speaker notes toggle.
- **Touch swipe:** horizontal swipe with delta greater than 40px advances slides on mobile/tablet.
- **Click zones:** invisible left/right edge regions reveal chevrons on hover and fire prev/next.
- **Progress bar:** 3px gradient bar at the top that fills left-to-right as you advance.
- **Slide transitions:** opacity 0 to 1, translateX 40px to 0, 0.4s ease.
- **Speaker notes side panel:** 320px collapsible panel populated from each slide's `data-script` attribute. Append `?client` to the URL to hide it for the audience view.
- **Theme toggle:** light/dark via `data-theme` on `<html>`. CSS variables flip.
- **Fullscreen API:** press `F` to enter/exit.
- **Glassmorphism cards:** backdrop-filter blur, semi-transparent surfaces, no drop shadows.
- **Animated bar charts:** IntersectionObserver fires the fill animation when the slide enters view. Bars start at 0% and animate to `data-value` over 0.8s.
- **Info-button detail panels:** click the info icon on a card to open a floating panel; it auto-positions to stay inside the viewport.
- **Expandable cards:** click anywhere on the card header to reveal more, with a rotating chevron icon.
- **Slide counter:** monospace `N / total` in the footer corner.

## How to use it

1. Open `index.html` in any modern browser. No build step.
2. Each `<section class="slide">` is one slide. Add or remove sections.
3. Put speaker notes on the `data-script` attribute of each slide.
4. Drop bar charts in by adding `<div class="chart-bars" data-chart>` and rows with `data-value="N"`.
5. For info panels, give the trigger button `data-detail="someid"` and add a `<div class="detail-panel" id="detail-someid">` to the body.
6. Deploy by hosting the file as static HTML anywhere (GitHub Pages, S3, Cloudflare Pages, a USB drive).

## Tier 2 skills that pair well

- **`viz`** for chart selection, encoding choices, and chart-type discipline before you fill in the bar values.
- **`shape`** to plan the deck's narrative arc before opening this file.
- **`build`** as the end-to-end pipeline that drops generated content into this shell.
- **`critique`** to pressure-test the design once it is filled in.

## What this is NOT

- Not Beautiful.ai, Pitch, or Tome. No collaborative editing, no template library, no AI generation inside the deck.
- Not a presentation engine like reveal.js or impress.js. No animation timeline, no nested slides, no math typesetting plugins.
- Not a print/export tool. There is no built-in PDF export; print the browser if you need a hard copy.
- Not a design system reference. The visual language is opinionated but minimal; if you need a full token set, that lives elsewhere in the kit.
