#!/usr/bin/env bash
# gate-record.sh — Record gate status in per-feature gate-status.json
# Usage: .specify/scripts/bash/gate-record.sh --gate TR1 --status passed --evidence "Spec created"
# Atomic write via temp file + mv
#
# Records a gate decision with full audit trail (FR-014 history tracking).
# Supports IPD decisions: Go, Kill, Hold, Recycle via --decision flag.
# Per-feature isolation via get_feature_gate_status_path().

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/gate-common.sh"

# ============================================================
# Defaults
# ============================================================
GATE=""
STATUS=""
EVIDENCE=""
JSON_OUTPUT=false
FEATURE_DIR_OVERRIDE=""
DECISION=""
DECISION_MAKER=""
DECISION_RATIONALE=""

# ============================================================
# Argument parsing
# ============================================================
while [ $# -gt 0 ]; do
    case "$1" in
        --gate) GATE="$2"; shift 2 ;;
        --status) STATUS="$2"; shift 2 ;;
        --evidence) EVIDENCE="$2"; shift 2 ;;
        --json) JSON_OUTPUT=true; shift ;;
        --feature) FEATURE_DIR_OVERRIDE="$2"; shift 2 ;;
        --decision) DECISION="$2"; shift 2 ;;
        --decision_maker) DECISION_MAKER="$2"; shift 2 ;;
        --decision_rationale) DECISION_RATIONALE="$2"; shift 2 ;;
        --help|-h)
            echo "Usage: $0 --gate GATE_ID --status STATUS --evidence EVIDENCE [options]"
            echo ""
            echo "Required:"
            echo "  --gate GATE_ID         Gate identifier (TR0-TR6)"
            echo "  --status STATUS        Gate status (passed/pending/failed/skipped/hold/recycled)"
            echo "  --evidence TEXT        Evidence text (max 2000 chars)"
            echo ""
            echo "Optional:"
            echo "  --json                 Output JSON instead of human-readable text"
            echo "  --feature DIR          Override feature directory (default: from feature.json)"
            echo "  --decision DECISION    IPD decision (Go/Kill/Hold/Recycle)"
            echo "  --decision_maker NAME  Person who made the decision"
            echo "  --decision_rationale   Rationale for the decision"
            echo ""
            echo "Examples:"
            echo "  $0 --gate TR0 --status passed --evidence 'Constitution ratified'"
            echo "  $0 --gate TR1 --status passed --evidence 'Spec created' --decision Go"
            echo "  $0 --gate TR4 --status hold --evidence 'Blocked on review' --decision Hold --decision_maker 'PM'"
            exit 0 ;;
        *) echo "Unknown arg: $1" >&2; exit 1 ;;
    esac
done

# ============================================================
# Validate required arguments
# ============================================================
ERRORS=""
[ -z "$GATE" ] && ERRORS="${ERRORS}Missing --gate; "
[ -z "$STATUS" ] && ERRORS="${ERRORS}Missing --status; "
[ -z "$EVIDENCE" ] && ERRORS="${ERRORS}Missing --evidence; "

if [ -n "$ERRORS" ]; then
    if [ "$JSON_OUTPUT" = "true" ]; then
        echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"${ERRORS%?}\"]}"
    else
        echo "Error: ${ERRORS%?}" >&2
    fi
    exit 1
fi

# ============================================================
# Validate gate ID, status, and decision
# ============================================================
if ! valid_gate_id "$GATE"; then
    MSG="Invalid gate: $GATE. Valid: TR0, TR1, TR2_TR3, TR4, TR4A, TR5, TR6"
    if [ "$JSON_OUTPUT" = "true" ]; then
        echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"$MSG\"]}"
    else
        echo "Error: $MSG" >&2
    fi
    exit 1
fi

