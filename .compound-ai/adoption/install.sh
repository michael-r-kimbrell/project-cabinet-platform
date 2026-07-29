#!/bin/sh
# Compound AI Individual edition installer (POSIX sh).
# Copies the kit into operating-standards/ under your project root.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
KIT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

AUTO=0
DRY_RUN=0
UNINSTALL=0

usage() {
  cat <<'EOF'
Usage: install.sh [--yes|-y] [--dry-run] [--uninstall]

Copies the Compound AI kit into operating-standards/ under a project root.
Asks before overwriting existing files unless --yes is passed.
--dry-run prints the files and Claude settings keys that would change.
--uninstall removes Compound AI Claude Code hook wiring from settings.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    -y|--yes)
      AUTO=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      AUTO=1
      shift
      ;;
    --uninstall)
      UNINSTALL=1
      AUTO=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'install.sh: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

expand_user_path() {
  # Quote the tilde in the patterns so the shell matches a LITERAL leading `~`,
  # not a tilde-expanded `$HOME`. An unquoted `~/*` pattern expands to `$HOME/*`
  # and then wrongly matches any absolute path already under $HOME, doubling it.
  case "$1" in
    '~/'*)
      if [ -z "${HOME:-}" ]; then
        printf 'install.sh: HOME is not set; cannot expand %s\n' "$1" >&2
        exit 1
      fi
      printf '%s' "${HOME}${1#\~}"
      ;;
    '~')
      if [ -z "${HOME:-}" ]; then
        printf 'install.sh: HOME is not set; cannot expand ~\n' >&2
        exit 1
      fi
      printf '%s' "$HOME"
      ;;
    *)
      printf '%s' "$1"
      ;;
  esac
}

