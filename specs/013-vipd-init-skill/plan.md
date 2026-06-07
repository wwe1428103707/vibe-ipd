# Implementation Plan: vipd-init Skill

**Branch**: `013-featurename-vipd-init-skill` | **Date**: 2026-06-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/013-vipd-init-skill/spec.md`

## Summary

Create a `/vipd-init` Claude Code skill that wraps the upstream speckit CLI (`specify init`) behind a unified vibe-ipd branded entry point. The skill detects available tooling (`uvx`/`pipx`), delegates scaffolding to the speckit CLI, and post-processes the scaffolded project for consistent vibe-ipd branding. This eliminates confusion where users previously had to know both `specify init` (for scaffolding) and `/vipd-*` (for daily commands).

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS
- **TR Gates Passed**: TR0 (Constitution), TR1 (Spec)
- **Next Gate**: TR2/TR3 (Plan — this plan), TR4 (Development/Implementation)

## Technical Context

**Language/Version**: SKILL.md — Markdown with YAML frontmatter (per existing `vipd-*` skill convention)

**Primary Dependencies**: 
- `uvx` (from `uv` package manager) — primary delegation path: `uvx --from git+https://github.com/github/spec-kit.git specify init`
- `pipx` — fallback: `pipx install git+https://github.com/github/spec-kit.git && specify init`
- No additional runtime dependencies beyond existing project tools

**Storage**: N/A — outputs a filesystem directory scaffold

**Testing**: Manual verification via `/vipd-init` invocation + directory structure inspection

**Target Platform**: Cross-platform (Windows PowerShell, macOS/Linux Bash) — per existing skill conventions referencing `.specify/scripts/` scripts

**Project Type**: Claude Code Skill (`.claude/skills/vipd-init/SKILL.md`)

**Performance Goals**: Scaffold a new project in under 60 seconds with `uvx` cold start (including download)

**Constraints**: 
- Must follow existing skill conventions (see `vipd-specify`, `vipd-constitution` for reference patterns)
- Must gracefully handle missing external tools (`uvx`, `pipx`, `git`) with clear error messages and manual setup instructions
- Must not modify the caller's current project — only the target project directory

**Scale/Scope**: Single SKILL.md file (~150-200 lines), no additional source files

**WSJF Priority Score**: 8 — (Value=10 + Time Criticality=8 + Risk Reduction=6) / Job Size=3

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Compliance | Notes |
|-----------|------------|-------|
| I. Spec-First, Intent-Driven | ✅ PASS | Spec exists at `specs/013-vipd-init-skill/spec.md` |
| II. Dual-Track Agile | ✅ PASS | Discovery (this plan) → Delivery (tasks) |
| III. Agile-Stage-Gate Governance | ✅ PASS | TR gates satisfied for Concept phase |
| IV. Cross-Functional PDT | ✅ N/A | Internal tooling feature, no PDT scope |
| V. Quality Built-In | ✅ PASS | Checklist created, verification planned |

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: `.specify/memory/cbb-catalog.md` (not yet established for this project)
- **Reusable blocks identified**: 
  - Existing `vipd-*` skill files (frontmatter patterns, Pre-Execution Checks pattern, completion reporting convention)
  - `.specify/scripts/powershell/common.ps1` — path resolution and utility functions
  - `.specify/scripts/bash/common.sh` — path resolution and utility functions
  - `.specify/integrations/claude.manifest.json` — reference for what `specify init --integration claude` produces
- **New components needed**: 
  - `.claude/skills/vipd-init/SKILL.md` — the new skill definition
  - `specs/013-vipd-init-skill/research.md` — Phase 0 artifact
  - `specs/013-vipd-init-skill/quickstart.md` — Phase 1 artifact

## Project Structure

### Documentation (this feature)

```text
specs/013-vipd-init-skill/
├── spec.md              # Feature specification
├── plan.md              # This file — implementation plan
├── research.md          # Phase 0 output — technical research
├── quickstart.md        # Phase 1 output — usage quickstart
├── checklists/
│   └── requirements.md  # Quality checklist
└── tasks.md             # Phase 2 output — created by /vipd-tasks
```

### Source Code (repository root)

```text
.claude/skills/vipd-init/
└── SKILL.md             # The skill definition file (single deliverable)
```

**Structure Decision**: Single SKILL.md file following the established convention of all other `vipd-*` skills. A Claude Code skill is a markdown file with YAML frontmatter that instructs the AI on how to handle the `/vipd-init` command — no source code directory is needed.

## Complexity Tracking

> Not applicable — no constitution violations to justify. The feature is a single-file wrapper skill.

## Phase 0: Research

### Unknowns to Resolve

1. **How does `specify init` behave with `--integration claude`?**
   - What files/directories does it create?
   - Does `--integration` accept other values?
   - What happens on re-run in an existing directory?

2. **What is the exact `uvx` invocation pattern?**
   - Is `git+https://github.com/github/spec-kit.git` the correct URL?
   - Are version pins needed?
   - What's the cold-start latency?

3. **Post-scaffold state: what `speckit-*` skills exist?**
   - Inventory of files created under `.claude/skills/`
   - Are all covered by existing `vipd-*` equivalents?
   - What happens if both `speckit-*` and `vipd-*` skills coexist?

### Findings

Research conducted via existing project artifacts:

1. **`specify init --integration claude` behavior** (from `claude.manifest.json`): 
   Creates: `.claude/skills/speckit-*` skills (specify, plan, tasks, implement, clarify, checklist, analyze, constitution, taskstoissues), `.specify/` directory with scripts and templates.
   Also creates `.specify/integrations/claude.manifest.json` tracking file.

2. **`uvx` invocation**: 
   `uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>` is the documented pattern. No version pinning specified — uses latest.

3. **Post-scaffold state**:
   All `speckit-*` skills have matching `vipd-*` equivalents in this project. Coexistence is safe (no name collision since `speckit-` and `vipd-` prefixes differ), but confusing for branding.

### Research Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Primary delegation | `uvx` | Already documented; no extra install step |
| Post-init branding | Optional post-step | User may want pure speckit scaffold |
| Fallback method | `pipx` | Persistent install for repeated use |
| Integration passthrough | Forward all `--` flags to `specify init` | Future-proof; no flag parsing needed in skill |
