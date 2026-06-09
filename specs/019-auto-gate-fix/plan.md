# Implementation Plan: Auto Gate Fix & Report

**Branch**: `019-auto-gate-fix` | **Date**: 2026-06-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/019-auto-gate-fix/spec.md`

## Summary

增强 VIPD 门控系统：门控失败时 Agent 自动分析原因并修复（不再中断询问用户）；每个门控的详细检查条件记录到 `gate-history.jsonl`；提供 `/vipd-report` 命令生成静态 HTML 门控报告。

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS (see below)
- **TR Gates Passed**: TR0 ✅, TR1 ✅
- **Next Gate**: TR4 (Development Baseline) — transitioned through TR2/TR3 planning gate

## Technical Context

**Language/Version**: PowerShell (gate-check.ps1, gate-record.ps1) + HTML/CSS/JS (内联报告)

**Primary Dependencies**:
- 现有门控脚本: `gate-check.ps1`, `gate-record.ps1`, `gate-detect-ipd-mode.ps1`
- 现有记录文件: `.specify/memory/gate-status.json`
- JSON Lines 格式: `gate-history.jsonl`（新增）
- 各 skill 的 SKILL.md（修改门控失败处理逻辑）

**Storage**: `.specify/memory/gate-history.jsonl`（详细记录）、`.specify/memory/gate-status.json`（概览）、`specs/NNN-feature/vipd-report.html`（生成的报告）

**Testing**: 端到端测试 — 模拟门控失败场景 → 验证 Agent 自动修复 + 验证 JSONL 记录写入 + 验证 HTML 报告渲染

**Target Platform**: Claude Code CLI 中运行的 VIPD 工作流

**Project Type**: CLI 工具增强 / 门控系统增强

**Performance Goals**: 自动修复 ≤10 秒，HTML 报告生成 ≤5 秒（100 条记录）

**Constraints**:
- `gate-status.json` 必须保持向后兼容
- JSONL 格式确保追加写入性能 O(1)
- HTML 报告无外部依赖
- 自动修复不修改/删除现有文件

**Scale/Scope**: 影响 3 个门控脚本 + 5+ SKILL.md + 新增 1 个报告命令 + 1 个 HTML 报告生成脚本

**WSJF Priority Score**: 10 — (Value=5 + Time Criticality=3 + Risk Reduction=2) / Job Size=1

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| I. Spec-First, Intent-Driven | ✅ PASS | spec.md + clarify 4 项歧义已澄清 |
| II. Dual-Track Agile | ✅ PASS | 进入 Delivery 规划阶段 |
| III. Agile-Stage-Gate Governance | ✅ PASS | TR0→TR1→TR2/TR3 逐级通过 |
| IV. Cross-Functional PDT | ✅ PASS | 影响多个技能，均在项目范围内 |
| V. Quality Built-In | ✅ PASS | 自动修复有重试上限、安全合规门控不自动修复 |

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: `.specify/memory/cbb-catalog.md`（不存在）
- **Reusable blocks identified**:
  - `gate-check.ps1`（增强返回结构，添加 `fix_hint` 和 `category` 字段）
  - `gate-record.ps1`（扩写逻辑，增加 JSONL 写入分支）
- **New components needed**:
  - `.specify/scripts/powershell/generate-report.ps1`（HTML 报告生成器）
  - `.claude/templates/report-template.html`（HTML 报告模板）
  - `.specify/memory/gate-history.jsonl`（门控记录文件）
  - `.claude/skills/vipd-report/SKILL.md`（报告命令 skill）

## Project Structure

### Documentation (this feature)

```text
specs/019-auto-gate-fix/
├── plan.md              # 本文件
├── research.md          # Phase 0 输出
├── data-model.md        # Phase 1 输出
├── quickstart.md        # Phase 1 输出
├── contracts/           # Phase 1 输出
└── tasks.md             # Phase 2 输出
```

### Source Code (repository root)

```text
.specify/
├── scripts/
│   └── powershell/
│       ├── gate-check.ps1          # 修改：添加 fix_hint, category 字段
│       ├── gate-record.ps1         # 修改：增加 JSONL 写入
│       └── generate-report.ps1     # 新建：HTML 报告生成

.claude/
├── skills/
│   └── vipd-report/
│       └── SKILL.md               # 新建：/vipd-report 命令
└── templates/
    └── report-template.html       # 新建：HTML 报告模板

.specify/memory/
├── gate-status.json               # 不变
└── gate-history.jsonl             # 新建：详细门控记录
```

**Structure Decision**: 门控脚本增强保持原位，HTML 报告独立技能，JSONL 随同其他门控文件。

## Phase 0: Research Plan

### Unknowns to resolve

1. **gate-check.ps1 当前返回格式** — 了解当前 JSON 输出的结构和深度限制
2. **JSONL 格式设计** — 每条记录的确切字段和 schema
3. **HTML 报告自包含技术方案** — 内联 CSS/JS 实现
4. **SKILL.md 门控处理修改点** — 哪些 SKILL.md 需要修改

### Research → `research.md`
