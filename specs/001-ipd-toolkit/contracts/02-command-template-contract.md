# Contract: Command & Template Redesign Guide

**File**: `docs/ipd-transformation/02-command-template-redesign-guide.md`

**Schema**: The document MUST contain:

```markdown
# Command & Template Redesign Guide

## Overview

[Approach: SDD commands retain their primary purpose but gain IPD gate
 awareness at specific checkpoints.]

## Command Redesign

### /speckit-constitution

**Current behavior**: [summary]
**IPD gate integration**: [e.g., Add TR gate reference section]
**New behavior**: [summary]
**TR checkpoint**: TR0 (Project Setup)

### /speckit-specify

**Current behavior**: [summary]
**IPD gate integration**: [e.g., Add TR1 gate validation in spec template]
**New behavior**: [summary]
**TR checkpoint**: TR1 (Concept)

[... repeat for all 7 SDD commands ...]

## Template Redesign

### Constitution Template

**Current sections**: [...]
**New IPD-aligned sections**: [...]
**Backward compatible**: Yes/No

### Spec Template

**Current sections**: [...]
**New IPD-aligned sections**: [...]
**Backward compatible**: Yes/No

### Plan Template

**Current sections**: [...]
**New IPD-aligned sections**: [...]
**Backward compatible**: Yes/No

### Tasks Template

**Current sections**: [...]
**New IPD-aligned sections**: [...]
**Backward compatible**: Yes/No

## Implementation Sequence

[Recommended order, e.g., constitution first → spec → plan → tasks]

## Cross-References

- [Transformation Roadmap](01-transformation-roadmap.md) — phasing/timing
```

**Validation**: Must satisfy FR-004, FR-005, FR-006, FR-007.
