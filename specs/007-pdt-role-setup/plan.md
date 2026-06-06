# Implementation Plan: PDT Role Mapping & Agent Setup

**Branch**: `main` | **Date**: 2026-06-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/007-pdt-role-setup/spec.md`

**Note**: This template is filled in by the `/vipd-speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Create 5 IPD role-specific Claude Code skill files (`.claude/skills/vipd-agent-assign-*/SKILL.md`) that configure subagents to adopt LPDT/RTE, PO, Architect, QA Lead, and DevOps Lead personas. Each skill defines role-specific prompt instructions, decision authority, and RACI-aligned response framing. Additionally, define a Product Trio discovery workflow and RACI annotation format. All implementation is configuration/Markdown — no source code.

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS — all 5 principles addressed; Principle II (Dual-Track Agile) and Principle IV (Cross-Functional PDT) directly relevant
- **TR Gates Passed**: TR0 (Constitution), TR1 (Spec)
- **Next Gate**: TR4 (Development)

## Technical Context

**Language/Version**: Markdown with YAML frontmatter (Claude Code skill format)

**Primary Dependencies**: Claude Code Agent tool, existing `vipd-agent-assign`/`vipd-agent-execute`/`vipd-agent-validate` skills

**Storage**: Filesystem — `.claude/skills/vipd-agent-assign-*/SKILL.md`

**Testing**: Manual validation via `/vipd-agent-assign-*` invocations; structured review against role mapping guide

**Target Platform**: Claude Code (AI agent skill framework)

**Project Type**: CLI / agent skill configuration (Markdown skill definitions)

**Performance Goals**: N/A — skill file loading is sub-second; review quality is the metric

**Constraints**:
- Each skill file must have correct `name:`, `description:`, `user-invocable:` frontmatter
- Role instruction prompts must not exceed Claude Code's skill context limits
- Combined-role skills (e.g., LPDT+PO) must handle priority conflicts explicitly
- No external dependencies — all role context must be self-contained in the skill file

**Scale/Scope**: 5 individual role skills + 2 combined role skills (7 total skill files)

**WSJF Priority Score**: 20 — (Value=8 + Time Criticality=4 + Risk Reduction=5) / Job Size=0.85

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Evidence |
|-----------|-------|----------|
| I. Spec-First | PASS | Spec created with user stories, acceptance criteria, success criteria |
| II. Dual-Track Agile | PASS | Product Trio discovery track defined in User Story 2 |
| III. Agile-Stage-Gate | PASS | TR gate assessment completed (TR1 passed for this feature) |
| IV. Cross-Functional PDT | PASS | 5 IPD role skills directly implement this principle |
| V. Quality Built-In | PASS | RACI annotations ensure quality ownership clarity |

## Project Structure

### Documentation (this feature)

```text
specs/007-pdt-role-setup/
├── plan.md              # This file (/vipd-speckit-plan command output)
├── research.md          # Phase 0 output (/vipd-speckit-plan command)
├── data-model.md        # Phase 1 output (/vipd-speckit-plan command)
├── quickstart.md        # Phase 1 output (/vipd-speckit-plan command)
├── contracts/           # Phase 1 output (/vipd-speckit-plan command)
└── tasks.md             # Phase 2 output (/vipd-speckit-tasks command - NOT created by /vipd-speckit-plan)
```

### Source Code (repository root)

```text
.claude/skills/
├── vipd-agent-assign-lpdt/         # LPDT/RTE role agent
│   └── SKILL.md
├── vipd-agent-assign-po/           # PO role agent
│   └── SKILL.md
├── vipd-agent-assign-architect/    # System Architect role agent
│   └── SKILL.md
├── vipd-agent-assign-qa-lead/      # QA Lead role agent
│   └── SKILL.md
├── vipd-agent-assign-devops-lead/  # DevOps Lead role agent
│   └── SKILL.md
├── vipd-agent-assign-lpdt-po/      # Combined LPDT+PO (small team)
│   └── SKILL.md
└── vipd-agent-assign-devops-qa/    # Combined DevOps+QA (small team)
    └── SKILL.md
```

**Structure Decision**: Each IPD role gets its own `.claude/skills/vipd-agent-assign-*/SKILL.md` directory, following the existing convention of `vipd-agent-assign`, `vipd-agent-execute`, `vipd-agent-validate` skills. Combined roles use a hyphenated naming pattern (`vipd-agent-assign-lpdt-po`). Skills are registered in Claude Code via frontmatter `user-invocable: true`.

## Complexity Tracking

*No Constitution Check violations — complexity is appropriate for the scope.*
