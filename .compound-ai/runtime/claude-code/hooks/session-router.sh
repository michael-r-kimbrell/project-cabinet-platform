#!/usr/bin/env bash
set -u

# Vendored under Apache-2.0, adapted from Joshua Sutcliff's public claude-config
# (github.com/joshuadsutcliff). Credited in runtime/claude-code/NOTICE.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUNTIME_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STANDARDS_DIR="$(cd "$RUNTIME_DIR/../.." && pwd)"
DEFAULT_REGISTRY="$STANDARDS_DIR/doctrine/conventions/trigger-registry.yaml"
CAOS_REGISTRY_FROM_ENV="${CAOS_REGISTRY:-}"
CAOS_REGISTRY="${CAOS_REGISTRY_FROM_ENV:-$DEFAULT_REGISTRY}"
REGISTRY_SOURCE="fallback"
[ -n "$CAOS_REGISTRY_FROM_ENV" ] && REGISTRY_SOURCE="CAOS_REGISTRY"
SESSION_ROUTER_OFF="${SESSION_ROUTER_OFF:-0}"
SESSION_ROUTER_SHOW="${SESSION_ROUTER_SHOW:-0}"

load_local_settings() {
  command -v python3 >/dev/null 2>&1 || return 0
  local file
  for file in \
    "$STANDARDS_DIR/settings.local.json" \
    "$RUNTIME_DIR/settings.local.json" \
    "${HOME:-}/.claude/settings.local.json"; do
    [ -f "$file" ] || continue
    eval "$(
      python3 - "$file" <<'PY' 2>/dev/null
import json
import shlex
import sys

allowed = {"SESSION_ROUTER_OFF", "SESSION_ROUTER_SHOW", "CAOS_REGISTRY"}
try:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        data = json.load(handle)
except Exception:
    raise SystemExit(0)
env = {}
if isinstance(data, dict):
    env.update({k: v for k, v in data.items() if k in allowed})
    nested = data.get("env")
    if isinstance(nested, dict):
        env.update({k: v for k, v in nested.items() if k in allowed})
for key, value in env.items():
    print(f"{key}={shlex.quote(str(value))}")
PY
    )"
  done
}

emit_context() {
  local context="$1"
  local message="$2"
  python3 - "$context" "$message" "$SESSION_ROUTER_SHOW" <<'PY' 2>/dev/null || printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$context"
import json
import sys

context, message, show = sys.argv[1], sys.argv[2], sys.argv[3]
payload = {
    "hookSpecificOutput": {
        "hookEventName": "UserPromptSubmit",
        "additionalContext": context,
    }
}
if show == "1" and message:
    payload["hookSpecificOutput"]["systemMessage"] = message
print(json.dumps(payload, separators=(",", ":")))
PY
}

read_prompt() {
  payload_file="$(mktemp "${TMPDIR:-/tmp}/session-router.XXXXXX")"
  trap 'rm -f "$payload_file"' EXIT
  cat > "$payload_file" || return 1
  command -v python3 >/dev/null 2>&1 || return 1
  python3 - "$payload_file" <<'PY' 2>/dev/null
import json
import sys

try:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        data = json.load(handle)
except Exception:
    raise SystemExit(3)
prompt = data.get("prompt", "")
if not prompt and isinstance(data.get("tool_input"), dict):
    prompt = data["tool_input"].get("prompt", "")
print(prompt)
PY
}

classify_prompt() {
  local prompt="$1"
  local registry="$2"
  command -v python3 >/dev/null 2>&1 || {
    printf 'LIGHT\tno-python\n'
    return 0
  }
  python3 - "$prompt" "$registry" <<'PY'
import re
import sys

prompt = sys.argv[1]
registry = sys.argv[2]
text = prompt.lower()

heavy_terms = [
    ("multi-agent", True),
    ("architecture", True),
    ("strategy", False),
    ("tradeoff", True),
    ("review", False),
    ("converge", False),
    ("panel", False),
    ("migration", False),
    ("release", False),
    ("design", False),
]
medium_terms = [
    "implement", "validation", "local checks", "script", "wire", "test",
    "refactor", "debug", "build", "install", "adapter",
]

triggers = []
try:
    raw = open(registry, "r", encoding="utf-8").read()
except Exception:
    raw = ""

for match in re.finditer(r"triggers:\s*\[(.*?)\]", raw):
    for item in re.findall(r'"([^"]+)"|\'([^\']+)\'', match.group(1)):
        trigger = item[0] or item[1]
        if trigger:
            triggers.append(trigger)

for match in re.finditer(r"^\s*-\s+([A-Za-z0-9][^\n#]+)$", raw, re.MULTILINE):
    value = match.group(1).strip().strip('"').strip("'")
    if value and " " in value:
        triggers.append(value)

matched = [trigger for trigger in triggers if trigger.lower() in text]
heavy_matches = [term for term, _ in heavy_terms if term in text]
heavy_count = len(heavy_matches)
heavy_override = any(term in text for term, is_override in heavy_terms if is_override)
medium_count = sum(1 for term in medium_terms if term in text)

if heavy_count >= 2 or heavy_override:
    tier = "HEAVY"
elif medium_count >= 1 or matched:
    tier = "MEDIUM"
else:
    tier = "LIGHT"

detail = ",".join(matched[:3]) if matched else "heuristic"
print(f"{tier}\t{detail}")
PY
}

load_local_settings

if [ "$CAOS_REGISTRY" != "$DEFAULT_REGISTRY" ]; then
  REGISTRY_SOURCE="CAOS_REGISTRY"
fi

if [ "$SESSION_ROUTER_OFF" = "1" ]; then
  emit_context "Routing disabled by SESSION_ROUTER_OFF; fail-open pass-through." "Routing disabled"
  exit 0
fi

prompt="$(read_prompt)"
rc=$?
if [ "$rc" -ne 0 ]; then
  emit_context "Routing unavailable; malformed input, fail-open pass-through." "Routing unavailable"
  exit 0
fi

[ -f "$CAOS_REGISTRY" ] || {
  CAOS_REGISTRY="$DEFAULT_REGISTRY"
  REGISTRY_SOURCE="fallback"
}
result="$(classify_prompt "$prompt" "$CAOS_REGISTRY")"
tier="${result%%	*}"
detail="${result#*	}"

case "$tier" in
  LIGHT)
    directive="Routing tier: LIGHT. Keep context lean, use the minimum relevant pointer, and avoid delegation unless the user asks."
    ;;
  MEDIUM)
    directive="Routing tier: MEDIUM. Load the directly relevant skill or checklist, run local validation, and keep fan-out capped."
    ;;
  HEAVY)
    directive="Routing tier: HEAVY. Use the registry to choose the planning or review path, stage work in waves, and check usage before delegation."
    ;;
  *)
    tier="LIGHT"
    directive="Routing tier: LIGHT. Router fell back to the safest low-context path."
    ;;
esac

emit_context "$directive Registry source: $REGISTRY_SOURCE (${CAOS_REGISTRY##*/}); match: $detail." "Routing tier: $tier"
exit 0
