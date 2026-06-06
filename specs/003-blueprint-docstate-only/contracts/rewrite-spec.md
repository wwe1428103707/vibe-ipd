# Contract: Simplified Blueprint Structure

**Purpose**: Define the exact before/after structure for the blueprint rewrite.

## English Blueprint — Before → After Mapping

| Before (original) | After (simplified) |
|-------------------|-------------------|
| Overview (Jira-centric) | Overview (Docstate-centric) |
| Issue Hierarchy Configuration | ❌ REMOVED |
| Workflow States & TR Gates | ❌ REMOVED |
| Automation Rules (3 sections) | ❌ REMOVED |
| Dependency Management | ❌ REMOVED |
| CI/CD Integration | ❌ REMOVED |
| Spec Kit Agent Integration | ✅ RETAINED (core content) |
| Platform Alternatives (15 lines + migration notes) | Platform Alternatives (4 lines, table only) |
| Cross-References | ✅ RETAINED |

## Chinese Blueprint — Same mapping, translated

## Redesign Guide Cross-Reference Changes

| File | Before | After |
|------|--------|-------|
| `02-command-template-redesign-guide.md` | Links to blueprint "gate definitions that the tooling enforces" | Remove "gate definitions" reference; link to agent section |
| `zh/02-命令与模板改造指南.md` | Links to "Spec Kit代理集成模式章节" | — no change needed |
