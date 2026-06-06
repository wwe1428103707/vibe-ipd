# Product Trio Discovery Workflow

**Part of**: IPD Toolkit Transformation Plan Collection
**Status**: Draft
**Date**: 2026-06-06

## Overview

The Product Trio (PO + System Architect + UX Designer) is the discovery-track engine that validates features before they enter the delivery backlog. This workflow defines how the trio collaborates to assess desirability, feasibility, and viability of proposed features.

## When Product Trio Approval Is Required

A feature MUST pass through the Product Trio before entering the delivery backlog if it meets ANY of these criteria:

- New feature (not an enhancement to existing functionality)
- Cross-team impact (requires coordination with 2+ teams)
- New technology or external dependency
- User-facing workflow change

Bug fixes, minor enhancements, and technical debt items may bypass the Product Trio and go directly to the backlog after LPDT approval.

## Workflow Steps

### Step 1: Feature Brief (PO)

The PO creates a concise feature brief including:
- Problem statement and user need
- Expected business value
- Success criteria (measurable outcomes)
- Priority relative to other backlog items

**Tool**: `/vipd-specify` creates the spec; `/vipd-agent-assign-po` can validate the brief.

### Step 2: Technical Feasibility (Architect)

The System Architect assesses:
- Technical approach and architecture alignment
- CBB (Common Building Block) reuse opportunities
- New dependencies or technology needed
- Effort estimate (T-shirt size: S/M/L/XL)

**Tool**: `/vipd-agent-assign-architect` "Assess feasibility for {feature}"

### Step 3: UX Validation (UX Designer)

The UX Designer (or general-purpose agent acting as UX) evaluates:
- User workflow clarity
- Edge cases and error states
- Accessibility considerations
- Low-fidelity prototype or flow diagram (optional)

**Tool**: General-purpose Claude Code review of the spec from UX perspective.

### Step 4: Trio Review & Decision

The trio consolidates findings and produces a go/no-go recommendation:

1. Each member reviews independently (async, parallel)
2. Findings are consolidated into a single assessment
3. If no member vetoes: feature is **cleared for delivery backlog** (Go)
4. If any member vetoes: feature is **blocked** with rationale (No-Go)
5. If clarification needed: feature is **returned for refinement** (Recycle)

**Tool**: Use the [Trio Review Template](/.specify/templates/guides/trio-review-template.md) for structured output.

### Step 5: Gate Evidence (for TR1)

The completed trio assessment becomes TR1 gate evidence:

```text
Feature: {name}
Trio Verdict: Go / No-Go / Recycle
PO Assessment: {summary}
Architect Assessment: {summary}
UX Assessment: {summary}
Evidence: {links to spec, prototypes, research}
```

## Operating Cadence

| Frequency | Activity | Output |
|-----------|----------|--------|
| Weekly sync (1 hour) | Review in-progress discovery, align on priorities | Updated discovery backlog |
| Per sprint (before planning) | Handoff validated features to delivery track | Feature briefs with acceptance criteria |
| Per gate (TR1/TR2) | Present findings at gate review | Risk assessment, feasibility report |

## Scope of Authority

| Role | Decide | Recommend | Escalate |
|------|--------|-----------|----------|
| PO | Feature validity, priority order | Backlog sequencing | Resource needs to LPDT |
| Architect | Technical feasibility, approach | Architecture decisions | Cross-system impacts |
| UX Designer | User experience quality | Workflow, accessibility | Usability risks |

## Escalation

If the trio cannot reach consensus:

```text
Trio deadlock → LPDT (tie-breaking decision)
    → Architecture Board (if cross-system impact)
        → IPMT (if budget/scope change required)
```

## Small-Team Adaptations

For teams of 3-4 people, the Product Trio can operate with combined roles:
- **LPDT+PO**: One person handles both LPDT and PO perspectives
- **Dev+Arch**: Development lead covers architecture assessment
- **UX as shared service**: UX review is optional for small features

## Cross-References

- [Role Mapping Guide](04-role-mapping-pdt-setup-guide.md) — Full role definitions and RACI matrix
- [Constitution](../.specify/memory/constitution.md) — Principle II (Dual-Track Agile)

---

*This workflow implements **Principle II (Dual-Track Agile)** by defining the discovery track mechanism that validates features before delivery.*
