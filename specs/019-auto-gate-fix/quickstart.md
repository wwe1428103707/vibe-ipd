# Quickstart: Auto Gate Fix & Report

## 使用方式

门控自动修复和记录功能是透明的 — 安装后自动生效，无需用户额外配置。

### 门控失败时自动修复

当某个 TR 门控检查不通过时，系统会自动：
1. 分析失败原因
2. 尝试修复（如创建缺失文件）
3. 重新检查门控
4. 最多重试 3 次

用户无需响应"是否继续"提示，流程不中断。

### 查看门控历史

```bash
# 生成并打开 HTML 门控报告
vipd-report

# 指定输出路径
vipd-report --output docs/gate-report.html
```

### 门控记录文件位置

| 文件 | 内容 |
|------|------|
| `.specify/memory/gate-status.json` | 门控汇总概览（现有） |
| `.specify/memory/gate-history.jsonl` | 详细门控记录（新增） |
| `specs/NNN-feature/vipd-report.html` | 生成的 HTML 报告 |

## 预期行为对比

| 场景 | 改造前 | 改造后 |
|------|--------|--------|
| TR2/TR3 门控失败（plan.md 缺失） | 询问"是否继续？" → 用户手动处理 | 自动创建 plan.md 模板 → 重检 → 继续 |
| TR4 门控失败（tasks.md 缺失） | 询问"是否继续？" → 中断流程 | 自动降级 + 记录原因 → 继续 |
| 查看门控历史 | 读取 gate-status.json（摘要） | 通过 `/vipd-report` 查看 HTML 可视化报告 |
