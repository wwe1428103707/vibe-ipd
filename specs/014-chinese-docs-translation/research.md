# Research: Chinese Documentation Translation

**Plan**: [plan.md](plan.md) | **Date**: 2026-06-07

## Translation Glossary

Standard Chinese translations for key technical terms, established by referencing existing usage in `README.zh.md` and `docs/ipd-transformation/zh/`:

| English Term | Chinese Translation | Source Reference |
|---|---|---|
| Spec-Driven Development (SDD) | 规范驱动开发 | README.zh.md |
| Integrated Product Development (IPD) | 集成产品开发 | README.zh.md |
| Spec Kit / speckit | Spec Kit (speckit) | README.zh.md (kept as proper noun) |
| vibe-ipd | vibe-ipd | README.zh.md (kept as proper noun) |
| Agile-Stage-Gate | 敏捷-阶段门禁 | README.zh.md |
| Technology Review (TR) | 技术评审 (TR) | README.zh.md |
| Stage-Gate Governance | 阶段门禁治理 | README.zh.md |
| Multi-Agent Orchestration | 多智能体编排 | README.zh.md |
| Product Development Team (PDT) | 产品开发团队 (PDT) | README.zh.md |
| RACI Matrix | RACI 矩阵 | README.zh.md |
| Product Trio | 产品三驾马车 | README.zh.md |
| Quickstart Guide | 快速入门指南 | README.zh.md |
| Installation Guide | 安装指南 | README.zh.md |
| Architecture Decision Log (ADL) | 架构决策日志 (ADL) | README.zh.md |
| Gate / TR Gate | 门禁 / TR 门禁 | README.zh.md |
| Go / Kill / Hold / Recycle | 通过 / 终止 / 暂缓 / 返工 | README.zh.md |
| Continuous Discovery | 持续发现 | README.zh.md |
| Delivery Track | 交付轨道 | README.zh.md |
| oh-my-claudecode | oh-my-claudecode | README.zh.md (kept as proper noun) |
| Claude Code | Claude Code | README.zh.md (kept as proper noun) |
| Common Building Block (CBB) | 通用构建模块 (CBB) | README.zh.md |
| Definition of Done (DoD) | 完成定义 (DoD) | README.zh.md |
| Shift-Left Testing | 左移测试 | Consistent with industry standard |
| WSJF | WSJF | README.zh.md (abbreviation kept) |
| LPDT / RTE / PO | LPDT / RTE / PO | README.zh.md (role abbreviations kept) |

**Decision**: Keep project names (vibe-ipd, speckit, oh-my-claudecode, Claude Code) and role abbreviations (LPDT, RTE, PO, PDT) untranslated. Translate conceptual terms (stage-gate, multi-agent, governance) using the established terms from README.zh.md.

## Translation Approach

**Decision**: Human-quality AI-assisted translation with manual review.

**Rationale**:
- Technical documentation requires accurate terminology — AI translation with glossary enforcement ensures consistency
- Code blocks and commands must be preserved exactly — automated pre/post-check required
- Each document should be translated as a complete unit, not piecemeal, to maintain flow and context

**Process**:
1. For each document: read the full English source, translate with glossary reference
2. Preserve all Markdown structure, headings, code blocks, and links
3. Add language toggle at the top: `[English](...) · **[中文](...)**`
4. Adjust relative links to point to `docs/zh/` equivalents
5. Review: compare heading structure, verify code block preservation, check link correctness

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| Machine translation only (no human review) | Risk of incorrect technical terminology and loss of nuance in project-specific concepts |
| Translate only key sections, leaving rest in English | Inconsistent user experience — defeats purpose of bilingual support |
| Use a single flat `docs/zh/` directory (no subdirectories) | File naming conflicts — multiple docs could have same name (e.g., `overview.md`, `extensions.md`) |

## Document Inventory

Full inventory of documents requiring translation, grouped by priority:

### Priority P1 — Core (must-have)
| File | Lines | Est. Translation Effort |
|---|---|---|
| `docs/quickstart.md` | 206 | Medium |
| `docs/installation.md` | 112 | Medium |
| `README.zh.md` (link updates) | 161 | Small (update ~5 links) |

### Priority P2 — Reference (should-have)
| File | Lines | Est. Translation Effort |
|---|---|---|
| `docs/reference/core.md` | 97 | Medium |
| `docs/reference/authentication.md` | 181 | Medium |
| `docs/reference/extensions.md` | 201 | Medium |
| `docs/reference/integrations.md` | 194 | Medium |
| `docs/reference/overview.md` | 33 | Small |
| `docs/reference/presets.md` | 224 | Large |
| `docs/reference/workflows.md` | 323 | Large |

### Priority P3 — Concepts (nice-to-have)
| File | Lines | Est. Translation Effort |
|---|---|---|
| `docs/concepts/sdd.md` | 46 | Small |

### Pre-existing (link only)
| Directory | Notes |
|---|---|
| `docs/ipd-transformation/zh/` | Already translated — link from README.zh.md |

### Nice-to-Have (if scope permits)
| File | Lines |
|---|---|
| `docs/index.md` | 154 |
| `docs/upgrade.md` | 508 |
| `docs/local-development.md` | 173 |
| `docs/install/uv.md` | 60 |
| `docs/install/pipx.md` | 37 |
| `docs/install/one-time.md` | 32 |
| `docs/install/air-gapped.md` | 59 |
| `docs/README.md` | ~30 |
