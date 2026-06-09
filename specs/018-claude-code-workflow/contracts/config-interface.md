# 契约：配置接口

**版本**: 1.0
**用途**: 定义 `.vipd/config.yml` 中 mode 字段的读写契约

## 配置格式

```yaml
language: <en|zh>
mode: <standard|claude-code>
```

## 读取方

| 技能 | 读取时机 | 用途 |
|------|----------|------|
| `vipd-tasks` | 执行开始时 | 判断是否生成 Workflow 脚本 |
| `vipd-implement` | 执行开始时 | 判断是否通过 Workflow 工具执行 |

## 写入方

| 操作 | 写入内容 | 时机 |
|------|----------|------|
| `vipd init --integration claude-code` | `mode: claude-code` | 初始化完成时 |
| `vipd config set mode claude-code` | `mode: claude-code` | 用户主动配置时 |
| `vipd config set mode standard` | `mode: standard` | 用户回退到传统模式时 |

## 不存在时的默认行为

- 如果 `.vipd/config.yml` 不存在：传统模式（standard）
- 如果 `mode` 字段不存在：传统模式（standard）
- 如果 `mode` 值为空或未知：传统模式（standard）

## 优先级

运行时探测（Workflow 工具可用性）> 配置标记（mode 字段）
