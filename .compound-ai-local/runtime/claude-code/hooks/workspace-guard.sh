#!/usr/bin/env bash
# PreToolUse hook: keeps Claude Code inside the workspace root and blocks
# reading .env files back into the conversation.
#
# Wired in .claude/settings.json against Bash|Edit|Write|Read.
# Reads the tool-call JSON on stdin per Claude Code's hook schema:
#   { "tool_name": "...", "cwd": "...", "tool_input": { ... } }
# Exit 2 blocks the call and sends stderr back to Claude as the reason.
# Exit 0 allows it.
#
# Pure bash/grep JSON extraction - no jq dependency, since jq is not
# guaranteed to be on PATH in every environment this hook runs in.
# Only handles flat string fields (tool_name, cwd, file_path, command),
# which is all this hook needs; it is not a general JSON parser.
#
# Portability: the same checkout runs on Windows (Git Bash) and inside
# Linux containers (Claude Code on the web, CI). An absolute path baked
# into WORKSPACE_ROOT only means something on the machine it was written
# for, so the root is resolved at run time - see resolve_root below.

set -euo pipefail

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
HOOK_CWD="$(json_field cwd)"

block() {
  echo "$1" >&2
  exit 2
}

# --- path normalization -------------------------------------------------
# Windows and Git Bash spell the same location three ways:
#   C:\Users\me\ws     C:/Users/me/ws     /c/Users/me/ws
# Fold all of them to the /c/users/me/ws form so a Windows WORKSPACE_ROOT
# and a Windows file_path can actually be compared. Windows paths are
# case-insensitive, so lowercase them; POSIX paths are left alone.
is_win_path() {
  [[ "$1" == *\\* ]] || [[ "$1" =~ ^[A-Za-z]: ]] || [[ "$1" =~ ^/[A-Za-z]/ ]]
}

lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

# Collapse "." and ".." segments so a path cannot walk back out of the root
# by indirection: .../workspace/../../etc/passwd has to reduce to
# /etc/passwd before it is compared. Purely textual, so symlinks are still
# not resolved.
collapse_dots() {
  local p="$1" seg out=""
  local -a parts=() stack=()
  local oldifs="$IFS"
  set -f                      # a path may legitimately contain * or ?
  IFS='/'
  parts=($p)
  IFS="$oldifs"
  set +f
  for seg in ${parts[@]+"${parts[@]}"}; do
    case "$seg" in
      ''|.) ;;
      ..) [[ ${#stack[@]} -gt 0 ]] && stack=("${stack[@]:0:${#stack[@]}-1}") ;;
      *)  stack+=("$seg") ;;
    esac
  done
  for seg in ${stack[@]+"${stack[@]}"}; do
    out="$out/$seg"
  done
  printf '%s' "${out:-/}"
}

# Spelling only: separators and the drive prefix, with case left alone.
# This is the form that can still be handed to test -d, because a mounted
# volume may well be case-sensitive.
slash_form() {
  local p="$1"
  p="${p//\\//}"                                        # backslashes -> slashes
  if [[ "$p" =~ ^([A-Za-z]):(/.*)?$ ]]; then            # C:/foo -> /c/foo
    p="/$(lower "${BASH_REMATCH[1]}")${BASH_REMATCH[2]:-}"
  fi
  while [[ "$p" == */ && "$p" != "/" ]]; do p="${p%/}"; done
  [[ "$p" == /* ]] && p="$(collapse_dots "$p")"
  printf '%s' "$p"
}

# Comparison form: slash_form, plus case folding for Windows paths only,
# since NTFS is case-insensitive and POSIX filesystems are not.
norm_path() {
  local p
  p="$(slash_form "$1")"
  if is_win_path "$1"; then
    p="$(lower "$p")"
  fi
  printf '%s' "$p"
}

# --- resolve the workspace root ----------------------------------------
# In order of preference:
#   1. WORKSPACE_ROOT, but only if it actually exists on this machine.
#      It is a machine-specific absolute path, so in a container or on a
#      different OS it names nothing and cannot serve as a boundary.
#   2. CLAUDE_PROJECT_DIR, which Claude Code sets for every hook.
#   3. The cwd carried in the hook payload, then the shell's own cwd.
# Something always resolves, so the guard never silently switches off.
# Try each spelling in turn: as given (native Windows or POSIX), as the
# Git Bash mount form, and finally case-folded for a case-insensitive
# volume. Any hit means the root is real on this machine.
dir_exists() {
  [[ -d "$1" ]] && return 0
  [[ -d "$(slash_form "$1")" ]] && return 0
  [[ -d "$(norm_path "$1")" ]]
}

resolve_root() {
  local candidate
  for candidate in "${WORKSPACE_ROOT:-}" "${CLAUDE_PROJECT_DIR:-}" "$HOOK_CWD"; do
    if [[ -n "$candidate" ]] && dir_exists "$candidate"; then
      printf '%s' "$candidate"
      return
    fi
  done
  printf '%s' "$PWD"
}

ROOT="$(resolve_root)"
ROOT_N="$(norm_path "$ROOT")"

# --- Rule 1: block reads/writes of .env files -----------------------
if [[ "$FILE_PATH" == *.env* ]] || [[ "$COMMAND" == *".env"* ]]; then
  block "workspace-guard: .env files are off-limits to the agent. Secrets stay out of the conversation - reference the key by name, don't read the value."
fi

# --- Rule 2: file-touching tools must stay inside the workspace root ----
# Only absolute paths are checked. A relative path is resolved by the tool
# against cwd, which is already inside the workspace.
if [[ -n "$FILE_PATH" ]]; then
  case "$FILE_PATH" in
    /*|[A-Za-z]:[\\/]*|[A-Za-z]:)
      FILE_N="$(norm_path "$FILE_PATH")"
      # Exact match, or a genuine child. Requiring the separator is what
      # stops /home/me/workspace-other passing as /home/me/workspace.
      if [[ "$FILE_N" != "$ROOT_N" && "$FILE_N" != "$ROOT_N"/* ]]; then
        block "workspace-guard: '$FILE_PATH' is outside $ROOT. This agent's world is the workspace folder only."
      fi
      ;;
  esac
fi

# --- Rule 3: obviously destructive commands outside the workspace -------
if [[ "$TOOL_NAME" == "Bash" ]] && printf '%s' "$COMMAND" | grep -qE 'rm -rf /|rm -rf ~[^/]|del /s'; then
  block "workspace-guard: destructive command outside a clearly scoped workspace path. Blocked - narrow the target path and retry if this was intentional."
fi

exit 0
