# Data Model: IPD Toolkit Transformation Plan

**Branch**: `001-ipd-toolkit` | **Date**: 2026-06-06 | **Spec**: `spec.md`

## Overview

This feature produces 4 documentation entities (plan documents) under
`docs/ipd-transformation/`. These documents are the primary "entities" —
they are interrelated, follow a consistent schema, and reference each other.

## Entity: Transformation Roadmap

| Attribute | Value |
|-----------|-------|
| **File** | `docs/ipd-transformation/01-transformation-roadmap.md` |
| **Priority** | P1 (US1) |
| **Target Audience** | Project maintainers, stakeholders |

**Required Sections**:
- Overview & Transformation Scope
- Phase 1: Foundation — entrance/exit criteria, deliverables, effort estimate
- Phase 2: Integration — entrance/exit criteria, deliverables, effort estimate
- Phase 3: Optimization — entrance/exit criteria, deliverables, effort estimate
- Dependency Graph (inter-phase and intra-phase)
- Timeline (visual or textual)
- Effort Summary Table

**Validation Rules**:
- At least 3 phases MUST be defined (FR-001)
- Each phase MUST have prerequisites from prior phases (FR-002)
- Effort MUST be estimated per phase (FR-003)
- Must cover: command adaptation, template updates, tooling, governance (US1 AS3)

**Cross-References**: Links to:
- `02-command-template-redesign-guide.md` (details of command work)
- `03-tooling-integration-blueprint.md` (details of tooling work)
- `04-role-mapping-pdt-setup-guide.md` (details of org work)

---

## Entity: Command & Template Redesign Guide

| Attribute | Value |
|-----------|-------|
| **File** | `docs/ipd-transformation/02-command-template-redesign-guide.md` |
| **Priority** | P1 (US2) |
| **Target Audience** | AI coding agent maintainers |

**Required Sections**:
- Overview: SDD-to-IPD Integration Approach
- Command Redesign (per command):
  - Current behavior → Required IPD gate integration → New behavior
  - TR gate checkpoint mapping
- Template Redesign (per template):
  - Current sections → New IPD-aligned sections/fields
- Backward Compatibility Notes
- Implementation Sequence

**Validation Rules**:
- All 7 SDD commands MUST have a section (FR-004)
- Each command MUST reference its TR gate checkpoint (FR-005)
- All 4 templates MUST have a redesign section (FR-006)
- Backward compatibility MUST be addressed (FR-007)

**Cross-References**: Links to:
- `01-transformation-roadmap.md` (phasing/timing)
- Research: §2 (SDD inventory) and §1 (IPD concepts)

---

## Entity: Tooling Integration Blueprint

| Attribute | Value |
|-----------|-------|
| **File** | `docs/ipd-transformation/03-tooling-integration-blueprint.md` |
| **Priority** | P2 (US3) |
| **Target Audience** | Platform engineers |

**Required Sections**:
- Overview: Agile-Stage-Gate Platform Requirements
- Issue Hierarchy Configuration (Initiative → Feature → Story → Sub-Task)
- Workflow State Design & TR Gate Transitions
- Automation Rules for Gate Enforcement
- Dependency Management & Conflict Detection Setup
- CI/CD Integration Points
- Platform Alternatives & Migration Notes

**Validation Rules**:
- MUST define multi-level hierarchy (FR-008)
- MUST specify gate enforcement automation rules (FR-009)
- MUST include cross-team dependency mechanism (FR-010)
- MUST cover CI/CD integration (FR-011)

**Cross-References**: Links to:
- `02-command-template-redesign-guide.md` (gate definition alignment)
- Research: §3 (tooling landscape)

---

## Entity: Role Mapping & PDT Setup Guide

| Attribute | Value |
|-----------|-------|
| **File** | `docs/ipd-transformation/04-role-mapping-pdt-setup-guide.md` |
| **Priority** | P2 (US4) |
| **Target Audience** | PDT managers, team leads |

**Required Sections**:
- Overview: IPD-to-Agile Organizational Model
- Complete IPD-to-Agile Role Mapping Table (LPDT, PO, Architect, QA, DevOps)
- Product Trio Definition & Cadence
- Feature Team Autonomy vs. PDT Manager Coordination
- RACI Matrix Template
- Team Sizing Guidance (including small-team adaptations)
- Recommended Onboarding Sequence

**Validation Rules**:
- MUST provide complete mapping table (FR-012)
- MUST define Product Trio composition and cadence (FR-013)
- MUST specify PDT manager vs feature team boundaries (FR-014)

**Cross-References**: Links to:
- `01-transformation-roadmap.md` (timing of team formation)
- Research: §4 (role mapping reference, decision log)

---

## Entity Relationships (Cross-Reference Map)

```
01-transformation-roadmap.md
├── → 02-command-template-redesign-guide.md  (command work detail)
├── → 03-tooling-integration-blueprint.md     (tooling work detail)
└── → 04-role-mapping-pdt-setup-guide.md      (org work detail)

02-command-template-redesign-guide.md
└── → 01-transformation-roadmap.md            (phasing/timing)

03-tooling-integration-blueprint.md
└── → 02-command-template-redesign-guide.md    (gate definition alignment)

04-role-mapping-pdt-setup-guide.md
└── → 01-transformation-roadmap.md             (team formation timing)
```

---

## Consistency Requirements (FR-015)

- All documents MUST share the same heading hierarchy conventions
- All documents MUST use the same glossary terms for IPD/Agile concepts
- All documents MUST follow the same cross-reference format: `[Display Name](file.md)`
- The `README.md` index file MUST list all 4 documents with brief descriptions
  and explicit dependency ordering
