# Mode: resume

Orient at session start. Load the right context tier plus recent session history,
then present a tight delta. Run before doing any work. Paths are illustrative.

## Arguments (optional)

- No args: load the last 3 session logs.
- Number only (`resume 10`): load the last 10 logs.
- Search term (`resume auth`): load last 3 logs + search logs for "auth".
- Both (`resume 5 auth`): load last 5 logs + search for "auth".

Parse for a count (first numeric token, default 3) and a search term (the rest).

## Step 1 - Orientation and the right tier

Read the orientation note (the who / what / priorities map). Always required.
Then load only the context tier the task needs; do not bulk-load:

| Task shape | Load |
|---|---|
| Mechanical fix, one file | tier 0 only (the always-load contract) |
| Subsystem work | tier 0 + the relevant tier-1 subsystem slice |
| Cross-subsystem or architecture | tier 0 + current state + the relevant tier-2 section |
| Ambiguous | tier 0 + current state, then query the knowledge index |

Never directly load the full codebase or the full session archive; use search
(recall mode) instead. Rough cost: tier 0 is a few hundred tokens; tier 0 + 1 is
1 to 2k; adding a tier-2 section is 3 to 6k.

## Step 2 - Recent session logs

Find the N most recent logs (filenames sort chronologically). For each, read only
the top section through `## Pending Tasks`. Do NOT read `## Raw Session Log`
unless investigating a specific thread. The Quick Reference plus Decisions plus
Learnings plus Pending is the low-token scan surface.

## Step 3 - Search (if a term was given)

Search logs for content matching the term. Read the Quick Reference of any match
not already loaded.

## Step 4 - Present the orientation

Give a concise summary (roughly 10 to 20 lines):

1. Active projects and current status.
2. What was accomplished recently (last 1 to 2 logs).
3. Pending tasks: a consolidated, deduplicated `[ ]` list, most recent first.
4. Blockers or time-sensitive items (renewals, deadlines, carry-forward blocks).

## Invariants

- Always read the orientation note first.
- Never read a Raw Session Log section unless specifically investigating.
- The always-loaded core is already in context; do not re-read it.
- Skip a corrupt or Quick-Reference-less log and note the skip.
- Do not ask what to do; present the delta and proceed.
