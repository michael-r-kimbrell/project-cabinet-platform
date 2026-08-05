#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET_DIR="${1:-}"

if [[ -z "$TARGET_DIR" ]]; then
  echo "Usage: reference-impl/scripts/new-project.sh /path/to/project"
  exit 2
fi

mkdir -p "$TARGET_DIR"

copy_if_missing() {
  local src="$1"
  local dest="$2"
  if [[ -e "$dest" ]]; then
    echo "skip existing: $dest"
  else
    cp -R "$src" "$dest"
    echo "created: $dest"
  fi
}

copy_if_missing "$SOURCE_DIR/AGENT.md" "$TARGET_DIR/AGENT.md"
copy_if_missing "$SOURCE_DIR/Project.md" "$TARGET_DIR/Project.md"
copy_if_missing "$SOURCE_DIR/STATE.md" "$TARGET_DIR/STATE.md"
copy_if_missing "$SOURCE_DIR/session-log.md" "$TARGET_DIR/session-log.md"
copy_if_missing "$SOURCE_DIR/BACKLOG.md" "$TARGET_DIR/BACKLOG.md"
copy_if_missing "$SOURCE_DIR/_map.md" "$TARGET_DIR/_map.md"
copy_if_missing "$SOURCE_DIR/_skills-index.md" "$TARGET_DIR/_skills-index.md"
copy_if_missing "$SOURCE_DIR/context" "$TARGET_DIR/context"
copy_if_missing "$SOURCE_DIR/checklists" "$TARGET_DIR/checklists"

echo "Project scaffold ready: $TARGET_DIR"
echo "Next: fill AGENT.md, Project.md, and STATE.md."
