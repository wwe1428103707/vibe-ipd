**Document**: Command & Template Redesign Guide
**Part of**: IPD Toolkit Transformation Plan Collection
**Status**: Draft
**Date**: 2026-06-06

# Command & Template Redesign Guide

## Overview

The existing SDD command set operates in a linear pipeline without formal gate
mechanisms. This guide specifies how each command and template must be enhanced
to incorporate IPD Technology Review (TR) gate awareness while preserving their
original purpose and backward compatibility.

The integration follows a "gate checkpoint" pattern: each command gains a
pre-execution gate validation step that checks whether the required TR criteria
for the current phase have been satisfied. If not, the command warns the user
and optionally blocks execution.

## TR Gate Mapping Summary

| TR Gate | Phase | Applicable Commands |
|---------|-------|---------------------|
| TR0 | Project Setup | `/vipd-speckit-constitution` |
| TR1 | Concept | `/vipd-speckit-specify`, `/vipd-speckit-clarify` |
| TR2/TR3 | Plan/Design | `/vipd-speckit-checklist`, `/vipd-speckit-plan` |
| TR4 | Dev Entry | `/vipd-speckit-tasks` |
| TR4/TR4A | Development | `/vipd-speckit-implement` |
| TR5 | Validation | `/vipd-speckit-analyze` |

## Command Redesign

### `/vipd-speckit-constitution`

**Current behavior**: Creates/updates the project constitution from user
principles input. No gate validation.

**IPD gate integration**: Add TR0 gate validation that checks whether the
project already has an approved constitution before allowing updates. On first
creation, auto-register the ratification date as the TR0 gate approval date.

**New behavior**:
- First run: Creates constitution + registers TR0 gate approval
- Subsequent runs: Checks whether proposed changes are compatible with
  existing TR gates (no retroactive principle removal without re-review)
- **TR checkpoint**: TR0 (Project Setup)

### `/vipd-speckit-specify`

**Current behavior**: Creates feature specification from user description.
No gate validation.

**IPD gate integration**: Add TR1 gate awareness. Before creating a new spec,
validate that the project constitution is ratified (TR0 passed). After spec
creation, generate a TR1 readiness checklist showing which Concept-phase
criteria are met.

**New behavior**:
- Pre-flight: Check TR0 status (constitution must exist)
- Post-creation: Generate TR1 readiness report (spec completeness, feasibility
  indicators, initial risk assessment)
- **TR checkpoint**: TR1 (Concept)

### `/vipd-speckit-clarify`

**Current behavior**: Reduces spec ambiguity via Q&A session. No gate validation.

**IPD gate integration**: After all clarifications are resolved, generate a
risk assessment output that feeds into the TR1 gate decision. Track which
ambiguities were resolved and which risks remain open.

**New behavior**:
- During session: Tag each clarification by risk level (high/medium/low)
- Post-session: Generate TR1 risk summary as gate evidence
- **TR checkpoint**: TR1 (Concept)

### `/vipd-speckit-checklist`

**Current behavior**: Generates quality checklists for requirements validation.
No gate validation.

**IPD gate integration**: Reframe as TR2 entry gate validation. The checklist
output becomes the gate evidence for TR2 (architecture/plan readiness).

**New behavior**:
- Pre-flight: Check TR1 gate status (spec must be approved)
- Post-generation: Checklist completeness score as TR2 entry criterion
- **TR checkpoint**: TR2 (Architecture Readiness)

### `/vipd-speckit-plan`

**Current behavior**: Creates technical implementation plan from spec + user
tech stack input. No gate validation.

**IPD gate integration**: Add TR2/TR3 gate checkpoints. Before plan creation,
validate TR1 passed. After plan creation, generate architecture review summary
as TR3 gate evidence.

**New behavior**:
- Pre-flight: Check TR1 gate status
- Post-creation: Generate architecture decision log (ADL) as TR3 input
- Include Constitution Check section (already exists in plan template)
- **TR checkpoint**: TR2 (Architecture Review) / TR3 (Design Approval)

### `/vipd-speckit-tasks`

**Current behavior**: Breaks plan into actionable tasks. No gate validation.

**IPD gate integration**: Add TR4 gate checkpoint. Before task generation,
validate that architecture/design review (TR2/TR3) passed. Tasks become the
development baseline tracked during TR4/TR4A.

