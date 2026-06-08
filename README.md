# vibe-ipd

> **[English](README.md)** · [中文](README.zh.md)

**Integrated Product Development — Agile-Stage-Gate Hybrid for AI-Native Teams**

vibe-ipd 是一个基于 Spec Kit (speckit) 增强的集成产品开发（IPD）框架，融合了敏捷开发与阶段门禁治理（Agile-Stage-Gate），为 AI-Native 团队提供从概念到交付的全流程工程化支持。

vibe-ipd extends the [Spec Kit](https://github.com/github/spec-kit) (speckit) open-source toolkit with a full **IPD governance framework**, **multi-agent orchestration** via [oh-my-claudecode](https://github.com/oh-my-claudecode), and **Product Development Team (PDT) role mapping** — bringing enterprise-grade product development discipline to AI-assisted coding workflows.

---

## What Makes vibe-ipd Different from speckit?

While speckit provides the foundational Spec-Driven Development (SDD) engine, vibe-ipd adds an opinionated **IPD-Agile hybrid governance layer** on top:

| # | Differentiator | Description |
|---|----------------|-------------|
| 1 | **IPD Stage-Gate Governance (TR0–TR6)** | Full Technology Review gate model integrated into every SDD command — each `/vipd-*` command performs deep content validation against prior gate criteria before proceeding |
| 2 | **oh-my-claudecode Multi-Agent Orchestration** | 50+ specialized agent roles (architect, executor, debugger, security reviewer, etc.) orchestrated via intelligent multi-agent workflows, far beyond speckit's single-agent model |
| 3 | **PDT Role Mapping with RACI Matrix** | Explicit mapping of LPDT → RTE, Product Manager → PO, Dev Lead → System Architect, Test Lead → QA Lead, Ops Lead → DevOps Lead, with RACI-based responsibility assignments |
| 4 | **Product Trio Collaboration Workflows** | Built-in templates and workflows for PO + System Architect + UX Designer collaboration during the discovery track, with structured review processes |
| 5 | **Bilingual Support (中文/English)** | Chinese-first documentation, Windows-native PowerShell tooling, and bilingual spec/plan support — designed for teams operating in Chinese-speaking environments |
| 6 | **Dual-Track Agile with Automatic Gate Enforcement** | Continuous discovery track (Product Trio) runs in parallel with delivery track; TR gates are automatically enforced by AI agents without external platform dependencies |
| 7 | **Go/Kill/Hold/Recycle Gate Decisions** | Every TR gate review produces an explicit decision: Go, Kill, Hold, or Recycle — no implicit defaults, ensuring rigorous stage-gate discipline |

---

## Quickstart

### 1. Initialize your project

```bash
# Create a new vibe-ipd project (uses uvx or pipx under the hood)
/vipd-init my-project --integration claude
cd my-project
```

### 2. Establish project principles

```bash
/vipd-constitution Create principles focused on code quality, testing standards, and IPD governance
```

### 3. Specify your feature

```bash
/vipd-specify Build a user authentication system with email/password and SSO support
```

### 4. Create implementation plan

```bash
/vipd-plan Use Python FastAPI with PostgreSQL, JWT-based auth, and pytest
```

### 5. Generate tasks and implement

```bash
/vipd-tasks
/vipd-implement
```

That's it — your feature is now built with full IPD governance, TR gate validation, and multi-agent orchestration.

---

## Architecture Overview

```text
┌──────────────────────────────────────────────────┐
│                  vibe-ipd                        │
│  ┌─────────────┐  ┌──────────────────────────┐  │
│  │  Spec Kit    │  │  IPD Governance Layer    │  │
│  │  (Engine)    │  │  ├─ TR0–TR6 Gates       │  │
│  │              │  │  ├─ PDT Role Mapping     │  │
│  │  ├─ spec     │  │  ├─ RACI Matrix          │  │
│  │  ├─ plan     │  │  ├─ Product Trio         │  │
│  │  ├─ tasks    │  │  └─ ADL (Architecture    │  │
│  │  └─ impl     │  │     Decision Log)        │  │
│  └─────────────┘  └──────────────────────────┘  │
│                                                   │
│  ┌──────────────────────────────────────────┐    │
│  │  oh-my-claudecode Multi-Agent Layer      │    │
│  │  ├─ 50+ specialized agent roles          │    │
│  │  ├─ Intelligent task routing & execution │    │
│  │  └─ Workflow orchestration               │    │
│  └──────────────────────────────────────────┘    │
└──────────────────────────────────────────────────┘
```

## Feature Catalog

vibe-ipd v1.0.0 implements **17 features** across the IPD workflow:

| # | Feature | Status |
|---|---------|--------|
| 001 | IPD Toolkit — Core gate framework and constitution | ✅ |
| 002 | IPD Agent PM Integration | ✅ |
| 003 | Blueprint Docstate-only Mode | ✅ |
| 004 | VIPD Command Prefix Migration | ✅ |
| 005 | Implement IPD Gates (TR0-TR6) | ✅ |
| 006 | Implement Docstate Tools | ✅ |
| 007 | PDT Role Setup with RACI Matrix | ✅ |
| 008 | CLI IPD Adaptation | ✅ |
| 009 | IPD Migration Gaps — 25 gaps filled | ✅ |
| 010 | E2E Workflow Validation | ✅ |
| 011 | Multilingual Greeting (--lang en/zh/ja) | ✅ |
| 012 | Project Cleanup & Documentation Rebrand | ✅ |
| 013 | VIPD Init Skill (uvx/pipx scaffolding) | ✅ |
| 014 | Chinese Documentation Translation | ✅ |
| 015 | Fix TR Gate Chicken-Egg Dependency | ✅ |
| 016 | VIPD Init Language Option (--lang flag) | ✅ |
| 017 | **Version Management & Docs Preparation** | ✅ **v1.0.0** |

> Run `vipd --version` to see the current version and underlying speckit version.

## Versioning

vipd follows **semantic versioning** (MAJOR.MINOR.PATCH), same conventions as speckit:

| Bump | When |
|------|------|
| **MAJOR** | Breaking workflow changes, backward-incompatible format changes |
| **MINOR** | New features implemented (new specs) |
| **PATCH** | Bug fixes, doc updates, refactoring |

The vipd version is tracked independently from the speckit version. Run `vipd --version` to see both:

```
vipd 1.0.0 (speckit 0.9.3.dev0)
```

See [VERSION_BUMP.md](./VERSION_BUMP.md) for the complete bump process and [CHANGELOG.md](./CHANGELOG.md) for release history.

## Available Commands

All vibe-ipd commands follow the `/vipd-*` naming convention:

| Core Command | Description |
|--------------|-------------|
| `/vipd-init` | **Scaffold a new vibe-ipd project** — wraps upstream `specify init` CLI behind a unified brand entry point |
| `/vipd-constitution` | Create or update project governing principles with IPD gate criteria |
| `/vipd-specify` | Define feature specifications with user stories and TR1 gate assessment |
| `/vipd-clarify` | Identify and resolve underspecified areas before planning |
| `/vipd-plan` | Create implementation plan with gate readiness and ADL |
| `/vipd-tasks` | Generate actionable task lists with dependency ordering |
| `/vipd-implement` | Execute tasks with IPD gate validation at each phase |
| `/vipd-analyze` | Cross-artifact consistency and coverage analysis |
| `/vipd-checklist` | Generate quality checklists for requirements validation |

| Agent Assignment Commands | Description |
|---------------------------|-------------|
| `/vipd-agent-assign-assign` | Auto-assign tasks to specialized agents based on RACI matrix |
| `/vipd-agent-assign-validate` | Validate agent assignments exist and RACI-compliant |
| `/vipd-agent-assign-execute` | Execute tasks by spawning assigned agents with TR4 gate validation |

## Documentation

Full documentation is available in the [`docs/`](./docs/) directory:

- [Quickstart Guide](./docs/quickstart.md) — Get started with vibe-ipd
- [Installation Guide](./docs/installation.md) — Install and configure
- [Concepts](./docs/concepts/) — SDD, IPD, and Agile-Stage-Gate explained
- [IPD Transformation Guide](./docs/ipd-transformation/) — Migrate from speckit to vibe-ipd
- [Reference](./docs/reference/) — Command reference and CLI docs
- [Community](./docs/community/) — Extensions, presets, and walkthroughs

## Project Status

vibe-ipd is currently in **active development** as a fork of Spec Kit with enhanced IPD capabilities. The project has completed:

- ✅ Full Spec Kit compatibility (spec → plan → tasks → implement)
- ✅ IPD gate integration (TR0–TR6 with deep content validation)
- ✅ PDT role mapping with RACI compliance
- ✅ Product Trio workflow templates
- ✅ Multi-agent orchestration via oh-my-claudecode
- ✅ Windows-native PowerShell tooling
- ✅ Bilingual documentation (CN/EN)

**Current version**: `vipd 1.0.0` (speckit 0.9.3.dev0) — first official release! 🎉

**Next milestones**: TR6 launch gate automation, release management workflows, and CI/CD integration.

## Prerequisites

- **Linux/macOS/Windows** (Windows with PowerShell 5.1+ recommended)
- **Claude Code** or compatible AI coding agent
- [oh-my-claudecode](https://github.com/oh-my-claudecode) for multi-agent orchestration
- [uv](https://docs.astral.sh/uv/) or [pipx](https://pipx.pypa.io/) for package management
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

---

## Relationship to Spec Kit (speckit)

vibe-ipd is a **derivative fork** of the [Spec Kit](https://github.com/github/spec-kit) open-source project. We retain full compatibility with the speckit engine and its template/extension/preset systems while adding our opinionated IPD governance layer on top.

If you are looking for the upstream Spec-Driven Development toolkit without IPD extensions, please use [Spec Kit](https://github.com/github/spec-kit) directly.

## Acknowledgments

This project builds upon the excellent work of the [Spec Kit](https://github.com/github/spec-kit) team and the Spec-Driven Development methodology pioneered by [John Lam](https://github.com/jflam). Without their open-source contributions, vibe-ipd would not exist.

## License

This project is licensed under the terms of the MIT open source license. Please refer to the [LICENSE](./LICENSE) file for the full terms.
