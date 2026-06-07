#!/usr/bin/env bash
# gate-detect-ipd-mode.sh — Detect whether IPD mode is active
# Usage: .specify/scripts/bash/gate-detect-ipd-mode.sh [--json]
# Returns: {"ipd_mode": true/false}

set -euo pipefail

JSON=false
for arg in "$@"; do
    case "$arg" in
        --json) JSON=true ;;
    esac
done

# Find repo root by locating .specify directory
find_repo_root() {
    local dir
    dir=$(pwd)
    while [ -n "$dir" ]; do
        if [ -d "$dir/.specify" ]; then
            echo "$dir"
            return 0
        fi
        dir="${dir%/*}"
        [ "$dir" = "" ] && break
    done
    return 1
}

ROOT=$(find_repo_root) || {
    if $JSON; then echo '{"ipd_mode":false}'; else echo "IPD mode: INACTIVE (no .specify directory found)"; fi
    exit 0
}

CONSTITUTION="$ROOT/.specify/memory/constitution.md"
IPD_MODE=false
REASON=""

if [ ! -f "$CONSTITUTION" ]; then
    REASON="Constitution not found at .specify/memory/constitution.md"
elif ! grep -q "Gate Criteria Reference" "$CONSTITUTION" 2>/dev/null; then
    REASON="Constitution exists but does not contain Gate Criteria Reference section"
else
    IPD_MODE=true
fi

if $JSON; then
    echo "{\"ipd_mode\":$IPD_MODE}"
else
    if $IPD_MODE; then
        echo "IPD mode: ACTIVE"
    else
        echo "IPD mode: INACTIVE ($REASON)"
    fi
fi
exit 0
