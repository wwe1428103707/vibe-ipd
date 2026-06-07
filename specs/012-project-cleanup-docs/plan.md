# Implementation Plan: Project Cleanup & Documentation Rebrand

**Branch**: `012-project-cleanup-docs` | **Date**: 2026-06-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/012-project-cleanup-docs/spec.md`

## Summary

Rebrand the project's public-facing and internal documentation from "spec kit"/"speckit" to "vibe-ipd"/"vipd", rewrite the root README with a clear project identity and differentiators, and clean up stale references. The feature is documentation-only — no functional code changes.

## Technical Context

**Language/Version**: Markdown, YAML, plain text. No programming language.

**Primary Dependencies**: None — changes are text-level edits to `.md`, `.yml`, `.json` files.

**Storage**: N/A — documentation-only changes.

**Testing**: Visual review + grep-based validation for stale branding strings.

**Target Platform**: GitHub (README rendering), docfx static site (docs/).

**Project Type**: Documentation/rebranding.

**Performance Goals**: N/A — documentation change, no runtime performance impact.

**WSJF Priority Score**: 6 — (Value: 4 + Time Criticality: 1 + Risk Reduction: 1) / Job Size: 1 *(IPD only)*

**Scale/Scope**: ~20-30 files across root README, docs/ directory, and configuration files.

**Constraints**: FR-008 mandates documentation-only changes — no gate scripts, skills, or sample code modifications.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Principle I — Spec-First, Intent-Driven Development**: ✅ PASS
- Spec clearly defines what & why (rebranding, cleanup, differentiation).
- FRs and SCs are well-defined with measurable outcomes.

**Principle II — Dual-Track Agile**: ✅ PASS
- Feature scope is well-defined from concept phase.
- Documentation rebranding is a delivery-track activity with no discovery needed.

**Principle III — Agile-Stage-Gate Governance**: ✅ PASS
- TR1 gate passed with spec completeness.
- Planning within TR2/TR3 boundary.

**Principle IV — Cross-Functional PDT**: ✅ N/A
- Documentation-only change requiring only technical writing skills.

**Principle V — Quality Built-In with Automated Gate Verification**: ✅ PASS
- Grep-based validation checklists defined in acceptance criteria.
- SC-002/SC-003 are quantitatively verifiable.

**Overall**: ✅ PASS (4 pass, 1 N/A — no violations)

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS (all 5 principles verified)
- **TR Gates Passed**: TR0 (Constitution), TR1 (Spec)
- **Next Gate**: TR2/TR3 (Plan & Design) — *current*

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: Not established (single-project context).
- **Reusable blocks identified**: Existing spec/plan/task templates — unchanged structure reused.
- **New components needed**: None — this is a modification-only feature.
- **Reuse justification**: All changes are modifications of existing documentation files.

## Research

[See research.md](research.md) — Branding audit scope, inventory of files needing changes, and rebranding pattern decisions.

## Project Structure

### Documentation (this feature)

```text
specs/012-project-cleanup-docs/
├── plan.md              # This file
├── research.md          # Phase 0 — branding audit scope and decisions
├── data-model.md        # Phase 1 — document entity definitions and branding rules
├── quickstart.md        # Phase 1 — implementation action checklist
├── contracts/           # Phase 1 — README content contract
│   └── readme-contract.md
└── spec.md              # Feature specification
```

### Source Code (repository root)

```text
./
├── README.md                     # REWRITTEN — vibe-ipd identity + differentiators
├── CLAUDE.md                     # UPDATED — agent context synced
├── docs/                         # UPDATED — all .md files rebranded
├── .specify/                     # REVIEWED — config references
└── .claude/skills/vipd-*/        # REVIEWED — skill descriptions
```

## Complexity Tracking

> **No Constitution Check violations** — this section intentionally left blank per template guidance.
>
> The feature is a straightforward documentation rebrand with clear acceptance criteria.
