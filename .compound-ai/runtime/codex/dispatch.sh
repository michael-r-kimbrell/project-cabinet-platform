#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAOS_RUNTIME_NAME="${CAOS_RUNTIME_NAME:-codex}" exec "$SCRIPT_DIR/../generic/dispatch.sh" "$@"
