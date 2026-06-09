# Contract: Report Data Injection Format

**日期**: 2026-06-09 | **版本**: 1.0 | **Feature**: [spec.md](../spec.md)

---

## 1. 数据源

**文件**: `.specify/memory/gate-history.jsonl`
**格式**: JSON Lines — 每行一条独立 JSON 记录，`\n` 分隔，无外层数组

---

## 2. 记录结构

```typescript
interface GateRecord {
  /** 门控阶段标识，如 "TR1", "TR2_TR3", "TR4" */
  gate: string;

  /** 门控状态: "passed" | "failed" | "degraded" */
  status: string;

  /** ISO 8601 时间戳 */
  timestamp: string | null;

  /** 关联功能名称 */
  feature: string;

  /** 是否尝试过自动修复 */
  auto_fix_attempted: boolean;

  /** 当前重试次数 */
  attempt?: number;

  /** 最大重试次数 */
  max_attempts?: number;

  /** 证据/备注 */
  evidence?: string;

  /** 检查条件列表 */
  conditions?: GateCondition[];

  /** 错误列表 */
  errors?: string[];
}

interface GateCondition {
  /** 条件名称 */
  criterion: string;

  /** 是否通过 */
  matched: boolean;

  /** 分类: "documentation" | "process" | "code" | "security" | "compliance" */
  category?: string;
}
```

---

## 3. 注入机制

数据在 `generate-report.ps1` 中通过字符串替换注入到模板：

```html
<script id="gate-data" type="application/json">[{...},{...}]</script>
```

---

## 4. JS 消费端

内联 JS 从 `gate-data` script 标签读取并解析：

```javascript
const DATA = (function(){
  const s = document.getElementById('gate-data');
  if (s && s.textContent.trim()) {
    try { return JSON.parse(s.textContent); } catch(e) { return []; }
  }
  return [];
})();
```

---

## 5. 数据流契约

| 契约点 | 输入 | 输出 | 说明 |
|--------|------|------|------|
| `generate-report.ps1` → 模板 | `gate-history.jsonl` | `gate-data` 注入 | 脚本读取 JSONL，注入为 HTML 中的 JSON 数组 |
| 模板 → 浏览器 | `gate-data` (JSON) | 渲染页面 | 浏览器解析 JSON，JS 渲染仪表盘和时间线 |

---

## 6. 状态码映射

| `status` 值 | 视觉表示 | CSS 类 |
|-------------|----------|--------|
| `"passed"` | 绿色 | `text-emerald-700`, `bg-emerald-500` |
| `"failed"` | 红色 | `text-red-700`, `bg-red-500` |
| `"degraded"` | 黄色 | `text-amber-700`, `bg-amber-500` |
