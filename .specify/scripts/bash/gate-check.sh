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

valid_gate() { case "$1" in TR0|TR1|TR2_TR3|TR4|TR4A|TR5|TR6) return 0;; *) return 1;; esac; }
file_contains() { [ -f "$1" ] && grep -q "$2" "$1" 2>/dev/null; }

# test_depth_validation — validate Must-Meet content patterns for a gate
# Usage: test_depth_validation GATE_ID path1 [path2 ...]
# Output: "criterion|pattern|matched|artifact_path" per line,
#          summary line "depth_validated:true|false"
test_depth_validation() {
    local gate="$1"
    shift
    local all_matched=true
    local output=""
    local found f

    case "$gate" in
        TR0)
            # TR0 has no depth validation patterns
            ;;
        TR1)
            # Pattern 1: User Story heading
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "### User Story( [0-9])?" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}user_story|### User Story( [0-9])?|false|${found}"$'\n'
            else
                output="${output}user_story|### User Story( [0-9])?|true|${found}"$'\n'
            fi

            # Pattern 2: GWT scenarios
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -q "Given.*When.*Then" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}gwt_scenarios|Given.*When.*Then|false|${found}"$'\n'
            else
                output="${output}gwt_scenarios|Given.*When.*Then|true|${found}"$'\n'
            fi

            # Pattern 3: TR Gate Assessment
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -q "TR Gate Assessment" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}gate_assessment|TR Gate Assessment|false|${found}"$'\n'
            else
                output="${output}gate_assessment|TR Gate Assessment|true|${found}"$'\n'
            fi

            # Pattern 4: Feasibility or Risk Register
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "Feasibility|Risk Register" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}feasibility_risk|Feasibility or Risk Register|false|${found}"$'\n'
            else
                output="${output}feasibility_risk|Feasibility or Risk Register|true|${found}"$'\n'
            fi
            ;;
        TR2_TR3)
            # Pattern 1: Gate Readiness
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -q "Gate Readiness" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}gate_readiness|Gate Readiness|false|${found}"$'\n'
            else
                output="${output}gate_readiness|Gate Readiness|true|${found}"$'\n'
            fi

            # Pattern 2: Architecture Decision, Data Model, or API Contract
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "Architecture Decision|Data Model|API Contract" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}arch_decisions|Architecture Decision or Data Model or API Contract|false|${found}"$'\n'
            else
                output="${output}arch_decisions|Architecture Decision or Data Model or API Contract|true|${found}"$'\n'
            fi

            # Pattern 3: Constitution Check or WSJF
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "Constitution Check|WSJF" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}constitution_wsjf|Constitution Check or WSJF|false|${found}"$'\n'
            else
                output="${output}constitution_wsjf|Constitution Check or WSJF|true|${found}"$'\n'
            fi
            ;;
        TR4)
            # Pattern 1: Task checkboxes
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -q -- "- \[ \] T" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}task_checkboxes|- [ ] T|false|${found}"$'\n'
            else
                output="${output}task_checkboxes|- [ ] T|true|${found}"$'\n'
            fi

            # Pattern 2: Gate Completion Verification
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -q "Gate Completion Verification" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}gate_completion|Gate Completion Verification|false|${found}"$'\n'
            else
                output="${output}gate_completion|Gate Completion Verification|true|${found}"$'\n'
            fi

            # Pattern 3: Phase numbering
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -q "Phase [0-9]" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}phases|Phase [0-9]|false|${found}"$'\n'
            else
                output="${output}phases|Phase [0-9]|true|${found}"$'\n'
            fi

            # Pattern 4: Definition of Done or DoD
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "Definition of Done|DoD" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}dod|Definition of Done or DoD|false|${found}"$'\n'
            else
                output="${output}dod|Definition of Done or DoD|true|${found}"$'\n'
            fi
            ;;
        TR4A)
            # Pattern 1: Completed task checkboxes
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -q -- "- \[[xX]\] T" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}completed_tasks|- [x] T|false|${found}"$'\n'
            else
                output="${output}completed_tasks|- [x] T|true|${found}"$'\n'
            fi

            # Pattern 2: Quality Summary or Quality Report
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "Quality Summary|Quality Report" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}quality|Quality Summary or Quality Report|false|${found}"$'\n'
            else
                output="${output}quality|Quality Summary or Quality Report|true|${found}"$'\n'
            fi

            # Pattern 3: Incomplete task checkboxes (for ratio context)
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -q -- "- \[ \] T" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                found="${1:-N/A}"
                output="${output}pending_tasks|- [ ] T (pending)|false|${found}"$'\n'
            else
                output="${output}pending_tasks|- [ ] T (pending)|true|${found}"$'\n'
            fi
            ;;
        TR5)
            # Pattern 1: Cross-artifact or Consistency
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "Cross-artifact|Consistency" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}cross_artifact|Cross-artifact or Consistency|false|${found}"$'\n'
            else
                output="${output}cross_artifact|Cross-artifact or Consistency|true|${found}"$'\n'
            fi

            # Pattern 2: Test Report or Validation
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "Test Report|Validation" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}test_report|Test Report or Validation|false|${found}"$'\n'
            else
                output="${output}test_report|Test Report or Validation|true|${found}"$'\n'
            fi
            ;;
        TR6)
            # Pattern 1: Deployment Verification or Release Notes
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "Deployment Verif|Deploy.*verified|Release Notes" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}deploy_verification|Deployment Verif or Release Notes|false|${found}"$'\n'
            else
                output="${output}deploy_verification|Deployment Verif or Release Notes|true|${found}"$'\n'
            fi

            # Pattern 2: Ops Handover or Operational Readiness
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qE "Ops Handover|Operations.*Handover|Operational Readiness" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -z "$found" ]; then
                all_matched=false; found="${1:-N/A}"
                output="${output}ops_handover|Ops Handover or Operational Readiness|false|${found}"$'\n'
            else
                output="${output}ops_handover|Ops Handover or Operational Readiness|true|${found}"$'\n'
            fi
            ;;
    esac

    if $all_matched; then
        echo "${output}depth_validated:true"
    else
        echo "${output}depth_validated:false"
    fi
}

