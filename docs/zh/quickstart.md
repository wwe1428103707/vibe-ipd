> [English](../quickstart.md) · **[中文](.)**

# 快速入门指南

本指南将帮助你使用 vibe-ipd 开始规范驱动开发（Spec-Driven Development）。

> [!NOTE]
> 所有自动化脚本现已同时提供 Bash（`.sh`）和 PowerShell（`.ps1`）版本。`specify` CLI 会根据操作系统自动选择脚本类型，除非你传递 `--script sh|ps` 参数。

## 推荐工作流

> [!TIP]
> **上下文感知**：vibe-ipd 命令会根据你当前的 Git 分支（如 `001-feature-name`）自动检测当前特性。要切换不同的规范，只需切换 Git 分支即可。

安装 vibe-ipd 并定义了项目章程后，快速实验可以使用精简特性路径：`/vipd.specify` → `/vipd.plan` → `/vipd.tasks` → `/vipd.implement`。对于生产级特性或存在明显不确定性的工作，请将 `/vipd.clarify`、`/vipd.checklist` 和 `/vipd.analyze` 作为常规质量门禁使用：

```text
/vipd.constitution -> /vipd.specify -> /vipd.clarify -> /vipd.checklist -> /vipd.plan -> /vipd.tasks -> /vipd.analyze -> /vipd.implement
```

在规划前使用 `/vipd.clarify` 减少需求歧义，使用 `/vipd.checklist` 验证需求质量，在实施开始前使用 `/vipd.analyze` 检查规范/计划/任务的一致性。你可以在实施后再次运行 `/vipd.analyze` 作为额外审查，但首次分析应在 `/vipd.implement` 之前完成，以便在计划与任务仍可调整时及时发现差距。

### 第 1 步：安装 Specify

**在终端中**，运行 `specify` CLI 命令初始化项目：

```bash
# 创建新的项目目录
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>

# 或在当前目录中初始化
uvx --from git+https://github.com/github/spec-kit.git specify init .
```

> [!NOTE]
> 你也可以使用 `pipx` 持久安装 CLI：
>
> ```bash
> pipx install git+https://github.com/github/spec-kit.git
> ```
>
> 使用 `pipx` 安装后，直接运行 `specify` 命令而非 `uvx --from ... specify`，例如：
>
> ```bash
> specify init <PROJECT_NAME>
> specify init .
> ```

