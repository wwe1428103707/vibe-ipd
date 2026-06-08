# Feature Specification: VIPD Versioning & Docs Preparation

**Feature Branch**: `017-vipd-versioning-docs`

**Created**: 2026-06-08

**Status**: Draft

**Input**: User description: "为vipd引入单独的版本管理（版本更新规则与speckit相同，但不覆盖speckit版本，保留本项目所采用的speckit版本）。同时对文档进行更新，为第一个正式版做准备"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Track VIPD and Speckit Versions Separately (Priority: P1)

As a **project maintainer**, I want vipd to have its own version number that is tracked independently from speckit, while also recording which speckit version this project uses, so that I can version vipd releases without conflicting with the upstream speckit versioning.

**Why this priority**: Without separate version tracking, vipd's version is either the same as speckit (confusing) or non-existent (untrackable). This is the foundational requirement.

**Independent Test**: Can be validated by checking that the project has a version file containing both a `vipd_version` and a `speckit_version` entry, with different values.

**Acceptance Scenarios**:

1. **Given** the project root, **When** I inspect the version file, **Then** it contains a `vipd_version` field that is independent of the `speckit_version` field
2. **Given** the version file, **When** I read the `speckit_version` field, **Then** it matches the actual speckit version used by the project
3. **Given** a new vipd feature is completed, **When** the version is bumped, **Then** only the `vipd_version` changes — the `speckit_version` remains unchanged

---

### User Story 2 - Version Display and Verification (Priority: P1)

As a **user or contributor**, I want to see the current vipd version and the underlying speckit version by running a simple command, so that I know what version of the toolkit I'm using and can report it in bug reports.

**Why this priority**: Version visibility is essential for support, debugging, and release management.

**Independent Test**: Run `vipd --version` and confirm the output shows both `vipd` and `speckit` versions clearly.

**Acceptance Scenarios**:

1. **Given** the project, **When** I run `vipd --version`, **Then** it displays the vipd version and the speckit version in a readable format
2. **Given** a version bump, **When** I run `vipd --version` again, **Then** the displayed version reflects the new value
3. **Given** no arguments, **When** I run `vipd`, **Then** it shows a brief usage message that includes the version

---

### User Story 3 - Documentation Ready for First Release (Priority: P1)

As a **new user**, I want the project's documentation to clearly describe what vipd is, how to install it, and how to use it, so that I can get started without external guidance.

**Why this priority**: The first official release requires polished documentation. New users should understand the project's purpose, features, and workflow immediately.

**Independent Test**: A new contributor can read the README and successfully set up the project and run their first vipd command without asking for help.

**Acceptance Scenarios**:

1. **Given** the project README, **When** I read it, **Then** it explains the project's purpose, key features, prerequisites, and quickstart instructions
2. **Given** the README, **When** I follow the installation instructions, **Then** I can successfully set up the project
3. **Given** the README, **When** I look for usage examples, **Then** there is at least one complete workflow example from spec to implementation
4. **Given** the project documentation, **When** I look for a changelog or release notes, **Then** I can see the history of changes

---

### User Story 4 - Version Bump Workflow (Priority: P2)

