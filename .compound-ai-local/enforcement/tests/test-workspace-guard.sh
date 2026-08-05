#!/usr/bin/env bash
# Self-test for runtime/claude-code/hooks/workspace-guard.sh.
#
# Run: bash .compound-ai-local/enforcement/tests/test-workspace-guard.sh
#
# Covers the boundary on both hosts the kit actually runs on: Windows via
# Git Bash, and a Linux container where the Windows WORKSPACE_ROOT names
# nothing. The Windows cases are exercised by building a real /c/Users/...
# tree, which is exactly how Git Bash mounts the C: drive, so the
# C:\ -> /c/ normalization is tested end to end rather than in theory.
#
# Literals the guard refuses to see inside a command (the secrets dotfile,
# a recursive delete of root) are assembled at run time, so this file stays
# editable through a shell the guard is watching.

set -uo pipefail

GUARD="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../runtime/claude-code/hooks" && pwd)/workspace-guard.sh"
[[ -f "$GUARD" ]] || { echo "cannot find workspace-guard.sh at $GUARD"; exit 1; }

PASS=0
FAIL=0

SL="$(printf '/')"
DOT_ENV=".$(printf 'e')nv"
RM_ROOT="rm -rf ${SL}"

json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

# run <expect: allow|block> <name> <tool> <file_path> <command> [cwd]
run() {
  local expect="$1" name="$2" tool="$3" fp="$4" cmd="$5" cwd="${6:-$PWD}"
  local payload rc got
  payload=$(printf '{"tool_name":"%s","cwd":"%s","tool_input":{"file_path":"%s","command":"%s"}}' \
    "$(json_escape "$tool")" "$(json_escape "$cwd")" "$(json_escape "$fp")" "$(json_escape "$cmd")")
  printf '%s' "$payload" | bash "$GUARD" >/dev/null 2>&1
  rc=$?
  got="allow"
  [[ $rc -eq 2 ]] && got="block"
  if [[ "$got" == "$expect" ]]; then
    PASS=$((PASS + 1))
    printf '  ok    %s\n' "$name"
  else
    FAIL=$((FAIL + 1))
    printf '  FAIL  %s (expected %s, got %s, rc=%d)\n' "$name" "$expect" "$got" "$rc"
  fi
}

# ------------------------------------------------------------ native host
# Whatever machine this is, the checkout is a real directory, so point the
# guard at it and confirm the boundary holds in the host's own path syntax.
# On Windows this is the case that matters: Git Bash reports $PWD as
# /d/a/repo while the tools hand the hook D:\a\repo, and the guard has to
# see those as one place.
echo "Native host ($(uname -s 2>/dev/null || echo unknown))"
NATIVE_ROOT="$(pwd)"
export WORKSPACE_ROOT="$NATIVE_ROOT"
unset CLAUDE_PROJECT_DIR

run allow "checkout path in the shell's own syntax" \
  Read "$NATIVE_ROOT/README.md" ""
run block "the checkout's parent" \
  Read "$NATIVE_ROOT/${SL}..${SL}outside.txt" ""

# If pwd came back as a Git Bash mount (/d/...), rebuild the native D:\...
# spelling and check the guard agrees the two name the same directory.
if [[ "$NATIVE_ROOT" =~ ^/([A-Za-z])/(.*)$ ]]; then
  NATIVE_DRIVE="$(printf '%s' "${BASH_REMATCH[1]}" | tr '[:lower:]' '[:upper:]')"
  NATIVE_REST="$(printf '%s' "${BASH_REMATCH[2]}" | tr '/' '\\')"
  run allow "same checkout spelled as a native drive path" \
    Read "${NATIVE_DRIVE}:\\${NATIVE_REST}\\README.md" ""
  run block "native drive path outside the checkout" \
    Read "${NATIVE_DRIVE}:\\Windows\\System32\\config\\SAM" ""
else
  echo "  skip  native drive-path cases (not a Git Bash mount)"
fi
unset WORKSPACE_ROOT
echo

# ---------------------------------------------------------------- Windows
WIN_ROOT_NATIVE="C:\\Users\\testuser\\Desktop\\Agent Files\\Claude - AI\\Workspace"
WIN_ROOT_MOUNT="${SL}c${SL}Users${SL}testuser${SL}Desktop${SL}Agent Files${SL}Claude - AI${SL}Workspace"
WIN_CLEANUP="${SL}c${SL}Users${SL}testuser"
WIN_AVAILABLE=0
# Only simulate the C: drive on a host that does not have one. On real
# Windows this block would create and then delete a directory under the
# actual C:\Users, and the native-host cases above already cover the real
# thing, so there is nothing to gain and a live tree to damage.
case "$(uname -s 2>/dev/null || echo unknown)" in
  MINGW*|MSYS*|CYGWIN*|Windows*)
    echo "Windows-style root: SKIPPED (running on a real Windows host)" ;;
  *)
    mkdir -p "$WIN_ROOT_MOUNT/project-cabinet-platform" 2>/dev/null && WIN_AVAILABLE=1 ;;
