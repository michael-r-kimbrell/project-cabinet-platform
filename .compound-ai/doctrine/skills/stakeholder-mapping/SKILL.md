# Skill: stakeholder-mapping
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Map stakeholders for any initiative. Identify each person's influence and interest, classify them on the influence-interest grid, and produce an engagement strategy per quadrant. Standard PMI/PMBOK stakeholder management pattern, adapted for AI-assisted prep work.

## Triggers

"stakeholder map", "stakeholder mapping", "influence interest grid", "who do we need to manage", "stakeholder analysis", "engagement strategy", "power interest matrix", "who has influence over this"

## Protocol summary

Six-step procedure. Full procedure in `reference/protocol.md`.

1. **Collect**: gather stakeholder info from meetings, org chart, LinkedIn, observed dynamics
2. **Map relationships**: name, title, reports-to, influence, interest, communication preference, what they need
3. **Influence-interest grid**: place each stakeholder in one of four quadrants (Manage Closely, Keep Satisfied, Keep Informed, Monitor)
4. **"What does their boss care about" framework**: for high-influence stakeholders, surface upstream concerns
5. **Engagement strategy**: cadence, format, key messages, relationship risks per top-quadrant stakeholder
6. **Output**: structured markdown with table, grid visualization, engagement strategy cards

## The four quadrants

|  | High Interest | Low Interest |
|---|---|---|
| **High Influence** | MANAGE CLOSELY | KEEP SATISFIED |
| **Low Influence** | KEEP INFORMED | MONITOR |

## Pair with

- `cross-domain-translation` -- re-encode the same message for different stakeholders without losing fidelity
- `pressure-test` -- stress-test the engagement strategy before committing to a cadence

## Data sources (optional upstream)

For LinkedIn-based organizational mapping, [linkedin-osint-toolkit](https://github.com/michaelelizarov/linkedin-osint-toolkit) (MIT, by Michael Elizarov) provides employee scraping, role classification, and org-chart generation. The toolkit output (org chart JSON) slots directly into Step 1 above. Credit the original repo if you use it; this skill does not bundle the code.

## Source references

- Influence-interest grid: PMI/PMBOK standard stakeholder management
- Engagement quadrants (Manage Closely / Keep Satisfied / Keep Informed / Monitor): Mendelow's matrix
- "What does their boss care about" reframe: practitioner adaptation
