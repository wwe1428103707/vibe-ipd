> [English](../../reference/integrations.md) · **[中文](.)**

# 支持的 AI 编码智能体集成

Specify CLI 支持广泛的 AI 编码智能体。运行 `specify init` 时，CLI 会为你选择的 AI 编码智能体设置相应的命令文件、上下文规则和目录结构 — 无论你偏好哪种工具，都可以立即开始使用规范驱动开发。

## 支持的 AI 编码智能体

| 智能体 | 键值 | 说明 |
| --- | --- | --- |
| [Amp](https://ampcode.com/) | `amp` | |
| [Antigravity (agy)](https://antigravity.google/) | `agy` | 基于技能集成；技能会自动安装 |
| [Auggie CLI](https://docs.augmentcode.com/cli/overview) | `auggie` | |
| [Claude Code](https://www.anthropic.com/claude-code) | `claude` | 基于技能集成；在 `.claude/skills` 中安装技能 |
| [Cline](https://github.com/cline/cline) | `cline` | 基于 IDE 的智能体 |
| [CodeBuddy CLI](https://www.codebuddy.ai/cli) | `codebuddy` | |
| [Codex CLI](https://github.com/openai/codex) | `codex` | 基于技能集成；将技能安装到 `.agents/skills`，以 `$speckit-<command>` 方式调用 |
| [Cursor](https://cursor.sh/) | `cursor-agent` | |
| [Devin for Terminal](https://cli.devin.ai/docs) | `devin` | 基于技能集成；将技能安装到 `.devin/skills/`，以 `/vipd-<command>` 方式调用 |
| [Forge](https://forgecode.dev/) | `forge` | |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `gemini` | |
| [GitHub Copilot](https://code.visualstudio.com/) | `copilot` | |
| [Goose](https://block.github.io/goose/) | `goose` | 使用 `.goose/recipes/` 中的 YAML 配方格式 |
| [Hermes](https://github.com/NousResearch/hermes-agent) | `hermes` | 基于技能集成；将技能全局安装到 `~/.hermes/skills/` |
| [IBM Bob](https://www.ibm.com/products/bob) | `bob` | 基于 IDE 的智能体 |
| [iFlow CLI](https://docs.iflow.cn/en/cli/quickstart) | `iflow` | |
| [Junie](https://junie.jetbrains.com/) | `junie` | |
| [Kilo Code](https://github.com/Kilo-Org/kilocode) | `kilocode` | |
| [Kimi Code](https://code.kimi.com/) | `kimi` | 基于技能集成；支持 `--migrate-legacy` 用于点号到连字符的目录迁移 |
| [Kiro CLI](https://kiro.dev/docs/cli/) | `kiro-cli` | Kiro CLI 不替换基于文件的提示中的 `$ARGUMENTS`，因此 vibe-ipd 在渲染时会提供散文式回退方案。别名：`--integration kiro` |
| [Lingma](https://lingma.aliyun.com/) | `lingma` | 基于技能集成；技能会自动安装 |
| [Mistral Vibe](https://github.com/mistralai/mistral-vibe) | `vibe` | |
| [opencode](https://opencode.ai/) | `opencode` | |
| [Pi Coding Agent](https://pi.dev) | `pi` | Pi 默认不支持 MCP，因此 `taskstoissues` 无法按预期工作。可通过[扩展](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent#extensions)添加 MCP 支持 |
| [Qoder CLI](https://qoder.com/cli) | `qodercli` | |
| [Qwen Code](https://github.com/QwenLM/qwen-code) | `qwen` | |
| [Roo Code](https://roocode.com/) | `roo` | |
| [RovoDev](https://www.atlassian.com/software/rovo-dev) | `rovodev` | 生成 `.rovodev/skills/`、提示包装器和 `prompts.yml`；运行时使用 `acli rovodev` 分发 |
| [SHAI (OVHcloud)](https://github.com/ovh/shai) | `shai` | |
| [Tabnine CLI](https://docs.tabnine.com/main/getting-started/tabnine-cli) | `tabnine` | |
| [Trae](https://www.trae.ai/) | `trae` | 基于技能集成；技能会自动安装 |
| [Windsurf](https://windsurf.com/) | `windsurf` | |
| 通用 | `generic` | 自带智能体 — 对于未在上方列出的 AI 编码智能体，使用 `--integration generic --integration-options="--commands-dir <path>"` |

## 列出可用集成

```bash
specify integration list
```

显示所有可用集成、当前已安装的集成，以及每个集成是否需要 CLI 工具或基于 IDE。
当安装了多个集成时，列表会将默认集成与其他已安装集成分开标记。
列表还会显示每个内置集成是否声明为多安装安全。

## 安装集成

```bash
specify integration install <key>
```

| 选项 | 说明 |
| --- | --- |
| `--script sh\|ps` | 脚本类型：`sh`（bash/zsh）或 `ps`（PowerShell） |
| `--force` | 选择与未声明为多安装安全的集成一起安装 |
| `--integration-options` | 集成特定选项（例如 `--integration-options="--commands-dir .myagent/cmds"`） |

将指定集成安装到当前项目中。如果已安装其他集成，仅当所有涉及的集成都声明为多安装安全时，命令才会自动继续。否则，使用 `switch` 替换默认集成，或传递 `--force` 显式选择多安装。如果安装中途失败，会自动回滚到干净状态。

安装额外集成不会更改默认集成。使用 `specify integration use <key>` 更改默认集成。

> **注意：** 所有集成管理命令需要已使用 `specify init` 初始化的项目。要使用特定智能体启动新项目，请使用 `specify init <project> --integration <key>`。

**版本说明：** 可控的多安装支持于 vibe-ipd 0.8.5 引入。如果 `specify integration install <key>` 提示已安装了其他集成且仅建议 `switch` 或 `uninstall`，请使用 `specify version` 检查本地 CLI 并进行升级。运行 `uvx --from git+https://github.com/github/spec-kit.git specify ...` 这样的一次性命令仅为该命令使用临时副本；不会更新 `PATH` 上的持久 `specify` 可执行文件。

## 卸载集成

```bash
specify integration uninstall [<key>]
```

| 选项 | 说明 |
| --- | --- |
| `--force` | 即使文件已被修改也强制删除 |

卸载当前集成（或指定集成）。vibe-ipd 会跟踪安装期间创建的每个文件及其原始内容的 SHA-256 哈希值：

- **未修改的文件**会被自动删除。
- **已修改的文件**（经过手动编辑的）会被保留，以防自定义内容丢失。
- 使用 `--force` 可忽略修改情况删除所有集成文件。

## 切换到不同集成

```bash
specify integration switch <key>
```

| 选项 | 说明 |
| --- | --- |
| `--script sh\|ps` | 脚本类型：`sh`（bash/zsh）或 `ps`（PowerShell） |
| `--force` | 在卸载期间强制删除已修改文件；当目标已安装时，在更改默认值的同时覆盖托管共享模板 |
| `--integration-options` | 目标集成未安装时的选项 |

如果目标集成尚未安装，相当于单次执行 `uninstall` 后跟 `install`。在此模式下，`--force` 控制是否删除被移除集成中已修改的文件。如果目标集成已安装，`switch` 仅更改默认集成，类似于 `use`；在此模式下，`--force` 控制在更改默认值时是否覆盖托管共享模板。对于已安装的目标，`--integration-options` 会被拒绝，因为更改集成选项需要重新安装托管文件；请先运行 `upgrade <key> --integration-options ...`，然后运行 `use <key>`。

## 使用已安装的集成

```bash
specify integration use <key>
```

| 选项 | 说明 |
| --- | --- |
| `--force` | 在更改默认值时覆盖托管共享模板 |

设置默认集成，无需卸载任何其他已安装的集成。这还会刷新托管共享模板，使命令引用与新默认集成的调用风格一致。除非使用 `--force`，否则已修改或未跟踪的共享模板会被保留。

## 升级集成

```bash
specify integration upgrade [<key>]
```

| 选项 | 说明 |
| --- | --- |
| `--force` | 即使文件已被修改也强制覆盖 |
| `--script sh\|ps` | 脚本类型：`sh`（bash/zsh）或 `ps`（PowerShell） |
| `--integration-options` | 集成的选项 |

使用更新的模板和命令重新安装已安装的集成（例如，在升级 vibe-ipd 后）。默认为默认集成；如果提供了键值，则必须是已安装的集成之一。检测本地修改的文件，除非使用 `--force` 否则阻止升级。来自先前安装但不再需要的过时文件会被自动删除。即使升级非默认集成，共享模板仍与默认集成保持一致。

## 集成特定选项

某些集成通过 `--integration-options` 接受额外选项：

| 集成 | 选项 | 说明 |
| --- | --- | --- |
| `generic` | `--commands-dir` | 必填。命令文件的目录 |
| `kimi` | `--migrate-legacy` | 将旧的带点号技能目录迁移为连字符格式 |

示例：

```bash
specify integration install generic --integration-options="--commands-dir .myagent/cmds"
```

## 常见问题

### 能否在同一项目中安装多个集成？

可以，但这旨在用于团队可移植性而非默认工作流。仅当已安装的集成和新集成均被 vibe-ipd 声明为多安装安全时，多个集成才会自动允许。对于其他组合，请传递 `--force` 以确认多个智能体可能看到不相关的智能体特定指令或命令。

vibe-ipd 在 `.specify/integration.json` 中使用 `default_integration` 跟踪一个默认集成，使用 `installed_integrations` 跟踪所有已安装的集成，使用 `integration_settings` 跟踪每个集成的运行时设置，以及一个专用的 `integration_state_schema` 用于未来的状态迁移。原有的 `integration` 字段作为默认集成的别名保留。

### 哪些集成是多安装安全的？

当集成使用隔离的智能体目录、不与其他安全集成冲突的专用上下文文件、稳定的命令调用设置以及独立的安装清单时，该集成即为多安装安全。共享的 vibe-ipd 模板保持与单一默认集成对齐。

当前声明的多安装安全集成：

| 键值 | 隔离路径 |
| --- | --- |
| `auggie` | `.augment/commands`、`.augment/rules/specify-rules.md` |
| `claude` | `.claude/skills`、`CLAUDE.md` |
| `codebuddy` | `.codebuddy/commands`、`CODEBUDDY.md` |
| `codex` | `.agents/skills`、`AGENTS.md` |
| `cursor-agent` | `.cursor/skills`、`.cursor/rules/specify-rules.mdc` |
| `gemini` | `.gemini/commands`、`GEMINI.md` |
| `iflow` | `.iflow/commands`、`IFLOW.md` |
| `junie` | `.junie/commands`、`.junie/AGENTS.md` |
| `kilocode` | `.kilocode/workflows`、`.kilocode/rules/specify-rules.md` |
| `kimi` | `.kimi/skills`、`KIMI.md` |
| `qodercli` | `.qoder/commands`、`QODER.md` |
| `qwen` | `.qwen/commands`、`QWEN.md` |
| `roo` | `.roo/commands`、`.roo/rules/specify-rules.md` |
| `shai` | `.shai/commands`、`SHAI.md` |
| `tabnine` | `.tabnine/agent/commands`、`TABNINE.md` |
| `trae` | `.trae/skills`、`.trae/rules/project_rules.md` |
| `windsurf` | `.windsurf/workflows`、`.windsurf/rules/specify-rules.md` |

与其他集成共享上下文文件或命令目录的集成、需要动态安装路径（如 `--commands-dir`）的集成，或合并共享工具设置的集成，默认不会声明为安全。但仍可通过 `--force` 与另一个集成一起安装。

### 卸载或切换时我的更改会怎样？

已修改的文件会被自动保留。仅未修改的文件（与原始 SHA-256 哈希匹配）会被删除。使用 `--force` 可覆盖此行为。

### 如何知道使用哪个键值？

运行 `specify integration list` 查看所有可用集成及其键值，或查看上方的[支持的 AI 编码智能体](#supported-ai-coding-agents)表格。

### 是否需要安装 AI 编码智能体才能使用集成？

基于 CLI 的集成（如 Claude Code、Gemini CLI）需要安装相应工具。基于 IDE 的集成（如 Windsurf、Cursor）通过 IDE 本身工作。某些智能体（如 GitHub Copilot）同时支持 IDE 和 CLI 使用。`specify integration list` 会显示每个集成属于哪种类型。

### 何时使用 `upgrade` 与 `switch`？

升级 vibe-ipd 后希望刷新已安装集成的托管文件时，使用 `upgrade`。希望将当前默认集成替换为其他集成时，使用 `switch`；如果目标已安装，`switch` 的行为类似于 `use`。
