# Contract: Role Mapping & PDT Setup Guide

**File**: `docs/ipd-transformation/04-role-mapping-pdt-setup-guide.md`

**Schema**: The document MUST contain:

```markdown
# Role Mapping & PDT Setup Guide

## Overview

[Why IPD role mapping matters for Spec Kit teams.]

## IPD-to-Agile Role Mapping

| IPD Role | Agile/SAFe Role | Responsibilities | Accountabilities |
|----------|----------------|-----------------|-----------------|
| PDT Manager (LPDT) | RTE | Cross-team coordination, TR facilitation, dependency management | Delivery commitment |
| Product Manager | PO | Backlog ownership, story acceptance, stakeholder comms | Feature value delivery |
| Development Lead | System Architect | Architecture decisions, CBB, technical standards | Technical quality |
| Test Lead | QA Lead | Test strategy, DoD, quality gates | Release quality |
| Operations Lead | DevOps Lead | CI/CD, monitoring, deployment | Operational stability |

## Product Trio

### Composition
- PO (Product Manager)
- System Architect (Development Lead)
- UX Designer

### Operating Cadence
- Weekly sync (discovery review)
- Per-sprint handoff to delivery track
- Gate TR1/TR2 participation

### Scope of Authority
- Feature validation (go/no-go for discovery)
- Priority recommendations to PDT manager
- Technical feasibility assessment

## Feature Team Autonomy

| Activity | PDT Manager | Feature Team |
|----------|-------------|--------------|
| Sprint goal setting | Approves alignment | Defines within scope |
| Implementation approach | Not involved | Self-organizing |
| Cross-team dependencies | Coordinates | Flags blockers |
| Technical decisions | Not involved | Self-organizing |

## RACI Matrix Template

[Standard RACI for PDT: LPDT, PO, Architect, QA, DevOps for key activities:
- Requirement definition, architecture review, development, testing, deployment]

## Small-Team Adaptations

[Guidance for teams of 3–5 where one person plays multiple IPD roles]

## Cross-References

- [Transformation Roadmap](01-transformation-roadmap.md)
- Research: §4 (Role Mapping Reference)
```

**Validation**: Must satisfy FR-012, FR-013, FR-014.
