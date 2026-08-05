#!/usr/bin/env bash
set -u

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STANDARDS_DIR="$(cd "$SELF_DIR/../.." && pwd)"
BIN_DIR="$STANDARDS_DIR/enforcement/bin"
FIXTURES_DIR="$SELF_DIR/fixtures"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/compound-ai-selftest.XXXXXX")"

trap 'rm -rf "$TMP_ROOT"' EXIT

failures=0

log() {
  printf '%s\n' "$*"
}

fail() {
  printf 'FAIL selftest: %s\n' "$*" >&2
  failures=$((failures + 1))
}

run_expect_pass() {
  local label="$1"
  shift
  local output rc
  output="$("$@" 2>&1)"
  rc=$?
  if [ "$rc" -eq 0 ]; then
    log "PASS $label"
    [ -n "$output" ] && printf '%s\n' "$output" | sed 's/^/  /'
  else
    fail "$label expected exit 0, got $rc"
    [ -n "$output" ] && printf '%s\n' "$output" >&2
  fi
}

run_expect_fail() {
  local label="$1"
  shift
  local output rc
  output="$("$@" 2>&1)"
  rc=$?
  if [ "$rc" -ne 0 ]; then
    log "PASS $label blocked as expected (exit $rc)"
    [ -n "$output" ] && printf '%s\n' "$output" | sed 's/^/  /'
  else
    fail "$label expected nonzero exit"
    [ -n "$output" ] && printf '%s\n' "$output" >&2
  fi
}

run_expect_contains() {
  local label="$1"
  local expected="$2"
  shift 2
  local output rc
  output="$("$@" 2>&1)"
  rc=$?
  if [ "$rc" -eq 0 ] && printf '%s\n' "$output" | grep -Fq "$expected"; then
    log "PASS $label"
    [ -n "$output" ] && printf '%s\n' "$output" | sed 's/^/  /'
  else
    fail "$label expected exit 0 and output containing: $expected"
    printf 'exit: %s\n' "$rc" >&2
    [ -n "$output" ] && printf '%s\n' "$output" >&2
  fi
}

run_expect_not_contains() {
  local label="$1"
  local rejected="$2"
  shift 2
  local output rc
  output="$("$@" 2>&1)"
  rc=$?
  if [ "$rc" -eq 0 ] && ! printf '%s\n' "$output" | grep -Fq "$rejected"; then
    log "PASS $label"
    [ -n "$output" ] && printf '%s\n' "$output" | sed 's/^/  /'
  else
    fail "$label expected exit 0 and output without: $rejected"
    printf 'exit: %s\n' "$rc" >&2
    [ -n "$output" ] && printf '%s\n' "$output" >&2
  fi
}

run_json_assert() {
  local label="$1"
  local expr="$2"
  shift 2
  local output rc json_file
  output="$("$@" 2>&1)"
  rc=$?
  json_file="$TMP_ROOT/json-assert.json"
  printf '%s\n' "$output" > "$json_file"
  if python3 - "$json_file" "$expr" <<'PY'; then
import json
import sys

path, expr = sys.argv[1], sys.argv[2]
raw = open(path, "r", encoding="utf-8").read().strip()
data = json.loads(raw)
if not eval(expr, {"__builtins__": {}}, {"data": data, "bool": bool}):
    raise SystemExit(1)
PY
    log "PASS $label"
    [ -n "$output" ] && printf '%s\n' "$output" | sed 's/^/  /'
  else
    fail "$label JSON assertion failed: $expr"
    printf 'exit: %s\n' "$rc" >&2
    [ -n "$output" ] && printf '%s\n' "$output" >&2
  fi
}

