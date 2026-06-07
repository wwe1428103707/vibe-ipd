# Data Model: Project Cleanup & Documentation Rebrand

**Phase**: Phase 1 | **Date**: 2026-06-07 | **Feature**: [spec.md](spec.md)

## Entity: DocumentFile

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `path` | String | Relative path from repo root | Must be a `.md`, `.yml`, or `.json` file |
| `category` | Enum | `root_readme`, `docs_page`, `config`, `skill`, `agent_context` | Determines replacement scope |
| `branding_scope` | Enum | `full_rewrite`, `find_replace`, `review_only` | Modification intensity |
| `status` | Enum | `pending`, `updated`, `verified` | Tracks implementation progress |

## Entity: BrandingRule

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `search_pattern` | String | Text pattern to find | Case-sensitive or insensitive per rule |
| `replacement` | String | Text to replace with | Must be a valid branding string |
| `scope` | Enum | `all`, `docs_only`, `config_only` | Which file categories to apply to |
| `exclude_pattern` | String | Pattern to skip (e.g., attribution lines) | Optional |

## Validation Rules

- Branding rules must not apply to license or third-party attribution files
- Root README must contain at least 5 distinct differentiator sections
- Zero non-attribution `speckit` references in `docs/` after migration
- All `/speckit-*` command references must be updated to `/vipd-*`
