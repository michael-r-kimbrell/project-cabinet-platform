# Adopt this kit into a project — instructions for the agent

Paste this whole file to Claude (or another agent) after copying the kit
in, per `INSTALL.md`.

## Steps

1. Read `CLAUDE.md`, `doctrine/*.md`, and `capabilities/*.md` in this kit.
   Confirm you understand the workspace boundary, the five core habits, and
   the goal-loop before touching anything else.
2. Check whether the project already has a root `CLAUDE.md`. If not, copy
   this kit's `CLAUDE.md` to the project root. If one exists, merge: keep
   the project's existing content and add this kit's workspace-boundary
   and core-habits sections, don't overwrite silently — show the merge
   before applying it.
3. Merge `runtime/claude-code/settings.json`'s `hooks` block into the
   project's `.claude/settings.json` (create it if it doesn't exist).
4. Make the hook scripts executable and confirm `jq` is available (see
   `runtime/claude-code/NOTES.md`).
5. Create `.env` (if it doesn't exist) and confirm `.gitignore` excludes
   it.
6. Run `enforcement/bin/check-kit.sh` and report the result honestly —
   including any failing checks, not just the passing ones.
7. Report back: what was copied, what was merged vs. overwritten, and what
   the integrity check found. This report is itself a goal-loop
   verification step — don't skip it.

## What this does not do automatically

It does not create `data/regions/`, `data/suppliers/`, or
`data/name-translation/` — those get populated as real regions and
suppliers are added, per `doctrine/CONVENTIONS.md`. Don't scaffold empty
placeholder data files just to look complete.
