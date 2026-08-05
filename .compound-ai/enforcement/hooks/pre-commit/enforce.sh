#!/usr/bin/env bash
set -euo pipefail

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STANDARDS_DIR="$(cd "$HOOK_DIR/../../.." && pwd)"

cd "$STANDARDS_DIR"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -x "$HOOK_DIR/no-em-dashes.sh" ]; then
  "$HOOK_DIR/no-em-dashes.sh"
elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "pre-commit enforce: missing executable hook: enforcement/hooks/pre-commit/no-em-dashes.sh" >&2
  exit 1
else
  echo "pre-commit enforce: no Git worktree detected, skipping staged no-em-dash scan" >&2
fi

./enforcement/bin/check-kit.sh