write_usage_guard_stub() {
  local path="$1"
  cat > "$path" <<'EOF'
#!/usr/bin/env bash
set -u

mode="${1:-block}"
payload="$(mktemp)"
trap 'rm -f "$payload"' EXIT
cat > "$payload" || exit 0

if ! grep -q '^{' "$payload"; then
  printf '{"decision":"allow","reason":"fail-open malformed input"}\n'
  exit 0
fi

if [ "$mode" = "block" ] && grep -q '"tool_name"[[:space:]]*:[[:space:]]*"Agent"' "$payload"; then
  if ! grep -Eq '"model"[[:space:]]*:[[:space:]]*"(sonnet|haiku)"|"subagent_type"[[:space:]]*:[[:space:]]*"(researcher|code-generator|tester)"' "$payload"; then
    printf '{"decision":"block","reason":"Agent fixture missing approved model or cheap worker"}\n'
    exit 2
  fi
fi

if [ "$mode" = "block" ] && grep -q '"tool_name"[[:space:]]*:[[:space:]]*"Workflow"' "$payload"; then
  if grep -Eq '"estimated_usage_pct"[[:space:]]*:[[:space:]]*9[0-9]' "$payload"; then
    printf '{"decision":"block","reason":"Workflow fixture exceeds usage cap"}\n'
    exit 2
  fi
fi

printf '{"decision":"allow"}\n'
exit 0
EOF
  chmod +x "$path"
}

write_session_router_stub() {
  local path="$1"
  cat > "$path" <<'EOF'
#!/usr/bin/env bash
set -u

payload="$(mktemp)"
trap 'rm -f "$payload"' EXIT
cat > "$payload" || exit 0

if ! grep -q '^{' "$payload"; then
  printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Routing unavailable; fail-open on malformed input."}}\n'
  exit 0
fi

tier="LIGHT"
if grep -Eiq 'multi-agent|architecture|strategy|compare tradeoffs' "$payload"; then
  tier="HEAVY"
elif grep -Eiq 'implement|validation|local checks|script' "$payload"; then
  tier="MEDIUM"
fi

printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Routing tier: %s"}}\n' "$tier"
exit 0
EOF
  chmod +x "$path"
}

install_runtime_hooks() {
  local tree="$1"
  mkdir -p "$tree/runtime/claude-code/hooks"

  if [ -f "$STANDARDS_DIR/runtime/claude-code/hooks/usage-guard.sh" ] && [ -f "$STANDARDS_DIR/runtime/claude-code/hooks/session-router.sh" ]; then
    cp "$STANDARDS_DIR/runtime/claude-code/hooks/usage-guard.sh" "$tree/runtime/claude-code/hooks/usage-guard.sh"
    cp "$STANDARDS_DIR/runtime/claude-code/hooks/session-router.sh" "$tree/runtime/claude-code/hooks/session-router.sh"
    chmod +x "$tree/runtime/claude-code/hooks/usage-guard.sh" "$tree/runtime/claude-code/hooks/session-router.sh"
    printf 'vendored\n' > "$tree/.runtime-source"
  else
    write_usage_guard_stub "$tree/runtime/claude-code/hooks/usage-guard.sh"
    write_session_router_stub "$tree/runtime/claude-code/hooks/session-router.sh"
    printf 'fixture-stub\n' > "$tree/.runtime-source"
  fi
}

make_tree() {
  local tree="$1"
  mkdir -p \
    "$tree/doctrine/tiers" \
    "$tree/doctrine/conventions" \
    "$tree/doctrine/skills/minimal" \
    "$tree/runtime/claude-code/hooks" \
    "$tree/docs"

  cp "$STANDARDS_DIR/enforcement-rules.yaml" "$tree/enforcement-rules.yaml"
  mkdir -p "$tree/runtime/claude-code"
  cp "$STANDARDS_DIR/runtime/claude-code/settings.fragment.json" "$tree/runtime/claude-code/settings.fragment.json"

  printf '# Tier 0\n\nLoad host project rules first.\n' > "$tree/doctrine/tiers/tier0.md"
  printf '# Minimal Skill\n\nUse this placeholder for gate self-tests.\n' > "$tree/doctrine/skills/minimal/SKILL.md"
  printf '%s\n' '---' 'Total skills: 1' '---' '' '- `doctrine/skills/minimal/SKILL.md`' > "$tree/_skills-index.md"
  cat > "$tree/doctrine/conventions/trigger-registry.yaml" <<'EOF'
version: 1
entries:
  - skill: minimal
    tier: 1
    pointer: doctrine/skills/minimal/SKILL.md
    mode: auto
    triggers:
      - selftest
EOF

  cat > "$tree/HANDOFF.md" <<'EOF'
# Handoff

Tier 1: Session infrastructure (1 skills):
  ✓ minimal

Tier 2: Cognitive modes (0 skills):
EOF

  install_runtime_hooks "$tree"
}

