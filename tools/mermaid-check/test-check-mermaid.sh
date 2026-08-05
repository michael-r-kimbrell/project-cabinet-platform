#!/usr/bin/env bash
# Self-test for check-mermaid.mjs: proves the gate rejects the two defects
# that shipped in this repo's first Gantt chart, and accepts a good one.
#
# Run: bash tools/mermaid-check/test-check-mermaid.sh

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK="$HERE/check-mermaid.mjs"
FIXTURES="$HERE/fixtures"

PASS=0
FAIL=0

expect() {
  local want="$1" name="$2" file="$3"
  node "$CHECK" "$file" >/dev/null 2>&1
  local rc=$?
  local got="reject"
  [[ $rc -eq 0 ]] && got="accept"
  if [[ "$got" == "$want" ]]; then
    PASS=$((PASS + 1))
    printf '  ok    %s\n' "$name"
  else
    FAIL=$((FAIL + 1))
    printf '  FAIL  %s (expected %s, got %s)\n' "$name" "$want" "$got"
  fi
}

echo "check-mermaid gate self-test"
expect reject "colon in a gantt task name is rejected" "$FIXTURES/colon-in-task-name.md"
expect reject "task name colliding with the call keyword is rejected" "$FIXTURES/call-keyword-collision.md"
expect accept "a well-formed chart is accepted" "$FIXTURES/valid.md"

echo
echo "$PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
