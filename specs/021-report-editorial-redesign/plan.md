# Implementation Plan: 门控报告编辑风格优化

**Branch**: `021-report-editorial-redesign` | **日期**: 2026-06-09 | **Spec**: [spec.md](spec.md)

**输入**: Feature specification from `specs/021-report-editorial-redesign/spec.md`

---

## Summary

对 `report-template.html` 进行视觉升级，采用 TailwindCSS 现代编辑风格（报纸布局），使其呈现为一份排版严谨的"数字报纸"。同时增加工作流指标展示区域（并行任务数、Agent 数、阶段完成率等）。核心变更仅涉及前端模板和生成脚本，不修改门控检查逻辑。

**技术路径：**
- 重构 `.claude/templates/report-template.html` — 重新设计 HTML 结构、TailwindCSS 样式和内联 JS
- 微调 `.specify/scripts/powershell/generate-report.ps1` — 确保数据注入格式兼容（如需要）
- 所有变更集中在单个模板文件中，无需新增依赖或架构变更

---

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS ✅
- **TR Gates Passed**: TR0 ✅ → TR1 ✅ → TR2/TR3 ✅
- **Next Gate**: TR4 (Development)

---

## Technical Context

**Language/Version**: HTML5, CSS3 (TailwindCSS v3.4+ via CDN), Vanilla JS (ES6)

**Primary Dependencies**: TailwindCSS CDN (`https://cdn.tailwindcss.com`) — 无 bundler/构建工具依赖

**Storage**: N/A — 生成静态自包含 HTML 文件，无运行时数据存储

**Testing**: 手动浏览器测试 (Chrome/Firefox/Edge) + 视觉比对

**Target Platform**: 桌面浏览器 (≥ 1024px 视口宽度)

**Project Type**: 静态 HTML 模板 + PowerShell 脚本（生成器）

**Performance Goals**: 页面加载 < 1 秒（CDN 缓存后），生成的文件 < 200KB

**Constraints**: 
- 生成的 HTML 必须完全自包含（无外部 CSS/JS 文件依赖）
- TailwindCSS 通过 CDN 加载，不得引入 node_modules 或构建步骤
- 导航、卡片、CTA 必须键盘可聚焦

**Scale/Scope**: 单模板文件 + 单生成脚本，影响范围限于报告查看环节

**WSJF Priority Score**: 20 (Value=8, Time Criticality=5, Risk Reduction=3, Job Size=4)

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| 原则 | 检查结果 | 说明 |
|------|----------|------|
| I. Spec-First, Intent-Driven | ✅ 通过 | 规格已定义完整的视觉和功能意图 |
| II. Dual-Track Agile | ✅ 通过 | 纯增强性功能，不涉及用户探索 |
| III. Agile-Stage-Gate Governance | ✅ 通过 | TR2/TR3 门控已通过 |
| IV. Cross-Functional PDT | ✅ 通过 | 不涉及跨团队依赖 |
| V. Quality Built-In | ✅ 通过 | 成功标准包含可衡量的浏览器兼容性和性能指标 |

**结论**: 通过 ✅ — 无违规项需在复杂性跟踪中说明

---

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: 无 — 项目当前未建立 CBB 目录
- **可复用组件**: 
  - 现有 `report-template.html` 结构可复用（数据注入模式和渲染函数）
  - 现有 `generate-report.ps1` 数据注入逻辑可直接复用
- **新增组件**: 重新设计的 HTML 模板（TailwindCSS 编辑风格）
- **复用说明**: 保留现有数据注入架构和 JSON 格式，仅替换视觉呈现层

---

## Project Structure

### 文档结构 (本 Feature)

```text
specs/021-report-editorial-redesign/
├── spec.md              # 规格说明书
├── plan.md              # 本文件 (当前)
├── research.md          # Phase 0 输出
├── data-model.md        # Phase 1 输出
├── quickstart.md        # Phase 1 输出
├── contracts/           # Phase 1 输出
│   └── report-data-format.md  # 门控数据注入格式
└── tasks.md             # Phase 2 输出 (/vipd-tasks 创建)
```

### 源代码 (仓库根目录)

```text
.claude/templates/
├── report-template.html     # ✅ 主目标 — 重新设计为编辑风格
└── ...其他模板...

.specify/scripts/powershell/
├── generate-report.ps1      # ✅ 辅助目标 — 更新数据注入（如需要）
└── ...其他脚本...
```

**结构决策**: 单模板文件 + 单生成脚本。所有样式和逻辑内联在 HTML 文件中，无需创建新目录或模块。此决策符合"纯静态、轻量"的设计约束。

---

## Complexity Tracking

无违规项 — Constitution Check 全部通过，无复杂性需特殊说明。

---

## Phase 0: Research

### 待决项

本 Feature 在 clarify 阶段已解决所有歧义，无 NEEDS CLARIFICATION 标记。仅需确认 TailwindCSS 编辑风格的最佳实践。

| 待决项 | 状态 | 解决方式 |
|--------|------|----------|
| TailwindCSS CDN 配置 | ✅ 已解决 | 使用 CDN `tailwindcss` script + tailwind.config 扩展 |
| 编辑风格设计模式 | ✅ 已解决 | 基于 spec 中的完整视觉语言描述 |
| 工作流指标推导 | ✅ 已解决 | 从 gate-history.jsonl 直接推导（当前模板已有实现） |
| 移动端适配 | ✅ 已解决 | 澄清为纯桌面端 (≥ 1024px) |

### Research 输出

详见 [research.md](research.md)

---

## Phase 1: Design

### Data Model

详见 [data-model.md](data-model.md)

核心实体：
- **GateRecord**: 门控检查记录（来自 gate-history.jsonl）
- **WorkflowMetrics**: 从记录集合推导的工作流统计值

### Contracts

详见 [contracts/report-data-format.md](contracts/report-data-format.md)

数据注入格式：JSON 数组通过 `<script id="gate-data" type="application/json">` 标签注入。

### Quickstart

详见 [quickstart.md](quickstart.md)

如何重新生成报告、修改模板、验证输出。
