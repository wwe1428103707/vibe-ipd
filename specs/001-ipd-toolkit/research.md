# Research: IPD Toolkit Transformation Plan

**Branch**: `001-ipd-toolkit` | **Date**: 2026-06-06 | **Plan**: `plan.md`

## Research Task 1: IPD Fusion Guide Analysis

**Source**: `docs/IPD与敏捷开发深度融合的软件产品开发流程与研发管理平台搭建指南.md`

### Core IPD Concepts Extracted

| Concept | Description | Source Section |
|---------|-------------|----------------|
| Agile-Stage-Gate Hybrid | Retains Stage-Gate (TR) macro governance + Agile micro execution | §1 |
| Dual-Track Agile | Discovery Track (exploration) + Delivery Track (execution) run in parallel | §1 |
| Product Trio | PO + System Architect + UX Designer jointly validate features pre-development | §2.2 |
| PDT Role Mapping | IPD roles mapped to Agile/SAFe roles with clear responsibilities | §2.1 |
| TR1–TR6 Gates | 6 technology review gates with Must-Meet / Should-Meet criteria | §3.2 |
| Must-Meet / Should-Meet | Binary veto (Must-Meet) + scorecard (Should-Meet) for gate decisions | §3 |
| Quality Built-in | Automated CI/CD verification, shift-left testing, DoD enforcement | §5.2 |
| WSJF Prioritization | Weighted Shortest Job First for data-driven backlog prioritization | §4.4 |
| Multi-level Hierarchy | Initiative → Feature → Story → Sub-Task for requirement decomposition | §4.1 |
| Jira Automation Rules | Conditions, validators, post-functions for automated gate enforcement | §4.2 |
| Dependency Visualization | Cross-team dependency red-line alerts in Advanced Roadmaps | §4.3 |

### Recommended Document Structure Alignment

Each of the 4 deliverable documents should reference the relevant sections of the
fusion guide for authoritative context:

| Deliverable Document | Key Fusion Guide Sections |
|---------------------|--------------------------|
| Transformation Roadmap | §1 (Agile-Stage-Gate logic), §5 (落地路径/implementation path) |
| Command & Template Redesign Guide | §3.2 (phase/deliverable matrix), §1 (dual-track concepts) |
| Tooling Integration Blueprint | §4.1–§4.4 (Jira configuration in detail) |
| Role Mapping & PDT Setup Guide | §2.1 (role mapping table), §2.2 (Product Trio) |

---

## Research Task 2: SDD Toolkit Inventory

### Existing Commands (7)

| Command | Skill File | Current Purpose |
|---------|-----------|-----------------|
| `/vipd-speckit-constitution` | `.claude/skills/vipd-speckit-constitution/skill.md` | Create/update project constitution |
| `/vipd-speckit-specify` | `.claude/skills/vipd-speckit-specify/skill.md` | Define feature specification |
| `/vipd-speckit-clarify` | `.claude/skills/vipd-speckit-clarify/skill.md` | Reduce spec ambiguity via Q&A |
| `/vipd-speckit-plan` | `.claude/skills/vipd-speckit-plan/skill.md` | Create technical implementation plan |
| `/vipd-speckit-tasks` | `.claude/skills/vipd-speckit-tasks/skill.md` | Break plan into actionable tasks |
| `/vipd-speckit-implement` | `.claude/skills/vipd-speckit-implement/skill.md` | Execute implementation tasks |
| `/vipd-speckit-analyze` | `.claude/skills/vipd-speckit-analyze/skill.md` | Cross-artifact consistency analysis |

### Additional Commands

| Command | Skill File | Current Purpose |
|---------|-----------|-----------------|
| `/vipd-speckit-checklist` | `.claude/skills/vipd-speckit-checklist/skill.md` | Generate quality checklists |

### Existing Templates (4)

