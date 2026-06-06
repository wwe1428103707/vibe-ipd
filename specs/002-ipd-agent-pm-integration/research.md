# Research: IPD Agent-Driven Project Management Integration

**Branch**: `002-ipd-agent-pm-integration` | **Date**: 2026-06-06 | **Plan**: `plan.md`

## Research Task 1: Current Skill File Analysis

### Skill File Structure (common pattern)

All existing skill files in `.claude/skills/speckit-*/skill.md` follow this structure:

```yaml
---
name: "speckit-<command>"
description: "<short description>"
---
<instructions with sections, often including pre-execution checks and execution flow>
```

**Common injection points for gate checks**:
- After the frontmatter metadata block
- In the "Outline" or "Execution" section as a pre-flight step
- Before the instruction about proceeding with the core command logic

**Specific findings per command**:

| Skill File | Current Structure | Gate Injection Point | TR Gate |
|-----------|-------------------|---------------------|---------|
| `speckit-constitution/skill.md` | Pre-execution checks → Outline (hooks, loading, fill template, write) | After hook execution, before template fill | TR0 |
| `speckit-specify/skill.md` | Pre-execution checks → Outline (hooks, branch, dir, template, fill, validate) | After feature.json write, before spec template fill | TR1 |
| `speckit-clarify/skill.md` | Prerequisites → Steps (load, scan, question loop, integrate, validate) | After spec loaded, before question loop | TR1 |
| `speckit-plan/skill.md` | Pre-execution → Setup → Load → Execute | After setup script, before template fill | TR2/TR3 |
| `speckit-tasks/skill.md` | Pre-execution → Setup → Load → Generate | After JSON parse, before template fill | TR4 |
| `speckit-implement/skill.md` | Pre-execution → Setup → Load → Execute | After prerequisites, before execution | TR4/TR4A |
| `speckit-analyze/skill.md` | Pre-execution → Load → Analyze → Validate | After load, before analysis | TR5 |

---

## Research Task 2: IPD Gate Mapping

From the Command & Template Redesign Guide (001-ipd-toolkit):

| TR Gate | Phase | Applicable Commands | Gate Criteria (deep content validation) |
|---------|-------|---------------------|----------------------------------------|
| TR0 | Project Setup | constitution | Constitution exists AND has → "Agile-Stage-Gate Governance" principle + "Gate Criteria Reference" section |
| TR1 | Concept | specify, clarify | Spec exists AND has → user stories with acceptance criteria + "TR Gate Assessment" section |
| TR2/TR3 | Plan/Design | checklist, plan | Plan exists AND has → "Constitution Check" passed + "Gate Readiness" section |
| TR4 | Dev Entry | tasks | Tasks exist AND have → "Gate Completion Verification" checkpoints at phase boundaries |
| TR4/TR4A | Development | implement | Implementation in progress AND DoD criteria defined in tasks |
| TR5 | Validation | analyze | All prior gate evidence exists AND analysis report generated |

---

## Research Task 3: Template Inventory & Insertion Points

| Template | Current Sections | IPD Insertions |
|----------|-----------------|----------------|
| `constitution-template.md` | Core Principles (5), Section 2, Section 3, Governance | After Principle V: add "Agile-Stage-Gate Governance" principle; after Sections: add "Tooling & Platform Requirements" section; before Governance: add "Gate Criteria Reference" appendix |
| `spec-template.md` | User Stories, Requirements, Key Entities, Success Criteria, Assumptions | After User Stories: add "TR Gate Assessment" section; after Assumptions: add "Risk Register" section |
| `plan-template.md` | Summary, Technical Context, Constitution Check, Project Structure, Complexity | After Summary: add "Gate Readiness" section; after Technical Context: add "WSJF Priority Score" field |
| `tasks-template.md` | Phased tasks, Dependencies, Execution Order | After each phase "Checkpoint": add "Gate Completion Verification" checklist item |

---

## Research Task 4: IPD Detection Pattern Definition

The constitution MUST contain ALL of the following for IPD mode to activate:

1. A **principle heading** matching one of:
   - `### III. Agile-Stage-Gate Governance`
   - `### Agile-Stage-Gate Governance`
   (case-insensitive match on "Agile-Stage-Gate Governance")

2. A **section heading** matching one of:
   - `## Gate Criteria Reference`
   - `## TR Gate Criteria`
   (indicating the gate criteria are defined)

If both conditions are met → IPD mode is active → all gate checks are enforced.
If either condition is missing → SDD-only mode → no gate warnings shown.

### Decision Log

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| Gate checks are pre-flight (before command execution) | Catches issues early, prevents proceeding without gate readiness | Post-execution only (misses prevention), hybrid (both pre and post — overengineered) |
| Deep content validation (verify sections exist with content) | Required by Q1 clarification — file-existence is too weak | File existence only (too weak for IPD), schema validation (too rigid for docs) |
| Constitution-based IPD detection | Self-documenting, no extra config file, aligns with Spec Kit philosophy | Config flag (extra file), command flag (inconsistent), branch naming (brittle) |
| Backward compatible — SDD projects untouched | Hard requirement (SC-003); IPD detection returns false for old projects | Auto-migration of old projects (risk of breaking changes) |
