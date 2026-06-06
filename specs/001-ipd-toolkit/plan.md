# Implementation Plan: IPD Toolkit Transformation Plan — Chinese Translation Phase

**Branch**: `001-ipd-toolkit` | **Date**: 2026-06-06 | **Spec**: `specs/001-ipd-toolkit/spec.md`

**Input**: User request: "现在还需要将这些文件生成对应的中文翻译副本"

**Note**: This is a supplementary phase for the existing 001-ipd-toolkit feature. The English
documents have already been created under `docs/ipd-transformation/`. This phase creates
Chinese (中文) translations of all 7 documents as specified in the project assumptions:
"所有文件必须以中文撰写，并提供英文术语交叉引用。"

## Summary

Generate Chinese (中文) translations of all 7 existing documents under
`docs/ipd-transformation/`, maintaining the same structure and cross-references
but with Chinese primary text and English terminology in parentheses on first use.
The Chinese versions will be placed in a `zh/` subdirectory alongside the English originals.

## Technical Context

**Language/Version**: Markdown (GFM), Chinese (中文) primary text with English terminology
cross-references in parentheses on first use per project assumptions

**Primary Dependencies**: Existing English documents in `docs/ipd-transformation/`

**Storage**: Git repository under `docs/ipd-transformation/zh/`

**Testing**: Document review against spec acceptance criteria; cross-reference verification
between Chinese and English versions

**Target Platform**: Git-based documentation directory

**Project Type**: Documentation / Translation

**Performance Goals**: N/A

**Constraints**:
- Documents MUST be purely descriptive prose (no executable configs or code snippets)
- Documents MUST be in Markdown format under `docs/ipd-transformation/zh/`
- Documents MUST be written in Chinese with English terminology cross-references
- Documents MUST reference constitutional principles (I–V)
- All 7 documents MUST follow the same format as their English counterparts
- Cross-references between Chinese documents MUST use relative paths within `zh/`
- Cross-references to English originals MUST use `../` relative paths

**Scale/Scope**: 7 documents (4 core + glossary + contributing + README), ~25–50 pages total

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Principle I — Spec-First, Intent-Driven Development** ✅ PASS
- The original spec defined the documents; translation preserves the same WHAT and WHY.

**Principle II — Dual-Track Agile: Discovery & Delivery** ✅ PASS
- Translation is a delivery activity — the discovery (design) was completed in the
  first phase. Chinese translations unblock Chinese-speaking PDT teams.

**Principle III — Agile-Stage-Gate Governance** ✅ PASS
- No new features; this is a translation of existing gate-aware content.

**Principle IV — Cross-Functional PDT with Autonomous Feature Teams** ✅ PASS
- Chinese translations directly enable Principle IV by making documents accessible
  to Chinese-speaking team members.

**Principle V — Quality Built-In with Automated Gate Verification** ✅ PASS
- Translation quality will be verified by cross-reference checks and content review.

> **Gate verdict**: PASS — no violations. Complexity Tracking section not needed.

## Project Structure

### Documentation (this phase)

```text
docs/ipd-transformation/zh/       # Chinese translation directory
├── README.md                     # Collection overview (中文)
├── 01-转化路线图.md                # Transformation Roadmap (中文)
├── 02-命令与模板改造指南.md         # Command & Template Redesign Guide (中文)
├── 03-工具集成蓝图.md              # Tooling Integration Blueprint (中文)
├── 04-角色映射与PDT组建指南.md      # Role Mapping & PDT Setup Guide (中文)
├── glossary.md                   # Glossary (中文)
└── CONTRIBUTING.md                # Formatting conventions (中文)
```

### Source Documents (reference only, not modified)

```text
docs/ipd-transformation/          # English originals (already exist)
├── README.md
├── 01-transformation-roadmap.md
├── 02-command-template-redesign-guide.md
├── 03-tooling-integration-blueprint.md
├── 04-role-mapping-pdt-setup-guide.md
├── glossary.md
└── CONTRIBUTING.md
```

**Structure Decision**: Chinese translations in `zh/` subdirectory, using Chinese
filenames for discoverability by Chinese-speaking readers.

## Complexity Tracking

> Not needed — Constitution Check passed with no violations.

## Phase 0: Research

Research is minimal — all content exists in English. Only validation needed:

1. **Terminology consistency**: Ensure Chinese translations of key IPD/Agile terms
   align with the glossary and the source IPD fusion guide (which is already in Chinese).
2. **Cross-reference mapping**: Map all English file references to Chinese counterparts.

### Research Output

Key terminology mapping (from glossary and IPD fusion guide):

| English Term | Chinese Translation | Abbreviation |
|-------------|---------------------|--------------|
| Technology Review | 技术评审 | TR |
| Product Development Team | 产品开发团队 | PDT |
| Lead PDT Manager | PDT经理 | LPDT |
| Release Train Engineer | 敏捷发布火车工程师 | RTE |
| Definition of Done | 完成标准 | DoD |
| Weighted Shortest Job First | 加权最短作业优先 | WSJF |
| Common Building Block | 公用基础模块 | CBB |
| Product Trio | 产品三人组 | — |
| Agile-Stage-Gate | 敏捷-门径混合 | — |
| Dual-Track Agile | 双轨敏捷 | — |
| Product Owner | 产品负责人 | PO |
| System Architect | 系统架构师 | — |
| Spec-Driven Development | 规格驱动开发 | SDD |

## Phase 1: Design & Contracts

No new data model or contracts needed — the structure mirrors the English originals.
The quickstart guide needs a Chinese version pointing to the `zh/` directory.

### Agent Context Update

Update CLAUDE.md to reference both the English plan and the Chinese translation availability.