| Template | Path | Current Sections |
|----------|------|-----------------|
| Constitution | `.specify/templates/constitution-template.md` | Core Principles (5), 2 Additional Sections, Governance |
| Spec | `.specify/templates/spec-template.md` | User Stories, Requirements, Key Entities, Success Criteria, Assumptions |
| Plan | `.specify/templates/plan-template.md` | Summary, Technical Context, Constitution Check, Project Structure, Complexity Tracking |
| Tasks | `.specify/templates/tasks-template.md` | Phased tasks by user story, dependencies, execution order |

### Gate Integration Points (Preliminary)

Each command maps to a natural TR gate:

| SDD Command | Natural IPD Gate | Integration Point |
|-------------|-----------------|-------------------|
| `/vipd-speckit-constitution` | TR0 (Project Setup) | Principles define gate criteria |
| `/vipd-speckit-specify` | TR1 (Concept) | Spec completeness as gate input |
| `/vipd-speckit-clarify` | TR1 (Concept) | Risk/ambiguity resolution as gate evidence |
| `/vipd-speckit-checklist` | TR2 (Plan entry) | Quality readiness check |
| `/vipd-speckit-plan` | TR2/TR3 (Plan/Design) | Architecture review as gate input |
| `/vipd-speckit-tasks` | TR4 (Dev entry) | Task breakdown as execution baseline |
| `/vipd-speckit-implement` | TR4/TR4A (Dev) | CI quality reports as gate evidence |
| `/vipd-speckit-analyze` | TR5 (Validation) | Cross-artifact review as validation |

---

## Research Task 3: Tooling Landscape

### Jira Cloud Premium Advanced Roadmaps Capabilities

Based on the IPD fusion guide (§4) and industry-standard Jira configuration:

**Hierarchy Configuration**: Cloud Premium supports custom issue type hierarchy.
Standard hierarchy: Initiative (new) → Epic → Story → Sub-task.
Recommended IPD mapping: Initiative → Feature (mapped from Epic) → Story → Sub-Task.

**Advanced Roadmaps Features Used**:
- Multi-team plan with dependency visualization
- Automated out-of-sequence detection (red-line alerts)
- Capacity and velocity-based scheduling
- What-if scenario modeling

**Jira Automation Rules**:
- Condition-based transition gates (field validators)
- Post-function auto-creation of phase-standard tasks
- Webhook triggers for CI/CD integration

**Alternatives for Non-Jira Platforms**: Open-source options (OpenProject, Taiga,
Plane) may support subset of features but lack Advanced Roadmaps' dependency
visualization. Fallback approach: manual dependency tracking via shared spreadsheet
or lightweight Kanban board with blocker flags.

---

## Research Task 4: Role Mapping Reference

### IPD → Agile/SAFe Role Mapping (from Fusion Guide §2.1)

| IPD Role | Agile/SAFe Role | Core Responsibilities |
|----------|-----------------|----------------------|
| PDT Manager (LPDT) | RTE (Release Train Engineer) | Cross-team coordination, dependency management, TR facilitation |
| Product Manager | Product Owner (PO) | Backlog prioritization, user story definition, acceptance criteria |
| Development Lead | System Architect | Architecture decisions, CBB management, technical standards |
| Test Lead | QA Lead | Test strategy, DoD definition, quality metrics |
| Operations Lead | DevOps Lead | CI/CD pipeline, deployment automation, monitoring |

### Product Trio Composition (from Fusion Guide §2.2)

- **Product Owner**: Market/user need validation, business case
- **System Architect**: Technical feasibility, architectural constraints
- **UX Designer**: Usability, prototype creation, user research

The Product Trio operates in the Discovery Track, producing validated feature
concepts that feed the Delivery Track backlog.

### Decision Log

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| Focus on Jira Cloud Premium as primary platform | Most comprehensive Advanced Roadmaps support per fusion guide §4 | OpenProject (limited dependency viz); GitHub Projects (no multi-level hierarchy) |
| Map Initiative → IPD Concept/Business Case | Best fit for IPD's top-level funding/scope gate | Using Epic → Feature → Story only (loses macro governance layer) |
| Role mapping follows SAFe as the bridge | SAFe is the most widely adopted framework for scaling Agile to IPD-sized teams | Scrum at Scale (less prescriptive on roles); LeSS (too lightweight for IPD governance) |
