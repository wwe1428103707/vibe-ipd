**Document**: Role Mapping & PDT Setup Guide
**Part of**: IPD Toolkit Transformation Plan Collection
**Status**: Draft
**Date**: 2026-06-06

# Role Mapping & PDT Setup Guide

## Overview

The IPD-Agile hybrid model requires clear role definitions that bridge the
macro governance responsibilities of IPD with the self-organizing team
structure of Agile. This guide maps each IPD role to its Agile/SAFe equivalent
and defines how the Product Development Team (PDT) operates within the
Agile-Stage-Gate workflow.

## IPD-to-Agile Role Mapping

| IPD Role | Agile/SAFe Role | Core Responsibilities | Accountable For |
|----------|----------------|----------------------|-----------------|
| **PDT Manager (LPDT)** | Release Train Engineer (RTE) | Cross-team coordination, dependency resolution, TR gate facilitation, impediment removal | Delivery commitment, gate readiness |
| **Product Manager** | Product Owner (PO) | Backlog prioritization, user story definition, stakeholder communication, acceptance criteria sign-off | Feature value delivery |
| **Development Lead** | System Architect / Tech Lead | Architecture decisions, CBB management, technical standards, technology spike oversight | Technical quality, architecture compliance |
| **Test Lead** | QA Lead | Test strategy, DoD definition, quality metrics, environment management | Release quality, test coverage |
| **Operations Lead** | DevOps Lead | CI/CD pipeline, deployment automation, monitoring, incident response | Operational stability |

### Role Combinations for Small Teams

For teams of 3–5, roles may be combined:

| Team Size | Recommended Combination |
|-----------|------------------------|
| 3 people | LPDT + PO (1 person), Dev + Ops (1 person), QA + UX (1 person) |
| 4 people | LPDT (1), PO + UX (1), Dev + Arch (1), QA + Ops (1) |
| 5 people | Full PDT with one shared UX resource across teams |

## Product Trio

The Product Trio is the discovery-track engine that validates features before
they enter the delivery backlog.

### Composition

| Role | Person | Contribution |
|------|--------|--------------|
| **Product Owner** | PO (Product Manager) | Market/user need, business case, success criteria |
| **System Architect** | Development Lead | Technical feasibility, architecture constraints, effort estimation |
| **UX Designer** | Dedicated or shared | User research, prototypes, usability validation |

### Operating Cadence

| Frequency | Activity | Output |
|-----------|----------|--------|
| **Weekly sync** (1 hour) | Review in-progress discovery, align on priorities | Updated discovery backlog |
| **Per sprint** (before sprint planning) | Handoff validated features to delivery track | Feature briefs with acceptance criteria |
| **Per gate** (TR1/TR2) | Present findings at gate review | Risk assessment, feasibility report |

### Scope of Authority

- **Decide**: Feature validity (go/no-go to enter delivery backlog)
- **Recommend**: Priority relative to other features in backlog
- **Recommend**: Technical approach within architectural guidelines
- **Escalate**: Resource constraints or conflicts to PDT manager

### When Product Trio Approval Is Required

A feature MUST pass through the Product Trio before entering the delivery
backlog if it meets ANY of these criteria:
- New feature (not an enhancement to existing functionality)
- Cross-team impact (requires coordination with 2+ teams)
- New technology or external dependency
- User-facing workflow change

Bug fixes, minor enhancements, and technical debt items may bypass the Product
Trio and go directly to the backlog after PDT manager approval.

## Feature Team Autonomy

| Activity | PDT Manager (LPDT/RTE) | Feature Team |
|----------|------------------------|--------------|
| Sprint goal setting | Aligns with roadmap, approves scope | Defines specific goals within scope |
| Implementation approach | Not involved (trust the team) | Fully self-organizing |
| Technology choice | Approves architecture decisions | Recommends, implements |
| Cross-team dependencies | Coordinates, tracks, escalates | Flags blockers early |
| Task breakdown | Reviews at high level | Self-organizes |
| Daily execution | Not involved (attends stand-up as needed) | Self-managing |
| Quality standards | Defines must-meet criteria | Owns quality execution |
| Gate review | Facilitates, presents | Attends, provides evidence |