make_integrity_tree() {
  local tree="$1"
  mkdir -p "$tree/reference-impl/scripts"
  cp "$STANDARDS_DIR/reference-impl/scripts/build-manifest.py" "$tree/reference-impl/scripts/build-manifest.py"
  cp "$STANDARDS_DIR/reference-impl/scripts/verify-integrity.py" "$tree/reference-impl/scripts/verify-integrity.py"
  cp "$STANDARDS_DIR/reference-impl/scripts/verify-origin.py" "$tree/reference-impl/scripts/verify-origin.py"
  cp "$STANDARDS_DIR/NOTICE" "$tree/NOTICE"
  cp "$STANDARDS_DIR/NOTICE.md" "$tree/NOTICE.md"
  cp "$STANDARDS_DIR/CITATION.cff" "$tree/CITATION.cff"
  cat > "$tree/compound-ai.manifest.json" <<'EOF'
{
  "package_name": "Compound AI Operating Standards",
  "origin_id": "compound-ai",
  "authors": ["Cameron Sutcliff", "Joshua Sutcliff"],
  "canonical_url": "https://cameronsutcliff.com/compound-ai",
  "source_repo": "https://github.com/cameronpsutcliff/compound-ai",
  "version": "selftest",
  "release_date": "2026-06-19",
  "license_docs": "CC-BY-4.0",
  "license_code": "Apache-2.0",
  "generated_at": "",
  "aggregate_sha256": "",
  "files": []
}
EOF
  python3 "$tree/reference-impl/scripts/build-manifest.py" >/dev/null
}

assert_fixture_exists() {
  local file="$1"
  if [ ! -f "$file" ]; then
    fail "required fixture missing: ${file#$STANDARDS_DIR/}"
  fi
}

for fixture in \
  "$FIXTURES_DIR/oversized-SKILL.md" \
  "$FIXTURES_DIR/tier-violation.md" \
  "$FIXTURES_DIR/leak-sample.md" \
  "$FIXTURES_DIR/usage-guard/agent-no-model.json" \
  "$FIXTURES_DIR/usage-guard/agent-cheap-model.json" \
  "$FIXTURES_DIR/usage-guard/agent-over-budget.json" \
  "$FIXTURES_DIR/usage-guard/bash-tool.json" \
  "$FIXTURES_DIR/usage-guard/workflow-cap-hit.json" \
  "$FIXTURES_DIR/adapter-contract/no-goal.json" \
  "$FIXTURES_DIR/adapter-contract/budget-closed.json" \
  "$FIXTURES_DIR/adapter-contract/unmet-goal.json" \
  "$FIXTURES_DIR/adapter-contract/false-positive-no-agent.json" \
  "$FIXTURES_DIR/adapter-contract/routing-heavy.json" \
  "$FIXTURES_DIR/goal-loop/done-first.json" \
  "$FIXTURES_DIR/goal-loop/two-iterations-unmet.json" \
  "$FIXTURES_DIR/goal-loop/no-progress.json" \
  "$FIXTURES_DIR/session-router/light.json" \
  "$FIXTURES_DIR/session-router/medium.json" \
  "$FIXTURES_DIR/session-router/heavy.json" \
  "$FIXTURES_DIR/session-router/heavy-singular.json"; do
  assert_fixture_exists "$fixture"
done

