# Implementation Plan: IPD Agent-Driven Project Management Integration

**Branch**: `002-ipd-agent-pm-integration` | **Date**: 2026-06-06 | **Spec**: `specs/002-ipd-agent-pm-integration/spec.md`

**Input**: Feature specification from `specs/002-ipd-agent-pm-integration/spec.md`

**Note**: This plan covers modifying existing Spec Kit agent skill files and
templates to implement TR gate enforcement directly in the project, transforming
the Tooling Integration Blueprint from Jira-centric guidance to Spec Kit-native
project management via AI agents and document structure.

## Summary

Implement TR gate enforcement as pre-flight checks in all 7 `/vipd-speckit-*` commands,
update all 4 templates (constitution, spec, plan, tasks) with IPD-aware sections,
and update the Tooling Integration Blueprint document to describe this
agent-driven approach alongside the existing Jira-centric guidance.

## Technical Context

**Language/Version**: Agent skill files in Markdown + YAML frontmatter (same format
as existing `.claude/skills/vipd-speckit-*/skill.md`). Blueprint documents in GFM Markdown.

**Primary Dependencies**:
- Existing `.claude/skills/vipd-speckit-*/skill.md` files (7 commands) — to be modified
- Existing `.specify/templates/*.md` files (4 templates) — to be updated
- Existing `docs/ipd-transformation/03-tooling-integration-blueprint.md` — to be extended
- Existing `docs/ipd-transformation/zh/03-工具集成蓝图.md` — to be updated in parallel

**Storage**: Git repository — skill files in `.claude/skills/`, templates in
`.specify/templates/`, documents in `docs/ipd-transformation/`

**Testing**: Manual review and verification against spec acceptance scenarios.
No automated test framework for skill files.

**Target Platform**: Claude Code / any Spec Kit-compatible AI coding agent

**Project Type**: Agent skill configuration + documentation (not a library or application)

**Performance Goals**: N/A — skill files are static instructions; no runtime performance

**Constraints**:
- All template updates MUST be backward-compatible (SDD-only projects unaffected)
- Gate enforcement uses **deep content validation** (per Q1 clarification)
- IPD-mode detection is **constitution-based** (per Q2 clarification)
- Chinese blueprint document MUST be updated in parallel with English version
- No new commands — only modifications to existing 7 commands + `/vipd-speckit-analyze` enhancement

**Scale/Scope**: 7 skill files modified, 4 templates updated, 2 blueprint documents
updated, 1 new `/vipd-speckit-analyze` gate compliance check feature

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Principle I — Spec-First, Intent-Driven Development** ✅ PASS
- This spec defines precise WHAT and WHY for each skill/template modification
  before implementation begins.

**Principle II — Dual-Track Agile: Discovery & Delivery** ✅ PASS
- The gate enforcement mechanism aligns with dual-track: discovery (exploration
  track) validates feasibility, delivery track executes with gate oversight.

**Principle III — Agile-Stage-Gate Governance** ✅ PASS
- This feature IS the implementation of what Principle III prescribes — embedding
  TR gate checks directly into the development workflow commands.

**Principle IV — Cross-Functional PDT with Autonomous Feature Teams** ✅ PASS
- The gate checks enable PDT autonomy by making gate criteria transparent and
  enforceable without external gatekeeper intervention.

**Principle V — Quality Built-In with Automated Gate Verification** ✅ PASS
- Deep content validation and gate compliance analysis directly implement
  Principle V's call for automated gate verification.

> **Gate verdict**: PASS — no violations found.

## Project Structure

### Documentation (this feature)

```text
specs/002-ipd-agent-pm-integration/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output (gate criteria model)
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (gate check contracts)
└── tasks.md             # Phase 2 output (/vipd-speckit-tasks command)
```

### Files to Modify

```text
# Agent Skill Files (modify)
.claude/skills/vipd-speckit-constitution/skill.md    # → Add TR0 gate integration
.claude/skills/vipd-speckit-specify/skill.md          # → Add TR1 gate pre-flight check
.claude/skills/vipd-speckit-clarify/skill.md          # → Add TR1 gate evidence generation
.claude/skills/vipd-speckit-plan/skill.md             # → Add TR2/TR3 gate checkpoint
.claude/skills/vipd-speckit-tasks/skill.md            # → Add TR4 gate checkpoint
.claude/skills/vipd-speckit-implement/skill.md        # → Add TR4/TR4A gate checkpoint
.claude/skills/vipd-speckit-analyze/skill.md          # → Add TR5 gate compliance check

# Templates (modify)
.specify/templates/constitution-template.md      # → Add IPD gate criteria sections
.specify/templates/spec-template.md              # → Add TR Gate Assessment, Risk Register
.specify/templates/plan-template.md              # → Add Gate Readiness, WSJF Score
.specify/templates/tasks-template.md             # → Add Gate Completion Verification

# Blueprint Documents (modify)
docs/ipd-transformation/03-tooling-integration-blueprint.md     # → Add agent PM section
docs/ipd-transformation/zh/03-工具集成蓝图.md                   # → Parallel Chinese update
```

**Structure Decision**: Flat modifications to existing files — no new directories
or files needed. All changes are in-place updates.

## Complexity Tracking

> Not needed — Constitution Check passed with no violations.

## Phase 0: Research

### Research Tasks

1. **Current Skill File Analysis**: Review all 7 existing skill files to understand
   current command structure, decision points, and where to inject gate checks.

2. **IPD Gate Mapping**: Map each existing skill file to its corresponding TR gate
   using the mapping from the Command & Template Redesign Guide (001 feature).

3. **Template Inventory**: Review all 4 template files to identify exact insertion
   points for new IPD sections.

4. **Constitution Template for IPD Detection**: Define the exact text/heading
   pattern that constitutes a "Gate Criteria Reference" section for IPD-mode detection.

### Research Output

[Consolidated findings to be written to `research.md`]
