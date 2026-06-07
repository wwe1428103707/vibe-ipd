# Data Model: End-to-End Workflow Validation

**Phase**: Phase 1 design | **Date**: 2026-06-07 | **Feature**: [spec.md](spec.md)

## Overview

This feature involves two distinct domains: (1) the **Sample Project** — a simple CLI greeting tool used as the validation target, and (2) the **Validation Workflow** — the meta-process that exercises the project's toolchain. Entities are defined accordingly.

---

## Entity: SampleProject (samples/e2e-validate-hello/)

A minimal CLI application that serves as the validation target for the toolchain workflow.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `name` | String | Project name | Must be `e2e-validate-hello` |
| `path` | Path | Filesystem location | Must be under `samples/` directory |
| `readme` | File (`README.md`) | Project documentation | Must exist, non-empty |
| `entryPoint` | File (`hello.sh`) | CLI entry script | Must be executable, must accept `--name` argument |

**Relationships**:
- A SampleProject has one or more **ValidationCommands** that it responds to (defined in CLI contract)
- A SampleProject is the target of a **ValidationWorkflow**

**State Transitions**:
```
Created → Scaffolded → Validated → Archived
```

---

## Entity: ValidationWorkflow

The meta-process that exercises the project's IPD-Agile toolchain.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `featureName` | String | Feature being validated | Must be `e2e-workflow-validation` |
| `specDir` | Path | Feature spec directory | Must exist under `specs/` |
| `sampleProject` | Reference | Pointer to sample project entity | Must be initialized before workflow starts |
| `workflowSteps` | Array of StepResult | Ordered execution steps | Must follow specify→plan→tasks→implement→analyze |

**Validation Steps**:

| Step # | Command | Artifact Created | Success Criteria |
|--------|---------|-----------------|-----------------|
| 1 | `/vipd-specify` | `spec.md` in new spec directory | Spec file contains user stories, FRs, SCs |
| 2 | `/vipd-clarify` | Updated `spec.md` | No `[NEEDS CLARIFICATION]` markers remain |
| 3 | `/vipd-plan` | `plan.md` | Plan contains phases, design artifacts |
| 4 | `/vipd-tasks` | `tasks.md` | Dependency-ordered tasks with ownership |
| 5 | `/vipd-implement` | Source code in sample project | Code is functional (script runs) |
| 6 | `/vipd-analyze` | Consistency report | All critical consistency checks pass |

**State Transitions**:
```
Pending → Specifying[1] → Clarified[2] → Planned[3] → Tasked[4] → Implemented[5] → Analyzed[6] → Complete
```

---

## Entity: StepResult

Records the outcome of a single workflow step.

| Field | Type | Description |
|-------|------|-------------|
| `stepNumber` | Integer | 1–6 position in workflow sequence |
| `command` | String | Claude Code skill command invoked |
| `status` | Enum | `passed`, `failed`, `blocked` |
| `artifactPath` | Path | Path to the output artifact produced |
| `errors` | Array of String | Any error messages or unexpected behavior |
| `timestamp` | DateTime | When the step was executed |

---

## Entity: ValidationReport

The final output of the complete workflow, produced by the analyze step.

| Field | Type | Description |
|-------|------|-------------|
| `workflowRef` | Reference | Link to the ValidationWorkflow |
| `overallStatus` | Enum | `all_passed`, `partial`, `failed` |
| `stepResults` | Array of StepResult | Results of all 6 steps |
| `consistencyIssues` | Array of String | Cross-artifact consistency findings |
| `recommendations` | Array of String | Suggested improvements based on findings |
