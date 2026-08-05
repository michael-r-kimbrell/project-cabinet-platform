#!/usr/bin/env bash
# simulate-fresh-clone.sh - fresh-adopter simulation for a derived kit tree.
#
# Copies the derived tree into a clean temp directory (modeling a fresh clone on a
# bare laptop), then runs enforcement/bin/check-kit.sh. Used at derive time and in CI.
#
# Usage:
#   simulate-fresh-clone.sh [path-to-derived-tree]
#
# Default tree: operating-standards root (two levels above this script).
# Exit 0 when check-kit.sh passes on the fresh copy. Exit 1 on gate failure.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="${1:-$(cd "$SCRIPT_DIR/../.." && pwd)}"

if [ ! -f "$SOURCE/enforcement-rules.yaml" ]; then
  echo "simulate-fresh-clone: not a kit root (missing enforcement-rules.yaml): $SOURCE" >&2
  exit 2
fi

if [ ! -x "$SOURCE/enforcement/bin/check-kit.sh" ]; then
  echo "simulate-fresh-clone: missing enforcement/bin/check-kit.sh under $SOURCE" >&2
  exit 2
fi

TMPROOT="$(mktemp -d "${TMPDIR:-/tmp}/compound-ai-fresh-clone.XXXXXX")"
trap 'rm -rf "$TMPROOT"' EXIT

CLONE="$TMPROOT/kit"
mkdir -p "$CLONE"

echo "simulate-fresh-clone: copying $SOURCE -> $CLONE"
(
  cd "$SOURCE"
  find . -type f ! -path './.git/*' -print
) | while IFS= read -r relpath; do
  relpath="${relpath#./}"
  [ -z "$relpath" ] && continue
  mkdir -p "$CLONE/$(dirname "$relpath")"
  cp -p "$SOURCE/$relpath" "$CLONE/$relpath"
done

echo "simulate-fresh-clone: running check-kit.sh on fresh copy"
if "$CLONE/enforcement/bin/check-kit.sh" "$CLONE"; then
  echo "PASS simulate-fresh-clone: derived tree passes all gates on fresh copy"
  exit 0
fi

echo "FAIL simulate-fresh-clone: check-kit.sh failed on fresh copy" >&2
exit 1