if [ "$failures" -ne 0 ]; then
  exit 1
fi

log "== Baseline clean tree =="
base="$TMP_ROOT/base"
make_tree "$base"
run_expect_pass "check-line-caps clean baseline" "$BIN_DIR/check-line-caps.sh" "$base"
run_expect_pass "check-tier-discipline clean baseline" "$BIN_DIR/check-tier-discipline.sh" "$base"
run_expect_pass "check-portability clean baseline" "$BIN_DIR/check-portability.sh" "$base"
run_expect_pass "check-counts clean baseline" "$BIN_DIR/check-counts.sh" "$base"
run_expect_pass "check-registry-coherence clean baseline" "$BIN_DIR/check-registry-coherence.sh" "$base"
run_expect_pass "check-handoff-skills clean baseline" "$BIN_DIR/check-handoff-skills.sh" "$base"
run_expect_pass "check-benchmark-figures clean baseline" "$BIN_DIR/check-benchmark-figures.sh" "$base"
run_expect_pass "check-runtime-wiring clean baseline" "$BIN_DIR/check-runtime-wiring.sh" "$base"

log "== Provenance fixtures =="
integrity_tree="$TMP_ROOT/integrity"
make_integrity_tree "$integrity_tree"
run_expect_pass "verify-integrity shipped manifest" python3 "$integrity_tree/reference-impl/scripts/verify-integrity.py"
printf '\nTampered by selftest.\n' >> "$integrity_tree/NOTICE"
run_expect_fail "verify-integrity detects tampered file" python3 "$integrity_tree/reference-impl/scripts/verify-integrity.py"

log "== Gate block fixtures =="
case_dir="$TMP_ROOT/line-cap"
make_tree "$case_dir"
cp "$FIXTURES_DIR/oversized-SKILL.md" "$case_dir/doctrine/skills/minimal/SKILL.md"
run_expect_fail "check-line-caps oversized-SKILL.md" "$BIN_DIR/check-line-caps.sh" "$case_dir"

case_dir="$TMP_ROOT/tier-discipline"
make_tree "$case_dir"
cp "$FIXTURES_DIR/tier-violation.md" "$case_dir/doctrine/tiers/tier0.md"
run_expect_fail "check-tier-discipline tier-violation.md" "$BIN_DIR/check-tier-discipline.sh" "$case_dir"

case_dir="$TMP_ROOT/portability-leak"
make_tree "$case_dir"
cp "$FIXTURES_DIR/leak-sample.md" "$case_dir/docs/leak-sample.md"
run_expect_fail "check-portability leak-sample.md" "$BIN_DIR/check-portability.sh" "$case_dir"

case_dir="$TMP_ROOT/portability-allowlist"
make_tree "$case_dir"
printf '# Public attribution\n\nJoshua Sutcliff\njoshuadsutcliff\n' > "$case_dir/docs/allowlisted-near-match.md"
run_expect_pass "check-portability allowlisted near-match" "$BIN_DIR/check-portability.sh" "$case_dir"

# Team-surface coverage: team/ is omitted from the Individual zip (exclude.txt)
# but SHIPS to the Team edition, so a leak there must still be caught. The gate
# keys its scan-exclude off always-skip.txt (the union of what ships), not
# exclude.txt (the Individual-only surface). A gate that excluded by exclude.txt
# would miss this and wrongly pass; this fixture guards that regression.
case_dir="$TMP_ROOT/portability-team-surface"
make_tree "$case_dir"
mkdir -p "$case_dir/team/command-center" "$case_dir/derive"
printf '%s\n' 'doctrine/**' 'docs/**' 'runtime/**' 'team/**' 'enforcement-rules.yaml' '_skills-index.md' 'HANDOFF.md' > "$case_dir/derive/include.txt"
printf '%s\n' 'team/' > "$case_dir/derive/exclude.txt"
printf '%s\n' 'docs/FINAL-REVIEW.md' > "$case_dir/derive/always-skip.txt"
# Assemble the leak path at runtime so the literal does not appear in this
# shipped, leak-scanned script (the same technique derive.sh uses for its regex).
printf 'Build note: /%s/someone/private/notes.md\n' "Users" > "$case_dir/team/command-center/notes.md"
run_expect_fail "check-portability scans Team-shipped team/ (exclude.txt-omitted, not always-skipped)" "$BIN_DIR/check-portability.sh" "$case_dir"

