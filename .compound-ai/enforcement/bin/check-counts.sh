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
  echo "check-counts: cannot find operating-standards from: $input" >&2
  exit 2
}

STANDARDS_DIR="$(resolve_standards_dir "${1:-}")"
RULES="$STANDARDS_DIR/enforcement-rules.yaml"

index_file="$(awk '
  /rule_id:[[:space:]]*count/ { in_rule=1 }
  in_rule && /index_file:/ {
    value=$0
    sub(/^.*index_file:[[:space:]]*/, "", value)
    gsub(/"/, "", value)
    print value
    exit
  }
' "$RULES")"
registry_file="$(awk '
  /rule_id:[[:space:]]*count/ { in_rule=1 }
  in_rule && /registry_file:/ {
    value=$0
    sub(/^.*registry_file:[[:space:]]*/, "", value)
    gsub(/"/, "", value)
    print value
    exit
  }
' "$RULES")"

index_file="${index_file:-_skills-index.md}"
registry_file="${registry_file:-doctrine/conventions/trigger-registry.yaml}"
index_path="$STANDARDS_DIR/${index_file#operating-standards/}"
registry_path="$STANDARDS_DIR/${registry_file#operating-standards/}"

if [ ! -f "$index_path" ]; then
  printf 'FAIL counts: index file missing: %s\n' "${index_path#$STANDARDS_DIR/}" >&2
  exit 1
fi
if [ ! -f "$registry_path" ]; then
  printf 'FAIL counts: registry file missing: %s\n' "${registry_path#$STANDARDS_DIR/}" >&2
  exit 1
fi

total_skill_count="$(find "$STANDARDS_DIR" -type f -name 'SKILL.md' | wc -l | tr -d ' ')"
retired_count="$(awk '
  function finish() {
    if (skill != "" && mode == "retired") {
      count++
    }
  }
  /^[[:space:]]*- skill:/ {
    finish()
    skill=$0
    sub(/^.*skill:[[:space:]]*/, "", skill)
    gsub(/"/, "", skill)
    mode="active"
    next
  }
  /^[[:space:]]*mode:/ {
    mode=$0
    sub(/^.*mode:[[:space:]]*/, "", mode)
    gsub(/"/, "", mode)
  }
  END {
    finish()
    print count + 0
  }
' "$registry_path")"
actual_count=$((total_skill_count - retired_count))
registry_count="$(awk '
  function finish() {
    if (skill != "" && mode != "retired") {
      count++
    }
  }
  /^[[:space:]]*- skill:/ {
    finish()
    skill=$0
    sub(/^.*skill:[[:space:]]*/, "", skill)
    gsub(/"/, "", skill)
    mode="active"
    next
  }
  /^[[:space:]]*mode:/ {
    mode=$0
    sub(/^.*mode:[[:space:]]*/, "", mode)
    gsub(/"/, "", mode)
  }
  END {
    finish()
    print count + 0
  }
' "$registry_path")"
index_count="$(awk '
  /^---[[:space:]]*$/ {
    sep++
    next
  }
  sep == 1 && /`[^`]*SKILL[.]md`/ {
    count++
  }
  END {
    if (count > 0) {
      print count
    }
  }
' "$index_path")"

if [ -z "$index_count" ]; then
  index_count="$(awk '
  /Total skills:/ {
    line=$0
    gsub(/[^0-9]/, " ", line)
    n=split(line, nums, /[[:space:]]+/)
    for (i=1; i<=n; i++) {
      if (nums[i] != "") {
        print nums[i]
        exit
      }
    }
  }
  ' "$index_path")"
fi

failures=0
if [ -z "$index_count" ]; then
  printf 'FAIL counts: no Total skills value found in %s\n' "${index_path#$STANDARDS_DIR/}" >&2
  failures=$((failures + 1))
elif [ "$actual_count" -ne "$index_count" ]; then
  printf 'FAIL counts: derived SKILL.md count is %s, index records %s\n' "$actual_count" "$index_count" >&2
  failures=$((failures + 1))
fi

if [ "$actual_count" -ne "$registry_count" ]; then
  printf 'FAIL counts: derived SKILL.md count is %s, registry has %s entries\n' "$actual_count" "$registry_count" >&2
  failures=$((failures + 1))
fi

if [ "$failures" -gt 0 ]; then
  exit 1
fi

printf 'PASS counts: derived active skill count is %s (%s retired stubs)\n' "$actual_count" "$retired_count"
