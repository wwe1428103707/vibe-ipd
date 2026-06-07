# Quickstart: End-to-End Workflow Validation

This guide explains how to run the complete end-to-end validation of the IPD-Agile toolchain.

## Prerequisites

- Claude Code CLI environment on Windows 11
- Git access with repository cloned
- PowerShell execution policy allowing script execution
- This feature plan and spec created at `specs/010-e2e-workflow-validation/`

## Validation Steps

### Step 0: Create Sample Project Directory

Create the sample project scaffolding:

```bash
mkdir -p samples/e2e-validate-hello
```

Add a `README.md` and the greeting script (`hello.sh`).

**Verify**: Directory `samples/e2e-validate-hello/` exists with at least 2 files.

### Step 1: Execute Specification (`/vipd-specify`)

Run the specification skill for the sample project feature:

```text
/vipd-specify <feature description for the hello greeting tool>
```

**Output**: A new spec directory under `specs/` (e.g., `specs/011-hello-greeting/`).

**Verify**: `spec.md` exists with user stories, functional requirements, and success criteria.

### Step 2: Clarify (`/vipd-clarify`)

Resolve any ambiguities in the spec:

```text
/vipd-clarify
```

**Verify**: Spec has no remaining `[NEEDS CLARIFICATION]` markers.

### Step 3: Plan (`/vipd-plan`)

Generate the implementation plan:

```text
/vipd-plan
```

**Output**: `plan.md` in the sample project's spec directory.

**Verify**: Plan contains technical context, phases, and design approach.

### Step 4: Tasks (`/vipd-tasks`)

Generate task breakdown:

```text
/vipd-tasks
```

**Output**: `tasks.md` with dependency-ordered tasks.

**Verify**: Tasks are actionable, assigned, and have effort estimates.

### Step 5: Implement (`/vipd-implement`)

Execute the implementation:

```text
/vipd-implement
```

**Output**: Working source code in `samples/e2e-validate-hello/`.

**Verify**: `hello.sh --name World` prints the expected greeting.

### Step 6: Analyze (`/vipd-analyze`)

Perform cross-artifact consistency analysis:

```text
/vipd-analyze
```

**Output**: Consistency report.

**Verify**: No critical inconsistencies between spec, plan, tasks, and implementation.

## Success Criteria Checklist

| # | Criterion | How to Verify | Result |
|---|-----------|---------------|--------|
| SC-001 | Sample project created < 5 min | Time the creation step | ☐ |
| SC-002 | Workflow completes without errors | Each step exits cleanly | ☐ |
| SC-003 | Each phase produces correct artifacts | Artifact paths exist and non-empty | ☐ |
| SC-004 | Sample feature is functional | Run `hello.sh` and check output | ☐ |
| SC-005 | Analyze confirms consistency | Report shows no critical issues | ☐ |
| SC-006 | Gate commands run successfully | Check gate-status.json | ☐ |

## Troubleshooting

| Problem | Likely Cause | Solution |
|---------|-------------|----------|
| `/vipd-*` command not found | Skill not loaded | Verify `.claude/skills/` contains the skill |
| Gate check denies permission | Auto-mode restriction | Use "yes" to proceed, or adjust settings |
| Plan.md not found | Setup script not run | `setup-plan.ps1` must execute before planning |
| Tasks not dependency-ordered | Missing plan phases | Complete all plan phases before `/vipd-tasks` |
