# Feature Specification: 门控报告编辑风格优化

**Feature Branch**: `021-report-editorial-redesign`

**创建日期**: 2026-06-09

**状态**: Draft

**用户描述**: 将门控历史记录报告页面升级为 TailwindCSS 「现代编辑风格」布局，延续 newspaper 家族设计语言。增加工作流记录（并行任务数、Agent 数量、阶段完成率等）。

---

## 澄清记录

### 会话 2026-06-09

- Q: 移动端导航方式（汉堡菜单 vs 水平滚动）？ → A: 不需要移动端。报告为纯桌面端（≥ 1024px）设计，无需移动/平板响应式适配。
- Q: CTA/订阅区域功能范围（功能性 vs 装饰性）？ → A: 移除CTA区域。完全删除订阅表单和输入框。

---

## 用户场景与测试 *(必填)*

### 用户场景 1 — 报纸风格全页面布局 (P1)

作为一名项目干系人，我打开 HTML 门控报告时，希望看到一份排版严谨、视觉现代的"数字报纸"——包含报头、头版故事、多栏区域、引言摘录和工作流指标看板，而不是一张数据表格。

**为什么是这个优先级**: 编辑风格的门控报告是核心交付物，直接影响利益相关者对门控系统的阅读体验和信任度。

**独立测试**: 打开生成的 HTML 文件，验证页面视觉风格符合报纸编辑规范（多栏布局、醒目标题、报头 Masthead）。

**验收场景**:

1. **Given** 生成的门控 HTML 报告，**When** 在浏览器中打开，**Then** 页面包含完整的报纸报头区域（出版名称、日期、期号徽章、导航区）
2. **Given** 门控报告打开，**When** 查看页面结构，**Then** 应该有 Hero/头版故事区域，包含大标题、副标题（dek）、署名行和日期
3. **Given** 门控报告，**When** 滚动页面，**Then** 内容应按"总览 → 门控阶段 → 工作流 → 历史时间线"的报纸风格层次组织

---

### 用户场景 2 — 工作流指标看板 (P1)

作为一名项目经理，我希望在报告中看到直观的工作流指标（并行任务数、启动的 Agent 数、阶段活跃数、任务完成率等），以便快速评估自动化工作流的执行效率。

**为什么是这个优先级**: 工作流指标是 Feature 019 自动化门控修复的关键配套数据，没有指标展示就无法衡量自动化的效果。

**独立测试**: 生成包含多次门控检查的记录后，报告的工作流区域应显示至少 4 项指标。

**验收场景**:

1. **Given** gate-history.jsonl 包含多条带有 conditions 和 auto_fix_attempted 字段的记录，**When** 生成 HTML 报告，**Then** 工作流区域应显示并行任务数、Agent 数、活跃阶段数、任务完成率
2. **Given** 门控记录中包含不同门的检查数据，**When** 生成报告，**Then** 工作流指标应随数据自动计算更新

---

### 用户场景 3 — 桌面端视觉一致性 (P2)

作为一名用户，我在会议室大屏或桌面显示器上打开门控报告，希望布局在各种宽屏尺寸下都保持良好的阅读体验。

**为什么是这个优先级**: 报告主要在生产环境（桌面）查看，确保宽屏下视觉一致是基本要求。

**独立测试**: 在 1280px、1440px、1920px 三种桌面宽度打开报告，验证布局无偏移或内容溢出。

**验收场景**:

1. **Given** 门控报告在桌面端打开，**When** 视口宽度 ≥ 1024px，**Then** 内容以 12 列网格多栏布局展示，卡片和文章呈多列排列
2. **Given** 门控报告在 1920px 宽屏打开，**Then** 布局依然居中，左右间距一致，不出现过度拉伸或稀疏

---

### 用户场景 4 — 时间线交互过滤 (P2)

作为一名技术负责人，我希望能够按门控阶段过滤历史记录，快速定位特定门的详细信息。

**为什么是这个优先级**: 虽然过滤交互是 P2，但它是编辑风格报告中"实用性与美感并重"的体现。

**独立测试**: 在报告的门控历史区域，使用下拉筛选器选择特定门，验证列表中只显示该门控的记录。

**验收场景**:

1. **Given** 门控报告包含多个 TR 门的记录，**When** 从筛选器下拉框选择一个门（如 TR1），**Then** 历史时间线只显示该门的记录
2. **Given** 筛选器设为"全部"，**When** 查看历史时间线，**Then** 显示所有门的记录

---

### 边界情况

- 如果 gate-history.jsonl 为空或不存在，报告应显示"暂无门控记录"的空状态页面，而非白页或报错
- 如果门控记录数量很大（50+ 条），时间线应使用虚拟滚动或懒加载避免页面卡顿（建议使用 `scroll` 事件分批渲染）
- 如果所有门控都通过，Hero 区域显示"✅ All Systems Operational"；如果有降级或失败，显示对应状态和警示色
- 如果某条记录缺少 conditions 字段，时间线中的该记录应优雅降级显示"无条件数据"
- 工作流指标数据从已有记录中推导，如果数据不足以推导某项指标，显示"—"而非错误

