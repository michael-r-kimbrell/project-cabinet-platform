#!/usr/bin/env bash
# phase_wrapper.sh
# Compound AI Operating Standards -- Reference Implementation
# Source: cameronsutcliff.com/compound-ai
# License: Apache 2.0
# Version: 1.0.0
#
# Bash phase wrapper for set-e-tolerant pipeline orchestration.
# Wraps each phase so a single failure does not abort the entire pipeline.
# Records start/end/status to a log file and optionally to a SQLite table.
#
# Usage:
#   source phase_wrapper.sh
#   run_phase "news-classify" python scripts/classify_news.py --date today
#   run_phase "vacuum-detect" python scripts/detect_vacuums.py
#   run_phase "daily-brief"   python scripts/synthesize_brief.py --dry-run
#
# Environment variables:
#   PIPELINE_NAME   Name of the parent pipeline (default: "pipeline")
#   PIPELINE_LOG    Path to the log file (default: /tmp/pipeline_runs.log)
#   PIPELINE_DB     Path to SQLite DB for structured logging (optional)

set -euo pipefail

PIPELINE_NAME="${PIPELINE_NAME:-pipeline}"
PIPELINE_LOG="${PIPELINE_LOG:-/tmp/pipeline_runs.log}"
PIPELINE_DB="${PIPELINE_DB:-}"

_now() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
}

_log() {
    local level="$1"; shift
    echo "$(_now) [$level] $*" | tee -a "$PIPELINE_LOG"
}

_db_record() {
    local phase="$1" status="$2" started="$3" ended="$4" error_msg="${5:-}"
    if [[ -n "$PIPELINE_DB" ]] && command -v sqlite3 &>/dev/null; then
        sqlite3 "$PIPELINE_DB" <<SQL
CREATE TABLE IF NOT EXISTS pipeline_runs (
    run_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    pipeline_name TEXT NOT NULL,
    phase         TEXT,
    status        TEXT NOT NULL,
    started_at    TEXT NOT NULL,
    ended_at      TEXT,
    error_message TEXT
);
INSERT INTO pipeline_runs (pipeline_name, phase, status, started_at, ended_at, error_message)
VALUES ('${PIPELINE_NAME}', '${phase}', '${status}', '${started}', '${ended}', '${error_msg}');
SQL
    fi
}

run_phase() {
    # Usage: run_phase <phase_name> <command> [args...]
    local name="$1"; shift
    local started
    started="$(_now)"

    _log "INFO" "Phase START: $name"

    if "$@"; then
        local ended
        ended="$(_now)"
        _log "INFO" "Phase SUCCESS: $name"
        _db_record "$name" "success" "$started" "$ended"
        return 0
    else
        local code=$?
        local ended
        ended="$(_now)"
        _log "ERROR" "Phase FAILED: $name (exit $code)"
        _db_record "$name" "failed" "$started" "$ended" "exit code $code"
        # Do NOT exit -- let the next phase run
        return 0
    fi
}

# Optional: run all phases and report summary at the end
run_pipeline() {
    # Usage: run_pipeline phase1_name cmd1 -- phase2_name cmd2 -- ...
    # Phases are separated by --
    local -a phases=()
    local -a cmds=()
    local current_phase=""
    local -a current_cmd=()

    for arg in "$@"; do
        if [[ "$arg" == "--" ]]; then
            if [[ -n "$current_phase" ]]; then
                phases+=("$current_phase")
                cmds+=("${current_cmd[*]}")
                current_phase=""
                current_cmd=()
            fi
        elif [[ -z "$current_phase" ]]; then
            current_phase="$arg"
        else
            current_cmd+=("$arg")
        fi
    done
    # Capture last phase
    if [[ -n "$current_phase" ]]; then
        phases+=("$current_phase")
        cmds+=("${current_cmd[*]}")
    fi

    local failed=0
    for i in "${!phases[@]}"; do
        # shellcheck disable=SC2086
        run_phase "${phases[$i]}" ${cmds[$i]} || ((failed++))
    done

    if [[ $failed -gt 0 ]]; then
        _log "WARN" "Pipeline $PIPELINE_NAME completed with $failed failed phase(s)"
    else
        _log "INFO" "Pipeline $PIPELINE_NAME completed successfully"
    fi
}
