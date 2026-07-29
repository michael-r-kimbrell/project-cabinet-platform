#!/usr/bin/env bash
# Kit integrity self-test. Run from the repo root:
#   bash .compound-ai/enforcement/bin/check-kit.sh
# Exits non-zero on the first failed check so it's usable as a CI gate.

set -uo pipefail
KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REPO_ROOT="$(cd "$KIT_DIR/.." && pwd)"
FAIL=0

check() {
  local desc="$1"; shift
  if "$@"; then
    echo "  [ok] $desc"
  else
    echo "  [FAIL] $desc"
    FAIL=1
  fi
}

echo "== cabinet-ops kit integrity check =="

echo "-- doctrine files present"
for f in CONTEXT-TIERS.md SKILLS.md GOAL-LOOP.md CONVENTIONS.md; do
  check "doctrine/$f exists" test -f "$KIT_DIR/doctrine/$f"
done

echo "-- capability contracts present"
for f in adapter-contract.md usage-discipline.md session-routing.md goal-loop.md; do
  check "capabilities/$f exists" test -f "$KIT_DIR/capabilities/$f"
done

claude_md_mentions_workspace() {
  grep -qi 'workspace' "$1/../CLAUDE.md" 2>/dev/null || grep -qi 'workspace' "$2/CLAUDE.md" 2>/dev/null
}

no_env_tracked() {
  ! git -C "$1" ls-files 2>/dev/null | grep -qE '(^|/)\.env$'
}

gitignore_excludes_env() {
  grep -qxF '.env' "$1/.gitignore" 2>/dev/null
}

no_hardcoded_region_logic() {
  ! grep -rEn --include='*.py' --include='*.js' --include='*.ts' -i 'if.*region.*==.*"' "$1" 2>/dev/null \
    | grep -v '/data/' | grep -q .
}

echo "-- CLAUDE.md references the workspace boundary"
check "CLAUDE.md mentions workspace boundary" \
  claude_md_mentions_workspace "$KIT_DIR" "$REPO_ROOT"

echo "-- no secrets committed"
check "no .env file tracked in the repo" \
  no_env_tracked "$REPO_ROOT"

echo "-- .gitignore covers .env"
check ".gitignore excludes .env" \
  gitignore_excludes_env "$REPO_ROOT"

echo "-- no hardcoded region/supplier logic outside data/"
check "no region- or supplier-name string literals in app code (heuristic)" \
  no_hardcoded_region_logic "$REPO_ROOT"

echo "-- hook scripts are executable"
check "workspace-guard.sh is executable" test -x "$KIT_DIR/runtime/claude-code/hooks/workspace-guard.sh"
check "usage-guard.sh is executable" test -x "$KIT_DIR/runtime/claude-code/hooks/usage-guard.sh"

echo
if [[ "$FAIL" -eq 0 ]]; then
  echo "All checks passed."
else
  echo "One or more checks failed. Fix before merging."
fi
exit "$FAIL"
