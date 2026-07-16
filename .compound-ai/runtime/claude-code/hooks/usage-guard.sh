#!/usr/bin/env bash
# PreToolUse hook: caps subagent (Task tool) spawns per session so one
# task can't quietly burn a whole 5-hour usage window on fan-out.
#
# Wired in runtime/claude-code/settings.json against the Task matcher.
# Counter file lives per-session under .claude/ (gitignored) and resets
# when the counter file is removed — Claude Code doesn't expose a clean
# "session id" to shell hooks portably, so this counts per-day as a
# pragmatic proxy. Tighten SPAWN_CEILING or the reset logic to taste.

set -euo pipefail

SPAWN_CEILING="${SPAWN_CEILING:-8}"
COUNTER_DIR="${WORKSPACE_ROOT:-$HOME/workspace}/.claude/usage-guard"
COUNTER_FILE="$COUNTER_DIR/spawn-count-$(date +%Y%m%d)"

mkdir -p "$COUNTER_DIR"
[[ -f "$COUNTER_FILE" ]] || echo 0 > "$COUNTER_FILE"

COUNT="$(cat "$COUNTER_FILE")"
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

if (( COUNT > SPAWN_CEILING )); then
  echo "usage-guard: subagent spawn #$COUNT exceeds today's ceiling of $SPAWN_CEILING. This is almost always a sign the task should be broken down manually rather than fanned out further. Raise SPAWN_CEILING if this is a deliberate large job." >&2
  exit 2
fi

exit 0
