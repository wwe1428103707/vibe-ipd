# vibe-ipd

> [English](README.md) · **[中文](README.zh.md)**

**集成产品开发（IPD）— 敏捷-阶段门禁混合框架，面向 AI-Native 团队**

vibe-ipd 是基于 [Spec Kit (speckit)](https://github.com/github/spec-kit) 开源工具链增强的**集成产品开发（IPD）框架**，融合了敏捷开发与阶段门禁治理（Agile-Stage-Gate）。通过 [oh-my-claudecode](https://github.com/oh-my-claudecode) 多智能体编排和产品开发团队（PDT）角色映射，为 AI-Native 团队提供从概念到交付的全流程工程化支持。

---

## vibe-ipd 与 speckit 有什么不同？

speckit 提供了基础的规范驱动开发（SDD）引擎，而 vibe-ipd 在其之上增加了**IPD-敏捷混合治理层**：

| # | 差异化能力 | 说明 |
|---|-----------|------|
| 1 | **IPD 阶段门禁治理（TR0–TR6）** | 完整的技术评审门禁模型，集成到每个 SDD 命令中 — 每个 `/vipd-*` 命令在执行前都会对前置门禁标准进行深层内容校验 |
| 2 | **oh-my-claudecode 多智能体编排** | 50+ 专业智能体角色（架构师、执行者、调试器、安全审查员等），通过智能多智能体工作流进行编排，远超 speckit 的单智能体模式 |
| 3 | **PDT 角色映射与 RACI 矩阵** | 明确的角色映射：LPDT → RTE、产品经理 → PO、开发主管 → 系统架构师、测试主管 → QA 主管、运维主管 → DevOps 主管，附 RACI 责任分配 |
| 4 | **产品三驾马车协作工作流** | 内置 PO + 系统架构师 + UX 设计师在发现轨道的协作模板与结构化评审流程 |
| 5 | **双语支持（中文/English）** | 以中文为第一语言的文档、Windows 原生 PowerShell 工具链，支持中英双语的规范/计划 |
| 6 | **双轨敏捷与自动门禁执行** | 持续发现轨道（产品三驾马车）与交付轨道并行运行；TR 门禁由 AI 智能体自动执行，无需外部平台依赖 |
| 7 | **Go/Kill/Hold/Recycle 门禁决策** | 每个 TR 门禁评审产出明确的决策：Go（通过）、Kill（终止）、Hold（暂缓）或 Recycle（返工）— 没有隐式默认值，确保严格的门禁纪律 |

---

## 快速开始

### 1. 初始化项目

```bash
# 创建新的 vibe-ipd 项目（底层自动使用 uvx 或 pipx）
/vipd-init my-project --integration claude
cd my-project
```

### 2. 建立项目原则

```bash
/vipd-constitution 创建聚焦于代码质量、测试标准和 IPD 治理的原则
```

### 3. 定义特性规范

```bash
/vipd-specify 构建一个用户认证系统，支持邮箱/密码和 SSO 登录
```

### 4. 创建实施计划

```bash
/vipd-plan 使用 Python FastAPI + PostgreSQL，JWT 认证，pytest 测试
```

### 5. 生成任务并实施

```bash
/vipd-tasks
/vipd-implement
```

至此，你的特性已具备完整的 IPD 治理、TR 门禁验证和多智能体编排能力。

---

## 架构概览

```text
┌──────────────────────────────────────────────────┐
│                  vibe-ipd                        │
│  ┌─────────────┐  ┌──────────────────────────┐  │
│  │  Spec Kit    │  │  IPD 治理层              │  │
│  │  （引擎）    │  │  ├─ TR0–TR6 门禁         │  │
│  │              │  │  ├─ PDT 角色映射          │  │
│  │  ├─ spec     │  │  ├─ RACI 矩阵            │  │
│  │  ├─ plan     │  │  ├─ 产品三驾马车          │  │
│  │  ├─ tasks    │  │  └─ ADL（架构决策日志）   │  │
│  │  └─ impl     │  │                          │  │
│  └─────────────┘  └──────────────────────────┘  │
│                                                   │
│  ┌──────────────────────────────────────────┐    │
│  │  oh-my-claudecode 多智能体层             │    │
│  │  ├─ 50+ 专业智能体角色                   │    │
│  │  ├─ 智能任务路由与执行                    │    │
│  │  └─ 工作流编排                           │    │
│  └──────────────────────────────────────────┘    │
└──────────────────────────────────────────────────┘
```

## 可用命令

所有 vibe-ipd 命令遵循 `/vipd-*` 命名规范：

| 核心命令 | 说明 |
|---------|------|
| `/vipd-init` | **初始化 vibe-ipd 项目** — 将上游 `specify init` CLI 封装为统一的品牌入口 |
| `/vipd-constitution` | 创建或更新项目治理原则，含 IPD 门禁标准 |
| `/vipd-specify` | 定义特性规范，包含用户故事和 TR1 门禁评估 |
| `/vipd-clarify` | 识别并解决规划前的未明确领域 |
| `/vipd-plan` | 创建实施计划，含门禁就绪评估和 ADL |
| `/vipd-tasks` | 生成可执行的任务列表，含依赖排序 |
| `/vipd-implement` | 执行任务，每个阶段进行 IPD 门禁验证 |
| `/vipd-analyze` | 跨制品一致性与覆盖率分析 |
| `/vipd-checklist` | 生成需求验证的质量检查清单 |

| 智能体分配命令 | 说明 |
|---------------|------|
| `/vipd-agent-assign-assign` | 基于 RACI 矩阵自动将任务分配给专业智能体 |
| `/vipd-agent-assign-validate` | 验证智能体分配存在且符合 RACI 合规要求 |
| `/vipd-agent-assign-execute` | 通过启动已分配的智能体执行任务，附带 TR4 门禁验证 |

## 文档

完整文档位于 [`docs/`](./docs/) 目录：

- [快速入门指南](./docs/zh/quickstart.md) — 开始使用 vibe-ipd
- [安装指南](./docs/zh/installation.md) — 安装与配置
- [概念](./docs/zh/concepts/sdd.md) — SDD、IPD 和敏捷-阶段门禁详解
- [IPD 转型指南](./docs/ipd-transformation/zh/README.md) — 从 speckit 迁移到 vibe-ipd
- [参考](./docs/zh/reference/overview.md) — 命令参考和 CLI 文档

## 项目状态

vibe-ipd 目前处于**活跃开发**阶段，是基于 Spec Kit 的增强分支，已扩展 IPD 能力。已完成：

- ✅ 完整的 Spec Kit 兼容性（spec → plan → tasks → implement）
- ✅ IPD 门禁集成（TR0–TR6 深层内容校验）
- ✅ PDT 角色映射与 RACI 合规
- ✅ 产品三驾马车工作流模板
- ✅ 通过 oh-my-claudecode 实现的多智能体编排
- ✅ Windows 原生 PowerShell 工具链
- ✅ 双语文档（中文/English）

**下一里程碑**：TR6 发布门禁自动化、发布管理工作流、CI/CD 集成。

## 前置依赖

- **Linux/macOS/Windows**（推荐 Windows + PowerShell 5.1+）
- **Claude Code** 或兼容的 AI 编码智能体
- [oh-my-claudecode](https://github.com/oh-my-claudecode) — 多智能体编排
- [uv](https://docs.astral.sh/uv/) 或 [pipx](https://pipx.pypa.io/) — 包管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

---

## 与 Spec Kit (speckit) 的关系

vibe-ipd 是 [Spec Kit](https://github.com/github/spec-kit) 开源项目的**衍生分支**。我们保持了与 speckit 引擎及其模板/扩展/预设系统的完全兼容，同时在其之上增加了 IPD 治理层。

如果你需要的是上游的规范驱动开发工具包（不含 IPD 扩展），请直接使用 [Spec Kit](https://github.com/github/spec-kit)。

## 致谢

本项目建立在 [Spec Kit](https://github.com/github/spec-kit) 团队和 [John Lam](https://github.com/jflam) 开创的规范驱动开发方法论之上。没有他们的开源贡献，vibe-ipd 将不复存在。

## 许可证

本项目基于 MIT 开源许可证发布。完整条款请参阅 [LICENSE](./LICENSE) 文件。
