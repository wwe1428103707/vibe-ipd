# Implementation Plan: IPD Migration Functional Gaps

**Branch**: `009-ipd-migration-gaps` | **Date**: 2026-06-07 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/009-ipd-migration-gaps/spec.md`

## Summary

Fill 25 functional gaps in the VIPD toolchain where IPD governance intent (defined in the constitution) is not yet implemented in code, scripts, templates, and agent skills. The gaps fall into six categories: (1) gate system completeness (TR6, depth of validation, enforcement), (2) Python CLI integration (subprocess invocation of gate scripts), (3) per-feature gate tracking (migration from project-level to per-feature gate-status.json), (4) workflow and skill adaptation (IPD-aware agent skills, workflows, templates), (5) IPD-specific features (Product Trio, CBB, WSJF, RACI), and (6) documentation and naming cleanup. Implementation follows the SpecKit subprocess pattern — calling existing PS1/Bash gate scripts via `subprocess.run()` and parsing JSON output, not reimplementing gate logic in Python.

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS — all five principles are addressed by the requirements
- **TR Gates Passed**: TR0, TR1
- **Next Gate**: TR2/TR3 (this plan)

## Technical Context

**Language/Version**: Python 3.11+ (CLI), PowerShell 7+ (gate scripts), Bash (gate scripts)

**Primary Dependencies**: Typer (CLI framework), Rich (terminal rendering), PyYAML (workflow config), existing PS1/Bash gate scripts

**Storage**: Per-feature `specs/NNN-feature-name/gate-status.json` (migrated from project-level `.specify/memory/gate-status.json`)

**Testing**: pytest for Python CLI, Pester for PowerShell scripts, bash script direct invocation for Bash

**Target Platform**: Cross-platform (Windows PowerShell + Bash on Linux/macOS)

**Project Type**: CLI tool / developer productivity framework

**Performance Goals**: Gate checks must complete in <2 seconds; no noticeable latency added to command invocation

**Constraints**: Hard gate model — failed gate checks block command execution entirely; no bypass mechanism

**Scale/Scope**: 27 FRs across 9 user stories, touching ~30 files across scripts, CLI, skills, templates, and docs

**WSJF Priority Score**: (Value 8 + Time Criticality 7 + Risk Reduction 9) / Job Size 5 = **4.8**

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| I. Spec-First, Intent-Driven | ✅ PASS | This plan is derived from the spec; all FRs trace to spec requirements |
| II. Dual-Track Agile | ✅ PASS | FR-006 implements Product Trio review enforcement for TR1 |
| III. Agile-Stage-Gate Governance | ✅ PASS | FR-001 through FR-005, FR-013, FR-025 implement full gate lifecycle with hard enforcement |
| IV. Cross-Functional PDT | ✅ PASS | FR-009 implements RACI-aware agent assignment; FR-007 implements CBB catalog |
| V. Quality Built-In | ✅ PASS | FR-002, FR-003 implement substantive gate validation; FR-012 makes tests mandatory in IPD mode |

## Project Structure

### Documentation (this feature)

```text
specs/009-ipd-migration-gaps/
├── spec.md              # Feature specification
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── contracts/           # Phase 1 output
    ├── gate-enforcement-contract.md
    ├── per-feature-gate-status-contract.md
    └── gate-check-depth-contract.md
```

### Source Code (repository root)

```text
.specify/
├── memory/
│   ├── constitution.md          # FR-024: update LPDT+PO conflict note
│   └── cbb-catalog.md           # FR-007: new CBB catalog template
├── scripts/
│   ├── powershell/
│   │   ├── gate-check.ps1       # FR-001,FR-002,FR-013: add TR6, depth validation, ordering
│   │   ├── gate-record.ps1      # FR-013,FR-014,FR-025: ordering, audit trail, Go/Kill/Hold/Recycle
│   │   ├── gate-common.ps1      # FR-001: add TR6 to valid IDs, per-feature path support
│   │   ├── gate-detect-ipd-mode.ps1  # FR-011: add per-feature path resolution
│   │   ├── check-prerequisites.ps1    # FR-021: add gate prerequisite validation
│   │   ├── setup-plan.ps1             # FR-021: add TR1 gate check
│   │   └── setup-tasks.ps1            # FR-021: add TR2_TR3 gate check
│   └── bash/
│       ├── gate-check.sh         # FR-001,FR-002,FR-020: add TR6, depth, fix double-invocation bug
│       ├── gate-record.sh         # FR-013,FR-014,FR-025: new file (missing Bash equivalent)
│       └── gate-common.sh         # FR-001: add TR6, per-feature path support
├── templates/
│   ├── tasks-template.md         # FR-012,FR-017: mandatory tests, RACI, quality gates
│   ├── checklist-template.md     # FR-016: IPD sections
│   ├── plan-template.md           # FR-007: CBB reuse section
│   └── constitution-template.md  # FR-006: Trio review in TR1 criteria
├── workflows/
│   └── vipd/                     # FR-019: migrated from speckit/
│       └── workflow.yml           # FR-005,FR-019: IPD gate steps, vipd commands
└── extensions.yml                 # FR-005: updated hook commands

src/specify_cli/
├── __init__.py                    # FR-004: gate enforcement decorators on vipd-plan, vipd-tasks, etc.
├── _gate_utils.py                 # FR-004: new module — subprocess gate invocation utilities
├── commands/
│   └── check.py                   # FR-004,FR-011: extend check command with --gate-status
├── workflows/
│   └── steps/
│       └── gate/
│           └── __init__.py        # FR-005: extend GatewayStep with IPD gate script invocation

.claude/skills/
├── vipd-agent-assign-assign/SKILL.md    # FR-009,FR-018: rename + RACI awareness
├── vipd-agent-assign-execute/SKILL.md   # FR-010,FR-018: rename + TR4 gate check
├── vipd-agent-assign-validate/SKILL.md  # FR-018: rename
├── vipd-analyze/SKILL.md               # FR-011: Gate Status Summary section
├── vipd-agent-assign-lpdt/SKILL.md      # FR-023: concrete Must-Meet criteria
├── vipd-agent-assign-lpdt-po/SKILL.md   # FR-024: conflict of interest mitigation
├── vipd-specify/SKILL.md               # FR-006: Product Trio review in TR1 evidence
├── vipd-clarify/SKILL.md               # FR-006: Product Trio review conditional pass
├── vipd-tasks/SKILL.md                  # FR-012: mandatory tests in IPD mode
└── vipd-taskstoissues/SKILL.md          # FR-022: TR4 gate check

README.md                                # FR-015: IPD workflow documentation
```

**Structure Decision**: Single project (Option 1). All changes are within the existing monorepo structure — Python CLI, PowerShell/Bash scripts, agent skill markdown, and templates.

## Complexity Tracking

> No constitution violations. All changes follow existing patterns (subprocess invocation, skill markdown, template augmentation).

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | N/A |