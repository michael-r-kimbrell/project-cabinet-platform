#!/usr/bin/env bash
# check-benchmark-figures.sh
#
# Derived-not-typed guard for the session-start benchmark. The exact file
# counts, token estimates, and ratio live ONLY in the generated
# proof/session-start-benchmark/results.md (written by measure.sh and
# regenerated per edition by derive.sh). The headline and architecture docs must
# reference that file, never hand-type the figures, because hand-typed numbers
# drift the moment the tree changes.
#
# This gate fails if a scoped doc contains a benchmark-shaped figure: a
# comma-grouped token/byte count (NNN,NNN) or a precise decimal ratio (NN.Nx).
# Round order-of-magnitude labels (e.g. "two orders of magnitude") are fine.
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
  echo "check-benchmark-figures: cannot find operating-standards from: $input" >&2
  exit 2
}

STANDARDS_DIR="$(resolve_standards_dir "${1:-}")"

# Docs that discuss the benchmark and must reference results.md by pointer.
SCOPED_DOCS="README.md EXECUTIVE.md STANDARD.md docs/ARCHITECTURE.md _map.md AGENT.md"

# Benchmark-shaped figures: comma-grouped 6-digit counts, a precise decimal
# ratio (e.g. 156.2x), or a 3+ digit integer multiplier (e.g. 158x). Common
# small multipliers (2x, 10x, 50x) are left alone; a 3-digit Nx in a headline
# doc is a benchmark ceiling figure and must come from the generated results.md.
PATTERN='[0-9]{3},[0-9]{3}|[0-9]+\.[0-9]+x|[0-9]{3,}x'

failed=0
for rel in $SCOPED_DOCS; do
  f="$STANDARDS_DIR/$rel"
  [ -f "$f" ] || continue
  hits="$(grep -nE "$PATTERN" "$f" 2>/dev/null || true)"
  if [ -n "$hits" ]; then
    failed=1
    printf 'FAIL benchmark-figures: hand-typed benchmark figure in %s (reference proof/session-start-benchmark/results.md, do not hand-type):\n%s\n' "$rel" "$hits" >&2
  fi
done

if [ "$failed" -ne 0 ]; then
  exit 1
fi

printf 'PASS benchmark-figures: headline docs reference the generated benchmark, no hand-typed figures\n'
