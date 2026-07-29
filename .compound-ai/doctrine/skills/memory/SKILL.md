# Skill: memory
# Compound AI Operating Standards
# Authors: Cameron Sutcliff, Joshua Sutcliff (joshuadsutcliff)
# Source: github.com/cameronpsutcliff/compound-ai | License: Apache 2.0

## What this skill does

One memory skill with five meta-modes covering the full session-memory
lifecycle: capture, compress, preserve, resume, recall. It folds the
session-lifecycle commands (compress, preserve, resume) with the file-based
knowledge model (capture, recall). Core rule: memory lives in files. The
session is stateless; the filesystem is durable. Mental notes do not survive a
restart, so nothing important stays in context only.

## Triggers (one set, sub-routed by intent)

"remember this", "save this", "write it down", "note this" (capture);
"save the session", "session log", "compress this session", "close out the session" (compress);
"preserve this", "promote this pattern", "save this lesson", "this should be a standard", "make this reusable" (preserve);
"resume", "orient me", "load context", "what should I read", "start session", "catch me up" (resume);
"recall", "what do we know about", "what happened with", "search memory", "find past context" (recall).

## Sub-routing (load only the matching reference)

| Intent | Mode | Load |
|---|---|---|
| Write a durable fact or event as it happens | capture | `reference/capture.md` |
| Synthesize the session into a searchable log | compress | `reference/compress.md` |
| Route a lasting decision or pattern to its home | preserve | `reference/preserve.md` |
| Orient at session start; load recent logs + the right tier | resume | `reference/resume.md` |
| Retrieve prior context by search | recall | `reference/recall.md` |

The shared memory model (three layers, PARA folders, supersede-not-delete) is in
`reference/memory-model.md`. Read it once per project; every mode assumes it.

## Procedure

1. Classify the request into one of the five modes using the table above.
2. Load that mode's reference, plus `reference/memory-model.md` if the layout is
   not yet known for this project.
3. Execute the mode's steps. Every mode writes to files, never to mental notes.
4. Keep the always-loaded core lean: depth goes to a note, the core gets a
   one-line pointer. If the core grows past its budget, trim an equal amount.

## Outputs

- capture: a fact in the knowledge layer or a line in today's daily note.
- compress: an append-only session log with valid frontmatter.
- preserve: a routed decision (core edit, depth note + pointer, or supersession).
- resume: a tight orientation delta (active projects, recent work, pending, blockers).
- recall: the retrieved context with its source file cited.

## Checks

- The artifact exists on disk with valid frontmatter (capture, compress, preserve).
- resume presented a delta, not a full briefing, in roughly 20 lines or fewer.
- recall cited the source file(s) it retrieved from; no recall from memory alone.
- Session logs are append-only: a new file per session, never an in-place edit.

## References
- `reference/memory-model.md` - three layers, PARA rules, supersede rule (shared)
- `reference/capture.md` - daily notes, atomic facts, the write-it-down rule
- `reference/compress.md` - the session-log template and its invariants
- `reference/preserve.md` - routing a durable decision; the ACE promotion format
- `reference/resume.md` - session-start orientation and tier-loading discipline
- `reference/recall.md` - search strategy (semantic, keyword, vector)
- Field Guide Chapters 7-10: Operating Contract, Tiered Loading, Session Handoffs, Greater Vault
