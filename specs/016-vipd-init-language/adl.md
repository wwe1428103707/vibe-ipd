# Architecture Decision Log: VIPD Init Language Option

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md)

## ADL-001: Flat YAML Key-Value Format for Language Resources

| Field | Value |
|-------|-------|
| **Context** | FR-008 requires language strings in external files. The format choice affects maintainability and lookup simplicity. |
| **Decision** | Use flat YAML key-value pairs with `section.key` dot notation (e.g., `init.welcome`, `error.network`). |
| **Rationale** | Dot-notation keys make lookups trivial (`resources["error.network"]`) and avoid the complexity of deeply nested YAML traversal. YAML is already used throughout the project. |
| **Alternatives** | Deeply nested YAML (harder to lookup), JSON (less readable for translators), gettext .po files (overkill for this scope) |
| **Status** | Accepted |

## ADL-002: Config Priority Chain — CLI > Project > User > Default

| Field | Value |
|-------|-------|
| **Context** | FR-002 through FR-005 require multiple levels of language configuration with clear precedence rules. |
| **Decision** | Priority chain: `--lang` CLI flag > `.vipd/config.yml` (project) > `~/.vipd/config.yml` (user) > `en` default. |
| **Rationale** | Project-level config is version-controlled and shared (team consistency). User config provides personal override. CLI flag provides temporary override without modifying config files. This matches the standard pattern used by git and other CLI tools. |
| **Alternatives** | User config over project config (less team-friendly), only project config (no personal preference), only CLI flag (no persistence) |
| **Status** | Accepted |

## ADL-003: Whitelist-Based Language Validation via Directory Scan

| Field | Value |
|-------|-------|
| **Context** | FR-007 requires fallback for unsupported language codes. The mechanism must be extensible for new languages. |
| **Decision** | Scan the `lang/` directory for `*.yml` files; each filename stem is a valid code. This is the whitelist. Invalid codes fall back to `en` with a warning. |
| **Rationale** | Adding a language is literally creating a file — no config changes, no code changes, no deployment. The directory scan auto-discovers available languages at runtime. |
| **Alternatives** | Hardcoded list (requires code change for each language), registry file (extra maintenance) |
| **Status** | Accepted |

## ADL-004: New `.vipd/config.yml` for Configuration

| Field | Value |
|-------|-------|
| **Context** | FR-002 requires persisting the language choice. vipd currently has no centralized config mechanism. |
| **Decision** | Create `.vipd/config.yml` as the project-level configuration file, starting with the `language` key. |
| **Rationale** | The `.vipd/` directory is the natural home for vipd-specific configuration. A single YAML file is extensible for future configuration needs beyond language. |
| **Alternatives** | Embed in an existing file (no existing file exists), environment variables (not persistent), separate `lang` file (fragmentation) |
| **Status** | Accepted |