### Decision Escalation Path

```text
Feature Team decision → PDT Manager (LPDT) escalation
    → Architecture Board (if cross-system impact)
        → IPMT (if budget/scope change required)
```

## RACI Matrix

| Activity | LPDT (RTE) | PO | Architect | QA Lead | DevOps Lead |
|----------|-----------|-----|-----------|---------|-------------|
| Requirement definition | I | **R/A** | C | C | I |
| Architecture design | I | C | **R/A** | C | C |
| Implementation | I | I | C | I | C |
| Testing | I | C | I | **R/A** | C |
| Deployment | A | I | I | C | **R/A** |
| Gate review evidence | **R/A** | C | C | C | C |
| Backlog prioritization | C | **R/A** | I | I | I |
| Dependency management | **R/A** | C | C | I | I |
| Quality metrics | A | I | I | **R/A** | C |
| Production monitoring | I | I | C | C | **R/A** |

**R** = Responsible (doer), **A** = Accountable (decision maker),
**C** = Consulted (input required), **I** = Informed (notified after)

## Team Sizing Guidance

- **Minimum viable PDT**: 3 people (combined roles)
- **Recommended PDT**: 5–9 people (full role coverage)
- **Multiple PDTs**: For products requiring 10+ people, split into multiple
  PDTs aligned to subsystems or feature areas, each with its own LPDT
- **Innersource model**: For small orgs (< 15 people), use shared specialists
  (one QA, one Ops) serving multiple feature teams

## Small-Team Adaptations

For teams of 3–5 where one person covers multiple IPD roles:

1. **Accept slower gate throughput** — fewer people means more context
   switching; plan gate reviews with longer lead time
2. **Externalize specialized roles** — QA, UX, and Ops can be shared services
   rather than dedicated PDT members
3. **Reduce gate formality** — for small teams, TR gates can be lightweight
   (30-min review instead of full presentation)
4. **Automate what you can** — invest in CI/CD automation to compensate for
   limited manual QA and ops capacity

## Cross-References

- [Transformation Roadmap](01-transformation-roadmap.md) — Phase 2 timing for
  PDT formation in pilot project

*This guide aligns with **Principle IV (Cross-Functional PDT with Autonomous
Feature Teams)** by defining role mappings, autonomy boundaries, and escalation
paths, and **Principle II (Dual-Track Agile)** by specifying the Product Trio
discovery mechanism.*

## Implementation Status

Role-specific Claude Code subagent skills have been implemented:

| Role | Skill File | Status |
|------|------------|--------|
| LPDT/RTE (PDT Manager) | `.claude/skills/vipd-agent-assign-lpdt/SKILL.md` | Active |
| PO (Product Manager) | `.claude/skills/vipd-agent-assign-po/SKILL.md` | Active |
| Architect (Dev Lead) | `.claude/skills/vipd-agent-assign-architect/SKILL.md` | Active |
| QA Lead (Test Lead) | `.claude/skills/vipd-agent-assign-qa-lead/SKILL.md` | Active |
| DevOps Lead (Ops Lead) | `.claude/skills/vipd-agent-assign-devops-lead/SKILL.md` | Active |
| LPDT+PO (combined) | `.claude/skills/vipd-agent-assign-lpdt-po/SKILL.md` | Active |
| DevOps+QA (combined) | `.claude/skills/vipd-agent-assign-devops-qa/SKILL.md` | Active |
| Product Trio Workflow | `docs/ipd-transformation/product-trio-workflow.md` | Active |
| Trio Review Template | `.specify/templates/guides/trio-review-template.md` | Active |

Invoke any role via `/vipd-agent-assign-{role}` in Claude Code.
