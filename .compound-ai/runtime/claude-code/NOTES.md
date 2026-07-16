# Claude Code runtime notes

## How to wire it in

1. Copy or symlink this kit into your project as `.compound-ai/` (see
   `adoption/INSTALL.md`).
2. Merge the `hooks` block from `settings.json` into your project's
   `.claude/settings.json` (project-level, so it applies to everyone who
   opens this repo — commit it).
3. Make the hook scripts executable: `chmod +x .compound-ai/runtime/claude-code/hooks/*.sh`
4. Set `WORKSPACE_ROOT` in your shell environment to the real path, e.g.
   `C:\Users\<you>\workspace` (or its WSL/git-bash equivalent).
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
- Hooks run synchronously and block the tool call while they execute. Both
  scripts here are simple and fast; if you extend them, keep them under a
  second or two or Claude Code will feel sluggish.

## Other runtimes

Codex, Cursor, and anything else without an equivalent hook mechanism get
the same contract as a prompt prelude instead — see
`runtime/generic/PROMPT-PRELUDE.md`. That's advisory, not enforced: the
agent honors it because it's told to, not because anything blocks it
mechanically. State that gap to yourself honestly rather than assuming the
prelude gives you the same guarantee the hook does.
