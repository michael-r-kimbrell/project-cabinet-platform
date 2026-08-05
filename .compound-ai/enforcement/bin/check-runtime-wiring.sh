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
  echo "check-runtime-wiring: cannot find operating-standards from: $input" >&2
  exit 2
}

STANDARDS_DIR="$(resolve_standards_dir "${1:-}")"
REPO_ROOT="$(cd "$STANDARDS_DIR/.." && pwd)"
RULES="$STANDARDS_DIR/enforcement-rules.yaml"

fragment_rel="$(awk '
  /rule_id:[[:space:]]*runtime-wiring/ { in_rule=1 }
  in_rule && /fragment_file:/ {
    value=$0
    sub(/^.*fragment_file:[[:space:]]*/, "", value)
    gsub(/"/, "", value)
    print value
    exit
  }
' "$RULES")"
fragment_rel="${fragment_rel:-runtime/claude-code/settings.fragment.json}"

if [ -f "$REPO_ROOT/$fragment_rel" ]; then
  fragment="$REPO_ROOT/$fragment_rel"
  runtime_dir="$(cd "$(dirname "$fragment")" && pwd)"
elif [ -f "$STANDARDS_DIR/$fragment_rel" ]; then
  fragment="$STANDARDS_DIR/$fragment_rel"
  runtime_dir="$(cd "$(dirname "$fragment")" && pwd)"
else
  printf 'FAIL runtime-wiring: settings fragment missing: %s\n' "$fragment_rel" >&2
  exit 1
fi

failures=0
require_text() {
  local label="$1"
  local pattern="$2"
  if ! grep -Eq "$pattern" "$fragment"; then
    printf 'FAIL runtime-wiring: missing %s in %s\n' "$label" "${fragment#$REPO_ROOT/}" >&2
    failures=$((failures + 1))
  fi
}

require_text 'SessionStart event' '"SessionStart"'
require_text 'UserPromptSubmit event' '"UserPromptSubmit"'
require_text 'PreToolUse event' '"PreToolUse"'
require_text 'usage-guard hook' 'usage-guard[.]sh'
require_text 'session-router hook' 'session-router[.]sh'
require_text 'Agent|Workflow matcher' 'Agent[|]Workflow'
require_text 'refresh mode' 'refresh'
require_text 'inform mode' 'inform'
require_text 'block mode' 'block'

require_file() {
  local label="$1"
  local file="$2"
  if [ ! -f "$file" ]; then
    printf 'FAIL runtime-wiring: missing %s: %s\n' "$label" "${file#$REPO_ROOT/}" >&2
    failures=$((failures + 1))
  fi
}

require_executable() {
  local label="$1"
  local file="$2"
  require_file "$label" "$file"
  if [ -f "$file" ] && [ ! -x "$file" ]; then
    printf 'FAIL runtime-wiring: %s is not executable: %s\n' "$label" "${file#$REPO_ROOT/}" >&2
    failures=$((failures + 1))
  fi
}

for hook in usage-guard.sh session-router.sh; do
  found=""
  for candidate in \
    "$runtime_dir/hooks/$hook" \
    "$runtime_dir/$hook" \
    "$STANDARDS_DIR/runtime/claude-code/hooks/$hook" \
    "$REPO_ROOT/runtime/claude-code/hooks/$hook" \
    "$STANDARDS_DIR/hooks/$hook"; do
    if [ -f "$candidate" ]; then
      found="$candidate"
      break
    fi
  done
  if [ -z "$found" ]; then
    printf 'FAIL runtime-wiring: hook path does not resolve: %s\n' "$hook" >&2
    failures=$((failures + 1))
  fi
done

if [ -f "$STANDARDS_DIR/runtime/README.md" ]; then
  require_file "adapter contract" "$STANDARDS_DIR/capabilities/adapter-contract.md"
  require_file "runtime index" "$STANDARDS_DIR/runtime/README.md"

  require_file "claude-code README" "$STANDARDS_DIR/runtime/claude-code/README.md"
  require_file "claude-code conformance note" "$STANDARDS_DIR/runtime/claude-code/CONFORMANCE.md"

  if [ -d "$STANDARDS_DIR/runtime/generic" ]; then
    require_file "generic README" "$STANDARDS_DIR/runtime/generic/README.md"
    require_file "generic prompt prelude" "$STANDARDS_DIR/runtime/generic/prompt-prelude.md"
    require_file "generic conformance note" "$STANDARDS_DIR/runtime/generic/CONFORMANCE.md"
    require_executable "generic dispatch wrapper" "$STANDARDS_DIR/runtime/generic/dispatch.sh"
  fi

  if [ -d "$STANDARDS_DIR/runtime/codex" ]; then
    require_file "codex README" "$STANDARDS_DIR/runtime/codex/README.md"
    require_file "codex AGENTS.md" "$STANDARDS_DIR/runtime/codex/AGENTS.md"
    require_file "codex conformance note" "$STANDARDS_DIR/runtime/codex/CONFORMANCE.md"
    require_executable "codex dispatch wrapper" "$STANDARDS_DIR/runtime/codex/dispatch.sh"
  fi

  if [ -d "$STANDARDS_DIR/runtime/cursor" ]; then
    require_file "cursor README" "$STANDARDS_DIR/runtime/cursor/README.md"
    require_file "cursor rules file" "$STANDARDS_DIR/runtime/cursor/.cursor/rules/compound-ai.mdc"
    require_file "cursor conformance note" "$STANDARDS_DIR/runtime/cursor/CONFORMANCE.md"
    require_executable "cursor dispatch wrapper" "$STANDARDS_DIR/runtime/cursor/dispatch.sh"
  fi

  for wrapper in \
    "$STANDARDS_DIR/runtime/generic/dispatch.sh" \
    "$STANDARDS_DIR/runtime/codex/dispatch.sh" \
    "$STANDARDS_DIR/runtime/cursor/dispatch.sh"; do
    [ -f "$wrapper" ] || continue
    if ! grep -Eq 'dispatch|session-router|usage-guard|generic/dispatch[.]sh' "$wrapper"; then
      printf 'FAIL runtime-wiring: wrapper does not reference capability dispatch: %s\n' "${wrapper#$REPO_ROOT/}" >&2
      failures=$((failures + 1))
    fi
  done
fi

if [ "$failures" -gt 0 ]; then
  exit 1
fi

printf 'PASS runtime-wiring: settings fragment and runtime adapters are wired\n'
