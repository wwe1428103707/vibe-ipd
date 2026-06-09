# Research: Claude Code Workflow Optimization

**创建日期**: 2026-06-09
**目的**: 解析 Claude Code Workflow API 并确定实现方案
**来源**: [Claude Code Workflow 文档](https://code.claude.com/docs/en/workflows.md)、Claude Code 内置 Workflow 工具 API 参考、vipd 项目现有技能分析

---

## Decision 1: Workflow 脚本结构与 API

**决定**: 使用标准 Claude Code Workflow 格式，通过 `export const meta` + `agent()`、`parallel()`、`pipeline()`、`phase()`、`log()`、`budget`、`args` 编排任务

**论证**:
- 这是 Claude Code Workflow 的标准 API，由运行时原生支持
- `parallel()` 提供 Barrier 语义，适合 Setup/Foundational → User Story 的阶段性切换
- `pipeline()` 是无 Barrier 的逐项多阶段模式，适合不需要全部完成后才继续的场景
- `agent()` 支持 `schema` 参数返回结构化 JSON，`isolation: 'worktree'` 隔离执行，`model` 覆写模型
- `phase()` 提供进度分组，用户可通过 `/workflows` 命令实时查看
- `budget` 提供 `total`、`spent()`、`remaining()` 用于动态控制令牌消耗

**已验证的 API 签名**:

| 函数 | 签名 | 说明 |
|------|------|------|
| `meta` | `export const meta = { name, description, phases }` | 必需。纯字面量，不能包含变量或计算值 |
| `agent` | `(prompt, opts?)` | `opts`: `label`, `phase`, `schema`(JSON Schema), `model`, `isolation('worktree')`, `agentType` |
| `parallel` | `(thunks: Array<() => Promise>)` | Barrier 并发，全部完成才返回。失败项返回 null 不抛错 |
| `pipeline` | `(items, ...stages)` | 逐项多阶段，无 Barrier。默认行为 |
| `phase` | `(title: string)` | 设置当前进度分组 |
| `log` | `(message: string)` | 输出进度消息（叙述者行，非 agent 输出） |
| `args` | 全局变量 | 传递给 Workflow 的输入参数，数组/对象保持结构 |
| `budget` | `{ total, spent(), remaining() }` | 令牌预算控制 |

**运行时约束**:

| 约束 | 值 |
|------|-----|
| 最大并行 Agent 数 | 16（CPU 核数少时更少） |
| 单次运行总 Agent 数上限 | 1,000 |
| 文件系统/Shell 访问 | 仅 agent 内部可访问，workflow 脚本本身无直接访问 |
| 权限模式 | subagents 始终以 `acceptEdits` 模式运行 |
| 暂停恢复 | 同 session 内可恢复，已完成 agent 返回缓存结果 |
| 脚本语言 | 纯 JavaScript（不能有 TypeScript 类型注解） |

**替代方案考虑**:
- 使用子进程手动管理并发 → 不采用，与 Workflow 原生功能重复
- 只使用 `parallel()` 不用 `pipeline()` → 根据场景选择：Barrier 需要时用 `parallel()`，否则用 `pipeline()` 减少等待

---

## Decision 2: 编排策略 — pipeline 优先

**决定**: 采用 `pipeline()` 作为默认编排模式，在需要 Barrier 的场景使用 `parallel()`

**论证**:
- Workflow 文档明确 "DEFAULT TO pipeline()"
- Setup 和 Foundational 阶段：用 `parallel()` Barrier 确保全部就绪
- User Story 实现阶段：用 `parallel()` 并发执行各 Story
- Task 内部多个子任务：用 `pipeline()` 或合并到同一个 `agent()` 中

**编排结构**:

```
phase('Setup') → parallel(setup agents)          // Barrier: 全部 Setup 完成
phase('Foundational') → parallel(foundation agents) // Barrier: 全部 Foundational 完成
phase('User Stories') → parallel(story agents)    // Barrier: 全部 User Story 完成
phase('Polish') → parallel(polish agents)         // Barrier: 全部收尾完成
```

---

## Decision 3: `vipd-init` 集成增强

**决定**: 扩展 `--integration` 参数支持 `claude-code` 值，在 `init-options.json` 中写入临时标记，然后由 init 脚本将 `mode: claude-code` 写入 `.vipd/config.yml`

**论证**:
- 当前 `--integration` 已支持 `claude` 和 `copilot`，扩展 `claude-code` 是最小侵入改动
- 初始化完成后将 mode 写入 `.vipd/config.yml`，与 language 配置保持一致的访问模式
- `init-options.json` 保留初始化记录（溯源用途），所有运行时读取走 `.vipd/config.yml`

**变更点**:
- SKILL.md 参数说明：增加 `--integration claude-code` 示例
- 初始化后置步骤：新增 `.vipd/config.yml` 的 `mode` 写入逻辑
- `init-options.json`：新增 `"integration_workflow": true` 临时标记

---

## Decision 4: Workflow 脚本生成策略

**决定**: 每次运行 `vipd-tasks` 时自动重新生成 Workflow 脚本，使用模板 + 动态注入任务映射

**论证**:
- tasks.md 是单源真相，Workflow 脚本是从 tasks.md 派生的
- 自动重新生成确保两者始终一致
- Workflow 脚本是纯 JavaScript（非 TypeScript），无类型注解

**Workflow 脚本生成流程**:
1. 解析 tasks.md 提取：Phase 结构、User Story 标签、`[P]` 并行标记
2. 读取 Workflow 模板文件
3. 动态生成映射：
   - Phase 1 (Setup) → `phase('Setup')` + `parallel()` 块
   - Phase 2 (Foundational) → `phase('Foundational')` + `parallel()` 块
   - Phase 3+ (User Stories) → 每个 User Story 一个独立 `agent()` 或 `parallel()` 块
   - 每个 `[P]` 标记任务 → 独立 `agent()` 调用
4. 写入 `.claude/workflows/execute-tasks.wf.js`

---

## Decision 5: 环境探测策略

**决定**: 两步探测法 — 先读配置标记，再通过尝试调用 Workflow 进行运行时探测

**探测流程**:
1. 读取 `.vipd/config.yml`，检查 `mode: claude-code`
2. 如非 claude-code 模式 → 传统模式
3. 如是 → 尝试通过 Workflow 工具执行一个最小验证脚本
4. 调用成功 → 继续 Workflow 模式
5. 调用失败（工具不存在或抛出错误）→ 降级到传统模式，日志记录降级原因

**降级不可逆性**: 本次 `vipd-implement` 执行期间不重试探测。

**探测脚本示例**:
```javascript
export const meta = { name: 'probe', description: 'Runtime probe', phases: [] }
// 空 workfklow — 仅验证 Workflow 工具可用
```

---

## 原始数据参考

- [Claude Code Workflow 文档](https://code.claude.com/docs/en/workflows.md) — 动态 workflow 概念、约束、管理
- [Agent Teams 文档](https://code.claude.com/docs/en/agent-teams.md) — 多 Agent 团队协作模式
- [Subagents 文档](https://code.claude.com/docs/en/sub-agents.md) — agent 定义和配置
- 技能模板位置: `.claude/templates/workflow-template.js`（新建）
- 现有技能: `vipd-init` (SKILL.md)、`vipd-tasks` (SKILL.md)、`vipd-implement` (SKILL.md)