# test_should_meet — evaluate Should-Meet advisory criteria per gate
# Usage: test_should_meet GATE_ID path1 [path2 ...]
# Output: "criterion|status|score" per line
test_should_meet() {
    local gate="$1"
    shift
    local found f

    case "$gate" in
        TR1)
            # Market attractiveness — check for market analysis content
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qi "Market Analysis\|Market Attractiveness\|Market Size\|TAM\|SAM" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -n "$found" ]; then
                echo "market_attractiveness|pass|1.0"
            else
                echo "market_attractiveness|warn|0.0"
            fi
            ;;
        TR2_TR3)
            # Effort variance — check for effort estimates or story points
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qiE "Effort|Story Point|Estimate|Sizing" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -n "$found" ]; then
                echo "effort_variance|pass|1.0"
            else
                echo "effort_variance|warn|0.0"
            fi
            ;;
        TR4)
            # Velocity — check for velocity or sprint metrics
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qi "Velocity\|Sprint\|Throughput\|Cycle Time" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -n "$found" ]; then
                echo "velocity|pass|1.0"
            else
                echo "velocity|warn|0.0"
            fi
            ;;
        TR5)
            # Beta NPS — check for NPS or Net Promoter Score
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qiE "NPS|Net Promoter|User Satisfaction|CSAT" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -n "$found" ]; then
                echo "beta_nps|pass|1.0"
            else
                echo "beta_nps|warn|0.0"
            fi
            ;;
        TR6)
            # Training pass rate — check for training completion evidence
            found=""
            for f in "$@"; do
                if [ -f "$f" ] && grep -qiE "Training.*Pass|Training.*100%|Training.*Complete" "$f" 2>/dev/null; then
                    found="$f"; break
                fi
            done
            if [ -n "$found" ]; then
                echo "training_pass_rate|pass|1.0"
            else
                echo "training_pass_rate|warn|0.0"
            fi
            ;;
        *)
            # No Should-Meet criteria for gates without advisory checks
            ;;
    esac
}