---

## TR 门控评估 *(IPD only)*

- **适用 TR 门**: TR1 (概念) — 此功能不引入新的门控逻辑，仅增强已有 `generate-report.ps1` 和 `report-template.html`
- **风险等级**: 低 — 纯前端样式和工作流指标增强，不影响门控检查逻辑
- **门控证据要求**: 功能规格说明书、HTML 报告模板设计稿

---

## 需求 *(必填)*

### 功能需求

**视觉语言 (Visual Language)**

- **FR-001**: 报告页面必须使用 TailwindCSS（通过 CDN 内联加载），不得引入其他 CSS 框架
- **FR-002**: 调色板以黑白灰为主（`neutral-50`/`neutral-100`/`neutral-200`/`neutral-600`/`neutral-900`），单点缀色支持 `navy`（深蓝）、`burgundy`（酒红）、`gold`（哑金）三种可选，通过 CSS class 控制
- **FR-003**: 布局基于 12 列网格系统（`grid grid-cols-12`），桌面端一致间距 24–32px（`gap-6` 到 `gap-8`）
- **FR-004**: 分隔线使用细 1px 实线（`border`/`divide-y`），可选虚点线（`border-dotted`），禁止使用重阴影或渐变
- **FR-005**: 页面背景为纯白（`bg-white`）或米白（`bg-neutral-50`），侧边栏可使用浅灰面板（`bg-neutral-100`）

**布局规范 (Layout Blueprint)**

- **FR-006**: 顶部报头（Masthead）必须包含：出版物名称（"The Gate Report"）、日期、期号徽章（`Issue ##`）、导航区（Overview / Gates / Workflow / History）
- **FR-007**: Hero/头版故事区域必须包含：大标题（`font-serif text-4xl lg:text-5xl`）、副标题 dek（2–3 行）、署名行（`byline` with date）、指标摘要卡片（通过率/失败数等）
- **FR-008**: Highlights 行：3–4 个次要故事的卡片，包含类别标签（kicker）、标题、1–2 行摘要，固定宽高比
- **FR-009**: Section 块：每个门控数据分类（Features/Reports/Workflow）作为独立区块，有区头标签、跳转锚点，采用专栏式布局
  - Feature 块：2 列网格，主故事 + 辅故事
  - 数据块：卡片化，包含数据标签、数值、趋势
- **FR-010**: 引言/语录（Pull Quotes）区域：更大的字体（`font-serif text-lg`），细线边框或点缀色边条，署名，可选的 drop cap
- **FR-011**: 数据/信息图区域（可选）：简洁线条和点缀色风格，必须包含图注和数据来源
- **FR-012**: 页脚：包含分区链接、项目信息、期号/日期元数据、"返回顶部"链接

**排版规范 (Typography)**

- **FR-014**: 标题使用衬线字体（Georgia / Times New Roman），权重 600–700；正文使用人文无衬线字体（Inter / system-ui），字号 16–18px，行高 1.7–1.8
- **FR-015**: 类别标签（Kicker）使用大写 + 字母间距（`uppercase tracking-[.2em]`），署名可选用小型大写（`text-[.65rem] font-semibold`）
- **FR-016**: 大标题必须使用 `text-balance` 或 `text-wrap: balance` 避免孤行（widow）
- **FR-017**: 首段可选 Drop Cap 效果（`drop-cap::first-letter` 类），必须保持样式一致

**交互与状态 (Components & States)**

- **FR-018**: 按钮风格简约为主：主色填充（`bg-navy text-white hover:bg-navy/90`），次要为描边（`border border-neutral-300`），禁止重阴影
- **FR-019**: 卡片样式：`rounded-lg border border-neutral-200 bg-white p-5 md:p-6 transition hover:-translate-y-0.5`，避免重阴影
- **FR-020**: 标签/徽章：小型大写 + 点缀色 + 细边框（`rounded border border-gold/30 px-2 py-0.5 text-[.65rem]`）
- **FR-021**: 输入框：`border border-neutral-300 rounded-md px-4 py-3`，聚焦时带点缀色 ring（`focus:ring-2 focus:ring-navy/30`）
- **FR-022**: 列表/表格：使用 `divide-y divide-neutral-200`，数字右对齐

**动效与无障碍 (Motion & Accessibility)**

