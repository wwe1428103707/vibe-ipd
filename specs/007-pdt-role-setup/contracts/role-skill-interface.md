# Contracts: Role Skill Interface

## Role SKILL.md Contract

Every role-specific skill file at `.claude/skills/vipd-agent-assign-*/SKILL.md` MUST conform to this contract.

### Frontmatter

```yaml
---
name: "vipd-agent-assign-{role}"
description: "Act as {role_name} ({agile_equivalent}) — {one-line responsibility}"
metadata:
  author: "ipd-toolkit"
user-invocable: true
---
```

### Required Sections

| Section | Mandatory? | Content |
|---------|-----------|---------|
| Role Definition | YES | IPD role name, Agile equivalent, core responsibilities |
| Decision Authority | YES | What this role can decide / recommend / escalate |
| Constitution Cross-Reference | YES | Which constitutional principles this role enforces |
| Response Framing | YES | Instructions for how the agent should frame its output |
| RACI Context | YES | R, A, C, I positions for common activities |
| Gate Review Template | RECOMMENDED | Structured output format when reviewing a TR gate |

### Response Framing Rules

1. Every response MUST begin with a role identification: `**[{role_name}]** — {brief context}`
2. When making a decision, MUST state the authority basis: `**Authority**: {role} decides on {category}`
3. When escalating, MUST state the reason and target: `**Escalation**: {reason} → {target}`
4. Combined roles MUST identify which sub-role is speaking when the perspective matters

### Gate Review Contract

When a role skill is used for gate review, its output MUST include:

```yaml
gate_assessment:
  role: "{role_name}"
  gate: "TR_N"
  verdict: "go" | "kill" | "hold" | "recycle"
  must_meet:
    passed: []
    failed: []
  should_meet:
    score: number
    max_score: number
  evidence: "reference to specific artifacts"
  escalation_needed: boolean
  escalation_target: "pdt_manager" | "architecture_board" | "ipmt" | null
```

### Combined Role Contract

A combined role skill MUST:
1. List both roles in the frontmatter `name:` (e.g., `vipd-agent-assign-lpdt-po`)
2. Include a `## Conflict Resolution` section that defines priority rules
3. Tag each output segment with the active sub-role: `**[LPDT]**` or `**[PO]**`

## Invocation Contract

```text
# Direct invocation:
/{skill-name} [optional gate/feature reference]

# Subagent invocation in Claude Code:
Agent({description: "Role-specific task", prompt: "..."})
  → The skill file's Response Framing section configures agent behavior

# Combined workflow (Product Trio review):
1. /vipd-agent-assign-po  → assess feature value
2. /vipd-agent-assign-architect → assess technical feasibility  
3. Synthesize findings → go/no-go recommendation
```

## RACI Annotation Contract

When tasks.md includes RACI annotations for role assignments, each task MUST follow this format:

```text
- [ ] T001 [P] [US1] Create model in src/models/x.py RACI: R=<role>, A=<role>
```

### RACI Field Format

| Field | Required? | Values | Description |
|-------|-----------|--------|-------------|
| R | YES | `lpdt`, `po`, `architect`, `qa_lead`, `devops_lead` | Responsible — who does the work |
| A | YES | Same as R | Accountable — who answers for the outcome |
| C | NO | Same as R (comma-separated for multiple) | Consulted — whose input is required |
| I | NO | Same as R (comma-separated for multiple) | Informed — who is notified after |

### Role IDs for RACI

| Role ID | Display Name |
|---------|-------------|
| `lpdt` | PDT Manager (LPDT/RTE) |
| `po` | Product Manager (PO) |
| `architect` | Development Lead (Architect) |
| `qa_lead` | Test Lead (QA Lead) |
| `devops_lead` | Operations Lead (DevOps Lead) |

### Example

```text
- [ ] T001 Create user model in src/models/user.py RACI: R=architect, A=architect, C=po
- [ ] T002 Write API integration tests in tests/integration/test_api.py RACI: R=qa_lead, A=qa_lead
- [ ] T003 Deploy to staging in deploy/staging.sh RACI: R=devops_lead, A=devops_lead, C=qa_lead, I=lpdt
```