# Parse depth validation output into JSON-ready variables
# Sets $DEPTH_VALIDATED and $MUST_MEET_JSON in the caller's scope
parse_depth_output() {
    local depth_output="$1"
    DEPTH_VALIDATED="true"
    MUST_MEET_JSON="[]"
    local items=""
    while IFS= read -r line; do
        case "$line" in
            depth_validated:*) DEPTH_VALIDATED="${line#depth_validated:}" ;;
            "") ;;
            *) items="${items}\"${line}\"," ;;
        esac
    done <<< "$depth_output"
    [ -n "$items" ] && MUST_MEET_JSON="[${items%,}]" || MUST_MEET_JSON="[]"
}

check_tr0() {
    local errs=""
    if [ ! -f "$CONSTITUTION" ]; then errs="Constitution not found"
    elif ! file_contains "$CONSTITUTION" "Gate Criteria Reference"; then errs="Constitution missing Gate Criteria Reference"
    fi
    local DEPTH_VALIDATED MUST_MEET_JSON
    parse_depth_output "$(test_depth_validation TR0 "$CONSTITUTION" 2>/dev/null || true)"
    echo "{\"gate\":\"TR0\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'Constitution exists with Gate Criteria Reference' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')],\"must_meet_details\":${MUST_MEET_JSON},\"depth_validated\":\"${DEPTH_VALIDATED}\"}"
}
check_tr1() {
    local errs=""
    if [ ! -f "$SPEC" ]; then errs="Spec not found"
    elif ! file_contains "$SPEC" "TR Gate Assessment"; then errs="Spec missing TR Gate Assessment"
    fi
    local DEPTH_VALIDATED MUST_MEET_JSON
    parse_depth_output "$(test_depth_validation TR1 "$SPEC" 2>/dev/null || true)"
    echo "{\"gate\":\"TR1\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'Spec exists with TR Gate Assessment' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')],\"must_meet_details\":${MUST_MEET_JSON},\"depth_validated\":\"${DEPTH_VALIDATED}\"}"
}
check_tr2_tr3() {
    local errs=""
    if [ ! -f "$PLAN" ]; then errs="Plan not found"
    elif ! file_contains "$PLAN" "Gate Readiness"; then errs="Plan missing Gate Readiness"
    fi
    local DEPTH_VALIDATED MUST_MEET_JSON
    parse_depth_output "$(test_depth_validation TR2_TR3 "$PLAN" 2>/dev/null || true)"
    echo "{\"gate\":\"TR2_TR3\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'Plan exists with Gate Readiness' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')],\"must_meet_details\":${MUST_MEET_JSON},\"depth_validated\":\"${DEPTH_VALIDATED}\"}"
}
check_tr4() {
    local errs=""
    if [ ! -f "$TASKS" ]; then errs="Tasks not found"
    elif ! file_contains "$TASKS" "Gate Completion Verification"; then errs="Tasks missing Gate Completion Verification"
    fi
    local DEPTH_VALIDATED MUST_MEET_JSON
    parse_depth_output "$(test_depth_validation TR4 "$TASKS" 2>/dev/null || true)"
    echo "{\"gate\":\"TR4\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'Tasks exist with Gate Completion Verification' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')],\"must_meet_details\":${MUST_MEET_JSON},\"depth_validated\":\"${DEPTH_VALIDATED}\"}"
}
check_tr4a() {
    local errs="" total=0 completed=0
    if [ ! -f "$TASKS" ]; then errs="Tasks not found"
    else
        while IFS= read -r line; do
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]]+\[[xX]\] ]]; then
                completed=$((completed+1)); total=$((total+1))
            elif [[ "$line" =~ ^[[:space:]]*-[[:space:]]+\[[[:space:]]\] ]]; then
                total=$((total+1))
            fi
        done < "$TASKS"
        [ "$total" -eq 0 ] && errs="No tasks found"
    fi
    local DEPTH_VALIDATED MUST_MEET_JSON
    parse_depth_output "$(test_depth_validation TR4A "$TASKS" 2>/dev/null || true)"
    echo "{\"gate\":\"TR4A\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo "Tasks: $completed/$total completed" || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')],\"must_meet_details\":${MUST_MEET_JSON},\"depth_validated\":\"${DEPTH_VALIDATED}\"}"
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
    local DEPTH_VALIDATED MUST_MEET_JSON
    parse_depth_output "$(test_depth_validation TR5 "$SPEC" "$PLAN" "$TASKS" 2>/dev/null || true)"
    echo "{\"gate\":\"TR5\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'All prior gates passed' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')],\"must_meet_details\":${MUST_MEET_JSON},\"depth_validated\":\"${DEPTH_VALIDATED}\"}"
}
check_tr6() {
    local errs="" gs="$ROOT/.specify/memory/gate-status.json"
    if [ ! -f "$gs" ]; then errs="Gate status file not found"
    else
        for g in TR0 TR1 TR2_TR3 TR4 TR4A TR5; do
            s=$(grep -o "\"$g\":{[^}]*\"status\":\"[^\"]*\"" "$gs" 2>/dev/null | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
            [ "$s" != "passed" ] && errs="${errs}${g} not passed; "
        done
    fi
    if [ -z "$errs" ]; then
        local dep_errs=""
        for pat in "Deployment Verif" "Deploy.*verified" "Release Notes"; do
            if ! file_contains "$SPEC" "$pat" && ! file_contains "$TASKS" "$pat"; then
                dep_errs="${dep_errs}Missing deployment pattern: $pat; "
            fi
        done
        for pat in "Ops Handover" "Operations.*Handover" "Operational Readiness"; do
            if ! file_contains "$SPEC" "$pat" && ! file_contains "$TASKS" "$pat"; then
                dep_errs="${dep_errs}Missing ops handover pattern: $pat; "
            fi
        done
        errs="$dep_errs"
    fi
    local DEPTH_VALIDATED MUST_MEET_JSON
    parse_depth_output "$(test_depth_validation TR6 "$SPEC" "$TASKS" 2>/dev/null || true)"
    echo "{\"gate\":\"TR6\",\"status\":\"$( [ -z "$errs" ] && echo passed || echo failed )\",\"evidence\":\"$( [ -z "$errs" ] && echo 'All prior gates passed, deployment verification and ops handover patterns found' || echo '' )\",\"errors\":[$( [ -n "$errs" ] && echo "\"$errs\"" || echo '')],\"must_meet_details\":${MUST_MEET_JSON},\"depth_validated\":\"${DEPTH_VALIDATED}\"}"
}

