#!/usr/bin/env bash
# gate-check.sh — Validate whether a specific TR gate has passed
# Usage: .specify/scripts/bash/gate-check.sh --gate TR1 [--json]

set -euo pipefail

GATE=""
JSON=false
while [ $# -gt 0 ]; do
    case "$1" in
        --gate) GATE="$2"; shift 2 ;;
        --json) JSON=true; shift ;;
        *) echo "Unknown arg: $1"; exit 1 ;;
    esac
done

find_repo_root() {
    local dir
    dir=$(pwd)
    while [ -n "$dir" ]; do
        if [ -d "$dir/.specify" ]; then echo "$dir"; return 0; fi
        dir="${dir%/*}"; [ "$dir" = "" ] && break
    done
    return 1
}

ROOT=$(find_repo_root) || { echo '{"gate":"","status":"failed","errors":["No .specify directory found"]}'; exit 1; }
CONSTITUTION="$ROOT/.specify/memory/constitution.md"
FEATURE_JSON="$ROOT/.specify/feature.json"
FEATURE_DIR=""
if [ -f "$FEATURE_JSON" ]; then
    FD=$(grep -o '"feature_directory"[[:space:]]*:[[:space:]]*"[^"]*"' "$FEATURE_JSON" | head -1 | sed 's/.*"feature_directory"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
    if [ -n "$FD" ]; then
        case "$FD" in
            /*) FEATURE_DIR="$FD" ;;
            *) FEATURE_DIR="$ROOT/$FD" ;;
        esac
    fi
fi
SPEC="$FEATURE_DIR/spec.md"
PLAN="$FEATURE_DIR/plan.md"
TASKS="$FEATURE_DIR/tasks.md"

valid_gate() { case "$1" in TR0|TR1|TR2_TR3|TR4|TR4A|TR5) return 0;; *) return 1;; esac; }
file_contains() { [ -f "$1" ] && grep -q "$2" "$1" 2>/dev/null; }

check_tr0() {
    local errs=""
    if [ ! -f "$CONSTITUTION" ]; then errs="Constitution not found"
    elif ! file_contains "$CONSTITUTION" "Gate Criteria Reference"; then errs="Constitution missing Gate Criteria Reference"
    fi
    echo "{\"gate\":\"TR0\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'Constitution exists with Gate Criteria Reference' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')]}"
}
check_tr1() {
    local errs=""
    if [ ! -f "$SPEC" ]; then errs="Spec not found"
    elif ! file_contains "$SPEC" "TR Gate Assessment"; then errs="Spec missing TR Gate Assessment"
    fi
    echo "{\"gate\":\"TR1\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'Spec exists with TR Gate Assessment' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')]}"
}
check_tr2_tr3() {
    local errs=""
    if [ ! -f "$PLAN" ]; then errs="Plan not found"
    elif ! file_contains "$PLAN" "Gate Readiness"; then errs="Plan missing Gate Readiness"
    fi
    echo "{\"gate\":\"TR2_TR3\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'Plan exists with Gate Readiness' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')]}"
}
check_tr4() {
    local errs=""
    if [ ! -f "$TASKS" ]; then errs="Tasks not found"
    elif ! file_contains "$TASKS" "Gate Completion Verification"; then errs="Tasks missing Gate Completion Verification"
    fi
    echo "{\"gate\":\"TR4\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'Tasks exist with Gate Completion Verification' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')]}"
}
check_tr4a() {
    local errs="" total=0 completed=0
    if [ ! -f "$TASKS" ]; then errs="Tasks not found"
    else
        while IFS= read -r line; do
            case "$line" in
                *'- ['[xX']']'*T[0-9][0-9][0-9]*) completed=$((completed+1)); total=$((total+1)) ;;
                *'- ['[[:space:]]']'*T[0-9][0-9][0-9]*) total=$((total+1)) ;;
            esac
        done < "$TASKS"
        [ "$total" -eq 0 ] && errs="No tasks found"
    fi
    echo "{\"gate\":\"TR4A\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo "Tasks: $completed/$total completed" || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')]}"
}
check_tr5() {
    local errs="" gs="$ROOT/.specify/memory/gate-status.json"
    if [ ! -f "$gs" ]; then errs="Gate status file not found"
    else
        for g in TR0 TR1 TR2_TR3 TR4 TR4A; do
            s=$(grep -o "\"$g\":{[^}]*\"status\":\"[^\"]*\"" "$gs" 2>/dev/null | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
            [ "$s" != "passed" ] && errs="${errs}${g} not passed; "
        done
    fi
    echo "{\"gate\":\"TR5\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'All prior gates passed' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')]}"
}

! valid_gate "$GATE" && echo '{"status":"failed","errors":["Invalid gate"]}' && exit 1

GATE_ORDER=(TR0 TR1 TR2_TR3 TR4 TR4A TR5)
IDX=-1; for i in "${!GATE_ORDER[@]}"; do [ "${GATE_ORDER[$i]}" = "$GATE" ] && IDX=$i; done

PRIOR=(); CURRENT=""; ERRORS=""
for ((i=0; i<=IDX; i++)); do
    g="${GATE_ORDER[$i]}"
    result=$(check_$(echo "$g" | tr '[:upper:]' '[:lower:]' | tr '_' '_'))
    # Use tr to lowercase and handle TR2_TR3 -> check_tr2_tr3
    # Need to normalize gate names
    fname="check_$(echo "$g" | tr '[:upper:]' '[:lower:]')"
    result=$($fname)
    if [ "$i" -lt "$IDX" ]; then
        PRIOR+=("$result")
        s=$(echo "$result" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
        [ "$s" != "passed" ] && ERRORS="${ERRORS}${g} failed; "
    else
        CURRENT="$result"
    fi
done

OVERALL="passed"; [ -n "$ERRORS" ] && OVERALL="failed"

PRIOR_JSON=""; sep=""
for p in "${PRIOR[@]}"; do PRIOR_JSON="${PRIOR_JSON}${sep}${p}"; sep=","; done

echo "{\"gate\":\"$GATE\",\"status\":\"$OVERALL\",\"prior_gates\":[$PRIOR_JSON],\"current_gate\":$CURRENT,\"errors\":[$( [ -n "$ERRORS" ] && echo "\"$ERRORS\"" || echo '' )]}"
[ "$OVERALL" = "failed" ] && exit 1
exit 0
