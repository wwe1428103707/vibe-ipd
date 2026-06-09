# 契约：GateCheck 结果接口

**版本**: 1.0
**用途**: 定义 gate-check.ps1 返回的 must_meet_details 中 fix_hint 和 category 字段的格式

## fix_hint 格式

```json
{
  "action": "create_file|generate_content|update_content",
  "path": "要创建/修改的文件路径",
  "template": "使用的模板路径（仅 create_file 时需要）",
  "content_hint": "内容的简要描述（generate_content 时需要）"
}
```

## category 值域

| 值 | 说明 | 是否自动修复 |
|----|------|-------------|
| documentation | 文档类（spec, plan, tasks 缺失等） | 是 |
| code | 代码/脚本类 | 是 |
| process | 流程类（门控顺序错误等） | 否 |
| security | 安全类 | 否 |
| compliance | 合规类 | 否 |
| (空/未设置) | 未知分类 | Agent 自行判断 |
