# Research: Blueprint Document-State Only

**Branch**: `003-blueprint-docstate-only` | **Date**: 2026-06-06 | **Plan**: `plan.md`

## Research Task 1: Content Audit — Sections to Remove

Current English blueprint sections (~218 lines total) and their fate:

| Section | Lines | Action | Reason |
|---------|-------|--------|--------|
| Overview (Jira-centric) | 15 | **Rewrite** | Focus on docstate as primary approach |
| Issue Hierarchy Configuration | 35 | **Remove** | Jira-specific (Initiative → Feature → Story hierarchy) |
| Workflow States & TR Gate Transitions | 20 | **Remove** | Jira-specific workflow states |
| Automation Rules (3 gates) | 50 | **Remove** | Jira Automation rules, conditions, validators |
| Dependency Management | 25 | **Remove** | Advanced Roadmaps configuration |
| CI/CD Integration | 20 | **Remove** | Jira webhook + CI integration |
| Spec Kit Agent Integration | 30 | **Retain** | Core docstate content (from 002 feature) |
| Platform Alternatives | 15 | **Simplify** | Remove step-by-step, keep minimal table |
| Cross-References | 8 | **Retain** | Update to point to simplified doc |

**Estimated new length**: ~70–80 lines (was 218 → ~64% reduction, meeting SC-001 ≤40%)

## Research Task 2: Cross-Reference Audit

Search `docs/ipd-transformation/` for references to Jira blueprint sections:

| Source File | Reference | Action |
|-------------|-----------|--------|
| `02-command-template-redesign-guide.md` | `[Tooling Integration Blueprint](03-tooling-integration-blueprint.md) — gate definitions that the tooling enforces` | **Update** — remove "gate definitions" language; point to docstate section |
| `zh/02-命令与模板改造指南.md` | `[工具集成蓝图](03-工具集成蓝图.md) — Spec Kit代理集成模式章节` | **Keep** — already points to agent section |

## Research Task 3: Simplified Blueprint Section Inventory

New structure (target):

```markdown
# Tooling Integration Blueprint

## Overview (rewritten)

## Spec Kit Agent Integration (Document-State Mode)
### How It Works
### Comparison: Document-State vs Jira-Integrated

## Platform Alternatives (minimal table only)

## Cross-References
```

### Decision Log

| Decision | Rationale |
|----------|-----------|
| Remove all Jira configuration sections | FR-001 — the blueprint should focus on Spec Kit native enforcement |
| Retain comparison table | Documents the rationale for choosing docstate over external tools |
| Keep minimal "Platform Alternatives" section | Provides context for teams that may need external integration, but without configuration guidance |
| Chinese version mirrors English structure | FR-005 — maintains bilingual consistency |
