# Implementation Plan: VIPD Versioning & Docs Preparation

**Branch**: `017-vipd-versioning-docs` | **Date**: 2026-06-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/017-vipd-versioning-docs/spec.md`

## Summary

Introduce independent version management for vipd (semver MAJOR.MINOR.PATCH, tracking separately from speckit). Create `.vipd/version.yml` as the single source of truth, provide `vipd --version` display, document the version bump workflow. Simultaneously update the project README (EN + ZH) and create a CHANGELOG to prepare for the v1.0.0 release covering all 17 features.

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS
- **TR Gates Passed**: TR0, TR1
- **Next Gate**: TR2/TR3

## Technical Context

**Version Scheme**: Semantic versioning (`MAJOR.MINOR.PATCH`) for vipd, following same conventions as speckit but tracked independently

**Version File**: `.vipd/version.yml` — YAML format with `vipd_version` and `speckit_version` fields

**Display Mechanism**: Shell script `vipd --version` wrapper that reads the version file and formats output

**Documentation**: README.md (English), README.zh.md (Chinese), CHANGELOG.md, VERSION_BUMP.md

**Initial Version**: `vipd_version: 1.0.0`, `speckit_version: 0.9.3.dev0`

**Constraints**: Version file is the single source of truth — no hardcoded versions in scripts or SKILL.md files; all version display must read from the file

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Aligned | Evidence |
|-----------|---------|----------|
| I. Spec-First, SDD Core | ✅ | This feature was spec-first; plan implements spec intent |
| II. Dual-Track Agile | ✅ | Discovery through spec; delivery now |
| III. Agile-Stage-Gate | ✅ | Versioning helps gate tracking across releases |
| IV. Cross-Functional PDT | ✅ | Documentation is a cross-cutting concern handled by this feature |
| V. Quality Built-In | ✅ | Version file as single source of truth prevents version drift |

**Verdict**: PASS — all 5 principles satisfied.

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: [`.specify/memory/cbb-catalog.md`](../../.specify/memory/cbb-catalog.md)
- **Reusable blocks identified**:
  - `.vipd/config.yml` pattern (YAML config file in `.vipd/`)
  - Language string resource pattern from 016 (`lang/en.yml`)
  - Existing README structure
- **New components needed**:
  - `.vipd/version.yml` — version file
  - `vipd --version` display mechanism
  - `VERSION_BUMP.md` — bump workflow documentation
  - `CHANGELOG.md` — release history
  - Updated `README.md` and `README.zh.md`
- **Reuse justification**: Config file pattern already established; docs extend existing structure

## Project Structure

### Documentation (this feature)

```text
specs/017-vipd-versioning-docs/
├── spec.md                # Feature specification
├── plan.md                # This file
├── research.md            # Phase 0 output
├── data-model.md          # Phase 1 output
├── quickstart.md          # Phase 1 output
└── contracts/
    └── version-schema.json
```

### Source Code (repository root)

```text
.vipd/
├── config.yml              # Existing: language config
└── version.yml             # NEW: version file

vipd                        # NEW: CLI wrapper (bash script)
                            # usage: vipd --version, vipd --help

README.md                   # EXTEND: full project documentation
README.zh.md                # EXTEND: Chinese translation
CHANGELOG.md                # NEW: release history
VERSION_BUMP.md             # NEW: version bump process
```

## Complexity Tracking

No violations — the Constitution Check passes on all 5 principles.

---

## Phase 0: Research

Research tasks to determine format and content decisions.

### Research Tasks

| Task | Description | Resolution |
|------|-------------|------------|
| R1 | Version file schema | `.vipd/version.yml` with `vipd_version` and `speckit_version` |
| R2 | `vipd --version` display format | `vipd x.y.z (speckit a.b.c)` single-line output |
| R3 | CHANGELOG structure | Keep a Changelog format (https://keepachangelog.com) |
| R4 | README content audit | Catalog all 17 features, group by release theme |

### Research output

Written to `research.md`.

---

## Phase 1: Design & Contracts

### Entities to model (→ `data-model.md`)

- `VersionInfo` — contains `vipd_version` (semver) and `speckit_version` (semver); stored in `.vipd/version.yml`
- `VersionBumpRule` — MAJOR (breaking), MINOR (features), PATCH (fixes) rules
- `ChangelogEntry` — version, date, added/changed/fixed/removed sections

### Contracts (→ `contracts/`)

- `version-schema.json` — JSON Schema for `.vipd/version.yml`

### Quickstart (→ `quickstart.md`)

Step-by-step implementation guide for version file, display script, README update, and changelog.

### Agent Context

Update `CLAUDE.md` SPECKIT markers to reference this plan file.
