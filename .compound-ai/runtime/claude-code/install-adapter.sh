#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STANDARDS_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
FRAGMENT="$STANDARDS_DIR/runtime/claude-code/settings.fragment.json"
TARGET="${CLAUDE_SETTINGS:-}"
if [ -z "$TARGET" ] && [ -n "${HOME:-}" ]; then
  TARGET="$HOME/.claude/settings.json"
fi
MODE="dry-run"
TARGET_EXPLICIT="0"

usage() {
  cat <<'EOF'
Usage: install-adapter.sh [--dry-run|--install|--uninstall] [--settings PATH] [--fragment PATH]

--dry-run        Print the settings keys that would be merged and the merged JSON. Default.
--install        Write the merged JSON to the settings path after a Compound AI backup.
--uninstall      Remove Compound AI hook wiring, restoring backed up hook keys when present.
--settings PATH  Settings file to merge into.
--fragment PATH  Runtime settings fragment to merge.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      MODE="dry-run"
      shift
      ;;
    --install)
      MODE="install"
      shift
      ;;
    --uninstall)
      MODE="uninstall"
      shift
      ;;
    --settings)
      TARGET="${2:-}"
      TARGET_EXPLICIT="1"
      shift 2
      ;;
    --fragment)
      FRAGMENT="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'install-adapter: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ -z "$TARGET" ]; then
  printf 'install-adapter: settings target is empty; set HOME or CLAUDE_SETTINGS\n' >&2
  exit 1
fi

if [ ! -f "$FRAGMENT" ]; then
  printf 'install-adapter: missing settings fragment: %s\n' "$FRAGMENT" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  printf 'install-adapter: python3 required for JSON merge\n' >&2
  exit 1
fi

merged="$(mktemp "${TMPDIR:-/tmp}/claude-settings-merge.XXXXXX")"
trap 'rm -f "$merged"' EXIT

BASE_TARGET="$TARGET"
if [ "$MODE" = "dry-run" ] && [ "$TARGET_EXPLICIT" = "0" ]; then
  BASE_TARGET=""
fi

python3 - "$MODE" "$BASE_TARGET" "$FRAGMENT" "$TARGET" > "$merged" <<'PY'
import copy
import json
import os
import sys

mode, target, fragment, final_target = sys.argv[1:5]
backup = f"{final_target}.compound-ai-bak"


def load_json(path, default):
    if not path or not os.path.exists(path):
        return copy.deepcopy(default)
    with open(path, "r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise SystemExit(f"settings must be a JSON object: {path}")
    return data


def fragment_keys(patch):
    keys = []
    hooks = patch.get("hooks")
    if isinstance(hooks, dict):
        for event in sorted(hooks):
            keys.append(f"hooks.{event}")
    for key in sorted(patch):
        if key != "hooks" and not key.startswith("_"):
            keys.append(key)
    return keys


def merge_settings(base, patch):
    merged = copy.deepcopy(base)
    hooks = copy.deepcopy(merged.get("hooks", {}))
    if not isinstance(hooks, dict):
        hooks = {}
    patch_hooks = patch.get("hooks", {})
    if isinstance(patch_hooks, dict):
        for event, entries in patch_hooks.items():
            kit_entries = copy.deepcopy(entries) if isinstance(entries, list) else [copy.deepcopy(entries)]
            existing = hooks.get(event)
            existing = list(existing) if isinstance(existing, list) else []
            # Append the kit's hook entries; never replace a user's existing
            # hooks for this event. Dedupe by exact match so re-install stays
            # idempotent. This keeps the "never deletes" promise true.
            for entry in kit_entries:
                if entry not in existing:
                    existing.append(entry)
            hooks[event] = existing
        merged["hooks"] = hooks
    for key, value in patch.items():
        if key.startswith("_") or key == "hooks":
            continue
        merged[key] = copy.deepcopy(value)
    return merged


def remove_settings(current, patch, backup_data=None):
    result = copy.deepcopy(current)
    hooks = result.get("hooks")
    if not isinstance(hooks, dict):
        hooks = {}
    patch_hooks = patch.get("hooks", {})
    backup_hooks = backup_data.get("hooks", {}) if isinstance(backup_data, dict) else {}
    if not isinstance(backup_hooks, dict):
        backup_hooks = {}

    if isinstance(patch_hooks, dict):
        for event, entries in patch_hooks.items():
            kit_entries = entries if isinstance(entries, list) else [entries]
            if isinstance(backup_data, dict) and event in backup_hooks:
                hooks[event] = copy.deepcopy(backup_hooks[event])
            else:
                existing = hooks.get(event)
                if isinstance(existing, list):
                    # Remove only the kit's own entries; preserve user hooks.
                    remaining = [e for e in existing if e not in kit_entries]
                    if remaining:
                        hooks[event] = remaining
                    else:
                        hooks.pop(event, None)
                elif existing == entries:
                    hooks.pop(event, None)
    if hooks:
        result["hooks"] = hooks
    else:
        result.pop("hooks", None)

    for key, value in patch.items():
        if key.startswith("_") or key == "hooks":
            continue
        if isinstance(backup_data, dict) and key in backup_data:
            result[key] = copy.deepcopy(backup_data[key])
        elif result.get(key) == value:
            result.pop(key, None)
    return result


patch = load_json(fragment, {})
if mode == "uninstall":
    current = load_json(final_target, {})
    backup_data = load_json(backup, None) if os.path.exists(backup) else None
    output = remove_settings(current, patch, backup_data)
else:
    base = load_json(target, {})
    output = merge_settings(base, patch)

print("Compound AI settings keys: " + ", ".join(fragment_keys(patch)))
print(json.dumps(output, indent=2, sort_keys=True))
PY

case "$MODE" in
  dry-run)
    if [ "$TARGET_EXPLICIT" = "1" ]; then
      printf 'DRY RUN: would merge Claude settings into %s\n' "$TARGET"
    else
      printf 'DRY RUN: would merge Claude settings fragment with empty base\n'
    fi
    cat "$merged"
    ;;
  install)
    mkdir -p "$(dirname "$TARGET")"
    if [ -f "$TARGET" ] && [ ! -f "$TARGET.compound-ai-bak" ]; then
      cp "$TARGET" "$TARGET.compound-ai-bak"
      printf 'Backup written: %s.compound-ai-bak\n' "$TARGET"
    fi
    sed '1d' "$merged" > "$TARGET"
    printf 'Installed merged Claude settings: %s\n' "$TARGET"
    ;;
  uninstall)
    if [ ! -f "$TARGET" ]; then
      printf 'No Claude settings found at: %s\n' "$TARGET"
      exit 0
    fi
    sed '1d' "$merged" > "$TARGET"
    if [ -f "$TARGET.compound-ai-bak" ]; then
      printf 'Uninstalled Compound AI hooks using backup baseline: %s.compound-ai-bak\n' "$TARGET"
    else
      printf 'Uninstalled Compound AI hooks without backup: %s\n' "$TARGET"
    fi
    ;;
esac
