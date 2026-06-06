# Data Model: Blueprint Document-State Only

**Branch**: `003-blueprint-docstate-only` | **Date**: 2026-06-06

## Entity: Blueprint Document

| Attribute | English | Chinese |
|-----------|---------|---------|
| File path | `docs/ipd-transformation/03-tooling-integration-blueprint.md` | `docs/ipd-transformation/zh/03-工具集成蓝图.md` |
| Sections to remove | Issue Hierarchy, Workflow States, Automation Rules, Dependency Mgmt, CI/CD Integration | Same sections in Chinese |
| Sections to retain | Overview (rewrite), Agent Integration, Platform Alternatives (minimal), Cross-References | Same |
| Target max length | ≤90 lines | ≤90 lines |

## Entity: Redesign Guide Cross-Reference

| Attribute | English | Chinese |
|-----------|---------|---------|
| File path | `docs/ipd-transformation/02-command-template-redesign-guide.md` | `docs/ipd-transformation/zh/02-命令与模板改造指南.md` |
| Reference to update | Cross-References section linking to blueprint | Already points to agent section — verify only |