As a **maintainer**, I want a documented process for bumping the vipd version (following speckit's versioning rules), so that releases are consistent and predictable.

**Why this priority**: Without a defined process, version bumps are ad-hoc and may follow inconsistent rules.

**Independent Test**: Follow the documented bump process for a minor version increment and verify the version file is updated correctly.

**Acceptance Scenarios**:

1. **Given** the project's versioning policy, **When** I read it, **Then** it defines MAJOR.MINOR.PATCH update rules matching speckit's conventions
2. **Given** the version policy, **When** I perform a PATCH bump, **Then** only the patch number increments
3. **Given** the version policy, **When** I perform a MINOR bump, **Then** the minor number increments and the patch resets to 0

---

### Edge Cases

- What happens when the speckit version changes upstream? (The project should update `speckit_version` in the version file, but NOT change `vipd_version`)
- What if the version file is missing or corrupted? (The system should report a clear error and use "unknown" as fallback)
- What about pre-release versions (e.g., 0.9.0, 1.0.0-beta)? (The versioning scheme should support pre-release suffixes)
- How does version interact with the existing `--lang` flag? (Version output should respect the selected language)

## TR Gate Assessment *(IPD only)*

- **Applicable TR Gates**: TR1 (spec), TR2/TR3 (plan), TR4 (implementation)
- **Risk Level**: Low — versioning and documentation are straightforward, well-understood tasks
- **Gate Evidence Required**:
  - Version file schema design
  - Version display mechanism (CLI command or script)
  - README and documentation audit results
  - Changelog/first release preparation

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The project MUST have a version file (e.g., `VERSION` or `.vipd/version.yml`) containing both `vipd_version` and `speckit_version` fields.
- **FR-002**: The `vipd_version` MUST follow semantic versioning (`MAJOR.MINOR.PATCH`) and be independently bumpable — not tied to speckit's version.
- **FR-003**: The `speckit_version` MUST record the version of the speckit toolkit that this project currently uses.
- **FR-004**: The system MUST provide a `--version` flag (e.g., via a `vipd --version` command or script) that displays both vipd version and speckit version.
- **FR-005**: The version update rules MUST match speckit's conventions (MAJOR for breaking changes, MINOR for new features, PATCH for bug fixes), applied to `vipd_version` only.
- **FR-006**: The project README MUST be updated to include: project description, prerequisites, installation steps, quickstart workflow, feature catalog (list of implemented specs), and a "Getting Started" guide.
- **FR-007**: The project MUST have a `CHANGELOG.md` or `RELEASE_NOTES.md` documenting the history of changes, starting from the first release.
- **FR-008**: When speckit's version is updated in the project, the version file MUST be updated to reflect the new `speckit_version` — separately from any `vipd_version` changes.
- **FR-009**: All vipd skill files (`SKILL.md`) SHOULD include version reference in their metadata or footer, and the documentation SHOULD clearly indicate which features are available in which vipd version.

### Key Entities *(include if feature involves data)*

- **VIPD Version**: The semantic version of the vipd toolkit (e.g., `1.0.0`). Independent of speckit. Stored in version file.
- **Speckit Version**: The version of the speckit toolkit used by this project (e.g., `0.9.3.dev0`). Read from `.specify/init-options.json` or installed speckit package.
- **Version File**: A machine-readable file (e.g., `VERSION` or `.vipd/version.yml`) containing both version strings. Serves as the single source of truth for version queries.
- **Release Notes / CHANGELOG**: A human-readable document summarizing changes for each release.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `vipd --version` displays both `vipd` version and `speckit` version in a single command. The two versions are different values.
- **SC-002**: The project README covers all required sections (description, prerequisites, installation, quickstart, feature list) and a new user can complete their first feature spec → plan → tasks cycle without external help.
- **SC-003**: A version bump following the documented process updates the version file correctly in under 1 minute.
- **SC-004**: The CHANGELOG contains entries for at least all implemented features (001 through 017), organized by release version.
- **SC-005**: After version introduction, any future commit can be traced to a vipd version range via the version file and changelog.

## Assumptions

- Version 1.0.0 will be the first official release, covering all features implemented up to and including this one (017).
- The speckit version is currently `0.9.3.dev0` (from `.specify/init-options.json`).
- The version file format will be YAML (consistent with other `.vipd/` config files).
- README updates will build on the existing README content, not replace it entirely.
- The `--version` output will be English-only in v1 (i18n can be added later).
- Documentation updates should be done in both English and Chinese (continuing the pattern from feature 014).

## Risk Register *(IPD only)*

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Version confusion between vipd and speckit after bump | M | L | Always display both versions together; make the distinction clear in docs |
| README becomes outdated after release | M | M | Include a "Last updated" date; document the release process to include README review |
| Users may be on different speckit versions with the same vipd version | L | M | The version file always records the exact speckit version; `--version` shows both |
| Chinese documentation may lag behind English | M | M | Update both simultaneously as part of the same feature; document this requirement |
