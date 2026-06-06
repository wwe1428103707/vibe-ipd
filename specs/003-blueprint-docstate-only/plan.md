# Implementation Plan: Blueprint Document-State Only

**Branch**: `003-blueprint-docstate-only` | **Date**: 2026-06-06 | **Spec**: `specs/003-blueprint-docstate-only/spec.md`

**Input**: Feature specification from `specs/003-blueprint-docstate-only/spec.md`

**Note**: This plan covers the rewrite of the Tooling Integration Blueprint to
remove all Jira/external-tooling content and focus exclusively on Spec Kit's
native document-state mode for IPD gate enforcement.

## Summary

Rewrite `03-tooling-integration-blueprint.md` and its Chinese translation to
strip out all Jira-specific sections (issue hierarchy configuration, workflow
states, automation rules, Advanced Roadmaps, CI/CD integration), retaining only
the "Spec Kit Agent Integration (Document-State Mode)" section as the primary
gate enforcement mechanism. A minimal Platform Alternatives reference table is
kept. Cross-references in related documents are cleaned up.

## Gate Readiness *(IPD only)*

- **Constitution Check**: ✅ PASS — v1.0.0 constitution exists with Gate Criteria Reference
- **TR Gates Passed**: TR0, TR1
- **Next Gate**: TR2/TR3

## Technical Context

**Language/Version**: Markdown (GFM), English + Chinese translation

**Primary Dependencies**: Existing `docs/ipd-transformation/03-tooling-integration-blueprint.md`
and `zh/03-工具集成蓝图.md` — to be rewritten in place

**Storage**: Git repository under `docs/ipd-transformation/`

**Testing**: Manual review — verify zero Jira references remain, verify section count

**Target Platform**: Git-based documentation directory

**Project Type**: Documentation rewrite (document editing, not software)

**Performance Goals**: N/A — no runtime performance

**Constraints**:
- All Jira-specific content MUST be removed (FR-001)
- Document-state mode section (from 002 feature) MUST be the core content
- Chinese version MUST match English version structurally (FR-005)
- Cross-references in redesign guides MUST be cleaned up (FR-006)
- Document length ≤40% of original (SC-001)

**Scale/Scope**: 2 blueprint documents rewritten + cross-reference cleanup in 2 other docs

**WSJF Priority Score**: Not calculated — backlog item, not a competitive feature

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Principle I — Spec-First, Intent-Driven Development** ✅ PASS
- The spec defines precise WHAT: which sections to remove, what to retain.

**Principle II — Dual-Track Agile: Discovery & Delivery** ✅ PASS
- This rewrite is a delivery activity based on discovery from 001-ipd-toolkit.

**Principle III — Agile-Stage-Gate Governance** ✅ PASS
- The simplified blueprint focuses purely on document-state enforcement,
  which is the native Spec Kit gate mechanism.

**Principle IV — Cross-Functional PDT** ✅ PASS
- Removing Jira dependency makes IPD governance accessible to PDTs of any size.

**Principle V — Quality Built-In with Automated Gate Verification** ✅ PASS
- Document-state mode IS quality built-in — no external platform needed.

> **Gate verdict**: PASS — no violations found.

## Project Structure

### Documentation (this feature)

```text
specs/003-blueprint-docstate-only/
├── plan.md              # This file
├── research.md          # Currently existing Jira content to remove
├── data-model.md        # Simplified document structure
├── contracts/           # Rewrite specification
└── tasks.md             # Task breakdown

docs/ipd-transformation/  # Files to rewrite
├── 03-tooling-integration-blueprint.md     # REWRITE: English blueprint
└── zh/03-工具集成蓝图.md                   # REWRITE: Chinese blueprint
```

### Files to Modify

| File | Action | Change Type |
|------|--------|-------------|
| `docs/ipd-transformation/03-tooling-integration-blueprint.md` | Rewrite | Strip Jira content, keep docstate |
| `docs/ipd-transformation/zh/03-工具集成蓝图.md` | Rewrite | Parallel Chinese update |
| `docs/ipd-transformation/02-command-template-redesign-guide.md` | Edit | Remove Jira cross-refs |
| `docs/ipd-transformation/zh/02-命令与模板改造指南.md` | Edit | Remove Jira cross-refs |

**Structure Decision**: In-place rewrites — files keep the same name and location.

## Complexity Tracking

> Not needed — Constitution Check passed with no violations.

## Phase 0: Research

### Research Tasks

1. **Content Audit**: Scan the current English blueprint to identify every section
   that references Jira-specific configuration (issue hierarchy, Advanced Roadmaps,
   automation rules, CI/CD integration, gate transitions). These are the sections
   to remove.

2. **Cross-Reference Audit**: Search all documents in `docs/ipd-transformation/`
   for references to the blueprint's Jira sections.

3. **Section Inventory**: List what the simplified blueprint should contain:
   - Overview (rewrite to focus on docstate mode)
   - Spec Kit Agent Integration (retain from 002 feature)
   - Comparison table (retain)
   - Platform Alternatives (minimal, remove step-by-step)
   - Cross-References (retain)

### Research Output

[Consolidated findings to be written to `research.md`]

## Phase 1: Design & Contracts

### New Blueprint Structure

```text
1. Overview (rewritten — docstate-focused)
2. Spec Kit Agent Integration (Document-State Mode) (retained from 002)
   2.1 How It Works
   2.2 Comparison: Document-State vs Jira-Integrated (retain table)
3. Platform Alternatives (minimal — remove all step-by-step config)
4. Cross-References (retain)
```

The redesign guide cross-references pointing to the blueprint's Jira sections
should be updated to point to the simplified document-state section instead.
