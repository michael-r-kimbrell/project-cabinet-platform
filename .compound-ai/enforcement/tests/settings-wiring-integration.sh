#!/usr/bin/env bash
set -u

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STANDARDS_DIR="$(cd "$SELF_DIR/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/compound-ai-settings-wiring.XXXXXX")"

trap 'rm -rf "$TMP_ROOT"' EXIT

fail() {
  printf 'FAIL settings-wiring: %s\n' "$*" >&2
  exit 1
}

if ! command -v python3 >/dev/null 2>&1; then
  fail "python3 required for settings merge inspection"
fi

home="$TMP_ROOT/home"
project="$TMP_ROOT/project"
settings="$home/.claude/settings.json"
mkdir -p "$home/.claude" "$project"
cp -R "$STANDARDS_DIR/runtime" "$project/runtime"

HOME="$home" bash "$project/runtime/claude-code/install-adapter.sh" --install --settings "$settings" >/dev/null || fail "settings merge failed"

matcher_file="$TMP_ROOT/matcher.txt"
command_file="$TMP_ROOT/command.txt"
python3 - "$settings" "$matcher_file" "$command_file" <<'PY' || fail "could not extract PreToolUse hook command"
import json
import pathlib
import sys

settings_path, matcher_path, command_path = sys.argv[1:4]
with open(settings_path, "r", encoding="utf-8") as handle:
    settings = json.load(handle)

entries = settings.get("hooks", {}).get("PreToolUse", [])
for entry in entries:
    matcher = entry.get("matcher", "")
    for hook in entry.get("hooks", []):
        if hook.get("type") == "command" and "usage-guard.sh" in hook.get("command", ""):
            pathlib.Path(matcher_path).write_text(str(matcher), encoding="utf-8")
            pathlib.Path(command_path).write_text(hook["command"], encoding="utf-8")
            raise SystemExit(0)
raise SystemExit(1)
PY

matcher="$(cat "$matcher_file")"
command="$(cat "$command_file")"

case "$matcher" in
  *Agent*) ;;
  *) fail "PreToolUse matcher does not include Agent: $matcher" ;;
esac

blocked_payload="$TMP_ROOT/agent-over-budget.json"
allowed_payload="$TMP_ROOT/agent-allowed.json"
cat > "$blocked_payload" <<'EOF'
{
  "hook_event_name": "PreToolUse",
  "tool_name": "Agent",
  "tool_input": {
    "subagent_type": "researcher",
    "model": "haiku",
    "estimated_usage_pct": 95,
    "description": "Realistic wired PreToolUse fixture",
    "prompt": "Collect references after the usage cap has been reached."
  }
}
EOF
cat > "$allowed_payload" <<'EOF'
{
  "hook_event_name": "PreToolUse",
  "tool_name": "Agent",
  "tool_input": {
    "subagent_type": "researcher",
    "model": "haiku",
    "estimated_usage_pct": 10,
    "description": "Realistic wired PreToolUse fixture",
    "prompt": "Collect references for a narrow documentation check."
  }
}
EOF

run_hook_assert() {
  label=$1
  payload=$2
  expected_rc=$3
  expected_decision=$4
  output="$TMP_ROOT/$label.out"

  # A true live Claude Code session is not runnable in CI, so this exercises
  # the documented PreToolUse stdin, stdout, and exit-code hook contract.
  (
    cd "$project" || exit 1
    HOME="$home" sh -c "$command" < "$payload" > "$output" 2>&1
  )
  rc=$?
  if [ "$rc" -ne "$expected_rc" ]; then
    cat "$output" >&2
    fail "$label expected exit $expected_rc, got $rc"
  fi
  python3 - "$output" "$expected_decision" <<'PY' || {
import json
import sys

path, expected = sys.argv[1], sys.argv[2]
with open(path, "r", encoding="utf-8") as handle:
    data = json.load(handle)
if data.get("decision") != expected:
    raise SystemExit(1)
PY
    cat "$output" >&2
    fail "$label expected decision $expected_decision"
  }
}

run_hook_assert "blocked" "$blocked_payload" 2 "block"
run_hook_assert "allowed" "$allowed_payload" 0 "allow"

printf 'PASS settings-wiring: PreToolUse matcher and command block and allow through real settings wiring\n'
