#!/usr/bin/env bash
# Gate utility common functions — shared helpers for gate-detect-ipd-mode, gate-check, gate-record
# Source this file from individual gate scripts: . "$(dirname "${BASH_SOURCE[0]}")/gate-common.sh"

# Emit JSON output or plain text based on --json flag
gate_json() {
    local input="$1"
    local json_mode="${2:-false}"
    if [ "$json_mode" = "true" ]; then
        echo "$input"
    else
        echo "$input"
    fi
}

# Test if a file contains a specific pattern (content match, not just file existence)
file_contains() {
    local path="$1"
    local pattern="$2"
    [ -f "$path" ] && grep -q "$pattern" "$path" 2>/dev/null
}

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

# Get repository root
get_repo_root() {
    find_repo_root
}

# Build an absolute path relative to repo root
get_repo_relative_path() {
    local relative_path="$1"
    local root
    root=$(get_repo_root) || return 1
    echo "$root/$relative_path"
}

# Read gate-status.json, return file content (empty string if missing/corrupt)
get_gate_status() {
    local path
    path=$(get_repo_relative_path '.specify/memory/gate-status.json') || return 1
    if [ -f "$path" ]; then
        cat "$path"
    fi
}

# Validate gate ID is a known value (TR6 added for Launch gate)
valid_gate_id() {
    case "$1" in
        TR0|TR1|TR2_TR3|TR4|TR4A|TR5|TR6) return 0 ;;
        *) return 1 ;;
    esac
}

# Validate gate status is a known value (hold and recycled added for IPD decisions)
valid_gate_status() {
    case "$1" in
        passed|pending|failed|skipped|hold|recycled) return 0 ;;
        *) return 1 ;;
    esac
}

# Validate gate decision is a known IPD decision (Go/Kill/Hold/Recycle)
valid_gate_decision() {
    case "$1" in
        Go|Kill|Hold|Recycle|"") return 0 ;;
        *) return 1 ;;
    esac
}

# Get gate dependency order — prints space-separated ordered gates
# Callers should capture via: read -r -a arr <<< "$(get_gate_order)"
get_gate_order() {
    echo "TR0 TR1 TR2_TR3 TR4 TR4A TR5 TR6"
}

# Get prerequisite gates for a given gate (all gates that must pass before this one)
# Prints space-separated list of prerequisite gate IDs.
get_prerequisite_gates() {
    local gate_id="$1"
    local -a order
    read -r -a order <<< "$(get_gate_order)"
    local idx=-1
    for i in "${!order[@]}"; do
        if [ "${order[$i]}" = "$gate_id" ]; then
            idx=$i
            break
        fi
    done
    if [ "$idx" -le 0 ]; then
        return 0
    fi
    echo "${order[@]:0:$idx}"
}

# Validate that prerequisite gates have passed before allowing recording (FR-013)
# Accepts gate_id and a JSON string representing current gate status object.
# Returns JSON result with valid boolean, failed_prerequisites array, and message.
test_gate_order() {
    local gate_id="$1"
    local current_status_json="$2"

    local -a prereqs
    read -r -a prereqs <<< "$(get_prerequisite_gates "$gate_id")"

    local -a failed=()
    local prereq status

    for prereq in "${prereqs[@]}"; do
        # Parse status from JSON: extract "GATE":{"status":"VALUE"} pattern
        # Handle optional whitespace around colons (pretty-printed JSON)
        status=$(echo "$current_status_json" | grep -o "\"$prereq\":[[:space:]]*{[^}]*\"status\":[[:space:]]*\"[^\"]*\"" | grep -o '"status":[[:space:]]*"[^"]*"' | cut -d'"' -f4)
        if [ -z "$status" ] || [ "$status" != "passed" ]; then
            failed+=("$prereq")
        fi
    done

    if [ ${#failed[@]} -gt 0 ]; then
        local failed_csv
        failed_csv=$(IFS=','; echo "${failed[*]}")
        local failed_json
        failed_json=$(echo "$failed_csv" | sed 's/,/","/g')
        echo "{\"valid\":false,\"failed_prerequisites\":[\"$failed_json\"],\"message\":\"Cannot record $gate_id as passed because prerequisite gates have not passed: $failed_csv\"}"
        return 1
    fi

    echo '{"valid":true,"failed_prerequisites":[],"message":""}'
    return 0
}

# Resolve per-feature gate-status.json path (FR-003b, per-feature isolation)
# Reads .specify/feature.json to determine the current feature directory,
# then returns the path to specs/NNN-feature-name/gate-status.json.
# Falls back to legacy .specify/memory/gate-status.json if feature directory not found.
# Usage: get_feature_gate_status_path [legacy_fallback]
#   legacy_fallback: "true" to fall back to legacy path when per-feature path doesn't exist yet
get_feature_gate_status_path() {
    local legacy_fallback="${1:-false}"
    local root
    root=$(get_repo_root) || return 1

    # Try per-feature path first
    local feature_file="$root/.specify/feature.json"
    local feature_dir=""

    if [ -f "$feature_file" ]; then
        # Try jq first (most reliable)
        if command -v jq >/dev/null 2>&1; then
            feature_dir=$(jq -r '.feature_directory // empty' "$feature_file" 2>/dev/null || true)
        fi
        # Fall back to grep/sed
        if [ -z "$feature_dir" ]; then
            feature_dir=$(grep -o '"feature_directory"[[:space:]]*:[[:space:]]*"[^"]*"' "$feature_file" 2>/dev/null | head -1 | sed 's/.*"feature_directory"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || true)
        fi

        if [ -n "$feature_dir" ]; then
            # Normalize relative paths to absolute under repo root
            case "$feature_dir" in
                /*) ;;
                *) feature_dir="$root/$feature_dir" ;;
            esac

            local per_feature_path="$feature_dir/gate-status.json"
            if [ "$legacy_fallback" = "true" ] && [ ! -f "$per_feature_path" ]; then
                local legacy_path="$root/.specify/memory/gate-status.json"
                if [ -f "$legacy_path" ]; then
                    echo "$legacy_path"
                    return 0
                fi
            fi
            echo "$per_feature_path"
            return 0
        fi
    fi

    # Legacy path fallback
    if [ "$legacy_fallback" = "true" ]; then
        local legacy_path="$root/.specify/memory/gate-status.json"
        if [ -f "$legacy_path" ]; then
            echo "$legacy_path"
            return 0
        fi
    fi

    # Default: return per-feature path even if it doesn't exist yet (will be created)
    if [ -n "$feature_dir" ]; then
        echo "$feature_dir/gate-status.json"
    else
        echo "$root/.specify/memory/gate-status.json"
    fi
}
