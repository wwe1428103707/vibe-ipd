# Contract: Tooling Integration Blueprint

**File**: `docs/ipd-transformation/03-tooling-integration-blueprint.md`

**Schema**: The document MUST contain:

```markdown
# Tooling Integration Blueprint

## Overview

[Platform requirements for Agile-Stage-Gate support]

## Issue Hierarchy Configuration

**Target**: Initiative → Feature → Story → Sub-Task

[Step-by-step configuration: Jira settings → Issue types → Hierarchy]
[Or equivalent for non-Jira platforms]

## Workflow States & TR Gate Transitions

| Jira State | IPD Phase | TR Gate | Transition Validations |
|------------|-----------|---------|----------------------|
| Draft → Feasibility Study | Concept | - | - |
| Feasibility Study → Concept Approved | Concept | TR1 | Must-Meet criteria check |
| Concept Approved → Business Case Ready | Plan | TR2/TR3 | Architecture review done |
| ... | ... | ... | ... |

## Automation Rules

### Gate 1: Concept Approval Trigger
- Condition: All Feasibility tasks Done
- Action: Auto-create standard concept deliverables
- Validation: Must-Meet criteria checklist complete

### Gate 2: Development Readiness
- Condition: Architecture review approved
- Action: Unblock development queue
- Validation: API contracts reviewed

[Plus additional rules for each gate]

## Dependency Management

[Advanced Roadmaps configuration for cross-team dependency visualization:
- Link types: "blocks", "depends on"
- Out-of-sequence detection (red-line alerts)
- Regular sync cadence recommendations]

## CI/CD Integration

[Integration points between project management platform and CI/CD:
- Automation webhooks for gate status changes
- Quality check results as transition validators
- Deployment status feedback]

## Platform Alternatives

[Jira-alternative workarounds for teams without Advanced Roadmaps]

## Cross-References

- [Command & Template Redesign Guide](02-command-template-redesign-guide.md)
- Research: §3 (Tooling Landscape)
```

**Validation**: Must satisfy FR-008, FR-009, FR-010, FR-011.
