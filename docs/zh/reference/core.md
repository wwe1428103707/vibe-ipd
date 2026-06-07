> [English](../../reference/core.md) · **[中文](.)**

# 核心命令

`specify` 核心命令处理项目初始化、系统检查和版本信息。

## 初始化项目

```bash
specify init [<project_name>]
```

| 选项 | 说明 |
| --- | --- |
| `--integration <key>` | 要使用的 AI 编码智能体集成（例如 `copilot`、`claude`、`gemini`）。所有可用键值请参见[集成参考](integrations.md) |
| `--integration-options` | 集成的选项（例如 `--integration-options="--commands-dir .myagent/cmds"`） |
| `--script sh\|ps` | 脚本类型：`sh`（bash/zsh）或 `ps`（PowerShell） |
| `--here` | 在当前目录中初始化，而非创建新目录 |
| `--force` | 在已有目录中初始化时强制合并/覆盖 |
| `--no-git` | 跳过 Git 仓库初始化 |
| `--ignore-agent-tools` | 跳过 AI 编码智能体 CLI 工具的检查 |
| `--preset <id>` | 在初始化期间安装预设 |
| `--branch-numbering` | 分支编号策略：`sequential`（默认）或 `timestamp` |

创建新的 vibe-ipd 项目，包含必要的目录结构、模板、脚本和 AI 编码智能体集成文件。

> [!NOTE]
> git 扩展当前在 `specify init` 期间默认启用。
> 从 `v0.10.0` 开始，它将需要显式选择加入。初始化后如需添加，请运行 `specify extension add git`。

使用 `<project_name>` 创建新目录，或使用 `--here`（或 `.`）在当前目录初始化。如果目录中已有文件，请使用 `--force` 合并而无需确认。

省略 `--integration` 时，交互式终端会提示你选择集成。非交互式会话（如 CI 或管道运行）默认使用 GitHub Copilot；传递 `--integration <key>` 可显式选择其他集成。

### 示例

```bash
# 创建新项目并指定集成
specify init my-project --integration copilot

# 在当前目录初始化
specify init --here --integration copilot

# 强制合并到非空目录
specify init --here --force --integration copilot

# 使用 PowerShell 脚本（Windows/跨平台）
specify init my-project --integration copilot --script ps

# 跳过 Git 初始化
specify init my-project --integration copilot --no-git

# 在初始化期间安装预设
specify init my-project --integration copilot --preset compliance

# 使用基于时间戳的分支编号（适用于分布式团队）
specify init my-project --integration copilot --branch-numbering timestamp
```

### 环境变量

| 变量 | 说明 |
| --- | --- |
| `SPECIFY_FEATURE` | 为非 Git 仓库覆盖特性检测。设置为特性目录名称（例如 `001-photo-albums`），以便在不使用 Git 分支时处理特定特性。必须在智能体上下文中设置，然后才能使用 `/vipd.plan` 或后续命令。 |

## 检查已安装工具

```bash
specify check
```

检查系统上是否已安装所需工具：`git` 和任何基于 CLI 的 AI 编码智能体。基于 IDE 的智能体因不需要 CLI 工具而被跳过。

此命令保持离线状态。如果某个命令的行为类似较旧的 vibe-ipd 版本，或缺少预期的 CLI 功能，请运行 `specify self check` 检查本地 CLI 是否落后于最新版本。

## 版本信息

```bash
specify version
```

显示 vibe-ipd CLI 版本、Python 版本、平台和架构。

在不检查网络的情况下检查本地 CLI 能力：

```bash
specify version --features
specify version --features --json
```

JSON 格式适用于需要根据已安装 CLI 的支持功能选择工作流的脚本和编码智能体。

快速版本检查也可通过以下方式完成：

```bash
specify --version
specify -V
```
