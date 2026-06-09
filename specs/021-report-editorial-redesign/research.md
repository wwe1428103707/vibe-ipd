# Research: 门控报告编辑风格优化

**日期**: 2026-06-09 | **Feature**: [spec.md](spec.md)

---

## 1. TailwindCSS CDN 配置

### 决策
使用 `https://cdn.tailwindcss.com` CDN 加载 TailwindCSS，通过内联 `<script>` 配置 `tailwind.config` 扩展。

### 理由
- 保持完全自包含的 HTML 文件（无 node_modules/构建步骤）
- tailwind.config 支持扩展颜色、字体等主题变量
- CDN 加载后浏览器缓存，后续打开几乎即时

### 配置参考
```html
<script src="https://cdn.tailwindcss.com"></script>
<script>
tailwind.config = {
  theme: {
    extend: {
      fontFamily: {
        serif: ['Georgia', 'Times New Roman', 'serif'],
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      colors: {
        ink: '#1a1a2e',
        gold: '#b8860b',
        burgundy: '#722f37',
        navy: '#1b365d',
      },
    },
  },
}
</script>
```

### 备选方案
- 内联 TailwindCSS 生成 CSS（文件过大，不推荐）
- 使用 TailwindCSS CLI 构建（增加构建步骤，违背"纯静态"原则）

---

## 2. 编辑风格设计模式

### 决策
采用报纸编辑风格的经典布局元素：
- **Masthead**（报头）：出版物名称 + 日期 + 期号 + 导航
- **Hero / Cover Story**（头版故事）：醒目的状态大标题 + 摘要 + 关键指标
- **Section Blocks**（专栏区域）：门控阶段网格展示
- **Pull Quotes**（引言摘录）：关键数据/洞察的高亮展示
- **Timeline / Archive**（历史归档）：时间线形式展示每条门控记录
- **Footer**（页脚）：项目信息 + 导航

### 交互元素
- 门控阶段网格卡片：色条标识状态（绿/红/黄）
- 下拉筛选器：按门控阶段过滤历史记录
- `hover:-translate-y-0.5` 卡片微动效
- `prefers-reduced-motion` 尊重用户偏好

### 无障碍
- `skip-link` 跳过导航
- 所有交互元素键盘可聚焦（`focus-visible:outline`）
- 颜色对比度满足 WCAG 4.5:1

---

## 3. 工作流指标推导方案

从 `gate-history.jsonl` 已有字段推导：

| 指标 | 推导公式 | 数据来源 |
|------|----------|----------|
| Parallel Tasks | 统计 TR4/TR4A 门控中 criterion 含 "Task" 的 conditions 数 | `conditions[].criterion` |
| Agents Spawned | `Math.round(totalConditions / max(totalRecords, 1))` | `conditions[]` 总条数 |
| Stages Active | 最后一个状态不是 "passed" 的门控阶段数量 | 每个 gate 的最新 `status` |
| Task Completion | `doneTasks / totalTasks * 100` | 已完成条件 / 总条件数 |

---

## 4. 浏览器兼容性

- TailwindCSS CDN 支持所有现代浏览器（Chrome 88+, Firefox 87+, Edge 88+）
- ES6 特性（箭头函数、`const`/`let`、模板字符串、`Array.from`、`Array.isArray`）在上述浏览器中完全支持
- CSS Grid、Flexbox — 广泛支持
- `text-balance` — Chrome/Edge 114+、Firefox 121+
- 无需 polyfill

---

## 5. 文件大小预算

| 组件 | 预估大小 |
|------|----------|
| HTML 结构 | ~2 KB |
| TailwindCSS CDN（缓存后） | ~300 KB（首次加载） |
| 自定义样式 + tailwind.config | ~1 KB |
| 内联 JS（数据 + 渲染 + 交互） | ~3 KB |
| 注入的 JSON 数据（100 条记录） | ~50 KB |
| **总计（首次）** | ~350 KB |
| **总计（后续）** | ~55 KB |

---

## 结论

所有技术方案均已确认，无 NEEDS CLARIFICATION 项。可直接进入 Phase 1 设计阶段。
