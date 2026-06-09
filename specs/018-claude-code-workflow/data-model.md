# Data Model: Claude Code Workflow Optimization

## 实体一览

| 实体 | 存储位置 | 用途 |
|------|----------|------|
| WorkflowMode | `.vipd/config.yml` | 标记项目是否启用 Workflow 模式 |
| WorkflowScript | `.claude/workflows/execute-tasks.wf.js` | 可执行的 Workflow 编排脚本 |
| WorkflowTemplate | `.claude/templates/workflow-template.js` | Workflow 脚本生成模板 |
| TaskMapping | 内存/动态生成 | tasks.md → Workflow agent() 调用的映射关系 |
| ExecutionReport | 实时日志 + 最终摘要 | Workflow 执行汇总 |

---

## 1. WorkflowMode

存储在 `.vipd/config.yml` 的 `mode` 字段。

**字段定义**:

| 字段 | 类型 | 必填 | 值域 | 说明 |
|------|------|------|------|------|
| `mode` | string | 是 | `"standard"` / `"claude-code"` | 当前项目的工作模式 |
| `max_concurrent_agents` | int | 否 | 1~16，默认自适应 `min(5, 用户故事数)` | 最大并行 Agent 数。运行时上限 16 |

**状态转换**:

```
standard ──→ claude-code (通过 vipd config set mode claude-code)
claude-code ──→ standard (通过 vipd config set mode standard)
```

**读取规则**:
- 所有下游技能从 `.vipd/config.yml` 读取
- `init-options.json` 仅作为初始化临时记录，不用于运行时读取

---

## 2. WorkflowScript

存储在 `.claude/workflows/execute-tasks.wf.js`。

**结构规范**:

```javascript
export const meta = {
  name: 'execute-tasks',
  description: 'Execute tasks for <feature-name>',
  phases: [
    { title: 'Setup', detail: 'Project initialization tasks' },
    { title: 'Foundational', detail: 'Blocking prerequisites' },
    { title: 'User Stories', detail: 'Parallel user story implementation' },
    { title: 'Polish', detail: 'Cross-cutting concerns' },
  ],
}

// Phase 1: Setup
phase('Setup')
const setupResults = await parallel(SETUP_TASKS.map(t => () => agent(t.prompt)))

// Phase 2: Foundational
phase('Foundational')
const foundationResults = await parallel(FOUNDATION_TASKS.map(t => () => agent(t.prompt)))

// Phase 3+: User Stories (parallel by story)
phase('User Stories')
const storyResults = await parallel(STORIES.map(s => () => agent(s.prompt)))
```

**生成规则**:
- 每次 `vipd-tasks` 运行时自动重新生成
- 使用 WorkflowTemplate 作为骨架
- 动态注入当前 feature 的任务映射
- 无依赖的 User Story 放入 `parallel()` 块
- `[P]` 标记的任务作为独立 `agent()` 调用

---

## 3. WorkflowTemplate

存储在 `.claude/templates/workflow-template.js`。

**结构**:
- 静态部分: `export const meta {}` 结构定义、`phase()`/`parallel()` 编排框架
- 占位符: `{{FEATURE_NAME}}`、`{{PHASES}}`、`{{TASK_MAPPINGS}}`、`{{CONCURRENCY}}`
- 动态注入: 由 `vipd-tasks` 在运行时填充

---

## 4. TaskMapping

内存中的映射表，用于将 tasks.md 中的任务结构化转换为 Workflow agent() 调用。

**映射规则**:

| tasks.md 结构 | Workflow 结构 |
|---------------|---------------|
| Phase 1 (Setup 无 Story 标签) | `phase('Setup')` → `parallel()` |
| Phase 2 (Foundational 无 Story 标签) | `phase('Foundational')` → `parallel()` |
| Phase 3+：[US1] 标签任务 | 独立 `agent()` or `parallel()` 块 |
| `[P]` 标记任务 | 独立 `agent()` 调用 |
| 顺序依赖任务 | 同一 `agent()` 调用内顺序执行 |
| 无 `[P]` 同一 Story 任务 | 合并到同一个 `agent()` 调用 |

---

## 5. ExecutionReport

Workflow 执行完成后的汇总信息。

**包含内容**:
- 每个 Phase 的执行状态（成功/失败/跳过）
- 每个 Agent 的标签、状态、产出摘要
- 总执行时长
- 失败任务的详细错误信息
- 降级（如有）的原因记录

**消费方式**: 通过 `vipd-implement` 的完成报告展示给用户。
