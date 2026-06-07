# Research: Project Cleanup & Documentation Rebrand

**Phase**: Phase 0 | **Date**: 2026-06-07 | **Feature**: [Project Cleanup & Documentation Rebrand](spec.md)

## Research Tasks

### R-001: Inventory Files Needing Branding Updates

- **Decision**: Scan all `.md` files in `docs/`, root `README.md`, `CLAUDE.md`, and `.specify/` configuration files.
- **Rationale**: The spec targets US1 (root README), US2 (docs/), and US3 (config/skills). A comprehensive inventory ensures no file is missed.
- **Scope**:
  - `README.md` — full rewrite
  - `docs/*.md` — rebrand speckit → vibe-ipd, `/speckit-` → `/vipd-`
  - `docs/**/*.md` — rebrand same patterns
  - `CLAUDE.md` — update SPECKIT section to reference 012 feature
  - `.specify/feature.json` — verify points to 012
  - `.claude/skills/vipd-*/` — review descriptions

### R-002: Branding String Mapping

- **Decision**: Use consistent replacement map for all files:

| Search Pattern | Replace With | Context |
|---------------|--------------|---------|
| `Spec Kit` (as project name) | `vibe-ipd` | Primary branding |
| `spec kit` (as project name) | `vibe-ipd` | Lowercase context |
| `speckit` (as project name) | `vibe-ipd` | Self-reference |
| `/speckit-` (commands) | `/vipd-` | CLI commands |
| `Speckit` (title case) | `vibe-ipd` | Titles/headings |

- **Exclusions**: References to upstream speckit project in attribution context (e.g., "Based on Spec Kit v0.9.3") should be preserved.

### R-003: Differentiators to Highlight in README

- **Decision**: Feature at least 5 distinct differentiators:

| # | Differentiator | Description |
|---|---------------|-------------|
| 1 | **IPD Governance Framework** | Full TR0-TR6 stage-gate model integrated into Agile delivery |
| 2 | **oh-my-claudecode Multi-Agent Orchestration** | 50+ specialized agent roles beyond speckit's single-agent model |
| 3 | **PDT Role Mapping** | LPDT/PO/Architect/QA/DevOps role assignments with RACI matrix |
| 4 | **Product Trio Workflows** | PO + Architect + UX Designer collaboration with review templates |
| 5 | **Bilingual Support (CN/EN)** | Chinese-first docs with English support, Windows-native tooling |

### R-004: Validation Strategy

- **Decision**: Use `grep -r` patterns for pre/post validation counts.
- **Rationale**: Quantitatively verifiable per SC-002 and SC-003.
- **Validation commands**:
  - `grep -r "speckit" docs/ --include="*.md" -i -c` — target zero (excl. attribution)
  - `grep -r "/speckit-" docs/ --include="*.md" -c` — target zero
