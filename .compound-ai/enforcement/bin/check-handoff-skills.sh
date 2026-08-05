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
  echo "check-handoff-skills: cannot find operating-standards from: $input" >&2
  exit 2
}

STANDARDS_DIR="$(resolve_standards_dir "${1:-}")"
REGISTRY="$STANDARDS_DIR/doctrine/conventions/trigger-registry.yaml"
HANDOFF="$STANDARDS_DIR/HANDOFF.md"

if [ ! -f "$REGISTRY" ]; then
  printf 'FAIL handoff-skills: registry missing: %s\n' "${REGISTRY#$STANDARDS_DIR/}" >&2
  exit 1
fi

if [ ! -f "$HANDOFF" ]; then
  printf 'FAIL handoff-skills: HANDOFF.md missing\n' >&2
  exit 1
fi

python3 - "$STANDARDS_DIR" "$REGISTRY" "$HANDOFF" <<'PY'
from __future__ import annotations

import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
registry_path = Path(sys.argv[2])
handoff_path = Path(sys.argv[3])


def clean_value(value: str) -> str:
    value = value.split("#", 1)[0].strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
        value = value[1:-1]
    return value


entries: list[dict[str, str]] = []
current: dict[str, str] | None = None
for raw_line in registry_path.read_text(encoding="utf-8").splitlines():
    if re.match(r"\s*-\s+skill:", raw_line):
        if current:
            entries.append(current)
        current = {"skill": clean_value(raw_line.split("skill:", 1)[1])}
        continue
    if current is None:
        continue
    for key in ("tier", "mode", "pointer"):
        marker = f"{key}:"
        if re.match(rf"\s*{key}:", raw_line):
            current[key] = clean_value(raw_line.split(marker, 1)[1])
if current:
    entries.append(current)

expected: dict[str, str] = {}
pointer_failures: list[str] = []
for entry in entries:
    if entry.get("tier") != "1":
        continue
    if entry.get("mode") == "retired":
        continue
    skill = entry.get("skill", "")
    pointer = entry.get("pointer", "")
    if not skill:
        continue
    expected[skill] = pointer
    if pointer and not (root / pointer).is_file():
        pointer_failures.append(f"{skill} points to missing file: {pointer}")

handoff_text = handoff_path.read_text(encoding="utf-8")
section_match = re.search(r"Tier 1:.*?(?=\nTier 2:)", handoff_text, re.S)
if not section_match:
    print("FAIL handoff-skills: Tier 1 section not found in HANDOFF.md", file=sys.stderr)
    raise SystemExit(1)

found: list[str] = []
for line in section_match.group(0).splitlines():
    match = re.search(r"✓\s+([A-Za-z0-9][A-Za-z0-9-]*)", line)
    if match:
        found.append(match.group(1))

found_set = set(found)
expected_set = set(expected)
missing = sorted(expected_set - found_set)
unknown = sorted(found_set - expected_set)
duplicates = sorted({skill for skill in found if found.count(skill) > 1})

failures = []
failures.extend(pointer_failures)
failures.extend(f"missing live Tier-1 skill in HANDOFF.md: {skill}" for skill in missing)
failures.extend(f"HANDOFF.md lists non-live Tier-1 skill: {skill}" for skill in unknown)
failures.extend(f"HANDOFF.md duplicates Tier-1 skill: {skill}" for skill in duplicates)

if failures:
    for failure in failures:
        print(f"FAIL handoff-skills: {failure}", file=sys.stderr)
    raise SystemExit(1)

print(f"PASS handoff-skills: HANDOFF.md lists {len(found)} live Tier-1 skills")
PY
