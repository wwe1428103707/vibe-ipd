---

description: "Task list for Gate Report Editorial Redesign — Feature 021"
---

# Tasks: 门控报告编辑风格优化

**输入**: Design documents from `specs/021-report-editorial-redesign/`

**前置条件**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅

**IPD 模式**: 已激活 — 测试为强制要求（Constitution Principle V: Quality Built-In）。测试任务以浏览器渲染验证为主（此 Feature 为纯前端模板增强，无单元测试框架）。

---

## Format: `[ID] [P?] [Story] Description`

- **[P]**: 可并行执行（不同文件/区域，无依赖）
- **[Story]**: 所属用户故事 (US1–US4)
- 描述中包含精确文件路径

## Path Conventions

```text
.claude/templates/report-template.html    # 主目标模板
.specify/scripts/powershell/generate-report.ps1  # 数据注入脚本
```

---

## Phase 1: Setup (共享基础设施)

**目的**: 理解现有代码结构，建立编辑风格基础配置

- [x] T001 阅读现有 `report-template.html`，分析当前结构、样式和 JS 渲染逻辑
- [x] T002 阅读 `generate-report.ps1`，确认数据注入流程和 JSON 格式
- [x] T003 在 `.claude/templates/report-template.html` 中设置 TailwindCSS CDN 和 `tailwind.config` 扩展（fontFamily、colors: ink/gold/burgundy/navy）
- [x] T004 [P] 添加自定义 CSS：`.skip-link`、`.drop-cap::first-letter`、`@media (prefers-reduced-motion: reduce)` 动画禁用

**Checkpoint**: TailwindCSS 基础配置完成，自定义样式已添加

---

## Phase 2: Foundational (阻塞性前置条件)

**目的**: 页面骨架结构 — Masthead 报头 + Footer 页脚（所有 User Story 共享的基础骨架）

**⚠️ CRITICAL**: 此阶段完成后才能开始 User Story。报头和页脚是所有 Stories 的共享结构。

- [x] T005 在 `report-template.html` 中构建报头 Masthead：出版物名称"The Gate Report" + 期号徽章 + 日期 + 导航区（Overview / Gates / Workflow / History），桌面端水平导航（overflow-x-auto）
- [x] T006 在 `report-template.html` 中构建页脚 Footer：分区链接 + 项目信息 + 期号/日期元数据 + "↑ Back to top" 链接
- [x] T007 [P] 构建 12 列网格布局系统（`grid grid-cols-12 gap-6`）和 `mx-auto max-w-7xl` 容器

**Checkpoint**: 骨架就绪 — Masthead + Footer + 12 列网格系统

> **门控完成验证**: 所有 Setup 和 Foundational 任务 [ ] 已完成 / [ ] 已验证

---

## Phase 3: User Story 1 — 报纸风格全页面布局 (Priority: P1) 🎯 MVP

**目标**: 实现报纸编辑风格的核心页面布局，包含 Hero 头版故事、多栏区域、引言摘录，使用黑白灰 + 点缀色配色和细线分隔，使报告呈现可读性强、层次清晰的专业报纸风格。

**独立测试**: 在浏览器中直接打开生成的 HTML 文件，验证报头、Hero 区域、多栏布局、引言、时间线等元素正确渲染。截图对比与 spec 中的视觉描述是否一致。

### 视觉验证 (强制 — IPD Quality Built-In)

- [x] T008 [P] [US1] 视觉验证：报头 Masthead 正确显示出版物名称、期号、日期和导航链接，导航锚点可点击跳转

### 实现任务

