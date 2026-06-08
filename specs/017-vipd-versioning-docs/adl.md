# Architecture Decision Log: VIPD Versioning & Docs Preparation

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md)

## ADL-001: Version File in `.vipd/version.yml`

| Field | Value |
|-------|-------|
| **Context** | FR-001 requires a version file with both `vipd_version` and `speckit_version`. |
| **Decision** | Store versions in `.vipd/version.yml` as a YAML file with two string fields. |
| **Rationale** | Consistent with existing `.vipd/config.yml` pattern. YAML is human-readable and machine-parseable. Single source of truth prevents version drift. |
| **Alternatives** | pyproject.toml (overkill for a non-Python-package project), VERSION text file (no structure), hardcoded in scripts (not maintainable) |
| **Status** | Accepted |

## ADL-002: CLI Wrapper Script at Repo Root

| Field | Value |
|-------|-------|
| **Context** | FR-004 requires `vipd --version` display. The project has no CLI entry point. |
| **Decision** | Create a simple bash script `vipd` at the repository root that reads `.vipd/version.yml` and formats output. |
| **Rationale** | A standalone script is zero-dependency, works cross-platform (via Git Bash/WSL), and can be extended for future CLI needs. |
| **Alternatives** | Python entry point (requires Python + dependencies), SKILL.md only (not invocable from terminal), Makefile target (project-specific) |
| **Status** | Accepted |

## ADL-003: README with Full Feature Catalog

| Field | Value |
|-------|-------|
| **Context** | FR-006 requires README updates for the first release. |
| **Decision** | Update README.md and README.zh.md with a comprehensive feature catalog table showing all 17 specs with status indicators. |
| **Rationale** | A feature catalog table gives new users immediate visibility into what vipd can do. Bilingual (EN/ZH) continues the pattern from feature 014. |
| **Alternatives** | Separate docs/ site (overhead for v1), no feature catalog (users have to guess), auto-generated (not curated) |
| **Status** | Accepted |

## ADL-004: Initial Version 1.0.0

| Field | Value |
|-------|-------|
| **Context** | The first official release needs an initial version number. |
| **Decision** | Start at `1.0.0` for vipd, recording `speckit_version: 0.9.3.dev0`. |
| **Rationale** | All 17 features represent a complete, functional IPD toolkit — justifying a 1.0.0 release. Starting at 1.0.0 rather than 0.x signals project maturity and stability. |
| **Alternatives** | 0.1.0 (too early for 17 features), 0.9.0 (implies pre-release), date-based (non-standard) |
| **Status** | Accepted |
