# Contract: Template IPD Section Specifications

**Purpose**: Define exactly what new sections to add to each template and
where they should be inserted.

## Constitution Template

**File**: `.specify/templates/constitution-template.md`

### Additions

1. **After Principle V, before SECTION_2**: Insert new principle:
   ```markdown
   ### VI. Agile-Stage-Gate Governance
   [... content from Constitution v1.0.0 ...]
   ```

2. **After SECTION_3, before Governance**: Insert:
   ```markdown
   ## Gate Criteria Reference

   | TR Gate | Phase | Must-Meet Criteria | Should-Meet Criteria |
   |---------|-------|-------------------|---------------------|
   | TR1 | Concept | Spec created, feasibility assessed | Market attractiveness > 8/10 |
   | TR2/TR3 | Plan | Architecture reviewed, dependencies locked | Effort variance < 15% |
   | TR4 | Development | DoD defined, CI configured | Velocity variance < 15% |
   | TR5 | Validation | Blocker/critical bugs = 0 | Beta NPS >= 8 |
   | TR6 | Launch | Deployment verified, ops handover | Training pass rate = 100% |
   ```

## Spec Template

**File**: `.specify/templates/spec-template.md`

### Additions

1. **After User Scenarios, before Requirements**:
   ```markdown
   ## TR Gate Assessment

   - **Applicable TR Gates**: [TR1, TR2, ...]
   - **Risk Level**: [High / Medium / Low]
   - **Gate Evidence Required**: [...]
   ```

2. **After Assumptions**:
   ```markdown
   ## Risk Register

   | Risk | Impact | Likelihood | Mitigation |
   |------|--------|------------|------------|
   | [risk] | [H/M/L] | [H/M/L] | [strategy] |
   ```

## Plan Template

**File**: `.specify/templates/plan-template.md`

### Additions

1. **After Summary, before Technical Context**:
   ```markdown
   ## Gate Readiness

   - **Constitution Check**: [PASS / FAIL]
   - **TR Gates Passed**: [TR0, TR1, ...]
   - **Next Gate**: [TR_N]
   ```

2. **In Technical Context, add field**:
   ```markdown
   **WSJF Priority Score**: [number — calculated as (Value + Time Criticality + Risk Reduction) / Job Size]
   ```

## Tasks Template

**File**: `.specify/templates/tasks-template.md`

### Additions

1. **In each phase Checkpoint, append**:
   ```markdown
   > **Gate Completion Verification**: All tasks in this phase [ ] completed / [ ] verified
   ```