! valid_gate "$GATE" && echo '{"status":"failed","errors":["Invalid gate"]}' && exit 1

GATE_ORDER=(TR0 TR1 TR2_TR3 TR4 TR4A TR5 TR6)
IDX=-1; for i in "${!GATE_ORDER[@]}"; do [ "${GATE_ORDER[$i]}" = "$GATE" ] && IDX=$i; done

PRIOR=(); CURRENT=""; ERRORS=""
for ((i=0; i<=IDX; i++)); do
    g="${GATE_ORDER[$i]}"
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

# Should-Meet evaluation
SHOULD_MEET_OUTPUT=$(test_should_meet "$GATE" "$SPEC" "$PLAN" "$TASKS" 2>/dev/null || true)
SHOULD_MEET_JSON=""
while IFS= read -r line; do
    [ -n "$line" ] && SHOULD_MEET_JSON="${SHOULD_MEET_JSON}\"${line}\","
done <<< "$SHOULD_MEET_OUTPUT"
[ -n "$SHOULD_MEET_JSON" ] && SHOULD_MEET_JSON="[${SHOULD_MEET_JSON%,}]" || SHOULD_MEET_JSON="[]"

echo "{\"gate\":\"$GATE\",\"status\":\"$OVERALL\",\"prior_gates\":[$PRIOR_JSON],\"current_gate\":$CURRENT,\"should_meet\":$SHOULD_MEET_JSON,\"errors\":[$( [ -n "$ERRORS" ] && echo "\"$ERRORS\"" || echo '' )]}"
[ "$OVERALL" = "failed" ] && exit 1
exit 0