**New behavior**:
- Pre-flight: Check TR2/TR3 gate status
- Post-generation: Task count and effort estimate as TR4 baseline
- **TR checkpoint**: TR4 (Development Baseline)

### `/vipd-speckit-implement`

**Current behavior**: Executes implementation tasks. No gate validation.

**IPD gate integration**: Add TR4/TR4A gate checkpoints. Before implementation,
validate TR4 passed. After implementation, generate quality report (test
coverage, static analysis, security scan) as TR4A gate evidence.

**New behavior**:
- Pre-flight: Check TR4 gate status
- Continuous: Collect quality metrics during execution
- Post-completion: Generate TR4A quality report for gray release readiness
- **TR checkpoint**: TR4 (Development) / TR4A (Gray Release Readiness)

### `/vipd-speckit-analyze`

**Current behavior**: Cross-artifact consistency analysis. No gate validation.

**IPD gate integration**: Reframe as TR5 validation gate. The analysis output
becomes the primary evidence for TR5 (system validation) gate review.

**New behavior**:
- Pre-flight: Check TR4A gate status (implementation must be complete)
- Analysis scope: Extended to include IPD gate compliance, DoD verification,
  and Must-Meet criteria coverage
- Post-analysis: Generate TR5 validation report
- **TR checkpoint**: TR5 (System Validation)

## Template Redesign

### Constitution Template

**Current sections**: Core Principles (5), Additional Sections (2), Governance

**New IPD-aligned sections**:
- Add "Agile-Stage-Gate Governance" as a dedicated principle section
- Add "Tooling & Platform Requirements" section
- Add "Gate Criteria Reference" section listing Must-Meet/Should-Meet
  definitions per TR gate
- Governance: Add amendment procedure that requires TR gate re-review on
  MAJOR version changes

**Backward compatible**: Yes — new sections are additive; existing constitutions
remain valid.

### Spec Template

**Current sections**: User Stories, Requirements, Key Entities, Success
Criteria, Assumptions

**New IPD-aligned sections**:
- Add "TR Gate Assessment" section listing which TR gates apply and what
  evidence each requires
- Add "Risk Register" section for initial risk identification
- Success Criteria: Add Must-Meet/Should-Meet categorization

**Backward compatible**: Yes — new sections are additive.

### Plan Template

**Current sections**: Summary, Technical Context, Constitution Check, Project
Structure, Complexity Tracking

**New IPD-aligned sections**:
- Add "Gate Readiness" section replacing/preceding Constitution Check
- Add "TR Gate Evidence Checklist" section
- Add "WSJF Priority Score" section for backlog prioritization

**Backward compatible**: Yes — gate section replaces only the placement of
Constitution Check; the check itself remains.

### Tasks Template

**Current sections**: Phased tasks by user story, dependencies, execution order

**New IPD-aligned sections**:
- Add "Gate Completion Verification" to each phase checkpoint
- Add "DoD Checklist Template" as an appendix
- Add "Quality Gate Criteria" for each phase transition

**Backward compatible**: Yes — gate sections are additive notes.

## Implementation Sequence

Recommended order for implementing these changes:

1. **Constitution template first** — establishes the gate framework
2. **Spec template** — enables TR1 gate for new features
3. **Plan template + `/vipd-speckit-plan`** — enables TR2/TR3
4. **Tasks template + `/vipd-speckit-tasks`** — enables TR4
5. **`/vipd-speckit-implement`** — enables TR4/TR4A
6. **`/vipd-speckit-analyze`** — enables TR5
7. **`/vipd-speckit-constitution`, `/vipd-speckit-specify`, `/vipd-speckit-clarify`,
   `/vipd-speckit-checklist`** — remaining command gate integrations

This sequence ensures each gate can be tested end-to-end as it's implemented.

## Backward Compatibility Notes

- All template changes are additive — existing documents remain valid
- Commands gain pre-flight checks but retain existing behavior when no
  gate context exists (e.g., projects without TR gates configured)
- The TR gate system can be introduced incrementally per project

## Cross-References

- [Transformation Roadmap](01-transformation-roadmap.md) — Phase 2 timing
  for implementing these changes
- [Tooling Integration Blueprint](03-tooling-integration-blueprint.md) —
  document-state gate enforcement mode for vibe-ipd agent integration

*This guide aligns with **Principle I (Spec-First, Intent-Driven Development)**
by specifying precise changes before implementation, and **Principle III
(Agile-Stage-Gate Governance)** by defining TR gate integration points.*
