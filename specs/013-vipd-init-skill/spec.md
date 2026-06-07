# Feature Specification: vipd-init Skill

**Feature Branch**: `013-featurename-vipd-init-skill`

**Created**: 2026-06-07

**Status**: Draft

**Input**: User description: "创建一个 vipd-init 技能，封装底层的 speckit CLI 调用，这样用户只需要记得一个品牌入口，同时也可以避免冲突。"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Project Scaffolding via /vipd-init (Priority: P1)

As a developer new to vibe-ipd, I want to run `/vipd-init my-project --integration claude` so that I can scaffold a new project without needing to know about the underlying speckit CLI.

**Why this priority**: This is the primary entry point — without it, every new user must learn both vibe-ipd and speckit CLI commands to get started. This story delivers the core value of brand unification.

**Independent Test**: Can be fully tested by running `/vipd-init test-project --integration claude` and verifying that (1) a new directory `test-project/` is created, (2) the directory contains a valid `.specify/` structure, (3) `integration`-specific skill files exist under `.claude/`.

**Acceptance Scenarios**:

1. **Given** the vibe-ipd environment is ready, **When** a developer runs `/vipd-init my-app --integration claude`, **Then** a directory `my-app/` is created with the full speckit scaffold and Claude integration skills.
2. **Given** an existing project directory, **When** a developer runs `/vipd-init .` in that directory, **Then** the project is initialized in-place with the `.specify/` structure.
3. **Given** a project already initialized, **When** `/vipd-init` is run again, **Then** the command warns and skips re-initialization.

---

### User Story 2 - Vibe-IPD Post-Init Branding (Priority: P1)

As a vibe-ipd user, after scaffolding a project via `/vipd-init`, I want the project to automatically switch from speckit-branded skills (`speckit-*`) to vibe-ipd-branded skills (`vipd-*`) so that the entire experience is consistently branded.

**Why this priority**: Without this, users still see `speckit-*` skills in their project, defeating the purpose of unified branding.

**Independent Test**: Can be tested by running `/vipd-init test-project --integration claude` and verifying that `.claude/skills/` contains `vipd-*` skills (not `speckit-*`).

**Acceptance Scenarios**:

1. **Given** `/vipd-init` has completed, **When** the user checks `.claude/skills/`, **Then** the skills are named `vipd-specify`, `vipd-plan`, `vipd-implement`, etc.
2. **Given** the project is initialized, **When** the user runs any `/vipd-*` command, **Then** it resolves correctly without referencing `speckit-*` internal naming in user-facing output.

---

### User Story 3 - Integration Option Selection (Priority: P2)

As a project creator, I want `/vipd-init` to support the same `--integration` options as `specify init`, so that I can choose my AI coding agent (Claude, Copilot, etc.) without losing functionality.

**Why this priority**: Supports existing speckit users migrating to vibe-ipd. Lower priority because the primary integration is Claude Code.

**Independent Test**: Test with `--integration copilot` and verify the correct integration-specific files are generated.

**Acceptance Scenarios**:

1. **Given** `/vipd-init` runs with `--integration copilot`, **Then** integration files for GitHub Copilot are generated.
2. **Given** `/vipd-init` runs without `--integration`, **Then** it defaults to a standard scaffold with no AI-specific integration.

---

### Edge Cases

- What happens when `uvx` or `pipx` is not installed? → Clear error message with installation instructions.
- What happens when the target directory already exists and is non-empty? → Interactive confirmation before overwriting.
- What happens when the upstream speckit CLI is unreachable? → Informative error with manual setup instructions.
- What happens when executed in a project already containing `.specify/`? → Offer to upgrade or exit gracefully.

## TR Gate Assessment *(IPD only)*

- **Applicable TR Gates**: TR1 (Concept), TR2/TR3 (Plan)
- **Risk Level**: Low — the feature wraps an existing CLI; no new runtime logic.
- **Gate Evidence Required**: Spec (this file), SKILL.md file for `/vipd-init`, integration test output.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `/vipd-init` skill MUST accept a `<PROJECT_NAME>` argument specifying the target directory.
- **FR-002**: The `/vipd-init` skill MUST accept an optional `--integration` flag to select the AI coding agent integration.
- **FR-003**: The `/vipd-init` skill MUST delegate to the upstream speckit `specify init` CLI (via `uvx` or local installation) for actual scaffolding.
- **FR-004**: After scaffolding, `/vipd-init` MUST optionally apply vibe-ipd branding overrides (rename skills from `speckit-*` to `vipd-*` if applicable).
- **FR-005**: The `/vipd-init` skill MUST detect if `uvx` and/or `pipx` is available and provide clear guidance when neither is found.
- **FR-006**: The `/vipd-init` skill MUST support the current-directory form: `/vipd-init .` (equivalent to `specify init .`).
- **FR-007**: When the target directory already contains a `.specify/` directory, `/vipd-init` MUST detect this and ask for confirmation before re-initializing.

### Key Entities *(include if feature involves data)*

- **Project Directory**: The target directory where scaffolding is created.
- **Integration Type**: The AI coding agent type (claude, copilot, etc.) determining which integration files are generated.
- **Specify Init Options**: Configuration file (`.specify/init-options.json`) storing initialization metadata.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A new user can scaffold a complete vibe-ipd project in under 60 seconds using a single `/vipd-init` command.
- **SC-002**: The scaffolded project contains all files that `specify init` produces, verified by identical file listing (excluding skill renames).
- **SC-003**: After initialization, `/vipd-constitution`, `/vipd-specify`, and `/vipd-plan` all execute without "command not found" errors.
- **SC-004**: Zero references to `speckit-*` skills appear in user-facing output of `/vipd-init`.

## Assumptions

- The upstream speckit CLI (`specify init`) is available via `uvx` from `git+https://github.com/github/spec-kit.git` or via `pipx` local installation.
- The target system has either `uv` (with `uvx`) or `pipx` installed.
- The user runs `/vipd-init` from within an existing vibe-ipd project context (i.e., the skill file is already in place).
- The generated project uses the same `.specify/` structure expected by all other `/vipd-*` commands.

## Risk Register *(IPD only)*

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Upstream speckit CLI changes its command signature | H | L | Pin to known-good version; document fallback |
| `uvx` or `pipx` missing on user machine | H | M | Clear error with install instructions; document manual setup alternative |
| Skill conflicts with existing speckit-* skills after scaffolding | M | M | Post-init hook renames/replaces skills to vipd-* naming |
