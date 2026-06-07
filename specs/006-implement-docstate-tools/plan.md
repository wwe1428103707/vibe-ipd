# Implementation Plan: Document-State Tooling Implementation

**Branch**: `main` | **Date**: 2026-06-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/006-implement-docstate-tools/spec.md`

**Note**: This template is filled in by the `/vipd-speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Create 3 centralized utility scripts — `check-gate`, `record-gate`, and `detect-ipd-mode` — that encapsulate the gate validation, gate status recording, and IPD mode detection logic currently duplicated across 8 skill files. Implement in PowerShell (primary, Windows) and Bash (cross-platform). Then refactor the 8 `vipd-*` skill files to call these utilities instead of containing inline logic.

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS — Principle III (Agile-Stage-Gate Governance) and Principle V (Quality Built-In) directly relevant
- **TR Gates Passed**: TR0 (Constitution), TR1 (Spec)
- **Next Gate**: TR4 (Development)

## Technical Context

**Language/Version**: PowerShell 5.1+ (primary) + Bash 3.2+ (cross-platform)

**Primary Dependencies**: Existing `.specify/scripts/powershell/` infrastructure (common.ps1 patterns)

**Storage**: Filesystem — `.specify/scripts/powershell/gate-*.ps1`, `.specify/scripts/bash/gate-*.sh`, `.specify/memory/gate-status.json`

**Testing**: Manual script invocation with `-Json` flag for machine-parseable output validation

**Target Platform**: Windows (PowerShell) / Linux & macOS (Bash)

**Project Type**: CLI utility scripts (no application code)

**Performance Goals**: Each utility must complete in under 1 second for typical project sizes

**Constraints**:
- Must produce machine-parseable JSON output (for skill file consumption)
- Must handle missing/corrupt files gracefully
- Must maintain backward compatibility with existing gate-status.json schema
- PowerShell scripts follow existing common.ps1 patterns

**Scale/Scope**: 3 utility scripts + refactoring 8 skill files to use them

**WSJF Priority Score**: 18 — (Value=7 + Time Criticality=5 + Risk Reduction=5) / Job Size=0.95

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Evidence |
|-----------|-------|----------|
| I. Spec-First | PASS | Spec created with user stories, requirements, success criteria |
| II. Dual-Track Agile | PASS | Tooling supports discovery track gate validation |
| III. Agile-Stage-Gate | PASS | Centralized gate utilities enforce consistent gate progression |
| IV. Cross-Functional PDT | PASS | Tools are role-agnostic — all PDT roles benefit |
| V. Quality Built-In | PASS | Automated gate checks reduce manual verification |

## Project Structure

### Documentation (this feature)

```text
specs/006-implement-docstate-tools/
├── plan.md              # This file (/vipd-speckit-plan command output)
├── research.md          # Phase 0 output (/vipd-speckit-plan command)
├── data-model.md        # Phase 1 output (/vipd-speckit-plan command)
├── quickstart.md        # Phase 1 output (/vipd-speckit-plan command)
├── contracts/           # Phase 1 output (/vipd-speckit-plan command)
└── tasks.md             # Phase 2 output (/vipd-speckit-tasks command - NOT created by /vipd-speckit-plan)
```

### Source Code (repository root)

```text
.specify/
├── scripts/
│   ├── powershell/
│   │   ├── gate-detect-ipd-mode.ps1    # IPD mode detection
│   │   ├── gate-check.ps1              # Gate validation
│   │   └── gate-record.ps1             # Gate status recording
│   └── bash/
│       ├── gate-detect-ipd-mode.sh     # IPD mode detection
│       ├── gate-check.sh               # Gate validation
│       └── gate-record.sh              # Gate status recording
└── memory/
    └── gate-status.json                # Persistent gate progress (existing)
```

**Structure Decision**: PowerShell scripts follow existing `.specify/scripts/powershell/` conventions. Bash scripts mirror the same interface for cross-platform support. Scripts are prefixed with `gate-` for discoverability.

## Complexity Tracking

*No Constitution Check violations — complexity is appropriate for the scope.*
