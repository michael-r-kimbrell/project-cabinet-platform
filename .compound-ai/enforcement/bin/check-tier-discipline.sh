#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_STANDARDS_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

resolve_standards_dir() {
  local input="${1:-$DEFAULT_STANDARDS_DIR}"
  if [ -f "$input/enforcement-rules.yaml" ]; then
    cd "$input" && pwd
    return
  fi
  if [ -f "$input/operating-standards/enforcement-rules.yaml" ]; then
    cd "$input/operating-standards" && pwd
    return
  fi
  echo "check-tier-discipline: cannot find operating-standards from: $input" >&2
  exit 2
}

STANDARDS_DIR="$(resolve_standards_dir "${1:-}")"
RULES="$STANDARDS_DIR/enforcement-rules.yaml"

from_path="$(awk '
  /rule_id:[[:space:]]*tier-discipline/ { in_rule=1 }
  in_rule && /from:/ {
    value=$0
    sub(/^.*from:[[:space:]]*/, "", value)
    gsub(/"/, "", value)
    print value
    exit
  }
' "$RULES")"
from_path="${from_path:-doctrine/tiers/tier0.md}"

target="$STANDARDS_DIR/$from_path"
if [ ! -f "$target" ]; then
  printf 'FAIL tier-discipline: source file missing: %s\n' "$from_path" >&2
  exit 1
fi

# Tier-1 infrastructure skills may appear in tier0 paths. Tier-2 skills and
# Tier-3 shells must not be referenced by path from always-load context.
TIER23_PATTERN='parallel-lens-synthesis|consequence-simulation|cross-domain-translation|convergence-detection|detached-judgment|simulation-to-action-bridge|nod-protocol|ultra-think|pressure-test|code-audit|autoresearch|skill-creator|viz|stakeholder-mapping|loop-engineering|slide-shell|scroll-shell|mission-control|course-shell'

failures=0
while IFS=: read -r line_no line_text; do
  [ -n "$line_no" ] || continue
  printf 'FAIL tier-discipline: %s:%s references forbidden path: %s\n' "$from_path" "$line_no" "$line_text" >&2
  failures=$((failures + 1))
done <<EOF
$(grep -nE "tier-2-capabilities/|doctrine/skills/(${TIER23_PATTERN})/" "$target" || true)
EOF

if [ "$failures" -gt 0 ]; then
  exit 1
fi

printf 'PASS tier-discipline: %s has no tier-2 or tier-3 path references\n' "$from_path"
