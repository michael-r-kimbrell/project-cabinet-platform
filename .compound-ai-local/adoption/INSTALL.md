# Install walkthrough

## 1. Place the kit

Drop this whole folder into your project as `.compound-ai/`:

```
C:\Users\<you>\workspace\project-cabinet-platform\.compound-ai\   ← this kit
```

Or, if you want it available to every project in your workspace at once
(recommended, since the doctrine is general and only `CONVENTIONS.md`
mentions cabinets specifically), place it once at the workspace root and
reference it from each project's own `CLAUDE.md`.

## 2. Hand it to Claude

> "Read .compound-ai/adoption/ADOPT.md and follow it. Report back what you
> did and what enforcement/bin/check-kit.sh found — including anything
> that failed."

## 3. Smoke-test the hard-enforced parts by hand

The integrity check can confirm files exist; it can't confirm the hook
actually blocks something without a live session. So test it once,
directly:

1. Start a Claude Code session in the project.
2. Ask it to read a file outside `WORKSPACE_ROOT` (e.g. something in
   `Documents`).
3. Confirm the session reports being blocked, citing `workspace-guard`.
4. Ask it to read `.env`. Confirm the same.

If either isn't blocked, the hook isn't wired in correctly — check
`.claude/settings.json` has the merged `hooks` block and that
`WORKSPACE_ROOT` is actually set in the environment the session runs in.

## 4. Re-run the benchmark occasionally

`bash .compound-ai/proof/session-start-benchmark/measure.sh` — worth
running again after adding a few skills or doctrine files, just to see the
tiering payoff grow rather than assuming it does.