case_dir="$TMP_ROOT/counts"
make_tree "$case_dir"
printf '%s\n' '---' 'Total skills: 2' '---' '' '- `doctrine/skills/minimal/SKILL.md`' > "$case_dir/_skills-index.md"
run_expect_fail "check-counts count drift" "$BIN_DIR/check-counts.sh" "$case_dir"

case_dir="$TMP_ROOT/registry"
make_tree "$case_dir"
cat > "$case_dir/doctrine/conventions/trigger-registry.yaml" <<'EOF'
version: 1
entries:
  - skill: missing
    tier: 1
    pointer: doctrine/skills/missing/SKILL.md
    mode: auto
    triggers:
      - selftest
EOF
run_expect_fail "check-registry-coherence missing pointer" "$BIN_DIR/check-registry-coherence.sh" "$case_dir"

case_dir="$TMP_ROOT/handoff"
make_tree "$case_dir"
cat > "$case_dir/HANDOFF.md" <<'EOF'
# Handoff

Tier 1: Session infrastructure (1 skills):
  ✓ retired-skill

Tier 2: Cognitive modes (0 skills):
EOF
run_expect_fail "check-handoff-skills stale roster" "$BIN_DIR/check-handoff-skills.sh" "$case_dir"

case_dir="$TMP_ROOT/runtime-wiring"
make_tree "$case_dir"
rm -f "$case_dir/runtime/claude-code/hooks/session-router.sh"
run_expect_fail "check-runtime-wiring missing hook" "$BIN_DIR/check-runtime-wiring.sh" "$case_dir"

case_dir="$TMP_ROOT/benchmark-figures"
make_tree "$case_dir"
mkdir -p "$case_dir/docs"
printf '# Architecture\n\nThe full reference resident costs about 158.4x (202,207 tokens versus 1,276).\n' > "$case_dir/docs/ARCHITECTURE.md"
run_expect_fail "check-benchmark-figures hand-typed figure" "$BIN_DIR/check-benchmark-figures.sh" "$case_dir"

log "== Runtime hook fixtures =="
hook_tree="$TMP_ROOT/hooks"
make_tree "$hook_tree"
runtime_source="$(cat "$hook_tree/.runtime-source")"
log "Runtime source: $runtime_source"

run_expect_pass "usage-guard fail-open on malformed input" bash -c "printf 'not-json' | '$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block"
run_expect_fail "usage-guard blocks agent-no-model.json" bash -c "'$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block < '$FIXTURES_DIR/usage-guard/agent-no-model.json'"
run_expect_pass "usage-guard allows agent-cheap-model.json" bash -c "'$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block < '$FIXTURES_DIR/usage-guard/agent-cheap-model.json'"
run_expect_fail "usage-guard blocks workflow-cap-hit.json" bash -c "'$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block < '$FIXTURES_DIR/usage-guard/workflow-cap-hit.json'"
run_json_assert "CT-UD-1 Agent over budget returns block" 'data.get("decision")=="block"' bash -c "'$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block < '$FIXTURES_DIR/usage-guard/agent-over-budget.json'"
run_json_assert "CT-UD-2 cheap Agent below warning returns allow" 'data.get("decision")=="allow"' bash -c "'$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block < '$FIXTURES_DIR/usage-guard/agent-cheap-model.json'"
run_json_assert "CT-UD-3 Bash tool returns allow without evaluation" 'data.get("decision")=="allow" and data.get("usage_pct")==-1' bash -c "'$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block < '$FIXTURES_DIR/usage-guard/bash-tool.json'"
run_json_assert "CT-UD-4 malformed probe fails open" 'data.get("decision")=="allow" and data.get("usage_pct")==-1' bash -c "printf 'not-json' | '$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block"
run_json_assert "CT-UD-5 closed pct ceiling blocks delegation" 'data.get("decision")=="block"' bash -c "USAGE_GUARD_BLOCK_PCT=0 '$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block < '$FIXTURES_DIR/usage-guard/agent-cheap-model.json'"
run_json_assert "CT-UD-6 approved cheap worker passes model check" 'data.get("decision")=="allow"' bash -c "'$hook_tree/runtime/claude-code/hooks/usage-guard.sh' block < '$FIXTURES_DIR/usage-guard/agent-cheap-model.json'"
run_expect_pass "settings-wiring integration invokes wired PreToolUse command" bash "$SELF_DIR/settings-wiring-integration.sh"

