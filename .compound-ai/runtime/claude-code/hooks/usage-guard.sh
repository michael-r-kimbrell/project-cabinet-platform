#!/usr/bin/env bash
set -u

# Vendored under Apache-2.0, adapted from Joshua Sutcliff's public claude-config
# (github.com/joshuadsutcliff). Credited in runtime/claude-code/NOTICE.

mode="${1:-block}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUNTIME_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STANDARDS_DIR="$(cd "$RUNTIME_DIR/../.." && pwd)"

USAGE_GUARD_WARN_PCT="${USAGE_GUARD_WARN_PCT:-70}"
USAGE_GUARD_BLOCK_PCT="${USAGE_GUARD_BLOCK_PCT:-90}"
USAGE_GUARD_COST_LIMIT="${USAGE_GUARD_COST_LIMIT:-100}"
USAGE_GUARD_CACHE_SECS="${USAGE_GUARD_CACHE_SECS:-180}"
USAGE_GUARD_ESTIMATE_CHARS="${USAGE_GUARD_ESTIMATE_CHARS:-60000}"
CHEAP_WORKERS="${CHEAP_WORKERS:-researcher|code-generator|tester}"
BUDGET_PROBE="${BUDGET_PROBE:-auto}"
CCUSAGE_BIN="${CCUSAGE_BIN:-ccusage}"
USAGE_GUARD_NOTICE_FILE="${USAGE_GUARD_NOTICE_FILE:-${TMPDIR:-/tmp}/compound-ai-usage-guard-estimation.notice}"

json_out() {
  local decision="$1"
  local reason="$2"
  local pct="${3:--1}"
  python3 - "$decision" "$reason" "$pct" <<'PY' 2>/dev/null || printf '{"decision":"%s","reason":"%s","usage_pct":%s}\n' "$decision" "$reason" "$pct"
import json
import sys

decision, reason, pct = sys.argv[1], sys.argv[2], sys.argv[3]
try:
    pct_value = int(float(pct))
except Exception:
    pct_value = -1
print(json.dumps({"decision": decision, "reason": reason, "usage_pct": pct_value}, separators=(",", ":")))
PY
}

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

allowed = {
    "USAGE_GUARD_WARN_PCT",
    "USAGE_GUARD_BLOCK_PCT",
    "USAGE_GUARD_COST_LIMIT",
    "USAGE_GUARD_CACHE_SECS",
    "USAGE_GUARD_ESTIMATE_CHARS",
    "CHEAP_WORKERS",
    "BUDGET_PROBE",
    "CCUSAGE_BIN",
    "USAGE_GUARD_NOTICE_FILE",
}
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

read_payload() {
  payload_file="$(mktemp "${TMPDIR:-/tmp}/usage-guard.XXXXXX")"
  trap 'rm -f "$payload_file"' EXIT
  cat > "$payload_file" || return 1
}

payload_fields() {
  command -v python3 >/dev/null 2>&1 || return 1
  python3 - "$payload_file" <<'PY' 2>/dev/null
import json
import sys

try:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        data = json.load(handle)
except Exception:
    raise SystemExit(3)

tool_input = data.get("tool_input") if isinstance(data.get("tool_input"), dict) else {}
values = [
    data.get("tool_name", ""),
    tool_input.get("model", data.get("model", "")),
    tool_input.get("subagent_type", data.get("subagent_type", "")),
    str(tool_input.get("estimated_usage_pct", data.get("estimated_usage_pct", ""))),
    tool_input.get("prompt", data.get("prompt", "")),
]
print("\n".join(str(value) for value in values))
PY
}

estimate_pct_from_payload() {
  local prompt="$1"
  local chars limit pct
  chars="${#prompt}"
  limit="$USAGE_GUARD_ESTIMATE_CHARS"
  case "$limit" in
    ''|*[!0-9]*) limit=60000 ;;
  esac
  [ "$limit" -gt 0 ] || limit=60000
  pct=$((chars * 100 / limit))
  [ "$pct" -le 99 ] || pct=99
  printf '%s\n' "$pct"
}

ccusage_pct() {
  command -v "$CCUSAGE_BIN" >/dev/null 2>&1 || return 1
  "$CCUSAGE_BIN" --json 2>/dev/null | python3 - "$USAGE_GUARD_COST_LIMIT" <<'PY' 2>/dev/null
import json
import re
import sys

limit = float(sys.argv[1] or 100)
raw = sys.stdin.read()
try:
    data = json.loads(raw)
except Exception:
    data = raw

numbers = [float(x) for x in re.findall(r'"(?:totalCost|cost|amount)"\s*:\s*([0-9.]+)', raw)]
cost = max(numbers) if numbers else 0.0
if limit <= 0:
    raise SystemExit(1)
print(int(min(999, round((cost / limit) * 100))))
PY
}

