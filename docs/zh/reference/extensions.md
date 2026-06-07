> [English](../../reference/extensions.md) · **[中文](.)**

# 扩展

扩展为 vibe-ipd 增加新能力 — 领域特定命令、外部工具集成、质量门禁等。它们引入了超越内置规范驱动开发工作流的新命令和模板。

## 搜索可用扩展

```bash
specify extension search [query]
```

| 选项 | 说明 |
| --- | --- |
| `--tag` | 按标签过滤 |
| `--author` | 按作者过滤 |
| `--verified` | 仅显示已验证的扩展 |

搜索所有活动目录中与查询匹配的扩展。不提供查询时，列出所有可用扩展。

## 安装扩展

```bash
specify extension add <name>
```

| 选项 | 说明 |
| --- | --- |
| `--dev` | 从本地目录安装（用于开发） |
| `--from <url>` | 从自定义 URL 而非目录安装 |
| `--priority <N>` | 解析优先级（默认：10；数值越小优先级越高） |

从目录、URL 或本地目录安装扩展。扩展命令会自动注册到当前安装的 AI 编码智能体集成。

> **注意：** 所有扩展命令需要已使用 `specify init` 初始化的项目。

## 移除扩展

```bash
specify extension remove <name>
```

| 选项 | 说明 |
| --- | --- |
| `--keep-config` | 在移除期间保留配置文件 |
| `--force` | 跳过确认提示 |

移除已安装的扩展。配置文件默认会被备份；使用 `--keep-config` 将其保留在原地，或使用 `--force` 跳过确认。

## 列出已安装扩展

```bash
specify extension list
```

| 选项 | 说明 |
| --- | --- |
| `--available` | 显示可用（未安装）的扩展 |
| `--all` | 同时显示已安装和可用的扩展 |

列出已安装的扩展及其状态、版本和命令数量。

## 扩展信息

```bash
specify extension info <name>
```

显示已安装或可用扩展的详细信息，包括其描述、版本、命令和配置。

## 更新扩展

```bash
specify extension update [<name>]
```

更新特定扩展，或未指定名称时更新所有已安装的扩展。

## 启用/禁用扩展

```bash
specify extension enable <name>
specify extension disable <name>
```

禁用扩展而不移除它。禁用的扩展不会被加载，其命令也不可用。使用 `enable` 重新启用。

## 设置扩展优先级

```bash
specify extension set-priority <name> <priority>
```

更改扩展的解析优先级。当多个扩展提供同名命令时，优先级数值最小的扩展优先。

## 目录管理

扩展目录控制 `search` 和 `add` 查找扩展的位置。目录按优先级顺序检查（数值越小优先级越高）。

### 列出目录

```bash
specify extension catalog list
```

显示堆栈中所有活动目录及其优先级和安装权限。

### 添加目录

```bash
specify extension catalog add <url>
```

| 选项 | 说明 |
| --- | --- |
| `--name <name>` | 必填。目录的唯一名称 |
| `--priority <N>` | 优先级（默认：10；数值越小优先级越高） |
| `--install-allowed / --no-install-allowed` | 是否允许从此目录安装扩展 |
| `--description <text>` | 可选描述 |

将目录添加到项目的 `.specify/extension-catalogs.yml`。

### 移除目录

```bash
specify extension catalog remove <name>
```

从项目配置中移除目录。

### 目录解析顺序

目录按以下顺序解析（优先匹配）：

1. **环境变量** — `SPECKIT_CATALOG_URL` 覆盖所有目录
2. **项目配置** — `.specify/extension-catalogs.yml`
3. **用户配置** — `~/.specify/extension-catalogs.yml`
4. **内置默认** — 官方目录 + 社区目录

`.specify/extension-catalogs.yml` 示例：

```yaml
catalogs:
  - name: "my-org-catalog"
    url: "https://example.com/catalog.json"
    priority: 5
    install_allowed: true
    description: "我们批准的扩展"
```

## 扩展配置

大多数扩展在其安装目录中包含配置文件：

```text
.specify/extensions/<ext>/
├── <ext>-config.yml           # 项目配置（受版本控制）
├── <ext>-config.local.yml     # 本地覆盖（被 gitignore）
└── <ext>-config.template.yml  # 模板参考
```

配置按以下顺序合并（最后优先级最高）：

1. **扩展默认值**（来自 `extension.yml`）
2. **项目配置**（`<ext>-config.yml`）
3. **本地覆盖**（`<ext>-config.local.yml`）
4. **环境变量**（`SPECKIT_<EXT>_*`）

为新安装的扩展设置配置：

```bash
cp .specify/extensions/<ext>/<ext>-config.template.yml \
   .specify/extensions/<ext>/<ext>-config.yml
```

## 常见问题

### 为什么使用 `search` 找不到扩展？

请检查扩展名称的拼写。扩展可能尚未发布，或位于你尚未添加的目录中。使用 `specify extension catalog list` 查看哪些目录处于活动状态。

### 为什么扩展命令没有出现在我的 AI 编码智能体中？

使用 `specify extension list` 确认扩展已安装并已启用。如果显示已安装，请重启 AI 编码智能体 — 它可能需要重新加载才能生效。

### 如何设置扩展配置？

复制扩展附带的配置模板：

```bash
cp .specify/extensions/<ext>/<ext>-config.template.yml \
   .specify/extensions/<ext>/<ext>-config.yml
```

有关配置层级和覆盖的详细信息，请参阅[扩展配置](#extension-configuration)。

### 如何解决版本不兼容错误？

将 vibe-ipd 升级到扩展所需的版本。

### 谁维护扩展？

大多数扩展由其各自的作者独立创建和维护。vibe-ipd 维护者不审查、审计、认可或支持扩展代码。安装前请审查扩展的源代码，并自行承担使用风险。有关特定扩展的问题，请联系其作者或在扩展的仓库中提交问题。
