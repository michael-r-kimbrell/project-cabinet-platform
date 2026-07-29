# context-loader (retired)
# Folded into the unified `memory` skill in the skill-merge. No independent session-routable skill.

Session-start orientation and tier-loading are now the `resume` mode of `memory`.
Procedure: `doctrine/skills/memory/reference/resume.md`

Triggers ("load context", "what should I read", "start session", "orient me")
now route to `memory`.

The tier-loading discipline itself lives in `doctrine/tiers/` and is unchanged.
