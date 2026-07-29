#!/usr/bin/env bash
# Measures the token-cost gap between "tiered load" (CLAUDE.md only, Tier 0)
# and "full-resident load" (the whole kit read into context every session).
# Pure shell, no API call, reproducible anywhere. Token counts are a
# character-count estimate (bytes / 4) — order-of-magnitude, not exact,
# but the ratio is estimator-independent since both sides use the same
# divisor.
#
# Run from the repo root: bash .compound-ai/proof/session-start-benchmark/measure.sh

set -euo pipefail
KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

bytes_of() { cat "$@" 2>/dev/null | wc -c; }

TIER0_BYTES=$(bytes_of "$KIT_DIR/../CLAUDE.md" 2>/dev/null || bytes_of "$KIT_DIR/CLAUDE.md")
FULL_BYTES=$(find "$KIT_DIR" -name '*.md' -o -name '*.yaml' -o -name '*.sh' -o -name '*.json' | xargs cat 2>/dev/null | wc -c)

TIER0_TOKENS=$(( TIER0_BYTES / 4 ))
FULL_TOKENS=$(( FULL_BYTES / 4 ))

RATIO="n/a"
if [[ "$TIER0_TOKENS" -gt 0 ]]; then
  RATIO=$(awk "BEGIN { printf \"%.1f\", $FULL_TOKENS / $TIER0_TOKENS }")
fi

cat <<EOF
== session-start benchmark ==
Tier 0 (CLAUDE.md only):       ~${TIER0_TOKENS} tokens  (${TIER0_BYTES} bytes)
Full-resident (entire kit):    ~${FULL_TOKENS} tokens  (${FULL_BYTES} bytes)
Ratio (full / tier0):          ${RATIO}x

This is what a session pays every time if it re-reads the whole kit
instead of loading Tier 0 and pulling Tier 1 files on demand. Re-run after
adding doctrine/capability files to see how the gap moves — it should
grow, not shrink, as the kit gets more useful, which is exactly why
tiering matters more over time, not less.
EOF
