# Feature Specification: Chinese Documentation Translation

**Feature Branch**: `014-chinese-docs-translation`

**Created**: 2026-06-07

**Status**: Draft

**Input**: User description: "对README中关联的Documentation，都添加对应的中文翻译文档，并在中文版的readme中进行关联"

## Clarifications

### Session 2026-06-07

- Q: Should Community documentation (`docs/community/`) be translated to Chinese? → A: No, Community section does not need Chinese translation.
- Q: What directory structure should Chinese translations use? → A: Top-level `docs/zh/` mirror — translations go in `docs/zh/<section>/<file>`.
- Q: Should additional docs outside the Documentation section (index.md, upgrade.md, local-dev.md, install/*.md) be in scope? → A: SHOULD (nice-to-have) — core 5 entries are priority, additional docs if time permits.

## User Scenarios & Testing

### User Story 1 — Browse Quickstart Guide in Chinese (Priority: P1)

A Chinese-speaking user reads the README.zh.md and clicks on the "快速入门指南" link. They are taken to a fully translated Chinese version of the quickstart guide that covers all the same content as the English version: project initialization, specification creation, planning, task generation, and implementation.

**Why this priority**: The Quickstart Guide is the first documentation new users encounter. Chinese-speaking users must be able to follow it from start to finish without switching to English. This establishes the baseline bilingual experience.

**Independent Test**: Open README.zh.md, click "快速入门指南", verify the page displays in Chinese and all code blocks, links, and section headings match the English original's structure.

**Acceptance Scenarios**:

1. **Given** the Chinese quickstart guide exists, **When** a user navigates to `docs/zh/quickstart.md`, **Then** all sections from the English original are translated, with code blocks and commands preserved intact
2. **Given** the Chinese quickstart guide, **When** a user clicks a relative link within it, **Then** it resolves to the corresponding Chinese document (not the English one)
3. **Given** a Chinese-speaking user reads the guide, **When** they follow the four-step workflow (init → specify → plan → tasks), **Then** all CLI examples and installation commands remain executable as-is

---

### User Story 2 — Browse Installation Guide in Chinese (Priority: P1)

A Chinese-speaking developer wants to install vibe-ipd on Windows. They read the Chinese installation guide and find Windows-specific instructions with PowerShell examples, prerequisite checks, and configuration steps — all translated while preserving platform-specific accuracy.

**Why this priority**: Installation is the first hands-on step. An unclear translation can lead to setup failures and user frustration. The installation doc has platform-specific content (Windows/PowerShell nuances) that must be translated with care.

**Independent Test**: Open the Chinese installation guide, verify each prerequisite, installation method (uv/pipx), and verification step is translated while all code snippets remain executable.

**Acceptance Scenarios**:

1. **Given** the Chinese installation guide, **When** a user reads the prerequisites section, **Then** all prerequisites are listed in Chinese with tool names and version numbers unchanged
2. **Given** the Chinese installation guide, **When** a user follows the "使用 uv 安装" or "使用 pipx 安装" instructions, **Then** the exact shell commands from the English version are preserved

---

### User Story 3 — Read Reference Documentation in Chinese (Priority: P2)

A Chinese-speaking user exploring vibe-ipd's capabilities opens the Chinese version of the core concepts reference, authentication guide, extensions, integrations, presets, and workflows documentation. Each document is fully translated and linked from the Chinese README.

**Why this priority**: Reference docs are consulted frequently during daily use. Having them in Chinese reduces context-switching for Chinese-speaking team members, but the initial setup can still work without them since English docs exist.

**Independent Test**: Navigate from README.zh.md → "参考" section → click each reference link, verify each page is in Chinese and structurally matches its English counterpart.

**Acceptance Scenarios**:

1. **Given** the Chinese reference documentation, **When** a user opens `docs/zh/reference/core.md`, **Then** it contains a full translation of the English `docs/reference/core.md`
2. **Given** cross-references within reference docs, **When** a Chinese doc links to another reference page, **Then** the link points to the Chinese version of that page
3. **Given** the Chinese reference docs index, **When** a user browses the table of contents, **Then** all seven reference topics are listed (overview, core, authentication, extensions, integrations, presets, workflows)

---

### User Story 4 — Concepts Document in Chinese (Priority: P3)

A Chinese-speaking newcomer wants to understand Spec-Driven Development (SDD) methodology. They read the Chinese version of the SDD concepts page and grasp the core philosophy, workflow, and benefits without needing to reference the English original.

**Why this priority**: The concepts page is educational — users can still use the tool without reading it, but it provides valuable context. Lower priority because the information is supplementary.

**Independent Test**: Open `docs/zh/concepts/sdd.md` and verify the entire SDD philosophy, workflow diagram, and benefits section are translated.

**Acceptance Scenarios**:

1. **Given** the Chinese concepts doc, **When** a user reads the core philosophy section, **Then** all four philosophy principles are translated with accurate technical terminology
2. **Given** the Chinese concepts doc, **When** a user reads about the SDD workflow, **Then** the spec → plan → tasks → implement flow is clearly explained in Chinese

---

### User Story 5 — README.zh.md Links to Chinese Docs (Priority: P1)

A Chinese-speaking user opens README.zh.md and finds all documentation links under the "文档" section pointing to Chinese versions, not English ones. The user can seamlessly browse the entire documentation suite in Chinese.

**Why this priority**: Without this update, even with all translations done, users would still land on English pages. This is the glue that makes the translation effort usable.

**Independent Test**: Open README.zh.md, click every link in the Documentation section, verify they all resolve to Chinese-language documents.

**Acceptance Scenarios**:

1. **Given** README.zh.md, **When** a user views the Documentation section, **Then** all five documentation links point to Chinese versions (under `docs/zh/` or equivalent)
2. **Given** a translated document, **When** a user navigates to its Chinese version, **Then** it contains a language toggle link back to the English original (mirroring the `[English](...) · **[中文](...)**` pattern)

### Edge Cases

- What happens when a documentation file has no Chinese counterpart yet? The link should gracefully fall back to the English version.
- How does the system handle documentation files that are already in Chinese (e.g., `docs/IPD与敏捷开发深度融合的软件产品开发流程与研发管理平台搭建指南.md`)? They should remain untouched and linked appropriately.
- What about the `docs/ipd-transformation/zh/` directory that already has Chinese translations? These should remain in place and be linked from the appropriate section in README.zh.md without re-translating.
- How to handle code blocks, CLI commands, and configuration snippets within translated docs? These must be preserved verbatim — only prose text should be translated.

## TR Gate Assessment

- **Applicable TR Gates**: TR1
- **Risk Level**: Low
- **Gate Evidence Required**: Spec exists with user stories, acceptance criteria, and scope definition

## Requirements

### Functional Requirements

- **FR-001**: README.zh.md MUST link to Chinese versions of all documentation entries listed in its Documentation section
- **FR-002**: Quickstart Guide (`docs/quickstart.md`) MUST have a Chinese translation accessible from README.zh.md
- **FR-003**: Installation Guide (`docs/installation.md`) MUST have a Chinese translation including all platform-specific notes (Windows/PowerShell)
- **FR-004**: Concepts documentation (`docs/concepts/sdd.md`) MUST have a Chinese translation preserving all technical terminology accurately
- **FR-005**: Reference documentation (`docs/reference/` — all 7 files) MUST have Chinese translations
- **FR-006**: IPD Transformation Guide (`docs/ipd-transformation/`) already has Chinese translations in `docs/ipd-transformation/zh/` — README.zh.md MUST link to these existing translations
- **FR-007**: Each Chinese translation document MUST preserve code blocks, CLI commands, configuration snippets, and file paths exactly as they appear in the English original
- **FR-008**: Each Chinese translation document MUST include a language toggle link (e.g., `[English](...) · **[中文](...)**`) referencing the corresponding English original
- **FR-009**: Relative links within Chinese documents MUST point to the corresponding Chinese document when a Chinese counterpart exists
- **FR-010**: Chinese translations MUST use the top-level `docs/zh/` mirror structure — translations go in `docs/zh/<section>/<file>` (e.g., `docs/zh/quickstart.md`, `docs/zh/reference/core.md`). The existing per-section `zh/` in `docs/ipd-transformation/zh/` is a pre-existing pattern and is not affected.
- **FR-011**: If any documentation file lacks a Chinese counterpart at the time of linking, README.zh.md MUST fall back gracefully by linking to the English version with a note indicating Chinese version pending
- **FR-012**: Additional docs not in the Documentation section (e.g., `docs/index.md`, `docs/upgrade.md`, `docs/local-development.md`, `docs/install/` files) SHOULD also receive Chinese translations for completeness
- **FR-013**: Each translated document MUST maintain the same section headings, heading hierarchy, and structural organization as the English original

### Key Entities

- **Documentation File**: An English markdown file under `docs/` that serves as the source for translation. Contains prose, code blocks, links, and metadata.
- **Chinese Translation File**: The translated counterpart preserving structure and code content while rendering prose in Chinese. Located at `docs/zh/<section>/<file>` mirroring the English structure.
- **README.zh.md**: The Chinese-language project landing page. Acts as the navigation hub linking to all Chinese documentation.
- **Language Toggle**: A bidirectional link at the top of each document allowing switching between English and Chinese versions.

## Success Criteria

### Measurable Outcomes

- **SC-001**: All 5 documentation entries listed in README.md's Documentation section have corresponding Chinese translations linked from README.zh.md (quickstart, installation, concepts, IPD-transformation, reference). Community docs are excluded per project scope.
- **SC-002**: A Chinese-speaking user can navigate from README.zh.md through the entire documentation tree — clicking any documentation link lands on a Chinese-language page without encountering an untranslated page
- **SC-003**: Each translated document preserves 100% of code blocks, CLI commands, and file paths verbatim from the English original — verified by automated diff of non-prose content
- **SC-004**: Each translated document maintains identical heading structure (same number of headings at each level) as the English original — verified by automated heading comparison
- **SC-005**: README.zh.md updates involve exactly 5 documentation link targets changed from English to Chinese paths (or existing `zh/` paths for IPD transformation)
- **SC-006**: Existing Chinese translations in `docs/ipd-transformation/zh/` are correctly linked and not duplicated or overwritten

## Assumptions

- The existing `docs/ipd-transformation/zh/` translations are complete and correct — they only need to be linked from README.zh.md, not re-translated
- Chinese translations will follow the `docs/zh/<section>/<file>` directory structure (chosen during specification clarification)
- All 20+ documentation files need translation — the total effort is estimated at 2,500–3,000 lines of prose translation
- Code blocks, shell commands, and configuration examples should never be translated — only surrounding prose and UI labels
- Documentation files that are already in Chinese (e.g., `docs/IPD与敏捷开发深度融合的软件产品开发流程与研发管理平台搭建指南.md`) are left untouched
- The translation quality bar is "accurate and readable" — technical terms (e.g., "Spec-Driven Development", "stage-gate", "PDT") should use established Chinese translations consistent with existing usage in README.zh.md and the IPD transformation zh docs

## Risk Register

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Inconsistent translation of technical terms across documents | M | M | Create a glossary of standard Chinese translations for key terms before starting translation |
| Code blocks or commands accidentally modified during translation | H | L | Enforce preservation check as part of translation review — compare all code blocks between English and Chinese versions |
| Inconsistent directory structure for Chinese docs | L | L | Directory convention resolved during clarification — use `docs/zh/` mirror structure consistently; existing `ipd-transformation/zh/` is a pre-existing exception |
| Stale translations when English docs are updated | M | H | Document that translations are a snapshot at time of creation; add a "Last synced" date footer to each translated document |
