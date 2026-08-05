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
  echo "check-line-caps: cannot find operating-standards from: $input" >&2
  exit 2
}

STANDARDS_DIR="$(resolve_standards_dir "${1:-}")"
RULES="$STANDARDS_DIR/enforcement-rules.yaml"

max_lines="$(awk '
  /rule_id:[[:space:]]*line-cap/ { in_rule=1 }
  in_rule && /max_lines:/ { print $2; exit }
' "$RULES")"
max_lines="${max_lines:-100}"

tmp_files="$(mktemp)"
tmp_seen="$(mktemp)"
trap 'rm -f "$tmp_files" "$tmp_seen"' EXIT

find "$STANDARDS_DIR" -type f \( -name 'AGENT.md' -o -name 'AGENTS.md' -o -name 'SKILL.md' \) -print > "$tmp_files"

if [ -d "$STANDARDS_DIR/routers" ]; then
  find "$STANDARDS_DIR/routers" -type f -name '*.md' -print >> "$tmp_files"
fi

sort -u "$tmp_files" > "$tmp_seen"

failures=0
while IFS= read -r file; do
  [ -f "$file" ] || continue
  rel="${file#$STANDARDS_DIR/}"
  case "$rel" in
    docs/*|templates/*|examples/*|reference/*|enforcement/tests/fixtures/*|*/templates/*|*/examples/*|*/reference/*)
      continue
      ;;
  esac

  lines="$(wc -l < "$file" | tr -d ' ')"
  if [ "$lines" -gt "$max_lines" ]; then
    printf 'FAIL line-cap: %s has %s lines, max %s\n' "$rel" "$lines" "$max_lines" >&2
    failures=$((failures + 1))
  fi
done < "$tmp_seen"

if [ "$failures" -gt 0 ]; then
  exit 1
fi

printf 'PASS line-cap: pointer files are within %s lines\n' "$max_lines"
