> [English](../installation.md) · **[中文](.)**

# 安装指南

## 前置依赖

- **Linux/macOS**（或 Windows；现已支持无需 WSL 的 PowerShell 脚本）
- AI 编码智能体：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/)、[Codebuddy CLI](https://www.codebuddy.ai/cli)、[Gemini CLI](https://github.com/google-gemini/gemini-cli) 或 [Pi Coding Agent](https://pi.dev)
- [uv](https://docs.astral.sh/uv/) 包管理工具（推荐）或 [pipx](https://pipx.pypa.io/) 持久安装
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 安装

> [!IMPORTANT]
> vibe-ipd 唯一官方维护的包来自 [github/spec-kit](https://github.com/github/spec-kit) GitHub 仓库。在 PyPI 上出现的同名包（如 pypi.org 上的 `specify-cli`）**并非**本项目 affiliated，也不由 vibe-ipd 维护者管理。正常安装请使用下方基于 GitHub 的命令。对于离线或气隙环境，从本仓库构建的本地 wheel 包同样有效。

### 持久安装（推荐）

一次安装，随处使用。将 `vX.Y.Z` 替换为 [Releases](https://github.com/github/spec-kit/releases) 中的标签：

> [!NOTE]
> 以下命令需要 **[uv](https://docs.astral.sh/uv/)**。如果显示 `command not found: uv`，请先[安装 uv](./install/uv.md)。

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@vX.Y.Z
```

然后初始化项目：

```bash
specify init <PROJECT_NAME> --integration copilot
```

### 一次性使用

直接运行而无需安装 — 请参阅[一次性使用（uvx）指南](install/one-time.md)。

### 替代包管理器

- **pipx** — 请参阅 [pipx 安装指南](install/pipx.md)
- **企业/气隙环境** — 请参阅[气隙环境安装指南](install/air-gapped.md)

### 指定集成方式

交互式终端会在初始化时提示你选择编码智能体集成方式。非交互式会话（如 CI 或管道运行）默认使用 GitHub Copilot，除非你传递 `--integration` 参数。

你也可以在初始化时主动指定编码智能体集成方式：

```bash
specify init <project_name> --integration claude
specify init <project_name> --integration gemini
specify init <project_name> --integration copilot
specify init <project_name> --integration codebuddy
specify init <project_name> --integration pi
```

### 指定脚本类型（Shell 与 PowerShell）

所有自动化脚本现已同时提供 Bash（`.sh`）和 PowerShell（`.ps1`）版本。

自动行为：

- Windows 默认：`ps`
- 其他操作系统默认：`sh`
- 交互模式：除非传递 `--script` 参数，否则会提示你选择

强制指定脚本类型：

```bash
specify init <project_name> --script sh
specify init <project_name> --script ps
```

### 忽略智能体工具检查

如果你希望获取模板而不检查相应工具：

```bash
specify init <project_name> --integration claude --ignore-agent-tools
```

## 验证

安装完成后，运行以下命令确认已安装正确版本：

```bash
specify version
```

这有助于验证你运行的是来自 GitHub 的官方 vibe-ipd 构建版本，而非同名的无关包。

**保持更新：** 定期运行 `specify self check` 了解是否有新版本可用 — 该命令为只读操作，不会修改你的安装。准备升级时，请参阅[升级指南](./upgrade.md)。

初始化后，你的编码智能体中应出现以下可用命令：

- `/vipd.specify` — 创建规范
- `/vipd.plan` — 生成实施计划
- `/vipd.tasks` — 分解为可执行任务

脚本安装在与所选脚本类型匹配的变体子目录中：

- `.specify/scripts/bash/` — 包含 `.sh` 脚本（Linux/macOS 默认）
- `.specify/scripts/powershell/` — 包含 `.ps1` 脚本（Windows 默认）

## 故障排除

### 企业/气隙环境安装

如果你的环境阻止访问 PyPI 或 GitHub，请参阅[企业/气隙环境安装指南](install/air-gapped.md)获取创建可移植 wheel 包的逐步说明。

### Linux 上的 Git 凭据管理器

如果你在 Linux 上遇到 Git 认证问题，请参阅[气隙环境安装指南](install/air-gapped.md#git-credential-manager-on-linux)中的 Git 凭据管理器设置说明。
