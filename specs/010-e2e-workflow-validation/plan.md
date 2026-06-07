# Implementation Plan: End-to-End Workflow Validation

**Branch**: `010-e2e-workflow-validation` | **Date**: 2026-06-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/010-e2e-workflow-validation/spec.md`

**Note**: This template is filled in by the `/vipd-plan` command.

## Summary

Validate the project's IPD-Agile toolchain by running a full specification-to-implementation workflow against a trivial sample CLI project ("hello-world" greeting tool). Create the sample project under `samples/e2e-validate-hello`, then execute the complete phase sequence (specify → plan → tasks → implement → analyze). Success is measured by: (1) all commands executing without unhandled errors, (2) each phase producing the expected artifact, (3) cross-artifact consistency verified in the final analysis step.

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS
- **TR Gates Passed**: TR0 (Constitution), TR1 (Spec)
- **Next Gate**: TR2/TR3 (Plan & Design) — current gate

## Technical Context

**Language/Version**: The validation is language-agnostic — the sample project can be any simple scripting language. Primary focus is on the toolchain behavior, not the sample code itself.

**Primary Dependencies**: No external dependencies required. Uses the project's built-in `/vipd-*` skill commands and Claude Code environment.

**Storage**: Filesystem only — artifacts created as `.md` files in `specs/010-e2e-workflow-validation/` and sample source files under `samples/e2e-validate-hello/`.

**Testing**: Manual validation by observing command outputs and verifying artifact existence. The `analyze` step provides automated cross-artifact consistency checks.

**Target Platform**: Claude Code CLI environment on Windows 11 (PowerShell + bash).

**Project Type**: Workflow validation / meta-testing — the deliverable is proof that the toolchain functions correctly.

**Performance Goals**: Not applicable — this is a functional validation, not a performance test.

**Constraints**:
- All `/vipd-*` commands must be invocable from within Claude Code
- The sample project must be minimal (hello-world level) to avoid scope creep
- Must work within existing permission model (Claude Code auto-mode)
- Must not require external services or network access
- Must be reproducible: the same sequence run twice should produce the same outcomes

**Scale/Scope**: Single feature, one sample project, one full workflow cycle. Breadth over depth — touch every command, but keep each step lightweight.

**WSJF Priority Score**: N/A — validation feature, no backlog estimation required.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Principle I — Spec-First, Intent-Driven Development

| Criteria | Status | Evidence |
|----------|--------|----------|
| Spec exists before planning | ✅ PASS | `spec.md` created at `specs/010-e2e-workflow-validation/spec.md` |
| Spec defines what & why, defers how | ✅ PASS | Spec describes workflow validation outcomes, not implementation tools |
| Spec contains independently testable user stories | ✅ PASS | 4 user stories (3 P1, 1 P2) each with independent tests and acceptance criteria |
| Spec refined iteratively | ✅ PASS | Clarify step (`/vipd-clarify`) is part of the planned workflow |

### Principle II — Dual-Track Agile

| Criteria | Status | Evidence |
|----------|--------|----------|
| Feature validated before delivery | ✅ PASS | This plan IS the validation — the feature itself validates the toolchain |
| Product Trio collaboration | ⚠️ N/A | Single evaluator running toolchain validation — PDT roles not activated |

### Principle III — Agile-Stage-Gate Governance

| Criteria | Status | Evidence |
|----------|--------|----------|
| TR gates defined | ✅ PASS | Constitution has full Gate Criteria Reference section activating IPD mode |
| TR1 passed before TR2/TR3 | ✅ PASS | TR1 recorded as passed in gate-status.json |
| Must-Meet criteria documented | ✅ PASS | Spec includes TR Gate Assessment section with TR1/TR4/TR5 mapping |

### Principle IV — Cross-Functional PDT

| Criteria | Status | Evidence |
|----------|--------|----------|
| Role mapping explicit | ⚠️ N/A | This is a toolchain validation by a single evaluator — PDT roles not activated for validation workflow |

### Principle V — Quality Built-In

| Criteria | Status | Evidence |
|----------|--------|----------|
| Shift-left testing enforced | ✅ PASS | Plan includes analyze step as final quality gate |
| DoD defined | ✅ PASS | Success criteria in spec define measurable outcomes |
| Cross-artifact consistency verified | ✅ PASS | FR-006 requires `/vipd-analyze` step |
| CI/CD enforcement | ⚠️ N/A | Validation runs in Claude Code interactive session |

### Complexity Tracking

No complexity violations detected. This feature is intentionally minimal — validation-only with a hello-world sample project.

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: Not available yet — no `.specify/memory/cbb-catalog.md` exists
- **Reusable blocks identified**: Existing sample project structures under `samples/` (none exist — first sample project)
- **New components needed**: `samples/e2e-validate-hello/` — a minimal greeting CLI project
- **Reuse justification**: N/A — this is the first sample project; no prior projects to reuse from

## Project Structure

### Documentation (this feature)

```text
specs/010-e2e-workflow-validation/
├── plan.md              # This file
├── research.md          # Phase 0 output — validation approach research
├── data-model.md        # Phase 1 output — entities for sample project & validation
├── quickstart.md        # Phase 1 output — how to run the validation
├── contracts/           # Phase 1 output — CLI interface contract for sample project
├── checklists/          # Quality checklists
│   └── requirements.md  # Specification quality checklist
└── spec.md              # Feature specification
```

### Source Code (repository root)

```text
samples/
└── e2e-validate-hello/  # Sample project source directory
    ├── README.md         # Project description
    └── hello.sh          # Simple greeting CLI script
```

**Structure Decision**: Single-project layout with CLI script as the entry point. The sample project lives under `samples/` to keep it separate from real project tooling. Feature documentation stays in `specs/010-e2e-workflow-validation/`.
