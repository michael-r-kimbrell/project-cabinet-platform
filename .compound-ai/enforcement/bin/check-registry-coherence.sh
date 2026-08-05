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
  echo "check-registry-coherence: cannot find operating-standards from: $input" >&2
  exit 2
}

STANDARDS_DIR="$(resolve_standards_dir "${1:-}")"
RULES="$STANDARDS_DIR/enforcement-rules.yaml"

registry_file="$(awk '
  /rule_id:[[:space:]]*registry-coherence/ { in_rule=1 }
  in_rule && /registry_file:/ {
    value=$0
    sub(/^.*registry_file:[[:space:]]*/, "", value)
    gsub(/"/, "", value)
    print value
    exit
  }
' "$RULES")"
registry_file="${registry_file:-doctrine/conventions/trigger-registry.yaml}"
registry_path="$STANDARDS_DIR/${registry_file#operating-standards/}"

if [ ! -f "$registry_path" ]; then
  printf 'FAIL registry-coherence: registry file missing: %s\n' "${registry_path#$STANDARDS_DIR/}" >&2
  exit 1
fi

tmp_registry="$(mktemp)"
tmp_actual="$(mktemp)"
trap 'rm -f "$tmp_registry" "$tmp_actual"' EXIT

awk '
  /^[[:space:]]*- skill:/ {
    skill=$0
    sub(/^.*skill:[[:space:]]*/, "", skill)
    gsub(/"/, "", skill)
  }
  /^[[:space:]]*pointer:/ {
    pointer=$0
    sub(/^.*pointer:[[:space:]]*/, "", pointer)
    gsub(/"/, "", pointer)
    print skill "\t" pointer
  }
' "$registry_path" > "$tmp_registry"

find "$STANDARDS_DIR" -type f -name 'SKILL.md' -print | sed "s#^$STANDARDS_DIR/##" | sort > "$tmp_actual"

failures=0
while IFS="$(printf '\t')" read -r skill pointer; do
  [ -n "$pointer" ] || continue
  if [ ! -f "$STANDARDS_DIR/$pointer" ]; then
    printf 'FAIL registry-coherence: %s points to missing file: %s\n' "$skill" "$pointer" >&2
    failures=$((failures + 1))
  fi
done < "$tmp_registry"

while IFS= read -r actual; do
  if ! grep -Fq "$(printf '\t')$actual" "$tmp_registry"; then
    printf 'FAIL registry-coherence: SKILL.md missing from registry: %s\n' "$actual" >&2
    failures=$((failures + 1))
  fi
done < "$tmp_actual"

duplicates="$(awk -F '\t' '{ print $2 }' "$tmp_registry" | sort | uniq -d)"
if [ -n "$duplicates" ]; then
  printf '%s\n' "$duplicates" | while IFS= read -r dup; do
    printf 'FAIL registry-coherence: duplicate registry pointer: %s\n' "$dup" >&2
  done
  failures=$((failures + 1))
fi

if [ "$failures" -gt 0 ]; then
  exit 1
fi

printf 'PASS registry-coherence: registry pointers resolve and match SKILL.md files\n'
