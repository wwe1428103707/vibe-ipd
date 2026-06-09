# Quickstart: Claude Code Workflow Optimization

## 新项目 — 使用 Claude Code 模式

```bash
# 1. 初始化项目时指定 Claude Code 模式
vipd init my-project --integration claude-code

# 2. 创建章程
vipd-constitution

# 3. 编写需求规格
vipd-specify "My feature description"
vipd-clarify

# 4. 规划实施
vipd-plan

# 5. 生成任务（自动生成 Workflow 脚本）
vipd-tasks

# 6. 执行实现（自动通过 Workflow 并行执行）
vipd-implement
```

## 已有项目 — 升级到 Claude Code 模式

```bash
# 通过配置命令切换到 Claude Code 模式
vipd config set mode claude-code

# 下次运行 vipd-tasks 时自动生成 Workflow 脚本
vipd-tasks

# 下次运行 vipd-implement 时自动使用 Workflow 并行执行
vipd-implement
```

## 传统模式降级

```bash
# 回到传统模式（可随时切换）
vipd config set mode standard
```

## 验证 Claude Code 模式是否激活

检查 `.vipd/config.yml`:
```yaml
language: zh
mode: claude-code  # ← 此行表示 Claude Code 模式已激活
```

## 预期行为对比

| 阶段 | 传统模式 | Claude Code 模式 |
|------|----------|-----------------|
| `vipd-tasks` | 生成 tasks.md | 生成 tasks.md + 自动生成 Workflow 脚本 |
| `vipd-implement` | 顺序执行任务 | 通过 Workflow 并行执行，多 Agent 协同 |

## 已知限制

- 需要 Claude Code CLI 环境（Workflow 工具可用）
- 非 Claude Code 环境自动降级到传统模式
- 并行 Agent 数上限自适应（最多 5 个）
- 暂停后执行结果保留，不重复执行已完成任务