- [x] T009 [P] [US1] 在 `report-template.html` 中构建 Hero/头版故事区域：大标题（`font-serif text-4xl`）+ 副标题 dek + 署名 byline + 指标摘要卡片
- [x] T010 [P] [US1] 在 `report-template.html` 中构建 Highlights 行：3–4 个次要故事卡片，含类别标签、标题、1–2 行摘要
- [x] T011 [P] [US1] 在 `report-template.html` 中构建 Section 块区域：Features（2 列网格）、数据块（卡片化，含标签/数值/趋势）
- [x] T012 [P] [US1] 在 `report-template.html` 中构建引言 Pull Quotes 区域：更大字体、细线边框或点缀色边条、署名、可选 drop cap
- [x] T013 [US1] 在 `report-template.html` 中构建 Gate History 时间线区域：每条记录以报纸文章卡片形式呈现（含门控状态标识、条件表格、证据摘要）
- [x] T014 [US1] 实现颜色系统：黑白灰基调（`neutral-50`~`neutral-900`），navy/gold/burgundy 点缀色应用于导航、标签、引言、分隔线等元素
- [x] T015 [US1] 实现细线分隔系统：`divide-y divide-neutral-200`，除引言和卡片外避免阴影

**Checkpoint**: US1 报纸风格布局完成 — 报头 → Hero → Highlights → Sections → Pull Quotes → 时间线 → Footer 完整页面

---

## Phase 4: User Story 2 — 工作流指标看板 (Priority: P1)

**目标**: 在报告中增加"Workflow Intelligence"区域，从 gate-history.jsonl 数据中推导并展示并行任务数、Agent 数、活跃阶段数、任务完成率等指标。

**独立测试**: 生成包含多次门控检查（含 conditions 数据）的报告后，打开 HTML 文件验证工作流区域是否正确显示至少 4 项指标。

### 视觉与功能验证 (强制 — IPD Quality Built-In)

- [x] T016 [P] [US2] 功能验证：准备含 >=5 条带 conditions 的门控记录数据（可手动构造测试 JSONL），生成报告后验证工作流 4 项指标正确显示且数值合理

### 实现任务

- [x] T017 [P] [US2] 在 `report-template.html` 中构建"Workflow Intelligence"区域布局：4 个指标卡片（Parallel Tasks / Agents Spawned / Stages Active / Task Completion），含分类标签和数据数值
- [x] T018 [US2] 实现 JS 工作流指标推导逻辑：从 `gate-data` JSON 中遍历记录，按 research.md 中的推导公式计算 4 项指标。数据不足时显示 "—"

**Checkpoint**: US2 工作流指标看板完成 — 4 项指标正确显示，无数据时优雅降级

---

## Phase 5: User Story 3 — 桌面端视觉一致性 (Priority: P2)

**目标**: 确保报告在 1280px–1920px 各种桌面宽度下布局一致、字体大小合适、间距协调。

**独立测试**: 在 1280px、1440px、1920px 三种宽度打开报告，截图对比无内容偏移或排版断裂。

### 视觉验证 (强制 — IPD Quality Built-In)

- [x] T019 [P] [US3] 视觉验证：在 1280px / 1440px / 1920px 三种宽度截图，对比布局一致性。主要内容区域应保持居中，间距适当，无溢出或断裂

### 实现任务

- [x] T020 [US3] 调整所有 TailwindCSS 断点类（`lg:`）确保 1024px–1920px 范围内 12 列网格正确展开，无窄屏单栏降级
- [x] T021 [US3] 在 `report-template.html` 中设置 `max-w-7xl` 容器和响应式 padding（`px-6 lg:px-10`），确保宽屏下左右间距一致

**Checkpoint**: US3 桌面端一致性完成 — 1280px–1920px 全宽适配

---

## Phase 6: User Story 4 — 时间线交互过滤 (Priority: P2)

**目标**: 用户可以通过下拉筛选器按门控阶段过滤历史时间线中的记录。

**独立测试**: 在包含多个 TR 门记录的报告中使用下拉框筛选特定门，验证时间线只显示该门记录。

### 功能验证 (强制 — IPD Quality Built-In)

- [x] T022 [P] [US4] 功能验证：在报告中使用筛选器下拉框选择特定门（如 TR1），验证时间线只显示该门记录。切换回"全部"后恢复显示所有记录

### 实现任务