if ! valid_gate_status "$STATUS"; then
    MSG="Invalid status: $STATUS. Use: passed, pending, failed, skipped, hold, recycled"
    if [ "$JSON_OUTPUT" = "true" ]; then
        echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"$MSG\"]}"
    else
        echo "Error: $MSG" >&2
    fi
    exit 1
fi

if [ -n "$DECISION" ] && ! valid_gate_decision "$DECISION"; then
    MSG="Invalid decision: $DECISION. Use: Go, Kill, Hold, Recycle"
    if [ "$JSON_OUTPUT" = "true" ]; then
        echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"$MSG\"]}"
    else
        echo "Error: $MSG" >&2
    fi
    exit 1
fi

# ============================================================
# Truncate evidence if needed (max 2000 chars, per FR-014)
# ============================================================
if [ ${#EVIDENCE} -gt 2000 ]; then
    EVIDENCE="${EVIDENCE:0:1997}..."
fi

# ============================================================
# Resolve repo root and gate-status.json path
# ============================================================
ROOT=$(get_repo_root) || {
    MSG="No .specify directory found -- not in a vipd project"
    if [ "$JSON_OUTPUT" = "true" ]; then
        echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"$MSG\"]}"
    else
        echo "Error: $MSG" >&2
    fi
    exit 1
}

if [ -n "$FEATURE_DIR_OVERRIDE" ]; then
    # User-supplied override for feature directory
    case "$FEATURE_DIR_OVERRIDE" in
        /*) GATE_STATUS_PATH="$FEATURE_DIR_OVERRIDE/gate-status.json" ;;
        *) GATE_STATUS_PATH="$ROOT/$FEATURE_DIR_OVERRIDE/gate-status.json" ;;
    esac
else
    # Resolve from feature.json (per-feature isolation, FR-003b)
    GATE_STATUS_PATH=$(get_feature_gate_status_path)
fi

GATE_DIR=$(dirname "$GATE_STATUS_PATH")
mkdir -p "$GATE_DIR"

# ============================================================
# Load existing gate-status.json or create skeleton
# The skeleton includes all 7 TR gates (TR0-TR6) set to "pending".
# ============================================================
TODAY=$(date +%Y-%m-%d)

if [ -f "$GATE_STATUS_PATH" ]; then
    GATE_JSON=$(cat "$GATE_STATUS_PATH")
else
    # Detect ipd_mode from legacy file if present
    IPD_MODE=false
    LEGACY_PATH="$ROOT/.specify/memory/gate-status.json"
    if [ -f "$LEGACY_PATH" ]; then
        grep -q '"ipd_mode"[[:space:]]*:[[:space:]]*true' "$LEGACY_PATH" 2>/dev/null && IPD_MODE=true
    fi

    GATE_JSON=$(cat <<SKELETON
{
  "ipd_mode": ${IPD_MODE},
  "last_updated": "${TODAY}",
  "gates": {
    "TR0": {"status": "pending", "evidence": "", "date": null},
    "TR1": {"status": "pending", "evidence": "", "date": null},
    "TR2_TR3": {"status": "pending", "evidence": "", "date": null},
    "TR4": {"status": "pending", "evidence": "", "date": null},
    "TR4A": {"status": "pending", "evidence": "", "date": null},
    "TR5": {"status": "pending", "evidence": "", "date": null},
    "TR6": {"status": "pending", "evidence": "", "date": null}
  }
}
SKELETON
    )
fi

# ============================================================
# Validate gate ordering (FR-013)
# Reject recording when prerequisite gates have not passed.
# Flatten JSON to one line so test_gate_order() grep works reliably.
# ============================================================
GATE_JSON_FLAT=$(echo "$GATE_JSON" | tr -d '\r\n' | tr -s ' ')

if ! ORDER_OUTPUT=$(test_gate_order "$GATE" "$GATE_JSON_FLAT" 2>/dev/null); then
    ORDER_MSG=$(echo "$ORDER_OUTPUT" | grep -o '"message":"[^"]*"' | cut -d'"' -f4)
    if [ "$JSON_OUTPUT" = "true" ]; then
        echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"$ORDER_MSG\"]}"
    else
        echo "Error: $ORDER_MSG" >&2
    fi
    exit 1
fi

# ============================================================
# Update gate status in JSON
# Extract previous status for audit trail, then build updated JSON.
# Uses jq if available; falls back to python (venv) then python3.
# ============================================================
# Extract previous status from existing JSON for history tracking.
# Note: strip both CR (\r) and LF (\n) for Windows CRLF compatibility.
PREV_STATUS=$(echo "$GATE_JSON_FLAT" | grep -o "\"$GATE\":[[:space:]]*{[^}]*\"status\":[[:space:]]*\"[^\"]*\"" | grep -o '"status":[[:space:]]*"[^"]*"' | cut -d'"' -f4 || true)
[ -z "$PREV_STATUS" ] && PREV_STATUS="pending"

UPDATED_JSON=""

if command -v jq >/dev/null 2>&1; then
    # Use jq for safe, structured JSON manipulation
    JQ_FILTER='
      .last_updated = $today
      | .gates[$gate].status = $status
      | .gates[$gate].evidence = $evidence
      | .gates[$gate].date = $today
      | if $decision != "" then .gates[$gate].decision = $decision else . end
      | if $decision_maker != "" then .gates[$gate].decision_maker = $decision_maker else . end
      | if $decision_rationale != "" then .gates[$gate].decision_rationale = $decision_rationale else . end
      | .gates[$gate].history = (.gates[$gate].history // []) + [{"from": $prev_status, "to": $status, "date": $today, "evidence": $evidence}]
    '

    UPDATED_JSON=$(echo "$GATE_JSON" | jq \
        --arg gate "$GATE" \
        --arg status "$STATUS" \
        --arg evidence "$EVIDENCE" \
        --arg today "$TODAY" \
        --arg decision "$DECISION" \
        --arg decision_maker "$DECISION_MAKER" \
        --arg decision_rationale "$DECISION_RATIONALE" \
        --arg prev_status "$PREV_STATUS" \
        "$JQ_FILTER"
    ) || {
        MSG="jq update failed"
        if [ "$JSON_OUTPUT" = "true" ]; then
            echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"$MSG\"]}"
        else
            echo "Error: $MSG" >&2
        fi
        exit 1
    }
elif command -v python >/dev/null 2>&1; then
    # Fallback to Python for JSON manipulation
    UPDATED_JSON=$(GATE="$GATE" STATUS="$STATUS" EVIDENCE="$EVIDENCE" TODAY="$TODAY" DECISION="$DECISION" DECISION_MAKER="$DECISION_MAKER" DECISION_RATIONALE="$DECISION_RATIONALE" PREV_STATUS="$PREV_STATUS" python -c "
import json, os, sys

data = json.load(sys.stdin)
gate = os.environ['GATE']
status = os.environ['STATUS']
evidence = os.environ['EVIDENCE']
today = os.environ['TODAY']
decision = os.environ['DECISION']
decision_maker = os.environ['DECISION_MAKER']
decision_rationale = os.environ['DECISION_RATIONALE']
prev_status = os.environ['PREV_STATUS']

# Ensure gate entry exists in the gates map
if gate not in data.get('gates', {}):
    data['gates'][gate] = {}

data['last_updated'] = today
data['gates'][gate]['status'] = status
data['gates'][gate]['evidence'] = evidence
data['gates'][gate]['date'] = today

if decision:
    data['gates'][gate]['decision'] = decision
if decision_maker:
    data['gates'][gate]['decision_maker'] = decision_maker
if decision_rationale:
    data['gates'][gate]['decision_rationale'] = decision_rationale

# Append audit trail entry (FR-014)
history = data['gates'][gate].get('history', [])
history.append({
    'from': prev_status,
    'to': status,
    'date': today,
    'evidence': evidence
})
data['gates'][gate]['history'] = history

print(json.dumps(data, indent=2, ensure_ascii=False))
" <<< "$GATE_JSON"
    ) || {
        MSG="python JSON update failed"
        if [ "$JSON_OUTPUT" = "true" ]; then
            echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"$MSG\"]}"
        else
            echo "Error: $MSG" >&2
        fi
        exit 1
    }
elif command -v python3 >/dev/null 2>&1; then
    # Fallback to python3 (may be Windows Store redirect stub)
    UPDATED_JSON=$(GATE="$GATE" STATUS="$STATUS" EVIDENCE="$EVIDENCE" TODAY="$TODAY" DECISION="$DECISION" DECISION_MAKER="$DECISION_MAKER" DECISION_RATIONALE="$DECISION_RATIONALE" PREV_STATUS="$PREV_STATUS" python3 -c "
import json, os, sys

data = json.load(sys.stdin)
gate = os.environ['GATE']
status = os.environ['STATUS']
evidence = os.environ['EVIDENCE']
today = os.environ['TODAY']
decision = os.environ['DECISION']
decision_maker = os.environ['DECISION_MAKER']
decision_rationale = os.environ['DECISION_RATIONALE']
prev_status = os.environ['PREV_STATUS']

# Ensure gate entry exists in the gates map
if gate not in data.get('gates', {}):
    data['gates'][gate] = {}

data['last_updated'] = today
data['gates'][gate]['status'] = status
data['gates'][gate]['evidence'] = evidence
data['gates'][gate]['date'] = today

if decision:
    data['gates'][gate]['decision'] = decision
if decision_maker:
    data['gates'][gate]['decision_maker'] = decision_maker
if decision_rationale:
    data['gates'][gate]['decision_rationale'] = decision_rationale

# Append audit trail entry (FR-014)
history = data['gates'][gate].get('history', [])
history.append({
    'from': prev_status,
    'to': status,
    'date': today,
    'evidence': evidence
})
data['gates'][gate]['history'] = history

print(json.dumps(data, indent=2, ensure_ascii=False))
" <<< "$GATE_JSON"
    ) || {
        MSG="python3 JSON update failed"
        if [ "$JSON_OUTPUT" = "true" ]; then
            echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"$MSG\"]}"
        else
            echo "Error: $MSG" >&2
        fi
        exit 1
    }
else
    MSG="Cannot update gate status: none of jq, python, or python3 is available. Install one and retry."
    if [ "$JSON_OUTPUT" = "true" ]; then
        echo "{\"gate\":\"$GATE\",\"status\":\"error\",\"errors\":[\"$MSG\"]}"
    else
        echo "Error: $MSG" >&2
    fi
    exit 1
fi

# ============================================================
# Atomic write: write to temp file in same directory, then mv
# Ensures we never leave a partially-written gate-status.json.
# ============================================================
TMP_FILE="${GATE_STATUS_PATH}.tmp"
echo "$UPDATED_JSON" > "$TMP_FILE"
mv "$TMP_FILE" "$GATE_STATUS_PATH"

# ============================================================
# Output
# ============================================================
if [ "$JSON_OUTPUT" = "true" ]; then
    echo "$UPDATED_JSON"
else
    echo "Gate:       $GATE"
    echo "Status:     $STATUS"
    echo "Evidence:   $EVIDENCE"
    echo "Date:       $TODAY"
    if [ -n "$DECISION" ]; then
        echo "Decision:   $DECISION"
    fi
    if [ -n "$DECISION_MAKER" ]; then
        echo "Decision Maker: $DECISION_MAKER"
    fi
    if [ -n "$DECISION_RATIONALE" ]; then
        echo "Rationale:  $DECISION_RATIONALE"
    fi
    echo "File:       $GATE_STATUS_PATH"
fi

exit 0
