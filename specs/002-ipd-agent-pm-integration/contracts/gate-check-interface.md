# Contract: Gate Check Pre-Flight Interface

**Purpose**: Define the standard gate check pattern to inject into each
`/speckit-*` skill file before the core command execution logic.

## Standard Gate Check Block

Every skill file MUST add the following block after its "Pre-Execution Checks"
section and before the main "Outline" or "Execution" section:

```markdown
## IPD Gate Check

**Purpose**: Verify that prior IPD TR gates are satisfied before proceeding.
This check only runs when IPD mode is active (constitution has Gate Criteria
Reference section). SDD-only projects pass through silently.

1. Check IPD mode status:
   - Does `.specify/memory/constitution.md` exist?
   - If YES: does it contain a "Gate Criteria Reference" section heading?
   - If BOTH true → IPD mode = ACTIVE → continue to step 2
   - Otherwise → IPD mode = INACTIVE → skip gate check → proceed normally

2. Deep content validation for associated TR gate:
   - [TR_GATE_NAME]: Verify [document_path] contains [required_section/pattern]
   - If PASS → proceed
   - If FAIL → display specific unmet criteria → ask: "Proceed anyway? (yes/no)"
   - If "no" → halt with message: "[TR_GATE_NAME] gate not passed. Run
     `/speckit-analyze` for details."

3. If ALL prior gates also need checking (chained validation):
   - For each prior gate in sequence [TR0 → TR_current]:
     - Run deep content validation
     - If any prior gate FAIL → block with: "Prior gate [TR_N] not passed.
       Complete [command] first."
```

## Per-Command Gate Parameters

| Command | TR Gate | Document to Validate | Required Section/Pattern |
|---------|---------|---------------------|------------------------|
| constitution | TR0 (setup) | `.specify/memory/constitution.md` | "Gate Criteria Reference" section heading |
| specify | TR1 (concept) | `.specify/memory/constitution.md` | "Gate Criteria Reference" + "Agile-Stage-Gate Governance" heading |
| clarify | TR1 (concept) | Same as specify + `spec.md` | All `[NEEDS CLARIFICATION]` resolved |
| plan | TR2/TR3 | `spec.md` | "TR Gate Assessment" section heading |
| tasks | TR4 | `plan.md` | "Gate Readiness" section heading |
| implement | TR4/TR4A | `tasks.md` | "Gate Completion Verification" checkpoints |
| analyze | TR5 | All prior documents | All prior gate criteria evidence collected |

## IPD Detection Implementation

```markdown
# Check IPD mode
CONSTITUTION_FILE=".specify/memory/constitution.md"
IPD_ACTIVE=false
if [ -f "$CONSTITUTION_FILE" ]; then
    if grep -qi "Gate Criteria Reference" "$CONSTITUTION_FILE" 2>/dev/null; then
        IPD_ACTIVE=true
    fi
fi

if [ "$IPD_ACTIVE" = true ]; then
    # Run deep content validation for this command's TR gate
    ...
fi
```