可选：显式指定脚本类型：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script ps  # 强制使用 PowerShell
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script sh  # 强制使用 POSIX shell
```

### 第 2 步：定义项目章程

**在编码智能体的聊天界面中**，使用 `/vipd.constitution` 斜杠命令来建立项目的核心规则和原则。你应该将项目的具体原则作为参数提供。

```markdown
/vipd.constitution 本项目采用"库优先"方案。所有特性必须首先作为独立库实现。我们严格遵循 TDD。我们更倾向函数式编程模式。
```

### 第 3 步：创建规范

**在聊天中**，使用 `/vipd.specify` 斜杠命令描述你想要构建的内容。关注**做什么**和**为什么做**，而非技术栈。

```markdown
/vipd.specify 构建一个应用，帮助我在独立的相册中整理照片。相册按日期分组，可以通过在主页上拖放来重新整理。相册之间不能嵌套。在每个相册内，照片以磁贴式界面预览。
```

### 第 4 步：优化和验证规范

**在聊天中**，使用 `/vipd.clarify` 斜杠命令来识别和解决规范中的歧义。你可以将特定关注点作为参数提供。

```bash
/vipd.clarify 重点关注安全和性能需求。
```

然后在创建技术计划前使用 `/vipd.checklist` 验证需求：

```bash
/vipd.checklist
```

### 第 5 步：创建技术实施计划

**在聊天中**，使用 `/vipd.plan` 斜杠命令提供你的技术栈和架构选择。

```markdown
/vipd.plan 该应用使用 Vite，尽量使用最少的库。尽可能使用原生 HTML、CSS 和 JavaScript。图片不上传到任何地方，元数据存储在本地 SQLite 数据库中。
```

### 第 6 步：分解、分析和实施

**在聊天中**，使用 `/vipd.tasks` 斜杠命令创建可执行的任务列表。

```markdown
/vipd.tasks
```

在实施前使用 `/vipd.analyze` 验证跨制品一致性：

```markdown
/vipd.analyze
```

使用 `/vipd.implement` 斜杠命令执行计划。

```markdown
/vipd.implement
```

> [!TIP]
> **分阶段实施**：对于复杂项目，应分阶段实施以避免超出智能体的上下文容量。从核心功能开始，验证其正常工作，然后增量添加特性。

## 完整示例：构建 Taskify

以下是构建团队生产力平台的完整示例：

### 第 1 步：定义章程

初始化项目章程以设定基本规则：

```markdown
/vipd.constitution Taskify 是一个"安全优先"的应用。所有用户输入必须经过验证。我们采用微服务架构。代码必须完整记录文档。
```

### 第 2 步：使用 `/vipd.specify` 定义需求

```text
开发 Taskify，一个团队生产力平台。它应允许用户创建项目、添加团队成员、分配任务、发表评论以及在 Kanban 式面板间移动任务。在当前阶段，我们称此特性为"创建 Taskify"。我们需要多个用户，但用户将预先声明和定义。我需要五个用户，分为两个类别：一位产品经理和四位工程师。创建三个不同的示例项目。使用标准的 Kanban 列来表示每个任务的状态，如"待办"、"进行中"、"审核中"和"已完成"。此应用无需登录功能，因为这只是确保基本功能搭建的初始测试。
```

### 第 3 步：优化规范

使用 `/vipd.clarify` 命令交互式地解决规范中的歧义。你也可以提供想要确保包含的具体细节。

```bash
/vipd.clarify 我想澄清任务卡片的细节。在 UI 中，每个任务卡片应能在 Kanban 工作面板的不同列之间更改当前状态。每个卡片可以留下无限数量的评论。在任务卡片中，可以分配一个有效的用户。
```

你可以使用 `/vipd.clarify` 继续添加更多细节来优化规范：

```bash
/vipd.clarify 当你首次启动 Taskify 时，它会显示五个用户供你选择。无需密码。点击用户后，进入主视图，显示项目列表。点击项目后，打开该项目的 Kanban 面板。你将看到各列内容。你可以在不同列之间拖放卡片。分配给当前登录用户的任务卡片将以不同颜色显示，便于快速识别。你可以编辑自己发表的任何评论，但不能编辑他人的评论。你可以删除自己发表的任何评论，但不能删除他人的评论。
```

### 第 4 步：验证规范

使用 `/vipd.checklist` 命令验证规范检查清单：

```bash
/vipd.checklist
```

### 第 5 步：使用 `/vipd.plan` 生成技术计划

明确说明你的技术栈和技术需求：

```bash
/vipd.plan 我们将使用 .NET Aspire 生成此应用，使用 Postgres 作为数据库。前端应使用 Blazor Server，支持拖放任务面板和实时更新。需要创建 REST API，包括项目 API、任务 API 和通知 API。
```

### 第 6 步：定义任务

使用 `/vipd.tasks` 命令生成可执行的任务列表：

```bash
/vipd.tasks
```

### 第 7 步：验证与实施

在实施前，让编码智能体使用 `/vipd.analyze` 审核规范、计划和任务：

```bash
/vipd.analyze
```

最后，实施方案：

```bash
/vipd.implement
```

> [!TIP]
> **分阶段实施**：对于像 Taskify 这样的大型项目，考虑分阶段实施（例如，阶段 1：基础项目/任务结构，阶段 2：Kanban 功能，阶段 3：评论和分配）。这可以防止上下文饱和，并允许在每个阶段进行验证。

## 关键原则

- **明确说明**你要构建的内容及其原因
- **在规范阶段不要关注技术栈**
- **迭代优化**你的规范，然后再实施
- **在编码开始前验证**需求和计划
- **让编码智能体处理**实施细节

## 后续步骤

- 阅读[完整方法论](https://github.com/github/spec-kit/blob/main/spec-driven.md)获取深入指导
- 在仓库中查看[更多示例](https://github.com/github/spec-kit/tree/main/templates)
- 探索 [GitHub 上的源代码](https://github.com/github/spec-kit)
