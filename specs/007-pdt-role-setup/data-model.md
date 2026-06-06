# Data Model: PDT Role Mapping

## Core Entities

### IPDRole

| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique role identifier (e.g., `lpdt`, `po`, `architect`) |
| name | string | Display name (e.g., "PDT Manager") |
| agileEquivalent | string | SAFe/Agile role mapping (e.g., "Release Train Engineer") |
| responsibilities | string[] | Core responsibilities (from Role Mapping Guide) |
| decisionAuthority | enum | `decide`, `recommend`, `escalate` per decision category |
| skillPath | string | Path to `.claude/skills/vipd-agent-assign-*/SKILL.md` |
| combinedRoles | string[] | List of role IDs this role combines (empty if single) |

### DecisionCategory

| Category | Description |
|----------|-------------|
| gate_readiness | Whether a TR gate has sufficient evidence to pass |
| feature_validity | Whether a feature should enter the delivery backlog |
| architecture_compliance | Whether design follows approved architecture |
| quality_acceptance | Whether quality criteria are met |
| priority_order | Relative priority of backlog items |
| technical_approach | Implementation methodology choices |

### RACIAssignment

| Field | Type | Description |
|-------|------|-------------|
| taskId | string | Reference to task in tasks.md |
| responsible | IPDRole | The "R" — who does the work |
| accountable | IPDRole | The "A" — who answers for the outcome |
| consulted | IPDRole[] | The "C" — whose input is required |
| informed | IPDRole[] | The "I" — who is notified |

## Authority Matrix

| Role | Gate Readiness | Feature Validity | Architecture | Quality | Priority | Technical |
|------|---------------|-----------------|--------------|---------|----------|-----------|
| LPDT | **Decide** | Decide | Escalate | Escalate | Recommend | Escalate |
| PO | Recommend | **Decide** | Escalate | Escalate | **Decide** | Escalate |
| Architect | Recommend | Recommend | **Decide** | Consult | Recommend | **Decide** |
| QA Lead | Recommend | Consult | Consult | **Decide** | Escalate | Consult |
| DevOps Lead | Consult | Consult | Consult | Consult | Escalate | Recommend |

*Bold = primary authority for that decision category.*

## Role-RACI Mapping

```yaml
roles:
  lpdt:
    name: "PDT Manager (LPDT)"
    agile_equivalent: "Release Train Engineer"
    responsibilities:
      - "Cross-team coordination"
      - "Dependency resolution"
      - "TR gate facilitation"
      - "Impediment removal"
    decides:
      - gate_readiness
      - delivery_commitment
    recommends:
      - feature_validity
      - priority_order
    escalates_to:
      - architecture_board  # for cross-system impact
      - ipmt                # for budget/scope change
    constitution_principles:
      - "III. Agile-Stage-Gate Governance"
      - "IV. Cross-Functional PDT"

  po:
    name: "Product Manager (PO)"
    agile_equivalent: "Product Owner"
    responsibilities:
      - "Backlog prioritization"
      - "User story definition"
      - "Stakeholder communication"
      - "Acceptance criteria sign-off"
    decides:
      - feature_validity
      - priority_order
      - acceptance_signoff
    recommends:
      - gate_readiness
    constitution_principles:
      - "II. Dual-Track Agile"

  architect:
    name: "Development Lead (Architect)"
    agile_equivalent: "System Architect / Tech Lead"
    responsibilities:
      - "Architecture decisions"
      - "CBB management"
      - "Technical standards"
      - "Technology spike oversight"
    decides:
      - architecture_compliance
      - technical_approach
    recommends:
      - feature_validity
      - gate_readiness
    constitution_principles:
      - "I. Spec-First"
      - "IV. Cross-Functional PDT"

  qa_lead:
    name: "Test Lead (QA Lead)"
    agile_equivalent: "QA Lead"
    responsibilities:
      - "Test strategy"
      - "Definition of Done"
      - "Quality metrics"
      - "Environment management"
    decides:
      - quality_acceptance
    recommends:
      - gate_readiness
      - technical_approach (testing)
    constitution_principles:
      - "V. Quality Built-In"

  devops_lead:
    name: "Operations Lead (DevOps Lead)"
    agile_equivalent: "DevOps Lead"
    responsibilities:
      - "CI/CD pipeline"
      - "Deployment automation"
      - "Monitoring"
      - "Incident response"
    decides:
      - operational_stability
    recommends:
      - technical_approach (infrastructure)
    constitution_principles:
      - "V. Quality Built-In"

## Combined Roles (Small Team)

```yaml
combined_roles:
  lpdt_po:
    combines: [lpdt, po]
    conflict_resolution: "LPDT perspective takes precedence on gate and delivery decisions; PO perspective on feature value and backlog"
    rationale: "Small team (3 people) — LPDT and PO combined for headcount efficiency"

  devops_qa:
    combines: [devops_lead, qa_lead]
    conflict_resolution: "QA Lead perspective takes precedence on quality decisions; DevOps Lead on operational decisions"
    rationale: "Small team (4 people) — shared specialist for test and operations"
```
