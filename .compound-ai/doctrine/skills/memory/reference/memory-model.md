# Memory model (shared by all five modes)

Paths below are illustrative. Adapt the folder names to your own store: a notes
vault, a docs folder, a knowledge directory. The shape is what matters.

## Three layers

| Layer | Where | Holds | The question it answers |
|---|---|---|---|
| 1. Knowledge graph | `life/` in PARA folders | atomic, durable facts about the world | what is true |
| 2. Daily notes | `memory/YYYY-MM-DD.md` | raw timeline of events | what happened, when |
| 3. Tacit knowledge | `MEMORY.md` (or the core file) | how the operator works, lessons | how to act |

Layer 1 is curated and supersede-only. Layer 2 is append-as-you-go raw capture.
Layer 3 is the always-loaded core; keep it lean.

## PARA folders (Layer 1)

Tiago Forte's PARA method organizes the knowledge graph:

- **Projects** - active work with a goal or deadline. Archive when complete.
- **Areas** - ongoing responsibilities (people, companies, systems). No end date.
- **Resources** - reference material and topics of interest.
- **Archives** - inactive items moved out of the other three.

Each entity gets a folder with two tiers: `summary.md` (quick context, load
first) and `items.yaml` (atomic facts, load on demand).

## Rules every mode honors

- **Save durable facts immediately.** A fact in a file beats a fact in context.
- **Supersede, never delete.** Mark the old fact `status: superseded` and add
  `superseded_by`. History is evidence; do not destroy it.
- **Create an entity when** it is mentioned three or more times, has a direct
  relationship to the operator, or is a significant project or company.
  Otherwise it stays a line in a daily note.
- **Keep the core lean.** The always-loaded file holds only what is needed every
  session. Everything else is a depth note with a one-line pointer from the core.
- **Write it down, no mental notes.** Memory does not survive a restart; files do.