ccusage_unavailable_for_probe() {
  local explicit_pct="$1"
  if printf '%s' "$explicit_pct" | grep -Eq '^[0-9]+([.][0-9]+)?$'; then
    return 1
  fi
  case "$BUDGET_PROBE" in
    ccusage|auto|'')
      command -v "$CCUSAGE_BIN" >/dev/null 2>&1 && return 1
      return 0
      ;;
  esac
  return 1
}

emit_estimation_notice_once() {
  local pct="$1"
  if [ -f "$USAGE_GUARD_NOTICE_FILE" ]; then
    return 1
  fi
  mkdir -p "$(dirname "$USAGE_GUARD_NOTICE_FILE")" 2>/dev/null || true
  : > "$USAGE_GUARD_NOTICE_FILE" 2>/dev/null || true
  json_out allow "usage cap running on estimation, not metered spend" "$pct"
  return 0
}

probe_pct() {
  local explicit_pct="$1"
  local prompt="$2"
  if printf '%s' "$explicit_pct" | grep -Eq '^[0-9]+([.][0-9]+)?$'; then
    printf '%s\n' "${explicit_pct%.*}"
    return 0
  fi

  case "$BUDGET_PROBE" in
    estimate)
      estimate_pct_from_payload "$prompt"
      return 0
      ;;
    ccusage|auto|'')
      if pct="$(ccusage_pct)"; then
        printf '%s\n' "$pct"
        return 0
      fi
      estimate_pct_from_payload "$prompt"
      return 0
      ;;
    *)
      if pct="$(sh -c "$BUDGET_PROBE" 2>/dev/null)" && printf '%s' "$pct" | grep -Eq '^[0-9]+([.][0-9]+)?$'; then
        printf '%s\n' "${pct%.*}"
        return 0
      fi
      estimate_pct_from_payload "$prompt"
      return 0
      ;;
  esac
}

approved_agent() {
  local model="$1"
  local subagent="$2"
  case "$model" in
    sonnet|haiku) return 0 ;;
  esac
  [ -n "$subagent" ] || return 1
  printf '%s\n' "$subagent" | grep -Eq "^(${CHEAP_WORKERS})$"
}

load_local_settings

case "$mode" in
  pct|block|inform|refresh) ;;
  *)
    json_out allow "unknown mode; fail-open" -1
    exit 0
    ;;
esac

read_payload || {
  json_out allow "payload read failed; fail-open" -1
  exit 0
}

fields_file="$(mktemp "${TMPDIR:-/tmp}/usage-guard-fields.XXXXXX")"
payload_fields > "$fields_file"
rc=$?
if [ "$rc" -ne 0 ]; then
  json_out allow "malformed or unparsable input; fail-open" -1
  exit 0
fi
trap 'rm -f "$payload_file" "$fields_file"' EXIT

tool_name="$(sed -n '1p' "$fields_file")"
model="$(sed -n '2p' "$fields_file")"
subagent_type="$(sed -n '3p' "$fields_file")"
estimated_usage_pct="$(sed -n '4p' "$fields_file")"
prompt="$(sed -n '5,$p' "$fields_file")"

if [ "$mode" = "block" ] && [ "$tool_name" != "Agent" ] && [ "$tool_name" != "Workflow" ]; then
  json_out allow "non-delegation tool ignored" -1
  exit 0
fi

pct="$(probe_pct "$estimated_usage_pct" "$prompt")"
case "$pct" in
  ''|*[!0-9]*) pct=-1 ;;
esac

if [ "$mode" = "pct" ]; then
  printf '%s\n' "$pct"
  exit 0
fi

if [ "$mode" = "refresh" ]; then
  json_out allow "usage cache refresh attempted via ${BUDGET_PROBE}" "$pct"
  exit 0
fi

if [ "$mode" = "inform" ]; then
  if ccusage_unavailable_for_probe "$estimated_usage_pct"; then
    emit_estimation_notice_once "$pct" && exit 0
  fi
  if [ "$pct" -ge "$USAGE_GUARD_WARN_PCT" ] 2>/dev/null; then
    json_out allow "usage warning threshold reached" "$pct"
  else
    json_out allow "usage below warning threshold" "$pct"
  fi
  exit 0
fi

if [ "$tool_name" = "Agent" ] && ! approved_agent "$model" "$subagent_type"; then
  json_out block "Agent must use sonnet, haiku, or an approved cheap worker" "$pct"
  exit 2
fi

if { [ "$tool_name" = "Agent" ] || [ "$tool_name" = "Workflow" ]; } && [ "$pct" -ge "$USAGE_GUARD_BLOCK_PCT" ] 2>/dev/null; then
  json_out block "usage block threshold reached" "$pct"
  exit 2
fi

json_out allow "usage guard passed" "$pct"
exit 0
