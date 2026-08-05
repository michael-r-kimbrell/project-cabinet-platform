# Claude Code runtime notes

## How to wire it in

1. Copy or symlink this kit into your project as `.compound-ai/` (see
   `adoption/INSTALL.md`).
2. Merge the `hooks` block from `settings.json` into your project's
   `.claude/settings.json` (project-level, so it applies to everyone who
   opens this repo — commit it).
3. Make the hook scripts executable: `chmod +x .compound-ai/runtime/claude-code/hooks/*.sh`
4. Optionally set `WORKSPACE_ROOT` to the real path, e.g.
   `C:\Users\<you>\workspace` (or its WSL/git-bash equivalent). The guard
   resolves its boundary at run time, in this order:
   `WORKSPACE_ROOT` if that path exists on the current machine, then
   `CLAUDE_PROJECT_DIR` (Claude Code sets it for every hook), then the `cwd`
   in the hook payload, then the shell's own `$PWD`. Something always
   resolves, so the guard never silently switches off. Set `WORKSPACE_ROOT`
   only when the boundary should be wider than the project directory, such
   as a workspace folder holding several repos.
   Note the consequence: on a machine where `WORKSPACE_ROOT` does not exist
   (a Linux container, a colleague's checkout, CI) the boundary tightens to
   the project directory. Paths the harness provides outside the repo, such
   as a session scratchpad under `/tmp`, are blocked there. Write inside the
   repo instead, or widen `WORKSPACE_ROOT` for that host.
5. Requires `jq` on PATH. If it's not installed: `winget install jqlang.jq`
   on Windows, or ask Claude to install it.
6. Restart the session (or run `/hooks` inside Claude Code) to confirm both
   hooks show up.

## Known limits — stated honestly, not overclaimed

- The workspace-boundary hook matches on the `file_path` and `command`
  fields it's given. A sufficiently indirect command (e.g. a script that
  itself calls out to another path) can still evade a naive path check.
  This is a real gap, not a hypothetical one — treat the hook as a strong
  deterrent and a safety net, not a proof.
- The usage-guard counter is per-day, not per-session, because Claude Code
  doesn't expose a stable session id to shell hooks in a portable way.
  That's a proxy, not the real thing.
- `.env` blocking covers `Read`, `Edit`, `Write`, and `Bash` commands whose
  command string mentions `.env`. It does not cover every possible way a
  Bash one-liner could reference the file indirectly (e.g. through a
  variable built at runtime). Don't treat this as airtight secret
  isolation — it raises the bar, it doesn't guarantee it.
- The guard reads its own tripwires out of the raw command string, so any
  Bash command that so much as mentions the secrets dotfile, or contains the
  literal text of the rule 3 delete pattern, is blocked. That includes
  commands that would edit the guard or these notes. It is the rule working
  as written rather than a bug, but it means editing those lines through a
  shell needs the literal assembled at run time. The self-test in
  `enforcement/tests/test-workspace-guard.sh` does exactly that.
- Path comparison is textual, not canonical. The guard folds Windows and
  Git Bash spellings together, collapses `.` and `..` segments, and requires
  a real path separator at the boundary, so neither `workspace-other` nor
  `workspace/../../etc` passes as a child of `workspace`. It does not
  resolve symlinks, so a link inside the workspace pointing out of it is
  still not caught. Same caveat as above: strong deterrent, not a proof.
- Hooks run synchronously and block the tool call while they execute. Both
  scripts here are simple and fast; if you extend them, keep them under a
  second or two or Claude Code will feel sluggish.

## Open items — deferred from the 2026-07-29 session, not yet resolved

Parked deliberately, not forgotten. Nothing here is broken today; all three
are "we don't actually know" rather than "we know it's wrong."

1. **The kit's pre-commit hooks are not installed.** `.compound-ai/` ships
   `enforcement/hooks/pre-commit/enforce.sh` and `no-em-dashes.sh`, but
   `.git/hooks/` contains only the stock `.sample` files. None of the kit's
   enforcement gates ran on commit `edca3f7`, and none will run on the next
   one. Decide whether that's intentional (the gates are opt-in) or an
   incomplete install, then either wire them into `.git/hooks/` or write
   down that we're skipping them on purpose. Note the kit forbids em-dashes
   while this very file is full of them, so wiring the hook as-is will fail
   the repo until that's reconciled.

2. **Two CLAUDE.md files load every session with no defined precedence.**
   `.compound-ai-local/CLAUDE.md` (the cabinet-ops doctrine: workspace
   boundary, five core habits, project context) and `.compound-ai/CLAUDE.md`
   (a short pointer that redirects to `AGENT.md` and a `_tiers.md`
   inheritance model) both get auto-loaded. They describe different
   operating contracts. Each kit also carries its own
   `runtime/claude-code/settings.json`, neither of which is the file
   actually in effect — the live one is the project's `.claude/settings.json`.
   Nothing enforces which doctrine wins, so today it's whichever the model
   weighs more heavily. Pick one as canonical and make the other a pointer
   before the two drift.

3. **Cross-reference, already recorded in `edca3f7`:** the spawn-ceiling
   `check`/`count` split assumes PostToolUse does not fire when a PreToolUse
   hook blocks the call. That assumption was never verified end-to-end. The
   tell is cheap: if the daily counter ever advances on a delegation you
   watched get rejected, the assumption is wrong.

## Other runtimes

Codex, Cursor, and anything else without an equivalent hook mechanism get
the same contract as a prompt prelude instead — see
`runtime/generic/PROMPT-PRELUDE.md`. That's advisory, not enforced: the
agent honors it because it's told to, not because anything blocks it
mechanically. State that gap to yourself honestly rather than assuming the
prelude gives you the same guarantee the hook does.
