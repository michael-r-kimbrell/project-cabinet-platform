# Session routing (the janitor vs. the brain surgeon)

Model names and exact usage multipliers change over time — check the
in-app model picker for what's current rather than trusting a hardcoded
name here. The tiers and what belongs in each are stable even when the
names underneath them change.

| Tier | Route here | Cabinet-project examples |
|---|---|---|
| Cheapest/fastest | Mechanical, high-volume, low-judgment tasks | Bulk supplier-name lookups, reformatting a data file, rewriting a short customer email |
| Mid-tier daily driver | Default for everyday work | Most day-to-day coding, routine bug fixes, drafting a translation-layer entry |
| Strategy tier | Planning, architecture, "see all the connections" | Deciding how the region/supplier data model should shape up before building it; reviewing a design proposal's logic before it ships |
| Top/build tier | Building something once the plan is settled | Implementing the design-generation flow once dimensions → design logic is actually specified |

## The pattern

Plan with the strategy tier, then hand the settled plan to the build tier
to implement. Don't skip the plan step and go straight to the build tier —
that's how you get a fast, confident, wrong first draft.

## Free lanes

Anything in the "cheapest/fastest" row is also a candidate for a free API
lane instead of paid usage — see `capabilities/usage-discipline.md`.