usage_notice_payload="$TMP_ROOT/usage-inform.json"
usage_notice_file="$TMP_ROOT/usage-estimation.notice"
printf '{"prompt":"short prompt without explicit usage"}\n' > "$usage_notice_payload"
run_expect_contains "usage-guard informs when ccusage unavailable" "usage cap running on estimation, not metered spend" bash -c "USAGE_GUARD_NOTICE_FILE='$usage_notice_file' CCUSAGE_BIN='__missing_ccusage__' '$hook_tree/runtime/claude-code/hooks/usage-guard.sh' inform < '$usage_notice_payload'"
run_expect_not_contains "usage-guard estimation notice is one-time" "usage cap running on estimation, not metered spend" bash -c "USAGE_GUARD_NOTICE_FILE='$usage_notice_file' CCUSAGE_BIN='__missing_ccusage__' '$hook_tree/runtime/claude-code/hooks/usage-guard.sh' inform < '$usage_notice_payload'"

run_expect_pass "session-router fail-open on malformed input" bash -c "printf 'not-json' | '$hook_tree/runtime/claude-code/hooks/session-router.sh'"
run_expect_pass "session-router accepts light.json" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/light.json'"
run_expect_pass "session-router accepts medium.json" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/medium.json'"
run_expect_pass "session-router accepts heavy.json" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/heavy.json'"
run_expect_contains "session-router routes heavy-singular.json as HEAVY" "Routing tier: HEAVY" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/heavy-singular.json'"
run_expect_contains "CT-SR-1 multi-agent architecture routes HEAVY" "Routing tier: HEAVY" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/heavy.json'"
run_expect_contains "CT-SR-2 implement session router routes MEDIUM" "Routing tier: MEDIUM" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/medium.json'"
run_expect_contains "CT-SR-3 simple prompt routes LIGHT" "Routing tier: LIGHT" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/light.json'"
run_expect_contains "CT-SR-4 missing registry still returns tier" "Routing tier:" bash -c "CAOS_REGISTRY='$TMP_ROOT/missing-registry.yaml' '$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/medium.json'"
run_expect_contains "CT-SR-5 router off passes through" "Routing disabled by SESSION_ROUTER_OFF" bash -c "SESSION_ROUTER_OFF=1 '$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/heavy.json'"
run_expect_contains "CT-SR-6 LIGHT directive appears" "Keep context lean" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/light.json'"
run_expect_contains "CT-SR-6 MEDIUM directive appears" "run local validation" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/medium.json'"
run_expect_contains "CT-SR-6 HEAVY directive appears" "check usage before delegation" bash -c "'$hook_tree/runtime/claude-code/hooks/session-router.sh' < '$FIXTURES_DIR/session-router/heavy.json'"

log "== Adapter contract conformance fixtures =="
invalid_task="$TMP_ROOT/invalid-task.json"
printf 'not-json\n' > "$invalid_task"

