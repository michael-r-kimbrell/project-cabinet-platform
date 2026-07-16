#!/usr/bin/env bash
# PreToolUse hook: keeps Claude Code inside WORKSPACE_ROOT and blocks
# reading .env files back into the conversation.
#
# Wired in runtime/claude-code/settings.json against Bash|Edit|Write|Read.
# Reads the tool-call JSON on stdin per Claude Code's hook schema:
#   { "tool_name": "...", "tool_input": { ... } }
# Exit 2 blocks the call and sends stderr back to Claude as the reason.
# Exit 0 allows it.
#
# Pure bash/grep JSON extraction — no jq dependency, since jq is not
# guaranteed to be on PATH in every environment this hook runs in.
# Only handles flat string fields (tool_name, file_path, command), which
# is all this hook needs; it is not a general JSON parser.
#
# Set WORKSPACE_ROOT in your environment (or edit the default below)
# before relying on this — the fallback is a guess.

set -euo pipefail

WORKSPACE_ROOT="${WORKSPACE_ROOT:-$HOME/workspace}"
INPUT="$(cat)"

json_field() {
  local key="$1"
  local pattern
  pattern='"'"$key"'"[[:space:]]*:[[:space:]]*"([^"\\]|\\.)*"'
  local match
  match="$(printf '%s' "$INPUT" | grep -oE "$pattern" | head -n1 || true)"
  [[ -z "$match" ]] && return 0
  match="${match#*:}"                                   # drop key + colon
  match="${match#"${match%%[![:space:]]*}"}"            # trim leading ws
  match="${match#\"}"                                   # drop leading quote
  match="${match%\"}"                                   # drop trailing quote
  match="${match//\\\\/\\}"                              # unescape \\ -> \
  match="${match//\\\"/\"}"                              # unescape \" -> "
  printf '%s' "$match"
}

TOOL_NAME="$(json_field tool_name)"
FILE_PATH="$(json_field file_path)"
COMMAND="$(json_field command)"

block() {
  echo "$1" >&2
  exit 2
}

# --- Rule 1: block reads/writes of .env files ---------------------------
if [[ "$FILE_PATH" == *.env* ]] || [[ "$COMMAND" == *".env"* ]]; then
  block "workspace-guard: .env files are off-limits to the agent. Secrets stay out of the conversation — reference the key by name, don't read the value."
fi

# --- Rule 2: file-touching tools must stay inside WORKSPACE_ROOT --------
if [[ -n "$FILE_PATH" ]]; then
  case "$FILE_PATH" in
    "$WORKSPACE_ROOT"*) ;;  # inside workspace, fine
    /*|[A-Za-z]:\\*)
      block "workspace-guard: '$FILE_PATH' is outside $WORKSPACE_ROOT. This agent's world is the workspace folder only."
      ;;
    *) ;;  # relative path, assumed workspace-relative
  esac
fi

# --- Rule 3: obviously destructive commands outside the workspace -------
if [[ "$TOOL_NAME" == "Bash" ]] && echo "$COMMAND" | grep -qE 'rm -rf /|rm -rf ~[^/]|del /s'; then
  block "workspace-guard: destructive command outside a clearly scoped workspace path. Blocked — narrow the target path and retry if this was intentional."
fi

exit 0
