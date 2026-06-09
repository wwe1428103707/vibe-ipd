# Data Model: Auto Gate Fix & Report

## 实体一览

| 实体 | 存储位置 | 用途 |
|------|----------|------|
| GateRecord | `.specify/memory/gate-history.jsonl` | 单次门控检查的完整数据（JSONL 追加） |
| GateOverview | `.specify/memory/gate-status.json` | 门控汇总概览（现有，保持兼容） |
| HtmlReport | `specs/NNN-feature/vipd-report.html` | 生成的静态 HTML 报告 |
| AutoFixAttempt | 内嵌于 GateRecord.auto_fix | 自动修复尝试记录 |

---

## 1. GateRecord（JSONL）

每条记录为独立 JSON 行，追加写入 `gate-history.jsonl`。

**字段定义**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `timestamp` | string (ISO8601) | 是 | 门控检查时间 |
| `gate` | string | 是 | 门控 ID: TR0/TR1/TR2_TR3/TR4/TR4A/TR5/TR6 |
| `feature` | string | 是 | Feature 目录名（如 019-auto-gate-fix） |
| `status` | string | 是 | passed / failed / degraded |
| `conditions` | array | 是 | 条件结果列表 |
| `attempt` | int | 是 | 当前尝试次数（1-based） |
| `max_attempts` | int | 是 | 最大尝试次数（默认 3） |
| `auto_fix_attempted` | bool | 是 | 是否尝试了自动修复 |
| `auto_fix` | object | 否 | 自动修复详情（如尝试过） |
| `errors` | array | 否 | 错误信息列表 |
| `evidence` | string | 否 | 证据摘要 |

**GateCondition（conditions[] 元素）**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `criterion` | string | 是 | 条件名称 |
| `matched` | bool | 是 | 是否通过 |
| `category` | string | 否 | documentation/code/security/compliance/process |
| `fix_hint` | object | 否 | `{action, path, template}` 修复提示 |
| `artifact_path` | string | 否 | 检查的工件路径 |

**AutoFix（auto_fix 字段）**:

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `analyzed_cause` | string | 是 | Agent 分析的失败原因 |
| `action_taken` | string | 是 | 执行的修复操作描述 |
| `success` | bool | 是 | 是否成功 |
| `attempts` | array | 否 | 各次尝试详情 |

---

## 2. GateOverview（gate-status.json — 不变）

保持现有格式完全兼容。仅 `gates.{id}.evidence` 字段可能会引用 JSONL 中的详细行。

---

## 3. HtmlReport

**生成位置**: `specs/<feature>/vipd-report.html`
**格式**: 完全自包含静态 HTML（内联 CSS + JS）

**页面结构**:
- 仪表盘：门控总览卡片（各门控通过/失败状态）
- 时间线：按时间排序的门控检查历史
- 详情区：每个 GateRecord 的展开详情（使用 details/summary）
- 色彩标识：绿色=通过，红色=失败，黄色=降级
