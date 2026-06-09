# Research: Auto Gate Fix & Report

**创建日期**: 2026-06-09
**目的**: 确定门控自动修复、JSONL 记录、HTML 报告的实现方案
**来源**: gate-check.ps1 当前实现分析、spec.md/clarify 决策

---

## Decision 1: gate-check.ps1 增强方案

**决定**: 在 `gate-check.ps1` 的每个条件结果对象中增加 `fix_hint` 和 `category` 字段

**论证**:
- 当前 `must_meet_details` 数组包含 `{criterion, pattern, matched, artifact_path}` 四个字段
- 新增 `fix_hint` 字段：当 `matched=false` 时提供修复建议（如 `{"action": "create_file", "path": "plan.md", "template": "plan-template.md"}`）
- 新增 `category` 字段：标记条件分类（`documentation`/`code`/`security`/`compliance`/`process`）
- 保持向后兼容 — 现有消费者忽略未知字段

**JSON 结果结构变更**:
```json
{
  "criterion": "Gate Readiness",
  "pattern": "Gate Readiness",
  "matched": false,
  "artifact_path": "specs/019-auto-gate-fix/plan.md",
  "fix_hint": {"action": "create_file", "path": "plan.md", "template": "plan-template.md"},
  "category": "documentation"
}
```

---

## Decision 2: JSONL 记录格式

**决定**: 每条 JSONL 记录包含完整的门控检查快照，追加写入 `gate-history.jsonl`

**每行格式**:
```json
{
  "timestamp": "2026-06-09T12:00:00Z",
  "gate": "TR2_TR3",
  "feature": "019-auto-gate-fix", 
  "status": "passed",
  "conditions": [
    {"criterion": "Gate Readiness", "matched": true, "category": "documentation", "artifact_path": "specs/019-auto-gate-fix/plan.md"}
  ],
  "attempt": 1,
  "auto_fix_attempted": false
}
```

---

## Decision 3: HTML 报告技术方案

**决定**: 报告为一个完全自包含的静态 HTML 文件，内联所有 CSS 和 JS

**技术选择**:
- 纯内联 CSS（无 Tailwind/Bootstrap）
- 纯原生 JS（无 React/Vue）
- 使用 CSS 变量定制主题色
- JSON.parse() 加载 JSONL 记录数据
- 展开/折叠功能用原生 details/summary 元素

---

## Decision 4: SKILL.md 门控失败处理修改点

**决定**: 涉及门控检查的所有 SKILL.md 中的"门控失败 → 询问用户"逻辑改为"门控失败 → 分析原因 → 尝试修复 → 重试 → 降级"循环

**涉及 SKILL.md**:
- `vipd-tasks/SKILL.md` — TR4 门控失败处理
- `vipd-implement/SKILL.md` — TR4/TR4A 门控失败处理
- `vipd-plan/SKILL.md` — TR2/TR3 门控失败处理
- `vipd-clarify/SKILL.md` — TR1 门控失败处理
- `vipd-specify/SKILL.md` — TR1 门控失败处理

**修改模式**: 将 `if (failed) { ask user }` 改为 `if (failed) { analyze → auto_fix → retry(max 3) → degrade }`

---

## Decision 5: GateRecord 实体设计

详见 data-model.md。
