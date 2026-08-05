#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_ARG="${1:-}"

checks="
check-line-caps.sh
check-tier-discipline.sh
check-portability.sh
check-counts.sh
check-registry-coherence.sh
check-handoff-skills.sh
check-benchmark-figures.sh
check-runtime-wiring.sh
"

failures=0
for check in $checks; do
  printf '==> %s\n' "$check"
  if [ -n "$ROOT_ARG" ]; then
    "$SCRIPT_DIR/$check" "$ROOT_ARG"
  else
    "$SCRIPT_DIR/$check"
  fi
  rc=$?
  if [ "$rc" -ne 0 ]; then
    printf 'FAIL check-kit: %s exited %s\n' "$check" "$rc" >&2
    failures=$((failures + 1))
  fi
done

if [ "$failures" -gt 0 ]; then
  printf 'FAIL check-kit: %s gate(s) failed\n' "$failures" >&2
  exit 1
fi

printf 'PASS check-kit: all gates passed\n'
