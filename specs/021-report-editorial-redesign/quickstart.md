# Quickstart: 门控报告编辑风格优化

**日期**: 2026-06-09 | **Feature**: [spec.md](spec.md)

---

## 快速开始

### 1. 生成报告

确保 `gate-history.jsonl` 包含门控记录，然后运行：

```powershell
cd d:/vibe-ipd
.specify/scripts/powershell/generate-report.ps1
```

默认输出到当前 feature 目录的 `vipd-report.html`。
可选参数：`-OutputPath` 指定路径，`-Gate` 过滤特定门控。

### 2. 打开报告

在浏览器（Chrome/Firefox/Edge）直接打开生成的 HTML 文件。
无需 HTTP 服务器，纯静态文件。

### 3. 修改模板

编辑 `d:/vibe-ipd/.claude/templates/report-template.html`：

| 区域 | 文件位置 | 说明 |
|------|----------|------|
| 报头 (Masthead) | `<header>` | 出版物名称、期号、导航 |
| Hero 区域 | `<section id="overview">` | 头版故事 + 指标摘要 |
| 门控网格 | `<section id="gates">` | 各门控状态卡片 |
| 引言 | `<section>` 含 `pull-quote` | 关键洞察 |
| 工作流指标 | `<section id="workflow">` | 并行任务/Agent 数等 |
| 历史时间线 | `<section id="history">` | 门控记录列表 |
| JS 逻辑 | `<script>` (底部) | 数据解析、指标计算、渲染 |

### 4. 修改后测试

1. 编辑 `report-template.html`
2. 运行 `generate-report.ps1` 重新生成
3. 在浏览器打开 `vipd-report.html`
4. 验证：浏览器兼容性（Chrome/Firefox/Edge）、布局（1280px/1440px/1920px）、键盘导航

---

## 注意事项

- **TailwindCSS CDN**: 使用 `https://cdn.tailwindcss.com`，确保网络可用
- **数据格式**: JSON 数组注入到 `<script id="gate-data">`，保持有效 JSON
- **自包含**: 所有样式和脚本必须内联，不得引用外部文件
- **桌面端**: 报告 ≥ 1024px 优化，窄屏可能出现布局偏移
- **CBB**: 此模板是 FEATURE 019 (auto-gate-fix) 的视觉升级，生成脚本兼容

---

## 相关文件

| 文件 | 路径 | 说明 |
|------|------|------|
| 报告模板 | `.claude/templates/report-template.html` | 主目标文件 |
| 生成脚本 | `.specify/scripts/powershell/generate-report.ps1` | 数据注入 |
| 门控记录 | `.specify/memory/gate-history.jsonl` | 数据源 |
| 数据格式 | `contracts/report-data-format.md` | JSON 结构文档 |
| 数据模型 | `data-model.md` | 实体定义 |
