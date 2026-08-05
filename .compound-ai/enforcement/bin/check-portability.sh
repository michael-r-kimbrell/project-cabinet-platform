#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_STANDARDS_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

resolve_standards_dir() {
  local input="${1:-$DEFAULT_STANDARDS_DIR}"
  if [ -f "$input/enforcement-rules.yaml" ]; then
    cd "$input" && pwd
    return
  fi
  if [ -f "$input/operating-standards/enforcement-rules.yaml" ]; then
    cd "$input/operating-standards" && pwd
    return
  fi
  echo "check-portability: cannot find operating-standards from: $input" >&2
  exit 2
}

yaml_value() {
  local key="$1"
  awk -v key="$key" '
    $0 ~ key ":" {
      value=$0
      sub(/^.*:[[:space:]]*/, "", value)
      gsub(/"/, "", value)
      print value
      exit
    }
  ' "$RULES"
}

STANDARDS_DIR="$(resolve_standards_dir "${1:-}")"
REPO_ROOT="$(cd "$STANDARDS_DIR/.." && pwd)"
RULES="$STANDARDS_DIR/enforcement-rules.yaml"

denylist_rel="$(yaml_value 'denylist_file')"
allowlist_rel="$(yaml_value 'allowlist_file')"

denylist_candidates="
$STANDARDS_DIR/forbidden-terms.txt
$REPO_ROOT/operating-standards/forbidden-terms.txt
$REPO_ROOT/$denylist_rel
$STANDARDS_DIR/${denylist_rel#operating-standards/}
$STANDARDS_DIR/leak-denylist.txt
"

allowlist_candidates="
$STANDARDS_DIR/attribution-allowlist.txt
$REPO_ROOT/$allowlist_rel
$STANDARDS_DIR/${allowlist_rel#operating-standards/}
"

DENYLIST=""
for candidate in $denylist_candidates; do
  if [ -f "$candidate" ]; then
    DENYLIST="$candidate"
    break
  fi
done

ALLOWLIST=""
for candidate in $allowlist_candidates; do
  if [ -f "$candidate" ]; then
    ALLOWLIST="$candidate"
    break
  fi
done

tmp_deny="$(mktemp)"
tmp_local_deny="$(mktemp)"
tmp_allow="$(mktemp)"
tmp_files="$(mktemp)"
tmp_ext="$(mktemp)"
tmp_scan_exclude="$(mktemp)"
trap 'rm -f "$tmp_deny" "$tmp_local_deny" "$tmp_allow" "$tmp_files" "$tmp_ext" "$tmp_scan_exclude"' EXIT

if [ -n "$DENYLIST" ]; then
  sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$DENYLIST" > "$tmp_deny"
else
  # Fallback carries only generic personal-path patterns. Literal personal
  # names live in leak-denylist.local.txt (gitignored, maintainer-only).
  cat > "$tmp_deny" <<'EOF'
/Users/
~/<your-repo>
EOF
fi

# Maintainer-only local denylist of literal personal terms (gitignored, never
# shipped). Loaded on top of the shipped patterns when present so the gate also
# catches private project/person/family-framing terms during local validation.
LOCAL_DENYLIST=""
for candidate in \
  "$STANDARDS_DIR/leak-denylist.local.txt" \
  "$REPO_ROOT/operating-standards/leak-denylist.local.txt"; do
  if [ -f "$candidate" ]; then
    LOCAL_DENYLIST="$candidate"
    break
  fi
done

if [ -n "$LOCAL_DENYLIST" ]; then
  sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$LOCAL_DENYLIST" > "$tmp_local_deny"
fi

if [ -n "$ALLOWLIST" ]; then
  sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$ALLOWLIST" > "$tmp_allow"
else
  cat > "$tmp_allow" <<'EOF'
Cameron Sutcliff
Joshua Sutcliff
joshuadsutcliff
EOF
fi

failures=0

build_scan_excludes() {
  # The gate's scanned surface must equal the UNION of what actually ships (the
  # Team edition = include.txt minus the always-skip set). Scoping to the
  # Individual-only exclude.txt instead would leave a Team-shaped blind spot:
  # team/ and derive/ ship to Team but would never be leak-scanned. Use the
  # single-source always-skip list that derive.sh also drops by.
  local skip_file="$STANDARDS_DIR/derive/always-skip.txt"
  local rel

  if [ ! -f "$skip_file" ]; then
    return
  fi

  while IFS= read -r rel || [ -n "$rel" ]; do
    rel="${rel%%#*}"
    rel="${rel%"${rel##*[![:space:]]}"}"
    rel="${rel#"${rel%%[![:space:]]*}"}"
    [ -n "$rel" ] || continue
    printf '%s\n' "${rel%/}"
  done < "$skip_file"
}

build_scan_excludes > "$tmp_scan_exclude"

scan_excluded() {
  local rel="${1%/}"
  local pattern

  while IFS= read -r pattern || [ -n "$pattern" ]; do
    [ -n "$pattern" ] || continue
    if [ "$rel" = "$pattern" ] || [[ "$rel" == "$pattern/"* ]]; then
      return 0
    fi
  done < "$tmp_scan_exclude"
  return 1
}

emit_scan_file() {
  local file="$1"
  local rel="${file#$STANDARDS_DIR/}"

  if scan_excluded "$rel"; then
    return
  fi
  printf '%s\n' "$file"
}

build_scan_list() {
  local include_file="$STANDARDS_DIR/derive/include.txt"
  local rel pattern path

  if [ ! -f "$include_file" ]; then
    find "$STANDARDS_DIR" -type f -print | sort
    return
  fi

  while IFS= read -r rel; do
    rel="${rel%%#*}"
    rel="${rel%"${rel##*[![:space:]]}"}"
    rel="${rel#"${rel%%[![:space:]]*}"}"
    [ -n "$rel" ] || continue

    case "$rel" in
      *'/**')
        pattern="${rel%???}"
        if [ -d "$STANDARDS_DIR/$pattern" ]; then
          find "$STANDARDS_DIR/$pattern" -type f | while IFS= read -r path; do
            emit_scan_file "$path"
          done
        fi
        ;;
      *)
        path="$STANDARDS_DIR/$rel"
        if [ -f "$path" ]; then
          emit_scan_file "$path"
        elif [ -d "$path" ]; then
          find "$path" -type f | while IFS= read -r path; do
            emit_scan_file "$path"
          done
        fi
        ;;
    esac
  done < "$include_file" | sort -u
}

build_scan_list > "$tmp_files"

grep -E '[.]py$' "$tmp_files" > "$tmp_ext" || true
while IFS= read -r file; do
  [ -n "$file" ] || continue
  rel="${file#$STANDARDS_DIR/}"
  case "$rel" in
    reference-impl/*|team/*)
      ;;
    *)
      printf 'FAIL portability: Python file outside reference-impl/ or team/: %s\n' "$rel" >&2
      failures=$((failures + 1))
      ;;
  esac
done < "$tmp_ext"

grep -E '[.](sh|js)$' "$tmp_files" > "$tmp_ext" || true
while IFS= read -r file; do
  [ -n "$file" ] || continue
  rel="${file#$STANDARDS_DIR/}"
  case "$rel" in
    doctrine/tiers/*|doctrine/skills/*|doctrine/contracts/*|doctrine/conventions/*)
      printf 'FAIL portability: script file in doctrine path: %s\n' "$rel" >&2
      failures=$((failures + 1))
      ;;
    *)
      ;;
  esac
done < "$tmp_ext"

while IFS= read -r file; do
  rel="${file#$STANDARDS_DIR/}"
  case "$rel" in
    .git/*|_reference/*|enforcement/tests/fixtures/leak-sample.md|forbidden-terms.txt|leak-denylist.txt|leak-denylist.local.txt|attribution-allowlist.txt|enforcement/bin/check-*.sh)
      continue
      ;;
  esac
  case "$rel" in
    *.png|*.jpg|*.jpeg|*.gif|*.webp|*.ico|*.pdf|*.zip|*.pyc|.DS_Store)
      continue
      ;;
  esac
  if ! LC_ALL=C grep -Iq . "$file" 2>/dev/null; then
    continue
  fi

  awk -v rel="$rel" -v allow_file="$tmp_allow" -v deny_file="$tmp_deny" -v local_deny_file="$tmp_local_deny" '
    BEGIN {
      while ((getline line < allow_file) > 0) {
        allow[++allow_n]=line
      }
      close(allow_file)
      while ((getline line < deny_file) > 0) {
        deny[++deny_n]=line
      }
      close(deny_file)
      while ((getline line < local_deny_file) > 0) {
        local_deny[++local_deny_n]=line
      }
      close(local_deny_file)
    }
    function scrub_allowed(s, i) {
      for (i=1; i<=allow_n; i++) {
        if (allow[i] != "") {
          gsub(allow[i], "", s)
        }
      }
      return s
    }
    function is_word_char(c) {
      return c ~ /[[:alnum:]_]/
    }
    function boundary_match(s, term, start, pos, before, after) {
      start=1
      while ((pos=index(substr(s, start), term)) > 0) {
        pos=pos + start - 1
        before=(pos == 1) ? "" : substr(s, pos - 1, 1)
        after=substr(s, pos + length(term), 1)
        if (!is_word_char(before) && !is_word_char(after)) {
          return 1
        }
        start=pos + length(term)
      }
      return 0
    }
    function term_match(s, term) {
      if (term == "sync") {
        return 0
      }
      if (term ~ /^[[:alnum:]_]+$/) {
        return boundary_match(s, term)
      }
      return index(s, term) > 0
    }
    function obsidian_match(s, start, rest, close_pos, body, before) {
      start=index(s, "[[")
      while (start > 0) {
        rest=substr(s, start + 2)
        close_pos=index(rest, "]]")
        if (close_pos > 1) {
          body=substr(rest, 1, close_pos - 1)
          before=(start == 1) ? "" : substr(s, start - 1, 1)
          if (before != "[" && before != ":" && body !~ /^:/ && body !~ /^[[:space:]-]/ && body !~ /[[:space:]]/) {
            return 1
          }
        }
        s=substr(s, start + 2)
        start=index(s, "[[")
      }
      return 0
    }
    {
      clean=scrub_allowed($0)
      if (index(clean, "/Users/") > 0 || index(clean, "~/<your-repo>") > 0) {
        printf "FAIL portability: %s:%s contains personal filesystem path\n", rel, FNR > "/dev/stderr"
        found=1
      }
      if (obsidian_match(clean)) {
        printf "FAIL portability: %s:%s contains Obsidian-style private link\n", rel, FNR > "/dev/stderr"
        found=1
      }
      for (i=1; i<=deny_n; i++) {
        if (deny[i] != "" && term_match(clean, deny[i])) {
          printf "FAIL portability: %s:%s contains denied term: %s\n", rel, FNR, deny[i] > "/dev/stderr"
          found=1
        }
      }
      for (i=1; i<=local_deny_n; i++) {
        if (local_deny[i] != "" && term_match(clean, local_deny[i])) {
          printf "FAIL portability: %s:%s contains local denied term: %s\n", rel, FNR, local_deny[i] > "/dev/stderr"
          found=1
        }
      }
    }
    END { exit found ? 1 : 0 }
  ' "$file"
  rc=$?
  if [ "$rc" -ne 0 ]; then
    failures=$((failures + 1))
  fi
done < "$tmp_files"

if [ "$failures" -gt 0 ]; then
  exit 1
fi

if [ -n "$DENYLIST" ]; then
  deny_msg="${DENYLIST#$REPO_ROOT/}"
else
  deny_msg="built-in fallback"
fi
if [ -n "$ALLOWLIST" ]; then
  allow_msg="${ALLOWLIST#$REPO_ROOT/}"
else
  allow_msg="built-in fallback"
fi

printf 'PASS portability: denylist=%s allowlist=%s\n' "$deny_msg" "$allow_msg"
