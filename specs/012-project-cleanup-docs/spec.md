# Feature Specification: Project Cleanup & Documentation Rebrand

**Feature Branch**: `012-project-cleanup-docs`

**Created**: 2026-06-07

**Status**: Draft

**Input**: User description: "对项目进行清理，对README等文档和说明型文件进行调整，以展示更多本项目区别于speckit原项目的特色内容"

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Root README Reflects vibe-ipd Identity (Priority: P1)

As a project visitor or potential contributor, I want to read the root `README.md` and immediately understand what vibe-ipd is, what makes it unique compared to the upstream speckit project, and how to get started, so that I can decide whether this project is relevant to me.

**Why this priority**: The root README is the primary landing page for anyone discovering the project on GitHub. Without a clear identity, visitors cannot distinguish vibe-ipd from its speckit origin.

**Independent Test**: Can be evaluated by reading the README and verifying it contains: (1) a clear description of vibe-ipd's purpose, (2) at least 3 distinct differentiators from speckit, (3) a quickstart section, and (4) no outdated speckit branding as the primary identity.

**Acceptance Scenarios**:

1. **Given** a visitor opens the project README, **When** they read the first paragraph, **Then** it clearly states that this is "vibe-ipd" (not "spec kit" or "speckit") and describes its purpose.
2. **Given** a visitor familiar with speckit reads the README, **When** they review the "Differences from speckit" or equivalent section, **Then** they can identify at least 3 concrete differentiators (e.g., IPD governance, oh-my-claudecode orchestration, PDT role mapping).
3. **Given** a visitor wants to try the project, **When** they follow the quickstart instructions, **Then** they can successfully run a `/vipd-specify` → `/vipd-plan` → `/vipd-implement` workflow end-to-end.

---

### User Story 2 — Documentation Files Branded as vibe-ipd (Priority: P1)

As a user reading the project documentation under `docs/`, I want all pages to consistently refer to "vibe-ipd" and its `/vipd-*` commands, so that I don't encounter confusing references to "spec kit" or "speckit" commands.

**Why this priority**: Inconsistent branding across docs creates confusion and makes the project appear unmaintained. Users may try `/speckit-*` commands that don't exist in this project.

**Independent Test**: Can be verified by grepping all `.md` files in `docs/` for outdated branding strings and confirming zero hits for primary speckit identifiers.

**Acceptance Scenarios**:

1. **Given** all documentation files under `docs/`, **When** searched for `speckit` (case-insensitive), **Then** no more than 2 acceptable references remain (e.g., historical attribution line).
2. **Given** all documentation files under `docs/`, **When** searched for `/speckit-` command references, **Then** all have been updated to `/vipd-` equivalents.
3. **Given** the documentation site navigation, **When** reviewing `toc.yml` and `index.md`, **Then** all references use "vibe-ipd" branding.

---

### User Story 3 — Configuration and Script References Updated (Priority: P2)

As a developer maintaining the project, I want internal references (config files, script comments, templates) to consistently use `vipd-*` naming, so that there is no confusion between speckit conventions and vibe-ipd conventions when reading source code.

**Why this priority**: Internal consistency reduces maintenance errors and makes onboarding new contributors smoother. However, end-users rarely read internal scripts, so this is lower priority than public-facing docs.

**Independent Test**: Can be tested by running a grep across non-documentation files for stale speckit references and verifying they are limited to historical/attribution contexts.

**Acceptance Scenarios**:

1. **Given** the project's `.specify/` configuration files, **When** reviewed for stale `speckit` references in user-facing messages and comments, **Then** they use `vipd-*` or `vibe-ipd` nomenclature.
2. **Given** the skill definition files (`.claude/skills/vipd-*`), **When** their descriptions and help text are reviewed, **Then** they reference the correct `vipd-*` branding.
3. **Given** the gate script templates, **When** their output messages are reviewed, **Then** they reference the project as "vibe-ipd" or equivalent.

---

### Edge Cases

- What happens when a speckit reference is in a third-party attribution or license file that should not be modified?
- How to handle references in generated/templated files that might be regenerated from upstream?
- What about git history — should old commit messages referencing "speckit" be rewritten?
- How to distinguish between "speckit" as an upstream project reference vs. as the project's own branding?

## TR Gate Assessment *(IPD only)*

- **Applicable TR Gates**: TR1 (Concept), TR4 (Development)
- **Risk Level**: Low
- **Gate Evidence Required**: Spec completeness, updated README and docs with consistent branding

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The root `README.md` MUST be rewritten to clearly identify the project as "vibe-ipd", describe its purpose, and list key differentiators from the upstream speckit project.
- **FR-002**: All `docs/*.md` files MUST be updated to replace primary branding references from "spec kit"/"speckit" to "vibe-ipd" and update `/speckit-*` commands to `/vipd-*`.
- **FR-003**: The root `README.md` MUST include a "Quickstart" section demonstrating a minimal end-to-end workflow using `/vipd-*` commands.
- **FR-004**: Outdated or redundant files (e.g., speckit-specific upgrade guides, stale references) SHOULD be identified and cleaned up or relocated.
- **FR-005**: Template files and default configurations MUST use `vipd-*` naming in user-facing output.
- **FR-006**: Documentation MUST include a section or note explaining the project's relationship to the upstream speckit project and what makes vibe-ipd distinct.
- **FR-007**: The `CLAUDE.md` agent context file MUST be kept in sync with the rebranded project identity.
- **FR-008**: All changes MUST be documentation-only — no functional code in `hello.sh`, skills, or gate scripts shall be modified as part of this feature.

### Key Entities

- **README.md**: The root-level project README that serves as the primary entry point for visitors and contributors.
- **Documentation Pages**: All `.md` files under `docs/` covering installation, concepts, quickstart, reference, and upgrade guides.
- **Configuration Files**: Files under `.specify/`, templates, and skill definitions that contain user-facing branding references.
- **Branding Strings**: Key identifiers including "vibe-ipd", "vipd", "spec kit", "speckit", "Spec Kit" that define the project's identity.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Root `README.md` is fully rewritten with vibe-ipd branding and contains a "What makes vibe-ipd different from speckit" section with at least 3 distinct differentiators.
- **SC-002**: Zero occurrences of `speckit` (case-insensitive) as self-referential branding in `docs/` files (upstream attribution references excluded).
- **SC-003**: All `/speckit-*` command references in documentation updated to `/vipd-*` equivalents.
- **SC-004**: A visitor unfamiliar with the project can successfully understand what vibe-ipd is and run a basic workflow within 5 minutes of reading the README.

## Assumptions

- The upstream speckit project continues to exist; vibe-ipd is a fork/derivative with additional IPD and multi-agent features.
- Some historical attribution to speckit is acceptable and desirable (e.g., "Based on Spec Kit v0.9.3").
- License and attribution files should NOT be modified.
- Git history will NOT be rewritten — only the working tree and future commits will reflect the new branding.
- The `docs/` directory structure will be preserved; only content will be updated.

## Risk Register *(IPD only)*

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Incomplete rebranding leaves stale references | M | M | Automated grep-based validation checklist; manual review pass |
| Over-rebranding removes useful speckit upstream context | M | L | Maintain attribution section; preserve historical notes |
| Documentation changes conflict with in-progress feature work | L | L | Feature is documentation-only; no code conflicts expected |
