#!/usr/bin/env bash
set -euo pipefail

NOTE="${1:-Session completed. Update STATE.md and session-log.md before closing.}"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M %Z')"

{
  echo ""
  echo "## $TIMESTAMP"
  echo ""
  echo "$NOTE"
} >> STATE.md

echo "Appended session note to STATE.md"