resolve_dir() {
  raw=$(expand_user_path "$1")
  case "$raw" in
    /*) abs="$raw" ;;
    *) abs="$(pwd)/$raw" ;;
  esac
  parent=$(dirname "$abs")
  base=$(basename "$abs")
  if [ -d "$abs" ]; then
    CDPATH= cd -- "$abs" && pwd
  elif [ -d "$parent" ]; then
    printf '%s/%s\n' "$(CDPATH= cd -- "$parent" && pwd)" "$base"
  else
    printf '%s\n' "$abs"
  fi
}

ask() {
  prompt=$1
  default=$2
  if [ "$AUTO" -eq 1 ]; then
    printf '%s [%s] -> %s\n' "$prompt" "$default" "$default" >&2
    printf '%s' "$default"
    return 0
  fi
  printf '%s [%s]: ' "$prompt" "$default" >&2
  IFS= read -r reply || reply=""
  if [ -z "$reply" ]; then
    printf '%s' "$default"
  else
    printf '%s' "$reply"
  fi
}

ask_yes() {
  prompt=$1
  default_yes=$2
  if [ "$AUTO" -eq 1 ]; then
    if [ "$default_yes" -eq 1 ]; then
      printf '%s (Y/n) -> yes\n' "$prompt" >&2
      return 0
    fi
    printf '%s (y/N) -> no\n' "$prompt" >&2
    return 1
  fi
  if [ "$default_yes" -eq 1 ]; then
    suffix="Y/n"
  else
    suffix="y/N"
  fi
  printf '%s (%s): ' "$prompt" "$suffix" >&2
  IFS= read -r reply || reply=""
  reply=$(printf '%s' "$reply" | tr '[:upper:]' '[:lower:]')
  if [ -z "$reply" ]; then
    [ "$default_yes" -eq 1 ]
    return $?
  fi
  case "$reply" in
    y|yes) return 0 ;;
    *) return 1 ;;
  esac
}

should_skip_copy() {
  rel=$1
  case "$rel" in
    *.pyc) return 0 ;;
  esac
  old_ifs=$IFS
  IFS=/
  set -- $rel
  IFS=$old_ifs
  for part in "$@"; do
    case "$part" in
      .git|__pycache__|reference-impl|derive|leak-denylist.local.txt)
        return 0
        ;;
    esac
  done
  return 1
}

copy_tree() {
  src=$1
  dst=$2
  find "$src" -type f | sort | while IFS= read -r item; do
    rel=${item#"$src"/}
    if should_skip_copy "$rel"; then
      continue
    fi
    target="$dst/$rel"
    mkdir -p "$(dirname "$target")"
    if [ -f "$target" ]; then
      if [ "$AUTO" -eq 0 ]; then
        if ! ask_yes "Overwrite existing $rel?" 0; then
          printf '  kept existing %s\n' "$rel"
          continue
        fi
      fi
    fi
    cp -p "$item" "$target"
    printf '  copied %s\n' "$rel"
  done
}

list_copy_tree() {
  src=$1
  dst=$2
  find "$src" -type f | sort | while IFS= read -r item; do
    rel=${item#"$src"/}
    if should_skip_copy "$rel"; then
      continue
    fi
    printf '  would copy %s -> %s\n' "$rel" "$dst/$rel"
  done
}

claude_settings_target() {
  if [ -n "${CLAUDE_SETTINGS:-}" ]; then
    printf '%s' "$CLAUDE_SETTINGS"
    return 0
  fi
  if [ -z "${HOME:-}" ]; then
    printf 'install.sh: HOME is not set; cannot locate Claude settings\n' >&2
    exit 1
  fi
  printf '%s/.claude/settings.json' "$HOME"
}

preview_claude_runtime() {
  adapter="$KIT_ROOT/runtime/claude-code/install-adapter.sh"
  [ -f "$adapter" ] || return 0
  if ! command -v python3 >/dev/null 2>&1; then
    printf '%s\n' "DRY RUN: python3 not found; would skip Claude settings merge."
    return 0
  fi
  bash "$adapter" --dry-run --settings "$(claude_settings_target)"
}

install_claude_runtime() {
  kit_dst=$1
  adapter="$kit_dst/runtime/claude-code/install-adapter.sh"
  [ -f "$adapter" ] || return 0
  if ! command -v python3 >/dev/null 2>&1; then
    printf '%s\n' "Claude Code wiring skipped: python3 is not available."
    printf '  Preview merge later: bash "%s" --dry-run\n' "$adapter"
    return 0
  fi
  if [ "$AUTO" -eq 1 ]; then
    printf '%s\n' "Claude Code wiring skipped in non-interactive mode."
    printf '  Preview merge: bash "%s" --dry-run\n' "$adapter"
    printf '  Apply merge:   bash "%s" --install\n' "$adapter"
    return 0
  fi
  printf '\n'
  if ask_yes "Merge Claude Code runtime hooks into ~/.claude/settings.json?" 0; then
    if bash "$adapter" --install; then
      printf '%s\n' "  Claude Code settings updated."
    else
      printf '%s\n' "  Claude Code wiring failed. Run manually:"
      printf '    bash "%s" --dry-run\n' "$adapter"
    fi
  else
    printf '%s\n' "  Skipped Claude Code wiring. Preview anytime:"
    printf '    bash "%s" --dry-run\n' "$adapter"
  fi
}

uninstall_claude_runtime() {
  adapter="$KIT_ROOT/runtime/claude-code/install-adapter.sh"
  [ -f "$adapter" ] || return 0
  if ! command -v python3 >/dev/null 2>&1; then
    printf '%s\n' "Uninstall skipped: python3 is required for JSON settings updates." >&2
    exit 1
  fi
  bash "$adapter" --uninstall --settings "$(claude_settings_target)"
  printf '%s\n' "No kit files were deleted."
}

main() {
  if [ "$UNINSTALL" -eq 1 ]; then
    printf '%s\n' "Compound AI Individual edition uninstall"
    uninstall_claude_runtime
    exit 0
  fi

  printf '%s\n' "Compound AI Individual edition installer"
  printf '%s\n' "----------------------------------------"
  printf '%s\n' "Copies the kit into operating-standards/ under your project."
  printf '%s\n' "It never deletes anything and asks before overwriting."
  printf '\n'

  project_raw=$(ask "Target project root" "$(pwd)")
  project_root=$(resolve_dir "$project_raw")
  kit_dst="$project_root/operating-standards"

  printf '\n'
  printf 'Will copy the kit into: %s\n' "$kit_dst"
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '%s\n' "DRY RUN: no files or settings will be changed."
    list_copy_tree "$KIT_ROOT" "$kit_dst"
    printf '\n'
    preview_claude_runtime
    exit 0
  fi

  if ! ask_yes "Proceed?" 1; then
    printf '%s\n' "Stopped. Nothing was written."
    exit 1
  fi

  mkdir -p "$kit_dst"
  copy_tree "$KIT_ROOT" "$kit_dst"
  install_claude_runtime "$kit_dst"

  printf '\n'
  printf '%s\n' "Done. Installed kit root:"
  printf '  %s\n' "$kit_dst"
  printf '\n'
  printf '%s\n' "Verify the install:"
  printf '  bash "%s/enforcement/bin/check-kit.sh" "%s"\n' "$kit_dst" "$kit_dst"
  printf '\n'
  printf '%s\n' "Next: read adoption/ADOPT.md (existing project) or HANDOFF.md (new project), then AGENT.md."
}

main "$@"