- **FR-023**: 动效最小化：过渡 140–200ms，禁止视差。必须尊重 `prefers-reduced-motion`（使用 `@media (prefers-reduced-motion: reduce)` 屏蔽动画）
- **FR-024**: 悬停状态：卡片悬停时轻微上移（`hover:-translate-y-0.5`）+ 阴影变化，无弹跳效果
- **FR-025**: 所有文本必须满足 WCAG 4.5:1 对比度要求；图片上的标题必要时使用遮罩层（scrim）
- **FR-026**: 导航和卡片都必须是键盘可聚焦的，并显示可见的聚焦环（`focus-visible:outline focus-visible:outline-2`）
- **FR-027**: 必须提供"跳过导航"链接（`skip-link` 类），DOM 顺序 = 阅读顺序，禁止为布局重排

**响应式行为 (Responsive Behavior)**

- **FR-028**: 报告面向桌面端（≥ 1024px）优化，容器宽度 `mx-auto max-w-7xl`，12 列网格多栏布局。无移动端/平板适配要求。

**工作流记录展示**

- **FR-031**: 报告必须包含"Workflow Intelligence"区域，展示以下工作流指标：
  - 并行任务数（Parallel Tasks）：从指定门控的 conditions 中提取的任务类条件数量
  - 启动 Agent 数（Agents Spawned）：从 conditions 总数/检查次数推导的并发 Agent 估算值
  - 活跃阶段数（Stages Active）：当前未通过的活跃门阶段数
  - 任务完成率（Task Completion）：已完成任务占总任务的百分比
- **FR-032**: 工作流指标从 gate-history.jsonl 中已有的门控记录字段（conditions、auto_fix_attempted、gate、status）自动推导计算
- **FR-033**: 当数据不足以推导某项指标时，显示 "—"（长破折号）而非空白或错误

**数据处理与注入**

- **FR-034**: 报告数据通过 `<script id="gate-data" type="application/json">` 标签注入，无需外部 API 请求
- **FR-035**: `generate-report.ps1` PowerShell 脚本负责从 `.specify/memory/gate-history.jsonl` 读取记录并注入模板
- **FR-036**: 生成的 HTML 报告必须是完全自包含的文件（所有样式和脚本内联），可以直接在浏览器中打开

### 关键实体

- **GateRecord (门控记录)**: 单次门控检查的完整 JSON 数据，包含 gate ID、timestamp、conditions 列表、status、auto_fix_attempted 等
- **WorkflowMetrics (工作流指标)**: 从门控记录集合中推导的工作流统计值，包括 parallel tasks、agents spawned、stages active、task completion 等
- **GateReportTemplate (报告模板)**: `report-template.html` 文件，编辑风格 HTML 结构，TailwindCSS 样式和内联 JS 逻辑

---

## 成功标准 *(必填)*

### 可衡量的成果

- **SC-001**: 报告在最近版本 Chrome/Firefox/Edge 中渲染一致，视觉布局无偏移
- **SC-002**: 从打开 HTML 文件到内容完全可视 < 1 秒（纯静态 HTML，无外部依赖）
- **SC-003**: 工作流指标区域始终显示至少 4 项指标（并行任务数、Agent 数、活跃阶段数、完成率），数据为空时显示"—"占位
- **SC-004**: 报告在三种桌面宽度（1280px / 1440px / 1920px）下布局正确，无内容截断或重叠
- **SC-005**: 键盘用户可以通过 Tab 键遍历所有交互元素（过滤器下拉框、导航链接），并且聚焦环清晰可见
- **SC-006**: 验证 `prefers-reduced-motion` 时所有过渡动画被禁用，不影响功能使用
- **SC-007**: 生成的 HTML 文件是完全自包含的，可以离线打开而不依赖任何外部资源

---

## 假设

- Feature 019（Auto Gate Fix & Report）已实现基本的 `gate-history.jsonl` 写入逻辑和数据格式
- Feature 020（Editorial Gate Report）已定义基本编辑风格概念，本功能在其基础上深化视觉细节和工作流指标
- `gate-history.jsonl` 记录中已包含 `conditions`、`status`、`gate`、`timestamp`、`auto_fix_attempted`、`feature` 等字段
- HTML 报告模板存储在 `.claude/templates/report-template.html`，由 `generate-report.ps1` 负责数据注入
- 工作流指标从已有数据推导，不从外部系统获取
- 报告生成命令 `/vipd-report` 保持独立可用，不绑定到特定阶段
- 报告为纯桌面端设计，无需移动端/平板响应式适配。最小支持宽度 1024px

---

## 风险登记 *(IPD only)*

| 风险 | 影响 | 可能性 | 缓解措施 |
|------|------|--------|----------|
| 编辑风格样式过于复杂导致模板维护困难 | 中 | 中 | 保持 TailwindCSS 内联加载，样式集中在 tailwind.config 和少量自定义 CSS 中 |
| 工作流指标推导方式不准确 | 低 | 中 | 指标标记为"预估"，随 gate-history 数据结构完善逐步精确化 |
| 报告内容过多时页面性能下降 | 中 | 低 | 时间线采用懒加载分批渲染，50+ 记录时自动分页 |
