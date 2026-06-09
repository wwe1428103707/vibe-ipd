# 契约：Workflow 脚本生成接口

**版本**: 1.0
**用途**: 定义 `vipd-tasks` 生成的 Workflow 脚本与 `vipd-implement` 执行的接口规范

## Workflow 脚本格式

```javascript
export const meta = {
  name: '<string>',
  description: '<string>',
  phases: [{ title: '<string>', detail: '<string>' }],
}
```

- `name`: 必须为 `execute-tasks`
- `description`: 描述当前 feature 名称
- `phases`: 必须包含 Setup、Foundational、User Stories、Polish 四个阶段

## 脚本位置

- **必须**存储在 `.claude/workflows/execute-tasks.wf.js`
- **不得**存储在其他位置

## 执行契约

1. `vipd-implement` 通过 Workflow 工具执行脚本
2. 执行完成后，Workflow 工具返回汇总结果
3. 如果 Workflow 工具抛错或返回错误状态，`vipd-implement` 降级到传统模式

## 降级契约

| 条件 | 行为 |
|------|------|
| `.claude/workflows/execute-tasks.wf.js` 不存在 | 传统模式执行 |
| Workflow 工具不可用 | 传统模式执行，日志记录降级原因 |
| Workflow 脚本语法错误 | 传统模式执行，报告错误详情 |
| 部分 Agent 失败 | 标记失败任务，继续其他任务 |
