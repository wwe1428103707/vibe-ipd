# Quickstart: IPD Migration Functional Gaps

**Feature**: 009-ipd-migration-gaps | **Date**: 2026-06-07

## Overview

This feature fills 25 functional gaps in the VIPD toolchain where IPD governance intent (defined in the constitution) is not yet implemented. The changes span six categories: gate system completeness, Python CLI integration, per-feature gate tracking, workflow/skill adaptation, IPD-specific features (Trio, CBB, WSJF, RACI), and documentation/naming cleanup.

## Quick Start

### Prerequisites

1. All prior feature implementation (006, 007, 008) is complete
2. Gate scripts are deployed to `.specify/scripts/{powershell,bash}/`
3. Python CLI `specify` is installed and working
4. IPD mode is active (constitution contains "Gate Criteria Reference")

### Verify Current State

```bash
# Check IPD mode is active
pwsh -File .specify/scripts/powershell/gate-detect-ipd-mode.ps1 -Json

# Check current gate status
pwsh -File .specify/scripts/powershell/gate-check.ps1 -Gate TR1 -Json

# List gate-status.json (project-level, will be migrated)
cat .specify/memory/gate-status.json
```

### Implementation Order

The implementation is organized into 7 phases, ordered by dependency:

1. **Phase 1 — Foundation**: Gate script enhancements (TR6, depth validation, ordering, audit trail, per-feature paths, bug fix)
2. **Phase 2 — CLI Integration**: `_gate_utils.py`, command decorators, `specify check --gate-status`
3. **Phase 3 — Workflow & GatewayStep**: Extend workflow engine, migrate workflow to vipd/
4. **Phase 4 — Agent Skills**: Rename assign/execute/validate, add IPD awareness, TR4 gate check, Gate Status Summary
5. **Phase 5 — Templates**: tasks (RACI, mandatory tests), checklist (IPD sections), plan (CBB), constitution (Trio)
6. **Phase 6 — New Features**: CBB catalog, Product Trio review, WSJF rubric, Go/Kill/Hold/Recycle decisions
7. **Phase 7 — Documentation & Cleanup**: README, naming, LPDT concrete criteria, LPDT+PO conflict note

### Key Files to Touch

| Category | Files | Phase |
|----------|-------|-------|
| Gate scripts (PS1/Bash) | `gate-common.ps1`, `gate-check.ps1`, `gate-record.ps1`, `gate-detect-ipd-mode.ps1`, `gate-check.sh`, `gate-record.sh` (new), `gate-common.sh` | 1 |
| Python CLI | `_gate_utils.py` (new), `__init__.py`, `commands/check.py` | 2 |
| Workflow engine | `steps/gate/__init__.py`, `workflows/vipd/workflow.yml` (new) | 3 |
| Agent Skills | `assign/SKILL.md`, `execute/SKILL.md`, `validate/SKILL.md`, `analyze/SKILL.md`, `specify/SKILL.md`, `clarify/SKILL.md`, `tasks/SKILL.md`, `taskstoissues/SKILL.md`, `lpdt/SKILL.md`, `lpdt-po/SKILL.md` | 4 |
| Templates | `tasks-template.md`, `checklist-template.md`, `plan-template.md`, `constitution-template.md` | 5 |
| New files | `.specify/memory/cbb-catalog.md`, `.specify/workflows/vipd/workflow.yml` | 6 |
| Documentation | `README.md`, `lpdt/SKILL.md`, `lpdt-po/SKILL.md` | 7 |

### Testing Strategy

1. **Gate scripts**: Run `gate-check.ps1 -Gate TR6` (should fail gracefully since TR6 is new), `gate-record.ps1 -Gate TR6 -Status passed -Evidence "test"` (should succeed after prior gates pass)
2. **Depth validation**: Create a spec with only a "TR Gate Assessment" heading and verify TR1 fails with specific "Must-Meet criterion not met" messages
3. **Hard gate enforcement**: Run `vipd-plan` without TR1 passed and verify it blocks with a clear error message
4. **Per-feature gates**: Create gate-status.json in a feature directory and verify scripts read it correctly
5. **Out-of-order recording**: Attempt `gate-record.ps1 -Gate TR4` before TR1 and verify the error message
6. **Gate Status Summary**: Run `vipd-analyze` in IPD mode and verify it includes a gate compliance table