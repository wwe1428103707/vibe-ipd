# Feature Specification: CLI Source IPD Adaptation

**Feature Branch**: `008-cli-ipd-adaptation`

**Created**: 2026-06-06

**Status**: Draft

**Input**: User description: "Adapt src/specify_cli for IPD compatibility — rename references, update commands, align with vipd-* naming convention"

## Analysis Summary

### Files to Modify
- **29 Python files** contain `speckit` references (298 total occurrences)
- **0 files** currently reference `vipd` or `ipd`

### Change Categories

| Category | Files | Description |
|----------|-------|-------------|
| Core rename | 10+ | `speckit` → `vipd-speckit` in command names, descriptions, URLs |
| Integration configs | 19 | AI agent integration modules with command skill references |
| CLI commands | 3 | `_commands.py`, `_install_commands.py`, `_migrate_commands.py` |
| Assets & version | 2 | `_assets.py`, `__init__.py` — package metadata and version strings |
| Agent config | 1 | `agents.py` — command registrar and skill registration |
| Workflows | 2 | `steps/command/__init__.py`, `steps/prompt/__init__.py` |
| Hooks | 2 | `extensions.py`, `shared_infra.py` — extension hook patterns |

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Source Code Naming Alignment (Priority: P1)

As an IPD toolkit developer, I want all `speckit` references in the Python source code renamed to the `vipd-speckit-*` convention, so that the CLI generates commands matching the project's IPD-enhanced naming.

**Why this priority**: Without this rename, the CLI generates commands with `speckit-*` names that don't match the `vipd-*` skill files already in `.claude/skills/`.

**Independent Test**: After the rename, no Python file contains the old `speckit` string unless it's an upstream reference or backward-compatibility alias.

**Acceptance Scenarios**:
1. **Given** the source tree at `src/specify_cli/`, **When** all `speckit` references are renamed, **Then** `grep -r "speckit" src/` returns only intended upstream or legacy alias references.
2. **Given** the CLI is rebuilt, **When** a user runs `specify init`, **Then** generated command skills use `vipd-speckit-*` naming.

---

### User Story 2 - Integration Registry Updates (Priority: P1)

As an IPD toolkit developer, I want all 19 AI agent integration modules updated to reflect the new naming convention, so that each integration (Claude, Copilot, Cursor, etc.) generates correct `vipd-*` commands.

**Why this priority**: The integration registry is the source of truth for what commands each AI agent sees.

**Independent Test**: Each integration's `_COMMANDS` or registrar config references `vipd-speckit-*` instead of `speckit-*`.

**Acceptance Scenarios**:
1. **Given** the Claude integration module, **When** inspected, **Then** argument hints and command names use `vipd-speckit-*`.
2. **Given** the Copilot integration module, **When** inspected, **Then** the same rename is applied.
3. **Given** all other integration modules, **When** inspected, **Then** they follow the same pattern.

---

### User Story 3 - Version & Metadata Updates (Priority: P2)

As an IPD toolkit developer, I want package metadata and version strings updated to reflect the IPD-enhanced build.

**Why this priority**: Package metadata (`__init__.py`, version) identifies the build to users and downstream tools.

**Independent Test**: `pip show specify-cli` or equivalent reports the correct IPD-enhanced version.

**Acceptance Scenarios**:
1. **Given** `src/specify_cli/__init__.py`, **When** read, **Then** version and description reflect IPD adaptation.
2. **Given** `src/specify_cli/_assets.py`, **When** read, **Then** core pack references are updated.

---

### Edge Cases

- What about backward compatibility? Some integrations may need both old `speckit` and new `vipd-speckit` names for a transition period.
- What about the `specify` CLI entry point name? That's the tool name, not the command prefix — should stay as `specify`.
- What about generated content that users consume? Old project `.specify/` files should continue to work.

## TR Gate Assessment *(IPD only)*

- **Applicable TR Gates**: TR1 (Concept — analysis complete), TR2/TR3 (Plan — change plan defined)
- **Risk Level**: Medium — 298 occurrences across 29 files requires careful review
- **Gate Evidence Required**: Analysis complete; all rename targets identified

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: All `speckit-` command references in Python source MUST be renamed to `vipd-speckit-` convention.
- **FR-002**: Integration argument hints MUST use `vipd-speckit-*` command names.
- **FR-003**: Hook command references in source (e.g., `speckit.git.commit`) MUST use `vipd-speckit-*` naming.
- **FR-004**: Package `__init__.py` MUST be updated to reflect IPD-enhanced version.
- **FR-005**: No `speckit` string MUST remain in source unless it's a version history reference, upstream dependency, or backward-compatibility alias.
- **FR-006**: The `specify` CLI entry point name MUST remain unchanged (it's the tool name, not the command prefix).
- **FR-007**: All shell script and template command references in `_commands.py` MUST use updated naming.
- **FR-008**: Integration install/migrate commands MUST use updated command naming.

### Key Entities

- **Command Template**: A template file used to generate AI agent skill files (e.g., `speckit-constitution` → `vipd-speckit-constitution`).
- **Integration Module**: A Python module under `integrations/*/__init__.py` that defines how a specific AI agent (Claude, Copilot, etc.) interacts with the toolkit.
- **Registrar Config**: Configuration that tells the agent registrar how to format skill file names and directories.
- **Hook Command**: A command reference in extension hooks (e.g., `speckit.git.commit` → `vipd-speckit-git-commit`).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `grep -r "speckit" src/specify_cli/` returns 0 unexpected matches after rename.
- **SC-002**: All 19 integration modules have updated command name references.
- **SC-003**: `specify init` generates commands with `vipd-speckit-*` naming.
- **SC-004**: The Python package builds and imports without errors after changes.

## Assumptions

- The `specify` CLI tool name itself is not renamed (only the subcommand/skill names).
- All 19 integrations follow the same command naming pattern and can be bulk-updated.
- Backward compatibility for existing projects is maintained (old `.specify/` files still work).
- The rename is largely mechanical: find-and-replace with manual review for ambiguous cases.

## Risk Register *(IPD only)*

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Missed `speckit` references in rarely-used code paths | M | M | Comprehensive grep + manual review of all 29 files |
| Rename breaks integration with upstream Spec Kit updates | M | L | Keep internal rename memo; re-apply after upstream merges |
| Backward compatibility issue for existing projects | H | L | Only rename source — existing project files remain unchanged |
| Some integrations use `speckit` in user-facing strings that should stay | L | M | Review each occurrence; only rename command/technical references |
