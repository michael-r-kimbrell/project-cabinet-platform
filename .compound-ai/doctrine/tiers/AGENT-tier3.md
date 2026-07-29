# Tier 3: Shells

Project scaffolds. Pick one when starting a specific deliverable. Each shell is a working starting point with the capabilities pre-wired so you can focus on content.

## What this tier owns

| Shell | When to use | Inherits |
|---|---|---|
| `slide-shell/` | Presentation decks, executive briefings, conference talks | Keyboard nav, touch swipe, speaker notes, progress bar, theme toggle, fullscreen, glassmorphism cards, IntersectionObserver chart animations |
| `scroll-shell/` | Data-storytelling pages, long-form analyses, interactive reports | Framer Motion scroll-triggered animations, sliders with cascading calculations, tooltip system, Recharts integration, tabular-nums for numeric alignment |
| `mission-control/` | Dashboards, status surfaces, operational consoles | Grid-based module layout, real-time data slots, status indicators, role-based view toggles |
| `course-shell/` | Sequential lessons, training material, structured learning | Lesson progression tracking, knowledge checks, prerequisite chaining, completion state |

## Rules at this tier

1. **Shells inherit, do not redefine.** Use the Abyssal design system from `../tier-1-global/design-system/`.
2. **Capabilities come from Tier 2.** A shell may reference cognitive modes, viz, or pressure-test  -  but should not re-implement them.
3. **Every shell ships with placeholder content only.** Real content lives in your project, not in the shell.
4. **Every shell has a `README.md`** that explains what it produces, how to fill it, and which Tier 2 skills pair with it.

## How to pick a shell

| Question to ask | Shell |
|---|---|
| "Am I delivering this in a meeting / on a screen, slide by slide?" | `slide-shell` |
| "Will the reader scroll through this on a webpage and interact with it?" | `scroll-shell` |
| "Is this an operational surface someone monitors?" | `mission-control` |
| "Is this educational material someone progresses through?" | `course-shell` |

## Escalate up / drill down

- **Up:** `../doctrine/tiers/AGENT-tier2.md` for the skills that fill these shells with substance
- **Up further:** `../tier-1-global/design-system/` for the Abyssal tokens that style every shell
