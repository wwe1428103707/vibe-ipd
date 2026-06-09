# Implementation Plan: Claude Code Workflow Optimization

**Branch**: `018-claude-code-workflow` | **Date**: 2026-06-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/018-claude-code-workflow/spec.md`

## Summary

为 vipd 项目添加 Claude Code 专项优化：初始化时支持选择 `claude-code` 模式，此后 `vipd-tasks` 阶段自动生成 Claude Code Workflow 脚本（`.claude/workflows/execute-tasks.wf.js`），`vipd-implement` 阶段通过 Workflow 工具并行执行任务，多个 Agent 协同工作以缩短开发周期。

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS (see below)
- **TR Gates Passed**: TR0 ✅, TR1 ✅
- **Next Gate**: TR4 (Development Baseline) — transitioned through TR2/TR3 planning gate

## Technical Context

**Language/Version**: VIPD Shell/PowerShell 脚本 + Claude Code Workflow JavaScript API schema

**Primary Dependencies**:
- Claude Code CLI（Workflow 工具可用）
- 现有 `vipd-init`、`vipd-tasks`、`vipd-implement` 技能（SKILL.md）
- `.vipd/config.yml`（配置读写能力）
- `init-options.json`（初始化记录）

**Storage**: `.vipd/config.yml`（模式标记）、`.claude/workflows/`（Workflow 脚本）、项目文件系统

**Testing**: 端到端流程测试 — 模拟 `vipd init --integration claude-code` → `vipd-tasks` → `vipd-implement` 全链路

**Target Platform**: Claude Code CLI（Windows/Mac/Linux）

**Project Type**: 命令行工具 / AI 技能编排增强（Skill-based workflow）

**Performance Goals**: 3+ 独立 User Story 的项目，并行执行比顺序执行快至少 40%

**Constraints**:
- Claude Code Workflow API 版本兼容性
- `vipd-tasks` 生成耗时不超过 30 秒
- 降级路径必须 100% 可靠（Workflow 工具不可用时自动回退）
- 运行时约束：最大 16 并发 Agent，单次运行 1,000 agent 上限
- Workflow 脚本为纯 JavaScript（无 TypeScript 类型注解）

**Scale/Scope**: 影响 3 个核心技能（init、tasks、implement），新增约 300-500 行脚本/模板逻辑

**WSJF Priority Score**: 13 — (Value=8 + Time Criticality=3 + Risk Reduction=2) / Job Size=1

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| I. Spec-First, Intent-Driven | ✅ PASS | spec.md 已完整定义，clarify 环节 5 项歧义已澄清 |
| II. Dual-Track Agile | ✅ PASS | Discovery 已完成（spec + clarify），进入 Delivery 规划 |
| III. Agile-Stage-Gate Governance | ✅ PASS | TR0→TR1→TR2/TR3 逐级通过 |
| IV. Cross-Functional PDT | ✅ PASS | 无跨团队依赖，各技能负责人明确 |
| V. Quality Built-In | ✅ PASS | 降级机制、失败隔离、恢复策略均已定义 |

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: `.specify/memory/cbb-catalog.md`（不存在 — 首次评估）
- **Reusable blocks identified**:
  - `vipd-init` 的 `--integration` 参数解析模式（可扩展支持 claude-code）
  - `vipd-tasks` 的 tasks.md 生成逻辑（保持，新建 Workflow 脚本生成逻辑）
  - `vipd-implement` 的阶段执行循环（降级路径复用）
- **New components needed**:
  - Workflow 脚本生成器（模板引擎）
  - 运行时环境探测（检测 Workflow 工具可用性）
  - 配置读写扩展（`.vipd/config.yml` 的 mode 字段）
- **Reuse justification**: 核心技能逻辑保持不变，仅在 Claude Code 模式下添加并行路径

## Project Structure

### Documentation (this feature)

```text
specs/018-claude-code-workflow/
├── plan.md              # 本文件
├── research.md          # Phase 0 输出
├── data-model.md        # Phase 1 输出
├── quickstart.md        # Phase 1 输出
├── contracts/           # Phase 1 输出
└── tasks.md             # Phase 2 输出 (/vipd-tasks)
```

### Source Code (repository root)

```text
.claude/
├── skills/
│   ├── vipd-init/
│   │   └── SKILL.md              # 修改：支持 --integration claude-code
│   ├── vipd-tasks/
│   │   └── SKILL.md              # 修改：Claude Code 模式下生成 Workflow 脚本
│   └── vipd-implement/
│       └── SKILL.md              # 修改：Claude Code 模式下调用 Workflow 工具
└── templates/
    └── workflow-template.js      # 新建：Workflow 脚本模板
```

**Structure Decision**: 选择单一项目结构。所有技能文件在同一仓库中修改，Workflow 脚本模板集中存放。新增 `.claude/templates/` 目录。

## Phase 0: Research Plan

### Unknowns to resolve

1. **Claude Code Workflow API 规范** — `agent()`、`parallel()`、`pipeline()`、`phase()` API 签名和约束
2. **Workflow 脚本结构最佳实践** — 标准 `.wf.js` 文件模板设计
3. **`vipd-init` 集成增强模式** — 扩展 `--integration` 参数的最佳实现方式
4. **Workflow 工具调用机制** — 在 SKILL.md 中如何正确通过 Workflow tool 执行脚本
5. **环境探测策略** — 如何可靠检测当前是否在 Claude Code 环境中运行

### Research → `research.md`
