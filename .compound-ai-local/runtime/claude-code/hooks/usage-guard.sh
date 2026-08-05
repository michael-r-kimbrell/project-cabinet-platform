#!/usr/bin/env bash
# Spawn-ceiling hook: caps subagent (Agent tool) spawns per day so one
# task can't quietly burn a whole 5-hour usage window on fan-out.
#
# Runs in two modes, both wired in .claude/settings.json on the Agent matcher:
#   check  (PreToolUse)  - reads the counter, blocks at the ceiling, never writes
#   count  (PostToolUse) - records a spawn that actually happened
#
# The split is deliberate. A PreToolUse hook cannot see whether a *different*
# PreToolUse hook (the vendored usage-guard, say) rejected the same call, so
# counting at check time charged the ceiling for spawns that never happened.
# PostToolUse only fires once a call has cleared every gate and run.
#
# Counter file lives under .claude/ (gitignored) and resets when removed --
# Claude Code doesn't expose a clean "session id" to shell hooks portably, so
# this counts per-day as a pragmatic proxy. Tighten SPAWN_CEILING or the reset
# logic to taste.

set -euo pipefail

MODE="${1:-check}"
SPAWN_CEILING="${SPAWN_CEILING:-8}"
COUNTER_DIR="${WORKSPACE_ROOT:-$HOME/workspace}/.claude/usage-guard"
COUNTER_FILE="$COUNTER_DIR/spawn-count-$(date +%Y%m%d)"

mkdir -p "$COUNTER_DIR"
[[ -f "$COUNTER_FILE" ]] || echo 0 > "$COUNTER_FILE"

COUNT="$(cat "$COUNTER_FILE")"

case "$MODE" in
  check)
    # Refuse the spawn that would exceed the ceiling, without recording it.
    if (( COUNT >= SPAWN_CEILING )); then
      echo "usage-guard: subagent spawn #$((COUNT + 1)) exceeds today's ceiling of $SPAWN_CEILING. This is almost always a sign the task should be broken down manually rather than fanned out further. Raise SPAWN_CEILING if this is a deliberate large job." >&2
      exit 2
    fi
    ;;
  count)
    echo "$((COUNT + 1))" > "$COUNTER_FILE"
    ;;
  *)
    echo "usage-guard: unknown mode '$MODE'; expected 'check' or 'count'. Failing open." >&2
    exit 0
    ;;
esac

exit 0