- [x] T023 [US4] 在 `report-template.html` 的历史时间线区域实现下拉筛选器：从 `gate-data` JSON 中提取唯一的 gate 列表生成 `<select>` 选项，添加 `change` 事件监听过滤渲染

**Checkpoint**: US4 时间线过滤完成 — 筛选器正确工作

---

## Phase 7: Polish & 跨切面关注点

**目的**: 无障碍、动效、性能优化、文档更新

- [x] T024 [P] 在 `report-template.html` 中添加无障碍支持：`skip-link` 跳过导航、`aria-label` 标注、`role` 属性、`focus-visible:outline` 聚焦环
- [x] T025 在 `report-template.html` 中验证 `prefers-reduced-motion` 动效屏蔽生效，所有过渡 140–200ms
- [x] T026 [P] 在 `generate-report.ps1` 中确认数据注入格式兼容（JSON 序列化深度、空数据处理）
- [x] T027 验证所有交互元素（导航链接、筛选器、返回顶部）键盘可聚焦
- [x] T028 使用 .claude/templates/report-template.html 生成实际报告（运行 generate-report.ps1），在 Chrome/Firefox/Edge 中打开验证渲染一致性
- [x] T029 更新 `report-template.html` 文件头注释和文档（代码中的实现说明）
- [x] T030 运行最终验证：空数据状态 → 正常数据 → 边界数据（50+ 记录浏览无卡顿）

---

## 依赖关系与执行顺序

### Phase Dependencies

- **Setup (Phase 1)**: 无依赖 — 可立即开始
- **Foundational (Phase 2)**: 依赖 Setup 完成 — **阻塞所有 User Stories**
- **User Stories (Phase 3–6)**: 全部依赖 Phase 2 完成
  - US1 (P1) → US2 (P1) → US3 (P2) → US4 (P2) 按优先级顺序
  - 同优先级 (P1) 的 US1 和 US2 可选择并行
- **Polish (Final Phase)**: 依赖所有 User Stories 完成

### 并行机会

- Phase 1 中的 T004 可并行执行
- Phase 2 中的 T007 可并行执行
- US1 中 T009–T012 可在模板不同区域并行实现
- US4 中 T024 可在其他阶段并行执行

### 并行示例: US1 报纸布局

```bash
# 并行实现模板各区域（不同 DOM 区域，无冲突）:
Task: "构建 Hero 头版故事区域 (T009)"
Task: "构建 Highlights 行 (T010)"
Task: "构建 Section 块区域 (T011)"
Task: "构建 Pull Quotes 区域 (T012)"
```

### 并行示例: US1 + US2 并行

```bash
# US1 和 US2 的布局和核心渲染无依赖冲突:
Task: "构建 Hero + Highlights + Sections (US1)"
Task: "构建 Workflow Intelligence 区域布局 (US2)"
```

---

## 实现策略

### MVP 优先 (仅 US1 + US2 = P1 Stories)

1. 完成 Phase 1: Setup → 基础配置
2. 完成 Phase 2: Foundational → Masthead + Footer + 网格
3. 完成 Phase 3: US1 → 报纸布局（核心价值）
4. 完成 Phase 4: US2 → 工作流指标（核心价值）
5. **停，验证**: 打开 HTML 文件验证 US1 + US2 完整工作
6. 交付/评审

### 增量交付

1. Setup + Foundational → 骨架就绪
2. + US1 → 可读的报告布局 (MVP!)
3. + US2 → 工作流指标 (P1 完成)
4. + US3 → 宽屏一致性 (P2)
5. + US4 → 过滤交互 (P2)
6. + Polish → 无障碍 + 最终验证

---

## 注释

- [P] 任务 = 不同文件/区域，无依赖冲突
- [Story] 标签将任务映射到特定用户故事
- 每个 User Story 应可独立完成和测试
- Path: `.claude/templates/report-template.html` 为主目标文件
- 此 Feature 不修改门控检查逻辑，仅增强报告前端呈现
- 每个 Phase 完成后可独立验证再进入下一 Phase
