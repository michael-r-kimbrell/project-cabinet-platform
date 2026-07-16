# Skills convention

A skill is a Tier-1 file that packages a repeatable procedure this project
needs more than once. Not everything is a skill — a one-off task is just a
task.

## When something earns a skill file

- You've asked for the same kind of thing three times ("normalize this
  supplier's cabinet names," "generate a design proposal from dimensions +
  style + budget").
- The procedure has steps an agent could plausibly skip or reorder if not
  told explicitly.
- Getting it wrong is costly enough that "the agent will probably remember"
  isn't good enough.

## Format

Each skill is a single markdown file under `skills/<name>/SKILL.md` (create
the `skills/` folder when you add your first one) with:

- **Trigger** — what request should cause this to load
- **Inputs** — what the agent needs before starting
- **Procedure** — the actual steps, in order
- **Verification** — how the agent checks its own output before reporting
  done (ties back to the verify-before-claiming habit in `CLAUDE.md`)

## Starting skill candidates for this project

Don't build these yet — build them the third time you need them:

- `supplier-name-normalize` — map a vendor's cabinet naming to the internal
  canonical name, using the translation layer in `data/suppliers/`
- `design-proposal-draft` — turn dimensions + style + budget into a design
  the customer can approve
- `region-onboard` — add a new region as a data row, not a code change
  (see `doctrine/CONVENTIONS.md`)
