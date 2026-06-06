# Quickstart: Implementing IPD Agent-Driven PM

**Branch**: `002-ipd-agent-pm-integration` | **Date**: 2026-06-06

## What This Feature Does

This feature modifies existing Spec Kit components to implement TR gate
enforcement directly through AI agent commands, without requiring Jira or
any external tooling. The Tooling Integration Blueprint document is extended
to describe this "document-state mode" alongside the existing Jira guidance.

## Implementation Order

```text
Phase 1: Templates first (foundation for gate criteria)
  → constitution-template.md (add VI. Agile-Stage-Gate + Gate Criteria Reference)
  → spec-template.md (add TR Gate Assessment + Risk Register)
  → plan-template.md (add Gate Readiness + WSJF Score)
  → tasks-template.md (add Gate Completion Verification)

Phase 2: Commands second (gate enforcement in skills)
  → speckit-constitution/skill.md (TR0 gate + IPD mode detection)
  → speckit-specify/skill.md (TR1 pre-flight check)
  → speckit-clarify/skill.md (TR1 risk evidence generation)
  → speckit-plan/skill.md (TR2/TR3 checkpoint)
  → speckit-tasks/skill.md (TR4 baseline check)
  → speckit-implement/skill.md (TR4/TR4A quality check)
  → speckit-analyze/skill.md (TR5 compliance check)

Phase 3: Blueprint documentation
  → Update 03-tooling-integration-blueprint.md (add agent PM section)
  → Update zh/03-工具集成蓝图.md (parallel Chinese update)
```

## Key Design Decisions

1. **IPD detection**: Constitution-based — look for "Gate Criteria Reference" heading
2. **Gate enforcement**: Deep content validation — verify section content, not file existence
3. **Backward compatibility**: SDD-only projects see no gate warnings (IPD detection returns false)
4. **No new commands**: All changes are in-place modifications to existing 7 skill files

## Verification

After implementing each phase, verify:

- **Template phase**: Run `/vipd-speckit-constitution` on a test project → new IPD sections present
- **Command phase**: Run `/vipd-speckit-plan` without constitution → gate block warning shown
- **Blueprint phase**: Documents render correctly with new agent PM section

## Cross-Reference

- [Gate Check Interface Contract](contracts/gate-check-interface.md) — standard gate block pattern
- [Template Sections Contract](contracts/template-sections.md) — exact template modifications
- [Blueprint Agent Section Contract](contracts/blueprint-agent-section.md) — Blueprint additions
