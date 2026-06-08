# Data Model: VIPD Versioning & Docs Preparation

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md)

## Entities

### VersionInfo

The single source of truth for both vipd and speckit versions.

**File**: `.vipd/version.yml`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `vipd_version` | string | ✅ | Semantic version for vipd (e.g., `1.0.0`) |
| `speckit_version` | string | ✅ | Version of speckit used by this project (e.g., `0.9.3.dev0`) |

**Validation rules**:
- Both fields must follow semver (`MAJOR.MINOR.PATCH`, optionally with pre-release suffix)
- `vipd_version` is always bumpable independently
- `speckit_version` changes only when the project updates its speckit dependency

### VersionBumpRule

Defines when each version component is incremented.

| Component | Trigger | Example |
|-----------|---------|---------|
| MAJOR | Breaking changes to workflow or backward-incompatible spec format changes | 1.0.0 → 2.0.0 |
| MINOR | New features added (new specs implemented) | 1.0.0 → 1.1.0 |
| PATCH | Bug fixes, doc updates, refactoring | 1.0.0 → 1.0.1 |

### ChangelogEntry

A single release entry in CHANGELOG.md.

**Format**: Keep a Changelog (https://keepachangelog.com)

| Section | Description |
|---------|-------------|
| `Added` | New features implemented |
| `Changed` | Changes to existing functionality |
| `Deprecated` | Soon-to-be-removed features |
| `Removed` | Removed features |
| `Fixed` | Bug fixes |
| `Security` | Security updates |

## File Inventory

| File | Format | Location | Purpose |
|------|--------|----------|---------|
| `version.yml` | YAML | `.vipd/` | Single source of truth for versions |
| `vipd` | Bash | repo root | CLI wrapper for `--version` display |
| `CHANGELOG.md` | Markdown | repo root | Release history |
| `VERSION_BUMP.md` | Markdown | repo root | Version bump workflow docs |
| `README.md` | Markdown | repo root | English project docs |
| `README.zh.md` | Markdown | repo root | Chinese project docs |
| `version-schema.json` | JSON Schema | `contracts/` | Version file validation |

## Version Display Flow

```
User runs: vipd --version
         │
         ▼
  ┌──────────────┐
  │ Read         │
  │ .vipd/       │
  │ version.yml  │
  └──────┬───────┘
         │
         ▼
  ┌──────────────┐
  │ Format output│
  │ "vipd X.Y.Z │
  │  (speckit   │
  │   A.B.C)"   │
  └──────┬───────┘
         │
         ▼
  ┌──────────────┐
  │ Error?       │
  │ "vipd unknown│
  │  (speckit   │
  │   unknown)" │
  └──────────────┘
```

## Version Bump State Machine

```
       ┌───────────┐
       │ PATCH bump│ (bug fixes, docs)
       └─────┬─────┘
             │
  ┌──────────▼──────────┐
  │  X.Y.Z              │
  │  (current version)  │
  └──────────┬──────────┘
             │
   ┌─────────┼─────────┐
   │         │         │
   ▼         ▼         ▼
┌──────┐ ┌──────┐ ┌──────┐
│MAJOR │ │MINOR │ │PATCH │
│X+1.0.0││X.Y+1.0││X.Y.Z+1│
└──────┘ └──────┘ └──────┘
```
