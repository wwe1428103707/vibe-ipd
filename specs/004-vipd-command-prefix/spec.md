# Feature Specification: VIPD Command Prefix Renaming

**Feature Branch**: `004-vipd-command-prefix`

**Created**: 2026-06-06

**Status**: Draft

**Input**: User description: "基于命令与模板改造指南，对涉及到的现有命令和新增命令进行改造。统一添加vipd- 前缀：现有speckit命令变为vipd-speckit-*，新增非speckit命令直接使用vipd-*"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Speckit Commands Renamed with vipd- Prefix (Priority: P1)

As a developer using the IPD-enhanced toolkit, I need all existing
`/vipd-speckit-*` commands to be callable as `/vipd-speckit-*` so that the
toolkit has a distinct namespace distinguishing it from the upstream
Spec Kit project while preserving the original command lineage.

**Why this priority**: This is the core naming convention change that
affects every command, every skill file, and every documentation reference.
It must be done first before any other changes.

**Independent Test**: Running `/vipd-speckit-constitution` creates/updates
a project constitution with IPD-enhanced sections, demonstrating the
new prefix works for all original speckit commands.

**Acceptance Scenarios**:

1. **Given** the current `.claude/skills/` directory, **When** the rename
   is complete, **Then** every `speckit-` prefixed directory MUST have a
   corresponding `vipd-speckit-` prefixed copy or symlink.
2. **Given** any existing `/vipd-speckit-*` command reference in documentation
   and templates, **When** the rename is complete, **Then** all references
   MUST be updated to `/vipd-speckit-*`.
3. **Given** a user invoking `/vipd-speckit-plan` on an IPD-enhanced project,
   **Then** the command MUST execute with the same behavior (including IPD
   gate checks) as the original `/vipd-speckit-plan`.

---

### User Story 2 - Documentation and Template References Updated (Priority: P1)

As a documentation maintainer, I need all cross-references, command
examples, and workflow descriptions across the IPD transformation document
collection to use the new `/vipd-speckit-*` prefix so that the documentation
is consistent with the renamed commands.

**Why this priority**: Documentation consistency is critical for user trust.
Mixed old/new prefixes would cause confusion.

**Independent Test**: A search for `/vipd-speckit-` across all files in
`docs/ipd-transformation/` returns zero matches (all migrated to
`/vipd-speckit-`).

**Acceptance Scenarios**:

1. **Given** `docs/ipd-transformation/01-transformation-roadmap.md`,
   **When** searched, **Then** all command references MUST use
   `/vipd-speckit-*` prefix.
2. **Given** `docs/ipd-transformation/02-command-template-redesign-guide.md`,
   **When** searched, **Then** all 7 command sections and the TR mapping
   table MUST use `/vipd-speckit-*` prefix.
3. **Given** `docs/ipd-transformation/03-tooling-integration-blueprint.md`,
   **When** searched, **Then** the agent integration section MUST use
   `/vipd-speckit-*` prefix.
4. **Given** `docs/ipd-transformation/zh/` Chinese translations,
   **When** searched, **Then** all command references MUST use
   `/vipd-speckit-*` prefix.

---

### User Story 3 - Constitution, Templates, and Spec Artifacts Updated (Priority: P2)

As a project initializer, I need the constitution, all 4 workflow
templates, and the 3 existing spec artifact collections to reference the
new command prefix so that the entire project is self-consistent.

**Why this priority**: The constitution and templates define the project's
behavior. As spec artifacts document the toolkit's own development, they
must reference the commands that actually exist.

**Independent Test**: A new project initialized with the updated templates
produces command examples using `/vipd-speckit-*` in all generated output.

**Acceptance Scenarios**:

1. **Given** `.specify/memory/constitution.md`, **When** checked,
   **Then** the Development Workflow table MUST use `/vipd-speckit-*`.
2. **Given** `.specify/templates/constitution-template.md`, **When**
   checked, **Then** all speckit command references MUST use the new prefix.
3. **Given** the 3 existing spec directories (`specs/001-*`, `002-*`,
   `003-*`), **When** checked, **Then** all `/vipd-speckit-*` references in
   spec, plan, and task files MUST be updated to `/vipd-speckit-*`.

### Edge Cases

- What about the old `/vipd-speckit-*` commands — should they be removed or
  kept as aliases/symlinks for backward compatibility?
- What about the `specify` CLI tool itself — does `specify init` also
  need a `vipd-` prefix wrapper?
- What about configuration files like `.specify/extensions.yml` and
  `.specify/extensions/.registry` that reference `speckit.*` command
  names in hook configurations?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: All 18 existing skill directories in `.claude/skills/` with
  the `speckit-` prefix MUST have a corresponding `vipd-speckit-` copy
  with all internal references updated to the new prefix.
- **FR-002**: The old `speckit-` prefixed skills SHOULD be retained as
  backward-compatible wrappers that delegate to the `vipd-speckit-` versions.
- **FR-003**: All command references in `docs/ipd-transformation/` (all
  files including `zh/` translations) MUST be updated from `/vipd-speckit-` to
  `/vipd-speckit-`.
- **FR-004**: All command references in `.specify/memory/constitution.md`
  and `.specify/templates/constitution-template.md` MUST be updated.
- **FR-005**: All command references in `.specify/templates/spec-template.md`,
  `plan-template.md`, and `tasks-template.md` MUST be updated.
- **FR-006**: All command references in `specs/001-ipd-toolkit/`,
  `specs/002-ipd-agent-pm-integration/`, and `specs/003-blueprint-docstate-only/`
  MUST be updated.
- **FR-007**: The `before_specify` hook reference in
  `.specify/extensions.yml` (`speckit.git.feature`) and all other hook
  command references MUST use the new naming convention.
- **FR-008**: Any new non-speckit commands created specifically for the
  vipd toolkit (not derived from upstream spec-kit) MUST use the bare
  `vipd-` prefix without the `speckit` infix.

### Key Entities

- **18 Skill Directories**: `.claude/skills/vipd-speckit-*/` directories to be
  renamed/copied to `vipd-speckit-*`
- **IPD Transformation Documents**: 7 English + 7 Chinese files in
  `docs/ipd-transformation/` referencing `/vipd-speckit-*` commands
- **Constitution & Templates**: 5 files (memory + 4 templates) referencing
  speckit commands
- **Spec Artifacts**: 3 spec collections in `specs/001-*`, `002-*`, `003-*`
- **Configuration Files**: `.specify/extensions.yml` with hook command names
  like `speckit.git.feature`

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A project-wide grep for `/vipd-speckit-` across all files
  in the repository returns zero matches after the rename (all migrated
  to `/vipd-speckit-`).
- **SC-002**: All 18 original speckit skills have corresponding
  `vipd-speckit-` versions that pass the same TR gate checks.
- **SC-003**: Running `grep -r "speckit\." .specify/extensions.yml`
  returns zero matches (all hook command references migrated).

## Assumptions

- The old `/vipd-speckit-*` commands are retained as backward-compatible
  wrappers/symlinks to avoid breaking existing projects that use the
  old prefix.
- The `specify` CLI tool itself is NOT renamed — only the Speckit
  command/skill invocations within the project are prefixed.
- Chinese translations in `docs/ipd-transformation/zh/` use the same
  `/vipd-speckit-*` prefix (command names are not translated).
- The `.specify/extensions.yml` hook configurations use dotted command
  names (e.g., `vipd.speckit.git.commit`) consistent with the naming
  convention.
- This is a rename/duplication of skill files — the actual command
  logic within each skill remains the same; only the name/prefix changes.
