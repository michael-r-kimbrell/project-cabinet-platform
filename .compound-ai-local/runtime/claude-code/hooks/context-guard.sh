#!/usr/bin/env bash
# PreToolUse hook: blocks tool calls whose results are known to flood the
# conversation, because context cost compounds.
#
# Every turn re-sends the whole conversation, so one bloated tool result is
# not paid once. It is paid on every turn after it, for the rest of the
# session. A single unpaginated GitHub list call can carry an entire
# repository object, with every API URL, for each item returned.
#
# The session-router already advises "keep context lean" on every prompt.
# Advice loses to defaults. This is the same instruction with teeth.
#
# Wired in .claude/settings.json against the MCP tools that accept the
# relevant flags. Exit 2 blocks and returns the reason to the agent.

set -euo pipefail

INPUT="$(cat)"

field() {
  printf '%s' "$INPUT" | grep -oE "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -n1 | sed 's/.*:[[:space:]]*"//; s/"$//'
}
has_key() { printf '%s' "$INPUT" | grep -qE "\"$1\"[[:space:]]*:"; }

TOOL="$(field tool_name)"
block() { echo "$1" >&2; exit 2; }

# Tools that return per-item payloads big enough to matter and that accept
# minimal_output. Keep this list explicit: blocking a tool that has no such
# flag would be unfixable from the agent's side.
case "$TOOL" in
  mcp__github__list_commits|mcp__github__search_repositories|mcp__github__search_code|\
  mcp__github__search_issues|mcp__github__search_pull_requests|mcp__github__list_issues|\
  mcp__github__list_pull_requests)
    if ! printf '%s' "$INPUT" | grep -qE '"minimal_output"[[:space:]]*:[[:space:]]*true'; then
      block "context-guard: $TOOL without minimal_output:true. These return the full repository object per item and stay in context for the rest of the session. Re-run with minimal_output:true, and add perPage (5-10) unless you genuinely need more."
    fi
    if ! has_key 'perPage' && ! has_key 'per_page'; then
      block "context-guard: $TOOL without a page size. Add perPage (5-10). Unpaginated list calls default to 30 items and the result is re-sent on every later turn."
    fi
    ;;
esac

# Workflow-run listings carry two full repository objects per run and are the
# single most expensive call observed in practice. There is no minimal_output
# for them, so cap the page size instead.
case "$TOOL" in
  mcp__github__actions_list)
    if ! has_key 'per_page'; then
      block "context-guard: actions_list without per_page. Each run carries two complete repository objects. Set per_page to 1-3, or prefer pull_request_read with method get_check_runs, which returns a compact summary."
    fi
    ;;
esac

exit 0