for runtime_name in generic codex cursor; do
  dispatch="$STANDARDS_DIR/runtime/$runtime_name/dispatch.sh"
  run_json_assert "CT-AC-1 $runtime_name returns required fields" '"id" in data and "status" in data and "output" in data' "$dispatch" --input "$FIXTURES_DIR/adapter-contract/no-goal.json" --agent-cmd 'printf "4\n"'
  run_json_assert "CT-AC-2 $runtime_name closed budget halts" 'data.get("status")=="halted"' "$dispatch" --input "$FIXTURES_DIR/adapter-contract/budget-closed.json"
  run_json_assert "CT-AC-3 $runtime_name no GoalContract completes without error" 'data.get("status")!="error"' "$dispatch" --input "$FIXTURES_DIR/adapter-contract/no-goal.json" --agent-cmd 'printf "4\n"'
  run_json_assert "CT-AC-4 $runtime_name unmet goal is not done" 'data.get("status")!="done" and data.get("halt_reason")' "$dispatch" --input "$FIXTURES_DIR/adapter-contract/unmet-goal.json" --agent-cmd 'printf "not yet\n"'
  run_json_assert "CT-AC-5 $runtime_name injects routing context" '"Routing tier: HEAVY" in data.get("output","")' "$dispatch" --input "$FIXTURES_DIR/adapter-contract/routing-heavy.json"
  run_json_assert "CT-AC-6 $runtime_name invalid JSON errors with reason" 'data.get("status")=="error" and bool(data.get("halt_reason"))' "$dispatch" --input "$invalid_task"
done

run_json_assert "P-1 false-positive fixture halts without agent output" 'data.get("status")!="done" and "no agent command" in data.get("halt_reason","")' "$STANDARDS_DIR/runtime/generic/dispatch.sh" --input "$FIXTURES_DIR/adapter-contract/false-positive-no-agent.json"

log "== Goal-loop conformance fixtures =="
run_json_assert "CT-GL-1 done on first iteration" 'data.get("status")=="done" and data.get("iterations_run")==1 and data.get("completion_met") is True' "$STANDARDS_DIR/runtime/generic/dispatch.sh" --input "$FIXTURES_DIR/goal-loop/done-first.json" --agent-cmd 'printf "done\n"'
run_json_assert "CT-GL-2 iteration budget halts after two" 'data.get("status")=="halted" and data.get("iterations_run")==2 and bool(data.get("halt_reason"))' "$STANDARDS_DIR/runtime/generic/dispatch.sh" --input "$FIXTURES_DIR/goal-loop/two-iterations-unmet.json" --agent-cmd 'printf "attempt %s\n" "$CAOS_ITERATION"'
run_json_assert "CT-GL-3 identical outputs halt no-progress" 'data.get("status")=="halted" and data.get("iterations_run")==2 and data.get("no_progress_halt") is True' "$STANDARDS_DIR/runtime/generic/dispatch.sh" --input "$FIXTURES_DIR/goal-loop/no-progress.json" --agent-cmd 'printf "same\n"'
run_json_assert "CT-GL-4 no GoalContract has no completion_met field" 'data.get("status")!="error" and "completion_met" not in data' "$STANDARDS_DIR/runtime/generic/dispatch.sh" --input "$FIXTURES_DIR/adapter-contract/no-goal.json" --agent-cmd 'printf "4\n"'
run_json_assert "CT-GL-5 usage block halts before execution" 'data.get("status")=="halted" and "usage" in data.get("halt_reason","")' "$STANDARDS_DIR/runtime/generic/dispatch.sh" --input "$FIXTURES_DIR/adapter-contract/budget-closed.json" --agent-cmd 'printf "should not run\n"'
run_expect_contains "CT-GL-6 evaluator is separate from generator command" "evaluate_completion()" grep -F "evaluate_completion()" "$STANDARDS_DIR/runtime/generic/dispatch.sh"

if [ "$failures" -ne 0 ]; then
  printf 'FAIL selftest: %s assertion(s) failed\n' "$failures" >&2
  exit 1
fi

printf 'PASS selftest: all planted gate and runtime fixtures behaved as expected\n'