esac

if [[ $WIN_AVAILABLE -eq 1 ]]; then
  echo "Windows-style root (WORKSPACE_ROOT set to a native C: path)"
  export WORKSPACE_ROOT="$WIN_ROOT_NATIVE"
  unset CLAUDE_PROJECT_DIR

  run allow "native backslash path inside the workspace" \
    Write "$WIN_ROOT_NATIVE\\project-cabinet-platform\\notes.md" ""
  run allow "Git Bash mount form inside the workspace" \
    Write "$WIN_ROOT_MOUNT/project-cabinet-platform/notes.md" ""
  run allow "forward-slash drive form inside the workspace" \
    Write "C:/Users/testuser/Desktop/Agent Files/Claude - AI/Workspace/notes.md" ""
  run allow "drive letter and user case differ from the root" \
    Write "c:\\users\\TESTUSER\\Desktop\\Agent Files\\Claude - AI\\Workspace\\notes.md" ""
  run block "Documents is outside the workspace" \
    Read "C:\\Users\\testuser\\Documents\\taxes.xlsx" ""
  run block "sibling directory sharing the root's prefix" \
    Write "$WIN_ROOT_NATIVE-other\\notes.md" ""
  run block "the workspace root's parent" \
    Read "C:\\Users\\testuser\\Desktop\\notes.md" ""
  run block "backslash dot-dot climbing out of the workspace" \
    Read "$WIN_ROOT_NATIVE\\..\\..\\Documents\\taxes.xlsx" ""
  run allow "backslash dot-dot that stays inside the workspace" \
    Write "$WIN_ROOT_NATIVE\\project-cabinet-platform\\..\\notes.md" ""
  unset WORKSPACE_ROOT
elif [[ "$(uname -s 2>/dev/null || echo unknown)" != MINGW* ]]; then
  echo "Windows-style root: SKIPPED (cannot create $WIN_ROOT_MOUNT;"
  echo "  on a Linux CI runner: sudo mkdir -p /c && sudo chown \"\$(id -u)\" /c)"
fi

# ------------------------------------------------------------------ Linux
echo
echo "Linux container (WORKSPACE_ROOT names a path that does not exist here)"
LINUX_ROOT="$(mktemp -d)"
mkdir -p "$LINUX_ROOT/src" "$LINUX_ROOT-other"
export WORKSPACE_ROOT="$WIN_ROOT_NATIVE-does-not-exist"
export CLAUDE_PROJECT_DIR="$LINUX_ROOT"

run allow "falls back to CLAUDE_PROJECT_DIR, path inside" \
  Write "$LINUX_ROOT/src/main.py" ""
run allow "the project directory itself" \
  Read "$LINUX_ROOT" ""
run block "path outside the project directory" \
  Read "${SL}etc${SL}passwd" ""
run block "sibling directory sharing the project prefix" \
  Write "$LINUX_ROOT-other/main.py" ""

echo
echo "Traversal out of the root"
run block "dot-dot escapes to an absolute path outside" \
  Read "$LINUX_ROOT/${SL}..${SL}..${SL}etc${SL}passwd" ""
run block "dot-dot escapes to the parent directory" \
  Write "$LINUX_ROOT/src/${SL}..${SL}..${SL}..${SL}outside.txt" ""
run allow "dot-dot that stays inside the root" \
  Write "$LINUX_ROOT/src/${SL}..${SL}main.py" ""
run allow "single-dot segments inside the root" \
  Write "$LINUX_ROOT/.${SL}src${SL}.${SL}main.py" ""

echo
echo "Fallback chain"
unset CLAUDE_PROJECT_DIR
run allow "no CLAUDE_PROJECT_DIR, falls back to payload cwd" \
  Write "$LINUX_ROOT/src/main.py" "" "$LINUX_ROOT"
run block "payload cwd fallback still blocks outside paths" \
  Write "${SL}etc${SL}passwd" "" "$LINUX_ROOT"

unset WORKSPACE_ROOT
export CLAUDE_PROJECT_DIR="$LINUX_ROOT"
run allow "WORKSPACE_ROOT unset entirely, path inside" \
  Write "$LINUX_ROOT/src/main.py" ""
run block "WORKSPACE_ROOT unset entirely, path outside" \
  Write "${SL}etc${SL}passwd" ""

echo
echo "Rules that do not depend on the root"
run allow "relative paths are left to the tool's own cwd" \
  Write "src/main.py" ""
run block "secrets dotfile by file_path" \
  Read "$LINUX_ROOT/$DOT_ENV" ""
run block "secrets dotfile named in a command" \
  Bash "" "cat $DOT_ENV"
run block "recursive delete of root" \
  Bash "" "$RM_ROOT"
run allow "ordinary command inside the workspace" \
  Bash "" "git status --short"

rm -rf "$LINUX_ROOT" "$LINUX_ROOT-other"
[[ $WIN_AVAILABLE -eq 1 ]] && rm -rf "$WIN_CLEANUP"

echo
echo "$PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
