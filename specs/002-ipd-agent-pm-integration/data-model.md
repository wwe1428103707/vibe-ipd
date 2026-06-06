# Data Model: IPD Agent-Driven Project Management Integration

**Branch**: `002-ipd-agent-pm-integration` | **Date**: 2026-06-06 | **Spec**: `spec.md`

## Entity: TR Gate

| Attribute | Type | Description |
|-----------|------|-------------|
| id | TR0–TR6 | Gate identifier (TR0, TR1, TR2/TR3, TR4, TR4/TR4A, TR5, TR6) |
| phase | string | Development phase (Setup, Concept, Plan, Dev Entry, Development, Validation, Launch) |
| commands | string[] | Commands that enforce this gate |
| deep_check_pattern | string | Pattern to verify in documents for deep content validation |
| mode | "auto" / "manual" | Auto-checked by command, or requires explicit analyze |

**Relationships**: Each TR gate maps to 1+ commands that enforce its criteria.
Gates are sequential — TR(n+1) requires TR(n) to be passed first.

## Entity: Command Gate Integration

| Attribute | Type | Description |
|-----------|------|-------------|
| command | string | `/vipd-speckit-<name>` |
| skill_path | string | Path to `.claude/skills/vipd-speckit-<name>/skill.md` |
| tr_gate | string | Associated TR gate(s) |
| check_type | "pre-flight" / "post-execution" | When the check runs |
| ipd_detection | boolean | Whether IPD mode check is needed |
| deep_validation | string | What content to validate in which file |

**Example**:
- command: `/vipd-speckit-specify`
- skill_path: `.claude/skills/vipd-speckit-specify/skill.md`
- tr_gate: TR1
- check_type: pre-flight
- ipd_detection: true
- deep_validation: "Check constitution existence + Gate Criteria Reference section"

## Entity: Template IPD Section

| Attribute | Type | Description |
|-----------|------|-------------|
| template | string | Template file path |
| section_name | string | New section heading to add |
| insertion_point | string | After which existing section |
| content_pattern | string | Brief description of what the section contains |
| optional | boolean | Whether the section is optional (SDD projects can skip) |

## Entity: Blueprint Document

| Attribute | Type | Description |
|-----------|------|-------------|
| file_path | string | Path to the document |
| language | "en" / "zh" | English or Chinese |
| agent_section_location | string | Where to insert the agent PM section |
| content_summary | string | What the agent PM section should cover |

## State Transitions (Gate Flow)

```text
[SDD-only mode] → (constitution created with Gate Criteria Reference) → [IPD mode]

IPD mode gate flow:
TR0 (constitution ratified) → TR1 (spec approved) → TR2/TR3 (plan approved)
    → TR4 (tasks broken down) → TR4/TR4A (implemented & tested)
        → TR5 (validated) → TR6 (launched)
```

**Validation Rule**: A command MUST NOT proceed past its pre-flight gate check
if the prior TR gate has not been satisfied (deep content validation failed).

## Cross-Reference Validation

All gate criteria checks MUST reference the same TR gate definitions. The
gate criteria table in research.md serves as the single source of truth.
